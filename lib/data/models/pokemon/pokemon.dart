import 'package:json_annotation/json_annotation.dart';

part 'pokemon.g.dart';

@JsonSerializable()
class Pokemon {
  String? name;
  // @JsonKey(name: 'url')
  String? url;

  Pokemon({
    this.name,
    this.url,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  get value => null;

  Map<String, dynamic> toJson() => _$PokemonToJson(this);

  @override
  String toString() {
    return "($name,$url)";
  }
}

@JsonSerializable()
class PokemonAbilities {
  List<PokemonAbilityDetail>? abilities;
  String? name;

  PokemonAbilities({
    this.abilities,
    this.name,
  });

  factory PokemonAbilities.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilitiesFromJson(json);

  get value => null;

  Map<String, dynamic> toJson() => _$PokemonAbilitiesToJson(this);

  @override
  String toString() {
    return "($abilities)";
  }
}

@JsonSerializable()
class PokemonAbilityDetail {
  @JsonKey(name: 'is_hidden')
  bool? isHidden;
  int? slot;
  // String? name;
  PokemonAbility? ability;

  PokemonAbilityDetail({
    this.isHidden,
    this.slot,
    // this.name,
    this.ability,
  });

  factory PokemonAbilityDetail.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilityDetailFromJson(json);

  get value => null;

  Map<String, dynamic> toJson() => _$PokemonAbilityDetailToJson(this);

  @override
  String toString() {
    return "($isHidden,$slot)";
  }
}

@JsonSerializable()
class PokemonAbility {
  String? name;
  String? url;

  PokemonAbility({
    this.name,
    this.url,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) =>
      _$PokemonAbilityFromJson(json);

  get value => null;

  @override
  String toString() {
    return "($name,$url)";
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

  get value => null;

  @override
  String toString() {
    return "($count,$pokemons)";
  }
}
