import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokeshouts/Models/Pokepedia/pokepedia_image_dto.dart';
import 'package:pokeshouts/Models/Pokepedia/pokepedia_shout_file.dart';
import 'package:pokeshouts/Models/pokemon.dart';
import 'package:pokeshouts/Views/Helpers/pokedex_helper.dart';

class ApiController {
  final String _baseUrl = "https://www.pokepedia.fr/api.php";

  Future<PokepediaImageDTO> _getPokemonImageAsync(String pkmnName) async {
    http.Response response = await http.get(Uri.parse("$_baseUrl?action=query&prop=pageimages&titles=$pkmnName&format=json&pithumbsize=500"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final pages = data['query']['pages'];
      final pageKey = pages.keys.first;
      final page = pages[pageKey];

      if (page.containsKey('thumbnail')) {
        return PokepediaImageDTO.fromJson(page['thumbnail']);
      }
    }

    throw Exception("Image non trouvée, ou parsing échoué.");
  }

  /// Méthode pour récupérer le cri de Pokmon depuis MediaWiki
  /// => Méthode pas fiable, les fichiers OGG sont pas toujours présents dans les retours MediaWiki,
  /// en attente d'une refonte
  Future<String> _getPokemonShoutUrlAsync(String pkmnName) async {
    http.Response response = await http.get(Uri.parse("$_baseUrl?action=query&prop=images&titles=$pkmnName&format=json"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final pages = data['query']['pages'];
      final pageKey = pages.keys.first;
      final page = pages[pageKey];

      List<PokepediaShoutFile> elements = _MapHelper.getMapByIndex(page, "images").map((e) => PokepediaShoutFile(e["ns"], e["title"])).toList();

      String shoutFilename = elements.firstWhere((element) => element.title.contains("Cri")).title.replaceAll(" ", "_");

      return "https://www.pokepedia.fr/Spécial:FilePath/$shoutFilename";
    }
    throw Exception("Cri non trouvé, ou parsing échoué.");
  }

  Future<String> _getPokemonShoutUrlFromPokedexHelperAsync(int pkmnIndex, String game) async {
    String pkmnIdStr = "";
    switch (pkmnIndex.toString().length) {
      case 1:
        pkmnIdStr = "000$pkmnIndex";
        break;
      case 2:
        pkmnIdStr = "00$pkmnIndex";
        break;
      case 3:
        pkmnIdStr = "0$pkmnIndex";
        break;
      case 4:
      default:
        pkmnIdStr = pkmnIndex.toString();
        break;
    }

    return "https://www.pokepedia.fr/Spécial:FilePath/Cri_${pkmnIdStr}_$game.ogg";
  }

  Future<Pokemon> getPokemonInfosAsync(int pkmnIndex) async {
    PokedexValue pkmn = PokedexValue.fromJson(PokedexHelper.pokedex.entries.firstWhere((element) => element.key == pkmnIndex).value);

    PokepediaImageDTO imageDTO = await _getPokemonImageAsync(pkmn.name);
    String pokemonShoutUrl = await _getPokemonShoutUrlFromPokedexHelperAsync(pkmnIndex, pkmn.game);

    Pokemon pokemon = Pokemon(pkmnIndex, pkmn.name, imageDTO.source, pokemonShoutUrl);
    return pokemon;
  }

  Future<List<String>> searchStringsInHtml(String url) async {
    final response = await http.get(Uri.parse(url));

    final regex = RegExp(r'(https:\/\/)*www.pokepedia.fr\/images\/[a-zA-Z0-9\/_%-.]+(.ogg|.png)([a-zA-Z0-9\/_%-.])*(.ogg|.png)*');
    final matches = regex.allMatches(response.body);

    final List<String> strings = [];
    for (final match in matches) {
      strings.add(match.group(0)!);
    }

    return strings;
  }
}

class _MapHelper {
  static List getMapByIndex(Map map, String index) {
    List result = [];
    for (var item in map.entries) {
      if (item.key == index) {
        result = item.value;
      }
      if (item.value is Map) {
        getMapByIndex(item.value, index);
      }
    }
    return result;
  }
}
