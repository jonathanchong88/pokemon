import 'package:flutter_app_pokemon/data/data.dart';
import 'package:flutter_app_pokemon/views/detail/detail_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'detail_controller_test.mocks.dart';

class DetailControllerTest extends Mock implements DetailController {}

@GenerateMocks([DetailControllerTest])
void main() {
  late MockDetailControllerTest detailControllerTest;
  //
  setUpAll(() {
    detailControllerTest = MockDetailControllerTest();
  });

  group('detail controller test', () {
    test('test request pokemon detail data', () async {
      final model = PokemonAbilities();

      // arrange
      when(detailControllerTest.getPokemonDetailRequest())
          .thenAnswer((_) async {
        return model;
      });

      // act
      final res = await detailControllerTest.getPokemonDetailRequest();

      // expect
      expect(res, isA<PokemonAbilities>());
      expect(res, model);
    });

    test('test request pokemon detail data throws Exception', () {
      // arrange
      when(detailControllerTest.getPokemonDetailRequest())
          .thenAnswer((_) async {
        throw Exception();
      });
      // act
      final res = detailControllerTest.getPokemonDetailRequest();

      // expect
      expect(res, throwsException);
    });
  });
}
