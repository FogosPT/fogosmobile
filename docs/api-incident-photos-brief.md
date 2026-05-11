# Brief para a equipa fogosapi — upload de fotos de incidentes

Este documento descreve o que foi implementado no cliente Flutter
(`fogosmobile`) para o upload de fotos de incidentes e o que falta confirmar /
implementar no `fogosapi` (Laravel 12) para fechar o fluxo.

## Estado actual no cliente

A app já envia uploads contra:

```
POST {API_BASE}/v2/incidents/{fireId}/photos
Content-Type: multipart/form-data
```

`API_BASE` no cliente está fixado em `https://api.fogos.pt`. Se o vosso domínio
real for outro, dêem-nos o valor correto e nós actualizamos a constante em
`lib/constants/endpoints.dart`.

### Campos do multipart

| Campo       | Tipo    | Obrigatório | Descrição                                                                                              |
| ----------- | ------- | ----------- | ------------------------------------------------------------------------------------------------------ |
| `photo`     | file    | sim         | PNG composto pelo cliente, com chunk `eXIf` (TIFF/EXIF GPS).                                           |
| `public`    | string  | sim         | `"1"` ou `"0"`. Decide se a foto pode ser publicada na app.                                            |
| `signature` | string  | não         | Nome curto opcional definido pelo utilizador nas Definições. Limite cliente: 30 caracteres. Ausente se vazio. |

### Headers

| Header          | Obrigatório | Descrição                                                                                |
| --------------- | ----------- | ---------------------------------------------------------------------------------------- |
| `X-App-Version` | não         | Versão da app (lê `package_info_plus`). Útil para correlação. Pode cair em silêncio.    |

Sem autenticação. Endpoint público, rate-limited por IP (3/min, 8/h por incidente — confirmado).

### O que o cliente garante na foto enviada

- Sempre PNG.
- Sempre com chunk `eXIf` (construído em Dart puro pela app — `lib/utils/png_exif.dart`),
  contendo:
  - GPS Latitude / Longitude (graus/min/seg via RATIONAL).
  - GPS Altitude (em metros, RATIONAL com denominador 1000).
  - GPS ImgDirection (0–360°, RATIONAL com denominador 100).
  - GPS DateStamp + TimeStamp (UTC).
  - DateTimeOriginal + SubSecTimeOriginal no Exif IFD.
- Tamanho garantido pelo cliente: < 20 MB (validação local antes de enviar).
- Watermark visual queimado no rodapé (place name, GPS legível, altitude,
  direcção, data/hora, distância ao incêndio, e opcionalmente o nome do
  utilizador como "assinatura"). **Os dados sensíveis ficam visíveis na foto**
  por design — esse foi o comportamento aceite por consentimento explícito do
  utilizador no diálogo de envio.

### Consentimento que o cliente recolhe antes de enviar

O diálogo no Flutter mostra um aviso legal completo e devolve ao API a
escolha do utilizador via campo `public`. O texto cobre:

- Coordenadas GPS visíveis na foto.
- Se autorizada (`public=1`): foto fica pública na app + partilhada com ANEPC e
  outras entidades operacionais.
- Se negada (`public=0`): foto fica **apenas para uso operacional pela ANEPC**
  e não aparece publicamente.
- "Não envies fotos com…" (lista de proibições: pessoas identificáveis,
  matrículas, conteúdo gráfico, crimes).
- Responsabilidade do utilizador.
- Fotos rejeitadas → eliminadas definitivamente.
- Fotos aceites → podem ser conservadas e usadas para outros fins (treino de IA,
  análise operacional, investigação).

Por isso a API tem agora de tratar o `public` flag e respeitar essa escolha.

## O que falta a vós (fogosapi)

### 1. Aceitar os campos `public` e `signature`

Aceitar no body multipart, além de `photo`:

