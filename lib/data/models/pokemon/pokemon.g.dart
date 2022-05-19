// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pokemon _$PokemonFromJson(Map<String, dynamic> json) => Pokemon(
      name: json['name'] as String?,
      detailUrl: json['url'] as String?,
    );

Map<String, dynamic> _$PokemonToJson(Pokemon instance) => <String, dynamic>{
      'name': instance.name,
      'url': instance.detailUrl,
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
