import 'dart:async';
import 'dart:io';

import '../../configs/config.dart';
import '../providers/network/base_provider.dart';

abstract class IPokemonRepository {
  Future<dynamic> getPokemons({required String url});
}

class PokemonRepository extends BaseProvider implements IPokemonRepository {
  @override
  Future getPokemons({
    required String url,
  }) async {
    try {
      await request(
        method: Requests.get,
        path: url,
      );

      return decodeResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } on TimeoutException {
      throw ServiceNotRespondingException(
          'Service not responding in time please check your Internet Connection');
    }
  }
}