- `public` — string, `"0"` ou `"1"`. Obrigatório. Decide visibilidade pública.
- `signature` — string opcional, ≤ 30 caracteres, nome curto auto-definido pelo
  utilizador nas Definições da app. Ausente se vazio.

Persistir ambos junto com a foto.

Sugestão de documento em MongoDB:

```json
{
  "_id": "...",
  "incident_id": "...",
  "status": "pending",
  "public": true,           // novo — true/false
  "signature": "João P.",   // novo — string ou null
  "captured_at": "...",
  ...
}
```

Defaults seguros se vierem ausentes:

- `public` ausente → tratar como `true` por compatibilidade com cliente legacy.
  Quando a nova versão da app sair, o campo vem sempre — preferimos tratar
  ausência como `400` a longo prazo.
- `signature` ausente → guardar como `null` ou string vazia, indica utilizador
  anónimo (comportamento actual, antes desta funcionalidade).

**Validações sugeridas para `signature`**:

- Limitar a 30 caracteres no servidor (defesa em profundidade — o cliente já
  faz `maxLength: 30`).
- `trim()` ao guardar.
- Sanitizar / validar para não ser usado num campo onde HTML/JS possa ser
  interpretado (a não ser que a vossa pipeline já o faça em qualquer string
  que vai a output público).

### 2. Comportamento por status da foto + flag `public`

| `status`  | `public` | Comportamento                                                          |
| --------- | -------- | ---------------------------------------------------------------------- |
| `pending` | qualquer | Em moderação. Não aparece em `GET /v2/incidents/{id}/photos` público. |
| `approved`| `true`   | **Aparece** em `GET /v2/incidents/{id}/photos` público (sem GPS). Continua acessível à ANEPC pelo painel. |
| `approved`| `false`  | **Não aparece** no endpoint público. Acessível apenas à ANEPC pelo painel/extracção. |
| `rejected`| qualquer | Fotos eliminadas definitivamente do MinIO **e** do MongoDB (hard delete, não soft delete). |

Resumindo, o flag `public` só altera o que é exposto no endpoint público —
todas as fotos aceites continuam disponíveis para a ANEPC.

### 3. Eliminação definitiva no `rejected`

Quando uma foto é rejeitada na plataforma de moderação:

- Apagar o objecto do MinIO.
- Remover o documento do MongoDB (não soft delete).
- Esta acção tem de ser irreversível por design — está prometido no consent
  text do cliente.

### 4. Endpoint público de listagem

`GET /v2/incidents/{fireId}/photos` deve devolver **apenas** fotos com
`status=approved` **E** `public=true`. Sem coordenadas GPS no payload (já era o
caso). Confirmar que essa filtragem é feita.

**`signature` é apenas input.** O cliente envia o campo no POST mas **não lê**
`signature` de nenhuma resposta. Não há ecrãs que consumam a listagem pública
hoje, por isso a equipa mobile não precisa de adaptação. Tratem `signature`
como metadata interna da foto — usem (ou não) na vossa plataforma de
moderação como acharem útil; não há contrato de output a respeitar do nosso
lado.

### 5. Resposta do POST

Manter o contrato actual:

- **202 Accepted** com:
  ```json
  { "success": true, "data": { "id": "<photoId>", "status": "pending" } }
  ```
- **400** se PNG inválido / corrupto.
- **404** se incidente não existe.
- **413** se ficheiro > 20 MB.
- **422** se faltar GPS no chunk `eXIf`.
  Body: `{ "success": false, "error": "missing_gps_exif" }`.
- **429** com header `Retry-After` em segundos.
- **5xx** para erros do servidor.

O cliente já mapeia todos estes códigos para mensagens UX apropriadas.

### 6. Validação alternativa do nome do campo

Pusemos **`public`** no multipart. Se preferirem `allow_publication`,
`is_public`, ou outro nome, digam — é uma alteração trivial de uma linha em
`lib/services/incident_photos_service.dart`. Não há razão técnica para
preferir um sobre outro, é só convenção da vossa codebase.

