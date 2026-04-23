import 'package:flutter/gestures.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/contributors_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/about/contributor_item.dart';
import 'package:fogosmobile/screens/assets/icons.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/utils/uri_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:redux/redux.dart';

const _linkColor = Color(0xff4D9DE0);
const _bodyStyle = TextStyle(fontSize: 14, color: Colors.black87, height: 1.6);
const _sectionTitleStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87);
const _labelStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54);
const _legendLabelStyle = TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87);
const _legendDescStyle = TextStyle(fontSize: 12, color: Colors.black54, height: 1.4);

class About extends StatelessWidget {
  Widget _section(String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _sectionTitleStyle),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: _bodyStyle),
          Expanded(child: Text(text, style: _bodyStyle)),
        ],
      ),
    );
  }

  Widget _labeledBullets(String label, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle),
          const SizedBox(height: 2),
          ...items.map(_bullet),
        ],
      ),
    );
  }

  // Ícone numa bolinha colorida, igual ao mapa
  Widget _mapIcon(Color color, String svgPath, {double opacity = 1.0, Color borderColor = Colors.white}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
        border: Border.all(color: borderColor, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 3, offset: const Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(9),
      child: SvgPicture.asset(svgPath, colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
    );
  }

  // Bolinha colorida simples (para pontos de satélite)
  Widget _dot(Color color) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 3, offset: const Offset(0, 1)),
        ],
      ),
    );
  }

  Widget _legendItem({
    required Widget icon,
    required String label,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _legendLabelStyle),
                Text(description, style: _legendDescStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendSubtitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Text(text, style: _labelStyle),
    );
  }

  Widget _contributorsWidget(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      onInit: (Store<AppState> store) {
        if (!store.state.hasContributors) {
          store.dispatch(LoadContributorsAction());
        }
      },
      builder: (BuildContext context, AppState state) {
        if (!state.hasContributors) {
          return const Center(child: CircularProgressIndicator());
        }
        return StoreConnector<AppState, List>(
          converter: (Store<AppState> store) => store.state.contributors,
          builder: (BuildContext context, List contributors) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contributors.length,
              itemBuilder: (_, int i) => ContributorItem(contributor: contributors[i]),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF512F);
    const red = Colors.red;
    const grey = Color(0xFF9E9E9E);
    const modisYellow = Color(0xFFE1BC29);
    const viirsOrange = Color(0xFFE76700);

    return Scaffold(
      appBar: FireGradientAppBar(
        title: const Text('Sobre', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                child: Center(
                  child: SvgPicture.asset(imgSvgLogoPretoCor, height: 48),
                ),
              ),

              // Header info
              _bullet('Registos com base em dados da ANEPC – Autoridade Nacional de Emergência e Proteção Civil.'),
              _bullet('Atualizações frequentes.'),
              _bullet('Localização aproximada.'),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(text: '• Sugestões: ', style: _bodyStyle),
                      TextSpan(
                        text: 'mail@fogos.pt',
                        style: const TextStyle(fontSize: 14, color: _linkColor, height: 1.6),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => launchURL('mailto:mail@fogos.pt'),
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(),
              const SizedBox(height: 12),

              // Legenda do mapa
              _section(
                'Legenda do mapa',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendSubtitle('Tipos de ocorrência'),
                    _legendItem(
                      icon: _mapIcon(orange, imgSvgIconFire),
                      label: 'Incêndio',
                      description: 'Incêndio rural ou urbano ativo no terreno.',
                    ),
                    _legendItem(
                      icon: _mapIcon(orange, imgSvgIconNonFire),
                      label: 'Outro incidente',
                      description: 'Acidente ou outra ocorrência não relacionada com incêndio.',
                    ),

                    _legendSubtitle('Estado da ocorrência'),
                    _legendItem(
                      icon: _mapIcon(orange, imgSvgIconAlarm),
                      label: 'Despacho / Chegada ao TO',
                      description: 'Meios em trânsito ou a chegar ao teatro de operações. (Despacho, 1º Alerta, Chegada ao TO)',
                    ),
                    _legendItem(
                      icon: _mapIcon(orange, imgSvgIconFire),
                      label: 'Em curso / Em resolução',
                      description: 'Fogo ativo no terreno, com ou sem perigo de propagação. (Em Curso, Em Resolução, Ocorrência Significativa)',
                    ),
                    _legendItem(
                      icon: _mapIcon(orange, imgSvgIconWatch),
                      label: 'Vigilância',
                      description: 'Meios no local a monitorizar a situação.',
                    ),
                    _legendItem(
                      icon: _mapIcon(orange, imgSvgIconPointer),
                      label: 'Conclusão / Encerrada',
                      description: 'Ocorrência em fase final ou encerrada. (Conclusão, Encerrada)',
                    ),
                    _legendItem(
                      icon: _mapIcon(grey, imgSvgIconFake),
                      label: 'Falso alarme / Falso alerta',
                      description: 'Registo sem confirmação de ocorrência real.',
                    ),
                    _legendItem(
                      icon: _mapIcon(orange, imgSvgIconFire, opacity: 0.4, borderColor: Colors.green),
                      label: 'Gestão de Combustível / Queima / Prevenção a Queimadas',
                      description: 'Ocorrência de natureza preventiva. Marcador com borda verde e transparência reduzida.',
                    ),

                    _legendSubtitle('Cor do marcador'),
                    _legendItem(
                      icon: _mapIcon(red, imgSvgIconFire),
                      label: 'Ocorrência importante',
                      description: 'Marcador a vermelho indica ocorrência prioritária ou de grande dimensão.',
                    ),

                    _legendSubtitle('Pontos de satélite'),
                    _legendItem(
                      icon: _dot(modisYellow),
                      label: 'MODIS',
                      description: 'Ponto de calor detetado por satélite NASA (Terra / Aqua).',
                    ),
                    _legendItem(
                      icon: _dot(viirsOrange),
                      label: 'VIIRS',
                      description: 'Ponto de calor detetado por satélite NASA/NOAA (Suomi NPP).',
                    ),
                  ],
                ),
              ),

              const Divider(),
              const SizedBox(height: 12),

              // Sobre o Fogos.pt
              _section(
                'Sobre o Fogos.pt',
                const Text(
                  'O Fogos.pt é uma das principais fontes de informação sobre incêndios rurais em Portugal, disponibilizando dados em tempo quase real.\n\n'
                  'A plataforma foi desenvolvida originalmente por João Pina, e hoje é operada pela VOST Portugal, que assegura a integração, tratamento e disponibilização da informação ao público e a entidades operacionais, com a liderança técnica de João Pina, também ele um fundador da VOST Portugal.\n\n'
                  'Mais do que um agregador, o Fogos.pt funciona como uma camada de integração que transforma dados complexos em informação clara, útil e acionável.',
                  style: _bodyStyle,
                ),
              ),

              const Divider(),
              const SizedBox(height: 12),

              // Origem e tratamento dos dados
              _section(
                'Origem e tratamento dos dados',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'A informação resulta da articulação de múltiplas fontes oficiais e tecnológicas, incluindo:',
                      style: _bodyStyle,
                    ),
                    const SizedBox(height: 10),
                    _labeledBullets('Autoridades', [
                      'ANEPC – Autoridade Nacional de Emergência e Proteção Civil',
                      'ICNF – Instituto da Conservação da Natureza e das Florestas',
                      'AGIF – Agência para a Gestão Integrada de Fogos Rurais',
                    ]),
                    _labeledBullets('Satélites e tecnologia', [
                      'Copernicus, NASA, Meteosat e Mapbox',
                    ]),
                    _labeledBullets('Outras fontes complementares', [
                      'Waze e contributos OSINT por voluntários da VOST Portugal',
                    ]),
                    const SizedBox(height: 4),
                    const Text(
                      'Todos os dados são integrados, processados e validados pela VOST Portugal, incluindo processos de verificação, normalização e contextualização operacional.',
                      style: _bodyStyle,
                    ),
                  ],
                ),
              ),

              const Divider(),
              const SizedBox(height: 12),

              // Parceiros e apoios
              _section(
                'Parceiros e apoios',
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('A continuidade do serviço é suportada por:', style: _bodyStyle),
                    const SizedBox(height: 8),
                    _bullet('ANEPC — através do protocolo de cooperação com a VOST Portugal'),
                    _bullet('PTServidor — infraestrutura técnica (pro bono)'),
                    _bullet('Cloudflare — segurança e resiliência (Project Galileo)'),
                    _bullet('Mapbox — visualização cartográfica'),
                    _bullet('AGIF — enquadramento institucional'),
                  ],
                ),
              ),

              const Divider(),
              const SizedBox(height: 12),

              // Compromisso
              _section(
                'Compromisso',
                const Text(
                  'O Fogos.pt e a VOST Portugal asseguram a operação contínua do Fogos.pt, mantendo elevados padrões de transparência, fiabilidade e utilidade pública, especialmente em contextos críticos.',
                  style: _bodyStyle,
                ),
              ),

              const Divider(),
              const SizedBox(height: 12),

              // Contribuidores
              const Text('Made with ♥ by:', style: _bodyStyle),
              _contributorsWidget(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
