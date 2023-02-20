import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokeshouts/Models/file_info.dart';

import '../Models/shout_file.dart';

class ApiController
{
  var baseUrl = "https://pokepedia.fr/api.php";

  Future<FileInfo?> getPokemonInfos(String pkmnName) async
  {
    FileInfo? fileInfo;

    await http.get(Uri.parse("$baseUrl?action=query&prop=imageinfo&iiprop=url&titles=$pkmnName&format=json"))
      .then((response) {
        var decodedResponse = jsonDecode(response.body)["query"] as Map;
        Map<String,dynamic>? info = MapHelper.getMapByIndex(decodedResponse, "imageinfo")[0] as Map<String,dynamic>?;
        fileInfo = FileInfo.fromJson(info);
        return fileInfo;
      })
      .onError((error, stackTrace){
        throw Exception(error);
      });

    return fileInfo;
  }

  Future<FileInfo?> getPokemonShout(String pkmnName) async
  {
    FileInfo? fileInfo;

    await http.get(Uri.parse("$baseUrl?action=query&prop=images&titles=$pkmnName&format=json"))
      .then((response) async {
        var decodedResponse = jsonDecode(response.body)["query"] as Map;
        var elements = MapHelper.getMapByIndex(decodedResponse, "images").map((e) => ShoutFile(e["ns"], e["title"])).toList();
        var shoutFilename = elements.firstWhere((element) => element.title.contains("Cri")).title;
        await getPokemonInfos(shoutFilename).then((value) {
          fileInfo = value;
          return fileInfo;
        });
      });

      return fileInfo;
  }

  Future<List<String>> searchStringsInHtml(String url) async 
  {
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




class MapHelper
{
  static List result = [];
  static List getMapByIndex(Map map, String index)
  {
    for(var item in map.entries)
    {
      if(item.key == index)
      {
        MapHelper.result = item.value;
      }
      if(item.value is Map)
      {
        getMapByIndex(item.value, index);
      }
    }
    return MapHelper.result;
  }
}