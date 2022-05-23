// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) => Pokemon(
      name: json['name'] as String?,
      url: json['url'] as String?,
      isFavourite: json['isFavourite'] as bool? ?? false,
    );

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'isFavourite': instance.isFavourite,
    };

PokemonAbilities _$PokemonAbilitiesFromJson(Map<String, dynamic> json) =>
    PokemonAbilities(
      abilities: (json['abilities'] as List<dynamic>?)
          ?.map((e) => PokemonAbilityDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$PokemonAbilitiesToJson(PokemonAbilities instance) =>
    <String, dynamic>{
      'abilities': instance.abilities,
      'name': instance.name,
    };

PokemonAbilityDetail _$PokemonAbilityDetailFromJson(
        Map<String, dynamic> json) =>
    PokemonAbilityDetail(
      isHidden: json['is_hidden'] as bool?,
      slot: json['slot'] as int?,
      ability: json['ability'] == null
          ? null
          : PokemonAbility.fromJson(json['ability'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PokemonAbilityDetailToJson(
        PokemonAbilityDetail instance) =>
    <String, dynamic>{
      'is_hidden': instance.isHidden,
      'slot': instance.slot,
      'ability': instance.ability,
    };

PokemonAbility _$PokemonAbilityFromJson(Map<String, dynamic> json) =>
    PokemonAbility(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$PokemonAbilityToJson(PokemonAbility instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
    };

PokemonsEntity _$PokemonsEntityFromJson(Map<String, dynamic> json) =>
    PokemonsEntity(
      count: json['count'] as int?,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      pokemons: (json['results'] as List<dynamic>?)
          ?.map((e) => Pokemon.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PokemonsEntityToJson(PokemonsEntity instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.pokemons,
    };
