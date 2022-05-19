import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> sortBy<TSelected extends Comparable<TSelected>>(
          TSelected Function(T) selector) =>
      toList()..sort((a, b) => selector(a).compareTo(selector(b)));

  Iterable<T> sortByDescending<TSelected extends Comparable<TSelected>>(
          TSelected Function(T) selector) =>
      sortBy(selector).toList().reversed;
}

@JsonSerializable()
class Pokemon {
  String? name;
  @JsonKey(name: 'url')
  String? detailUrl;

  Pokemon({
    this.name,
    this.detailUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  get value => null;

  Map<String, dynamic> toJson() => _$PokemonToJson(this);

  @override
  String toString() {
    return "($name,$detailUrl)";
  }
}

@JsonSerializable()
class PokemonsEntity {
  final int? count;
  final String? next;
  final String? previous;
  @JsonKey(name: 'results')
  final List<Pokemon>? pokemons;

  const PokemonsEntity({this.count, this.next, this.previous, this.pokemons});

  factory PokemonsEntity.fromJson(Map<String, dynamic> json) =>
      _$PokemonsEntityFromJson(json);

  @override
  String toString() {
    return "($count,$pokemons)";
  }
}
