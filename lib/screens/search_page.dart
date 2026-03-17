import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fogosmobile/actions/fires_actions.dart';
import 'package:fogosmobile/actions/search_actions.dart';
import 'package:fogosmobile/constants/endpoints.dart';
import 'package:fogosmobile/constants/routes.dart';
import 'package:fogosmobile/localization/fogos_localizations.dart';
import 'package:fogosmobile/models/app_state.dart';
import 'package:fogosmobile/models/fire.dart';
import 'package:fogosmobile/screens/components/fire_gradient_app_bar.dart';
import 'package:fogosmobile/screens/utils/widget_utils.dart';
import 'package:fogosmobile/screens/assets/images.dart';
import 'package:fogosmobile/utils/network_utils.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _concelhoController = TextEditingController();
  DateTime? _afterDate;
  DateTime? _beforeDate;
  bool _allIncidents = true;
  bool _hasSearched = false;

  static const int _pageSize = 20;
  int _currentPage = 0;

  final _dateFormat = DateFormat('yyyy-MM-dd');

  List<String> _concelhos = [];
  bool _conchelhosLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConcelhos();
  }

  String _toTitleCase(String text) {
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      // Keep prepositions lowercase (da, de, do, das, dos, a, e, o)
      final lower = word.toLowerCase();
      const prepositions = ['da', 'de', 'do', 'das', 'dos', 'a', 'e', 'o'];
      if (prepositions.contains(lower)) return lower;
      // Handle hyphenated words
      if (word.contains('-')) {
        return word.split('-').map((part) {
          if (part.isEmpty) return part;
          final partLower = part.toLowerCase();
          if (prepositions.contains(partLower)) return partLower;
          return partLower[0].toUpperCase() + partLower.substring(1);
        }).join('-');
      }
      return lower[0].toUpperCase() + lower.substring(1);
    }).join(' ');
  }

  Future<void> _loadConcelhos() async {
    try {
      final response = await get(Endpoints.getLocations);
      final rows = response!.data['rows'] as List;
      final names = rows
          .map<String>((r) => _toTitleCase(r['value']['name'] as String))
          .toSet()
          .toList();
      names.sort((a, b) => removeDiacritics(a)
          .toLowerCase()
          .compareTo(removeDiacritics(b).toLowerCase()));
      setState(() {
        _concelhos = names;
        _conchelhosLoading = false;
      });
    } catch (_) {
      setState(() => _conchelhosLoading = false);
    }
  }

  void _search() {
    final concelho = _concelhoController.text.trim();
    if (concelho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Introduza um concelho')),
      );
      return;
    }

    setState(() {
      _currentPage = 0;
      _hasSearched = true;
    });

    final store = StoreProvider.of<AppState>(context);
    store.dispatch(SearchIncidentsAction(
      concelho: concelho,
      all: _allIncidents,
      after: _afterDate != null ? _dateFormat.format(_afterDate!) : null,
      before: _beforeDate != null ? _dateFormat.format(_beforeDate!) : null,
    ));
  }

  Future<void> _pickDate(BuildContext context, bool isAfter) async {
    FocusScope.of(context).unfocus();
    final initial = isAfter ? (_afterDate ?? DateTime.now()) : (_beforeDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isAfter) {
          _afterDate = picked;
        } else {
          _beforeDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _concelhoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FireGradientAppBar(
        title: Text(
          FogosLocalizations.of(context).textSearch,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _buildSearchForm(),
          Expanded(
            child: _buildResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                // If text matches an option exactly, hide the dropdown
                if (_concelhos.contains(textEditingValue.text)) {
                  return const Iterable<String>.empty();
                }
                final query = removeDiacritics(textEditingValue.text).toLowerCase();
                final matches = _concelhos.where((c) =>
                    removeDiacritics(c).toLowerCase().contains(query)).toList();
                // Limit visible results to avoid huge lists
                return matches.take(20);
              },
              onSelected: (String selection) {
                _concelhoController.text = selection;
              },
              fieldViewBuilder: (context, textController, focusNode, onFieldSubmitted) {
                // Sync our controller with autocomplete's controller
                textController.addListener(() {
                  _concelhoController.text = textController.text;
                });
                return TextField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Concelho',
                    hintText: _conchelhosLoading
                        ? 'A carregar concelhos...'
                        : 'Ex: Lisboa, Porto, Faro...',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                    suffixIcon: textController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, size: 20),
                            onPressed: () {
                              textController.clear();
                              _concelhoController.clear();
                            },
                          )
                        : null,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) {
                    onFieldSubmitted();
                    _search();
                  },
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return ListTile(
                            dense: true,
                            title: Text(option),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Depois de',
                        prefixIcon: Icon(Icons.calendar_today, size: 20),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        _afterDate != null ? _dateFormat.format(_afterDate!) : '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Antes de',
                        prefixIcon: Icon(Icons.calendar_today, size: 20),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(
                        _beforeDate != null ? _dateFormat.format(_beforeDate!) : '',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: Text('Todas as ocorrências', style: TextStyle(fontSize: 14)),
                    value: _allIncidents,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) => setState(() => _allIncidents = val),
                  ),
                ),
                SizedBox(width: 8),
                StoreConnector<AppState, AppState>(
                  converter: (Store<AppState> store) => store.state,
                  builder: (context, state) {
                    return ElevatedButton.icon(
                      onPressed: state.isLoading ? null : _search,
                      icon: state.isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.search),
                      label: Text('Pesquisar'),
                    );
                  },
                ),
              ],
            ),
            if (_afterDate != null || _beforeDate != null)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: TextButton(
                  onPressed: () => setState(() {
                    _afterDate = null;
                    _beforeDate = null;
                  }),
                  child: Text('Limpar datas', style: TextStyle(fontSize: 12)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return StoreConnector<AppState, AppState>(
      converter: (Store<AppState> store) => store.state,
      builder: (context, state) {
        if (!_hasSearched) {
          return Center(
            child: Text(
              'Pesquise por concelho',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        if (state.isLoading && state.searchResults.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        final results = state.searchResults;

        if (results.isEmpty) {
          return Center(
            child: Text(
              'Sem resultados',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final totalPages = (results.length / _pageSize).ceil();
        final startIndex = _currentPage * _pageSize;
        final endIndex = (startIndex + _pageSize).clamp(0, results.length);
        final pageResults = results.sublist(startIndex, endIndex);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${results.length} resultado(s)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (totalPages > 1)
                    Text(
                      'Página ${_currentPage + 1} de $totalPages',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: pageResults.length,
                itemBuilder: (context, index) {
                  return _buildFireCard(pageResults[index]);
                },
              ),
            ),
            if (totalPages > 1) _buildPagination(totalPages),
          ],
        );
      },
    );
  }

  Widget _buildFireCard(Fire fire) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: getFireColor(fire),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              getCorrectStatusImage(fire.statusCode, fire.important),
              width: 24,
              height: 24,
            ),
          ),
        ),
        title: Text(
          '${fire.district}, ${fire.city}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${fire.town}, ${fire.local}', style: TextStyle(fontSize: 13)),
            SizedBox(height: 2),
            if (fire.nature != null)
              Text(fire.nature!, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
            SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text('${fire.date} ${fire.time}',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                Spacer(),
                Icon(Icons.people, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text('${fire.human}',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(width: 8),
                Icon(Icons.directions_car, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text('${fire.terrain}',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(width: 8),
                Icon(Icons.flight, size: 14, color: Colors.grey),
                SizedBox(width: 4),
                Text('${fire.aerial}',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        isThreeLine: true,
        onTap: () {
          final store = StoreProvider.of<AppState>(context);
          store.dispatch(ClearFireAction());
          store.dispatch(LoadFireAction(fire.id));
          Navigator.of(context).pushNamed(FIRE_DETAILS_ROUTE);
        },
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
          ),
          ...List.generate(
            totalPages > 5 ? 5 : totalPages,
            (i) {
              final page = totalPages > 5
                  ? _getVisiblePage(i, totalPages)
                  : i;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: InkWell(
                  onTap: () => setState(() => _currentPage = page),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _currentPage == page
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '${page + 1}',
                        style: TextStyle(
                          color: _currentPage == page
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
          ),
        ],
      ),
    );
  }

  int _getVisiblePage(int index, int totalPages) {
    if (_currentPage <= 2) return index;
    if (_currentPage >= totalPages - 3) return totalPages - 5 + index;
    return _currentPage - 2 + index;
  }
}
