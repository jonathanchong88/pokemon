import 'package:flutter_app_pokemon/configs/utils/api.dart';
import 'package:flutter_app_pokemon/data/models/pokemon/pokemon.dart';
import 'package:flutter_app_pokemon/views/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_controller_test.mocks.dart';

class HomeControllerTest extends Mock implements HomeController {}

@GenerateMocks([HomeControllerTest])
void main() {
  late MockHomeControllerTest homeControllerTest;
  //
  setUpAll(() {
    homeControllerTest = MockHomeControllerTest();
  });

  group('home controller test', () {
    test('test request pokemons data', () async {
      final model = PokemonsEntity();

      // arrange
      when(homeControllerTest.pokemonRequest(Api.pokemonDbDefaultUrl))
          .thenAnswer((_) async {
        return model;
      });

      // act
      final res =
          await homeControllerTest.pokemonRequest(Api.pokemonDbDefaultUrl);

      // expect
      expect(res, isA<PokemonsEntity>());
      expect(res, model);
    });

    test('test request pokemons data throws Exception', () {
      // arrange
      when(homeControllerTest.pokemonRequest(Api.pokemonDbDefaultUrl))
          .thenAnswer((_) async {
        throw Exception();
      });
      // act
      final res = homeControllerTest.pokemonRequest(Api.pokemonDbDefaultUrl);

      // expect
      expect(res, throwsException);
    });

    test('test request favourite pokemons data', () async {
      final model = PokemonsEntity();

      // arrange
      when(homeControllerTest.favouritePokemonRequest()).thenAnswer((_) async {
        return model;
      });

      // act
      final res = await homeControllerTest.favouritePokemonRequest();

      // expect
      expect(res, isA<PokemonsEntity>());
      expect(res, model);
    });

    test('test request pokemons data throws Exception', () {
      // arrange
      when(homeControllerTest.favouritePokemonRequest()).thenAnswer((_) async {
        throw Exception();
      });

      // act
      final res = homeControllerTest.favouritePokemonRequest();

      // expect
      expect(res, throwsException);
    });
  });
}
