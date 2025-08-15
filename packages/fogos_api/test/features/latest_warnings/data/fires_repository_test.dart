import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:fogos_api/features/latest_warnings/data/fires_service.dart'
    show FiresService;
import 'package:fogos_api/features/latest_warnings/domain/fire.dart';
import 'package:fogos_api/features/latest_warnings/domain/fires.dart';
import 'package:fogos_api/networking/fogos_base_client.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/mock_fires.dart';
import 'fires_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FogosBaseClient>(),
])
void main() {
  FogosBaseClient fogosBaseClient = MockFogosBaseClient();

  late FiresService firesRepository;

  setUp(() {
    firesRepository = FiresService(fogosBaseClient);
  });

  test('Parses correctly a fire', () async {
    final data = json.decode(getFireMock);

    final fire = Fire.fromJson(data);

    expect(fire, isA<Fire>());
  });

  test('Parses correctly the list of fires', () async {
    when(fogosBaseClient.listActiveFires()).thenAnswer(
      (_) async => http.Response(getFiresMock, 200),
    );
    final response = await firesRepository.listActiveFires();
    expect(response, isA<Fires>());
  });

  test('Throws exception when response is not 200', () async {
    when(fogosBaseClient.listActiveFires()).thenAnswer(
      (_) async => http.Response('error', 500),
    );
    expect(firesRepository.listActiveFires(), throwsException);
  });
}
