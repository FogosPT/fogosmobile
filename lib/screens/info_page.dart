import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';

const String _infoMarkdownData = """# MEIOS
# 
# 
- __HUMANOS__ - Bombeiros, Força Especial de Bombeiros, PSP, Forças Armadas, INEM, Equipas Sapadores Florestais, GNR, GIPS Grupo Intervenção de Proteção e Socorro
- __TERRESTRES__ - Veículos rodoviários
- __AÉREOS__ - Helicópteros / Aviões
# 
Os números disponibilizados são os totais de meios accionados. O número pode diferir do que se encontra no terreno, uma vez que os meios accionados podem ainda estar em trânsito.
# 
As horas indicadas tanto no gráfico de meios como na linha do tempo dos estados do incêndios, são as horas que o nosso sistema detetou uma mudança de dados por parte da ANEPC podendo não corresponder ao momento exato em que essa alteração ocorreu.
# 
_Perigo de incêndio recolhido do IPMA_.
#
#
# ÍNDICES DE PERIGO DE INCÊNDIO
#
#
- (FWI) Índice Meteorológico de Perigo de Incêndio - Este é o índice final do sistema Canadiano, sendo calculado em função dos seus sub-índices ISI e BUI.
- (FFMC) Índice de Humidade dos Combustíveis Finos - Este índice, classifica os combustíveis finos mortos, de secagem rápida, quanto ao seu conteúdo em humidade. Corresponde assim ao grau de inflamabilidade destes combustíveis, que se encontram à superfície do solo. O conteúdo de humidade destes combustíveis às 12 UTC de um determinado dia, depende do conteúdo de humidade à mesma hora, do dia anterior, da precipitação (mm) ocorrida em 24 horas (12-12 UTC) e da temperatura (ºC) e da humidade relativa do ar (%) às 12 UTC do próprio dia. A intensidade do vento influência apenas na velocidade de secagem destes materiais.
- (ISI) Índice de Propagação Inicial - Este índice de propagação inicial do fogo, depende do sub-índice FFMC e da intensidade do vento (km/h) às 12 UTC.
- (BUI) Índice de Combustível Disponível - O índice de combustível disponível, é um factor de avaliação dos vegetais que podem alimentar um fogo (combustíveis "pesados" que se encontram no solo) e é calculado a partir de dois dos sub-índices: DMC e DC.
- (DC) Índice de Húmus - Este índice traduz o conteúdo de humidade do húmus e materiais lenhosos de tamanho médio que se encontram abaixo da superfície do solo até cerca de 8 cm. O índice de húmus é calculado a partir da precipitação ocorrida em 24 horas (12-12 UTC), da temperatura e humidade relativa do ar às 12 UTC e do índice de húmus da véspera.
- (DMC) Índice de Seca - Este índice é um bom indicador dos efeitos da seca sazonal nos combustíveis florestais (húmus e materiais lenhosos de maiores dimensões), que se encontram abaixo da superfície do solo, entre 8 e 20 cm de profundidade. O índice de seca é obtido a partir da precipitação ocorrida em 24 horas, da temperatura às 12 UTC e do índice de seca verificado na véspera.
# 
_Informação retirada do IPMA_.
#
#
# GRÁFICOS DE PREVISÃO IPMA (DETALHE DO INCIDENTE)
#
#
Na página de detalhe de cada incidente são apresentados gráficos com a previsão IPMA para o local exato do fogo. As séries horárias cobrem ~48 h e as diárias até 10 dias. Uma linha vertical vermelha tracejada indica a hora atual; arraste lateralmente para ver mais horas/dias. A "Corrida do modelo" indicada no topo é a hora a que a previsão foi calculada.
#
- __Temperatura e humidade__ — Temperatura do ar a 2 m (°C) e humidade relativa (%). Calor + ar seco favorecem o início e a propagação do fogo.
- __Vento e rajada__ — Velocidade média e rajadas (km/h). A ponta da seta indica para onde o vento sopra. Vento forte e rajadas aumentam o risco.
- __Pressão atmosférica__ — Pressão ao nível do mar (hPa). Variações bruscas podem indicar aproximação e passagem de superfícies frontais.
- __Precipitação acumulada__ — Precipitação prevista acumulada numa hora (mm). Útil para perceber se há ou não alívio meteorológico.
- __FWI / ISI / BUI__ — Índices do sistema Canadiano (sem unidade, diários, ECMWF 12 UTC). FWI = perigo global; ISI = facilidade de propagação (vento + combustível fino); BUI = quantidade de combustível disponível.
- __DC / DMC / FFMC__ — Índices de humidade dos combustíveis (sem unidade, diários, ECMWF 12 UTC). FFMC = combustíveis finos à superfície; DMC = camada intermédia; DC = profunda/seca de longo prazo. Valores altos = combustível seco.
- __FRM — probabilidade e anomalia__ — Fire Risk Map (LSA-SAF, satélite + previsão ECMWF). Prob. extremos (%): probabilidade de FWI acima do percentil 2000. Anomalia: desvio face ao normal climatológico.
#
_O Perigo de Incêndio Rural (RCM, escala 1–5) está disponível como camada do mapa principal._
#
_Dados: IPMA — previsão ECMWF (12 UTC) + LSA-SAF._
#
#
# PERIGO DE INCÊNDIO RURAL (RCM)
#
#
O Perigo de Incêndio Rural (RCM) combina o FWI com a carta de perigosidade do território para classificar cada concelho/estação em 5 classes:
#
- __1 — Reduzido__
- __2 — Moderado__
- __3 — Elevado__
- __4 — Muito elevado__
- __5 — Máximo__
#
A camada do RCM no mapa pode ser ativada para "hoje", "amanhã" ou "depois de amanhã".
#
_Fonte: IPMA — https://www.ipma.pt/pt/riscoincendio/rcm.pt/_.
#
#
""";

