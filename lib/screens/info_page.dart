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
As horas indicadas tanto no gráfico de meios como na linha do tempo dos estados do incêndios, são as horas que o nosso sistema detetou uma mudança de dados por parte da ANPC podendo não corresponder ao momento exato em que essa alteração ocorreu.
# 
_Risco de incêndio recolhido do IPMA_.
# 
# 
# ÍNDICES DE RISCO DE INCÊNDIO
# 
# 
- (FWI) Índice Meteorológico de Risco de Incêndio - Este é o índice final do sistema Canadiano, sendo calculado em função dos seus sub-índices ISI e BUI.
- (FFMC) Índice de Humidade dos Combustíveis Finos - Este índice, classifica os combustíveis finos mortos, de secagem rápida, quanto ao seu conteúdo em humidade. Corresponde assim ao grau de inflamabilidade destes combustíveis, que se encontram à superfície do solo. O conteúdo de humidade destes combustíveis às 12 UTC de um determinado dia, depende do conteúdo de humidade à mesma hora, do dia anterior, da precipitação (mm) ocorrida em 24 horas (12-12 UTC) e da temperatura (ºC) e da humidade relativa do ar (%) às 12 UTC do próprio dia. A intensidade do vento influência apenas na velocidade de secagem destes materiais.
- (ISI) Índice de Propagação Inicial - Este índice de propagação inicial do fogo, depende do sub-índice FFMC e da intensidade do vento (Km/h) às 12 UTC.
- (BUI) Índice de Combustível Disponível - O índice de combustível disponível, é um factor de avaliação dos vegetais que podem alimentar um fogo (combustíveis "pesados" que se encontram no solo) e é calculado a partir de dois dos sub-índices: DMC e DC.
- (DC) Índice de Húmus - Este índice traduz o conteúdo de humidade do húmus e materiais lenhosos de tamanho médio que se encontram abaixo da superfície do solo até cerca de 8 cm. O índice de húmus é calculado a partir da precipitação ocorrida em 24 horas (12-12 UTC), da temperatura e humidade relativa do ar às 12 UTC e do índice de húmus da véspera.
- (DMC) Índice de Seca - Este índice é um bom indicador dos efeitos da seca sazonal nos combustíveis florestais (húmus e materiais lenhosos de maiores dimensões), que se encontram abaixo da superfície do solo, entre 8 e 20 cm de profundidade. O índice de seca é obtido a partir da precipitação ocorrida em 24 horas, da temperatura às 12 UTC e do índice de seca verificado na véspera.
# 
_Informação retirada do IPMA_.
# 
# 
""";

class InfoPage extends StatelessWidget {
  final TextStyle _header = TextStyle(
    color: Color(0xffff512f),
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  final TextStyle _body = TextStyle(color: Colors.black, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new FireGradientAppBar(
        title: new Text(
          FogosLocalizations.of(context).textInformations,
          style: new TextStyle(color: Colors.white),
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
            _occurencyBulletPoint(FogosLocalizations.of(context).textInformationFirstOrderDispatch, imgSvgIconAlarm, Color(0xffff6e02)),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationArrival,
              imgSvgIconPointer,
              Color(0xffb81e1f),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationOngoing,
              imgSvgIconFire,
              Color(0xffb81e1f),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationSettling,
              imgSvgIconFire,
              Color(0xff65c4ed),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationClosing,
              imgSvgIconFire,
              Color(0xff8e7e7d),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationSupervision,
              imgSvgIconWatch,
              Color(0xff65c4ed),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textInformationClosed,
              imgSvgIconPointer,
              Color(0xff6abf59),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textFalseAlarm,
              imgSvgIconFake,
              Color(0xffbdbdbd),
            ),
            _occurencyBulletPoint(
              FogosLocalizations.of(context).textFalseAlert,
              imgSvgIconFake,
              Color(0xffbdbdbd),
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
