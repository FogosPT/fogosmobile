import 'package:flutter/gestures.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fogosmobile/actions/contributors_actions.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/screens/about/contributor_item.dart';
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

              // Sobre o Fogos.pt
              _section(
                'Sobre o Fogos.pt',
                const Text(
                  'O Fogos.pt é uma das principais fontes de informação sobre incêndios rurais em Portugal, com dados em tempo quase real.\n\n'
                  'Mais do que um agregador, funciona como uma camada de integração que transforma dados complexos em informação clara, útil e acessível.',
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
                      'A informação resulta da articulação de múltiplas fontes oficiais e tecnológicas:',
                      style: _bodyStyle,
                    ),
                    const SizedBox(height: 10),
                    _labeledBullets('Autoridades', [
                      'ANEPC – Autoridade Nacional de Emergência e Proteção Civil',
                      'ICNF – Instituto da Conservação da Natureza e das Florestas',
                      'AGIF – Agência para a Gestão Integrada de Fogos Rurais',
                    ]),
                    _labeledBullets('Satélites e tecnologia', [
                      'Copernicus, NASA, Meteosat',
                      'Mapbox',
                    ]),
                    _labeledBullets('Colaboração', [
                      'Waze',
                      'Contributos OSINT validados pela VOST Portugal',
                    ]),
                    const SizedBox(height: 4),
                    const Text(
                      'Antes de serem apresentados, os dados passam por processos de validação, normalização e agregação, garantindo informação consistente e fiável.',
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
                    _bullet('PTServidor — infraestrutura técnica (pro bono)'),
                    _bullet('Cloudflare — segurança e resiliência (Project Galileo)'),
                    _bullet('Mapbox — visualização cartográfica'),
                    _bullet('Agência para a Gestão Integrada de Fogos Rurais — enquadramento institucional'),
                    _bullet('VOST Portugal — validação e contextualização de informação'),
                  ],
                ),
              ),

              const Divider(),
              const SizedBox(height: 12),

              // Compromisso
              _section(
                'Compromisso',
                const Text(
                  'Manter a transparência e a utilidade pública, assegurando o acesso contínuo a informação fiável, especialmente em momentos críticos.',
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