### 7. Logging recomendado no servidor

Para nos ajudar a despistar problemas futuros, é útil que loguem (sem PII):

- IP truncado, `X-App-Version`, `incident_id`.
- Tamanho do ficheiro recebido vs. tamanho após resize.
- Resultado da extracção EXIF (presente / ausente; se ausente, qual a primeira
  validação que falhou).
- Decisão de rate limiting com motivo (3/min ou 8/h).

Tem ajudado-nos a perceber o que se passa quando o cliente reporta um erro.

## Fluxo end-to-end (para confirmar a alinhamento)

1. Utilizador tira foto na app, com fogo associado.
2. App compõe watermark + injecta chunk `eXIf` com GPS.
3. App mostra diálogo legal + checkbox "publicação pública" (default ON).
4. Utilizador confirma. App envia POST com `photo` + `public=1` ou `public=0`.
5. API valida (GPS presente, tamanho, formato), guarda em MinIO + MongoDB com
   `status=pending` e `public=<flag>`.
6. API responde 202 com photoId.
7. Equipa de moderação aprova ou rejeita na vossa plataforma.
8. Aprovada `public=true` → entra no `GET /v2/incidents/{id}/photos`.
   Aprovada `public=false` → fica retida só para a ANEPC.
   Rejeitada → eliminada do MinIO e MongoDB.

## Como testar do vosso lado

```bash
# happy path com publicação autorizada (foto válida com GPS)
curl -i -X POST https://api.fogos.pt/v2/incidents/<FIRE_ID>/photos \
     -F "photo=@foto-com-gps.png" \
     -F "public=1" \
     -F "signature=João P."
# esperado: 202 + { id, status: "pending" }
# documento Mongo deve guardar signature: "João P."

# uso operacional (não público), com assinatura
curl -i -X POST https://api.fogos.pt/v2/incidents/<FIRE_ID>/photos \
     -F "photo=@foto-com-gps.png" \
     -F "public=0" \
     -F "signature=João P."
# esperado: 202 + { id, status: "pending" }
# após aprovação, NÃO deve aparecer em GET /v2/incidents/<FIRE_ID>/photos

# sem assinatura (campo ausente)
curl -i -X POST https://api.fogos.pt/v2/incidents/<FIRE_ID>/photos \
     -F "photo=@foto-com-gps.png" \
     -F "public=1"
# esperado: 202; signature guardada como null

# faltar GPS
curl -i -X POST https://api.fogos.pt/v2/incidents/<FIRE_ID>/photos \
     -F "photo=@foto-sem-gps.png" \
     -F "public=1"
# esperado: 422 + { success: false, error: "missing_gps_exif" }
```

## Pontos a confirmar (decisão da vossa equipa)

- [ ] Nome dos campos: `public`, `signature` — ok, ou preferem outros nomes?
- [ ] Default de `public` quando ausente: `true` (compat) ou `400`?
- [ ] `signature` é apenas metadata interna (cliente não lê de respostas).
- [ ] Confirmar URL base: `https://api.fogos.pt` ou outro domínio?
- [ ] Confirmar que `GET /v2/incidents/{id}/photos` filtra por `public=true` e
      não devolve GPS.
- [ ] Confirmar política de hard-delete em `rejected`.
- [ ] Logging adicional pretendido?

Quando estiverem confirmados, fechamos o lado do cliente e fica pronto para
release.

## Ficheiros-chave do cliente (para referência)

- `lib/services/incident_photos_service.dart` — cliente HTTP, parse de respostas.
- `lib/utils/png_exif.dart` — geração do chunk `eXIf` em Dart puro.
- `lib/screens/incident_camera/incident_camera_screen.dart` — diálogo de
  consentimento, watermark, captura.
- `lib/screens/settings/photo_signature_settings.dart` — assinatura opcional
  do utilizador.
- `lib/constants/endpoints.dart` — URL base.

Qualquer questão, falem connosco.
