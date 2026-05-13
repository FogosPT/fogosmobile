# Plano para a equipa do frontend — exibição de fotos no site

## Objectivo

Mostrar, na página de cada incidente do site fogos.pt, as fotos submetidas pelos utilizadores que já foram aprovadas pela moderação.

## 1. Endpoint a consumir

`GET https://api.fogos.pt/v2/incidents/{id}/photos`

- `{id}` — id do incidente (mesmo id já usado nas páginas de detalhe; aceita tanto o id legado como o `_id`).
- Sem autenticação. Público.
- Query params opcionais:
  - `per_page` (default 20, máx 50)
  - `page` (paginação standard)
- Resposta com `Cache-Control: public, max-age=300` (5 min) — usar cache HTTP normal do browser/CDN.

## 2. Formato da resposta

```json
{
  "success": true,
  "data": [
    {
      "id": "65f...",
      "url": "https://<minio-public>/incidents/<fireId>/<photoId>.jpg",
      "taken_at": "2026-05-13T14:32:11+00:00",
      "captured_at": "2026-05-13T14:32:11+00:00",
      "width": 1600,
      "height": 1200
    }
  ],
  "meta": { "total": 12, "page": 1, "per_page": 20 }
}
```

Notas:

- A API só devolve fotos aprovadas e marcadas como públicas. O frontend não precisa de fazer qualquer filtro adicional.
- `url` é um link público directo (MinIO/S3) — usar como `src` de `<img>`.
- `taken_at` e `captured_at` são o mesmo valor (timestamp EXIF da captura). Usar `captured_at`.
- Não há GPS, autor, nem assinatura no payload público — não tentar exibir esses campos; foram intencionalmente removidos.
- Ordenadas da mais recente para a mais antiga.

## 3. UI a implementar

1. Galeria na página do incidente:
   - Carregar a primeira página ao abrir o detalhe do incidente.
   - Se `meta.total === 0`, não mostrar a secção (ou mostrar estado vazio discreto).
   - Grid de thumbnails (usar `width`/`height` para reservar espaço e evitar layout shift).
2. Lightbox / vista ampliada ao clicar numa thumb, com a data de captura formatada (`captured_at`) e navegação prev/next.
3. Paginação ou "carregar mais" consoante `meta.total`.
4. Lazy loading das imagens (`loading="lazy"`).

## 4. Estados a tratar

- Lista vazia → esconder secção.
- Erro de rede → não bloquear o resto da página; falhar em silêncio ou mostrar mensagem discreta.
- Imagem que falha a carregar → esconder o item, não mostrar broken image.

## 5. Outras indicações

- Se não houver imagens não mostra nada na interface.