class InfoPage extends StatelessWidget {
  final TextStyle _header = TextStyle(
    color: Color(0xffF25C54),
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  final TextStyle _body = TextStyle(color: Colors.black, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FireGradientAppBar(
        title: Text(
          FogosLocalizations.of(context).textInformations,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Scrollbar(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            ListTile(
              title: Text(FogosLocalizations.of(context).textInformationIncidentStatus.toUpperCase(), style: _header),
              contentPadding: EdgeInsets.symmetric(horizontal: 0),
            ),
            _occurencyBulletPoint(FogosLocalizations.of(context).textInformationFirstOrderDispatch, imgSvgIconAlarm, Color(0xffE76700)),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationArrival,
              imgSvgIconPointer,
              Color(0xffAD1F1F),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationOngoing,
              imgSvgIconFire,
              Color(0xffAD1F1F),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationSettling,
              imgSvgIconFire,
              Color(0xff4D9DE0),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationClosing,
              imgSvgIconFire,
              Color(0xffC6C8D2),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationSupervision,
              imgSvgIconWatch,
              Color(0xff4D9DE0),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationClosed,
              imgSvgIconPointer,
              Color(0xff3BB273),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textFalseAlarm,
              imgSvgIconFake,
              Color(0xffAFB2C0),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textFalseAlert,
              imgSvgIconFake,
              Color(0xffAFB2C0),
            ),
            SizedBox(height: 20),
            MarkdownBody(
              data: _infoMarkdownData,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                h1: _header,
                p: _body,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _occurencyBulletPoint(String text, String icon, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      title: Text(text),
      leading: _buildIcon(icon, color),
    );
  }

  Widget _buildIcon(String icon, Color color) {
    return CircleAvatar(
      backgroundColor: color,
      child: Container(
        width: 25,
        child: SvgPicture.asset(
          icon,
          semanticsLabel: 'Acme Logo',
        ),
      ),
    );
  }
}
