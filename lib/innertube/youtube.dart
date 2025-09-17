import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'innertube.dart';

class Youtube {
  final Innertube _innertube;
  final List<String> logs = [];

  Youtube(this._innertube);

  // Get YouTube's Search Auto Complete
  Future<dynamic> autoComplete(String text) async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.URLS["YT_SUGGESTIONS"]}/search?q=${Uri.encodeComponent(text)}&client=youtube&ds=yt'),
        headers: {
          'Cache-Control': 'no-cache',
          'Pragma': 'no-cache',
          'Expires': '0',
        },
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        try {
          final buffer = Uint8List.fromList(response.bodyBytes);
          var data = _getEncoding(contentType).decode(buffer);

          data = data.replaceFirst(RegExp(r'^.*?\('), '').replaceFirst(RegExp(r'\)$'), '');
          var newdata = json.decode(data);


          return newdata[1];
        } catch (e) {
          return response.body;
        }
      }
      throw Exception('Failed to get suggestions');
    } catch (e) {
      throw Exception('Error getting suggestions: $e');
    }
  }

  Encoding _getEncoding(String? contentType) {
    if (contentType == null) return utf8;

    final re = RegExp(r'charset=([^()<>@,;:\"/[\]?.=\s]*)', caseSensitive: false);
    var content = re.firstMatch(contentType);

    if (content == null) {
      final re2 = RegExp(r'charset=([A-Za-z0-9-]+)', multiLine: true);
      content = re2.firstMatch(contentType);
    }

    if (content == null) return utf8;

    final charset = content.group(1)?.toLowerCase();
    switch (charset) {
      case 'utf-8':
        return utf8;
      case 'iso-8859-1':
        return latin1;
      default:
        return utf8;
    }
  }

  Future<Map<String, dynamic>> getReturnYoutubeDislike(String id) async {
    try {
      final response = await http.get(
        Uri.parse('https://returnyoutubedislikeapi.com/votes?videoId=$id'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to get dislike data');
    } catch (e) {
      throw Exception('Error getting dislike data: $e');
    }
  }

  Future<Map<String, dynamic>?> getSponsorBlock(String id) async {
    String sha256(String content) {
      return crypto.sha256.convert(utf8.encode(content)).toString().substring(0, 6);
    }

    final hashedVideoId = sha256(id);
    try {
      final response = await http.get(
        Uri.parse(
            'https://sponsor.ajay.app/api/skipSegments/$hashedVideoId'
                '?categories=%5B%22sponsor%22%2C%22poi_highlight%22%2C%22exclusive_access%22%2C%22chapter%22%2C%22selfpromo%22%2C%22interaction%22%2C%22intro%22%2C%22outro%22%2C%22preview%22%2C%22filler%22%2C%22music_offtopic%22%5D'
                '&actionTypes=%5B%22skip%22%2C%22mute%22%2C%22full%22%5D'
                '&userAgent=mnjggcdmjocbbbhaepdhchncahnbgone'
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        for (var item in data) {
          if (item['videoID'] == id) {
            return item;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }


  // Recommendations
  Future<Map<String, dynamic>> recommend() async {
    final response = await _innertube.getRecommendationsAsync();
    if (!response['success']) {
      throw Exception("An error occurred and innertube failed to respond");
    }

    var contents = response['data']['contents']['singleColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']?['contents'][0]['itemSectionRenderer']?['contents'][0]?['elementRenderer']?['newElement'] != null
        ? null
        : response['data']['contents']['singleColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']?['contents'];

    contents ??= response['data']['contents']['singleColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']['content']['richGridRenderer']?['contents'];

    if (contents != null) {
      final finalContents = contents.map((shelves) {
        final video = shelves['shelfRenderer']?['content']?['horizontalListRenderer'] ?? shelves['richItemRenderer']?['content'];
        if (video != null) {
          return video;
        }
        return null;
      }).toList();

      final continuations = response['data']['contents']['singleColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['continuations'];

      return {'continuations': continuations, 'contents': finalContents};
    } else {
      String? title;
      String? subtitle;

      response['data']['contents']['singleColumnBrowseResultsRenderer']['tabs'][0]['tabRenderer']['content']['sectionListRenderer']['contents'].forEach((tab) {
        if (tab['itemSectionRenderer'] != null) {
          if (tab['itemSectionRenderer']['contents'][0]['elementRenderer']['newElement']['type']['componentType']['model']['feedNudgeModel'] != null) {
            title = tab['itemSectionRenderer']['contents'][0]['elementRenderer']['newElement']['type']['componentType']['model']['feedNudgeModel']['nudgeData']['title']['content'];
            subtitle = tab['itemSectionRenderer']['contents'][0]['elementRenderer']['newElement']['type']['componentType']['model']['feedNudgeModel']['nudgeData']['subtitle']['content'];
          }
        } else {
          title = tab['tabRenderer']['content']['richGridRenderer']['contents'][1]['richSectionRenderer']['content']['feedNudgeRenderer']['title']['runs'][0]['text'];
          subtitle = tab['tabRenderer']['content']['richGridRenderer']['contents'][1]['richSectionRenderer']['content']['feedNudgeRenderer']['subtitle']['runs'][0]['text'];
        }
      });

      return {'title': title, 'subtitle': subtitle};
    }
  }

  Future<Map<String, dynamic>> search(String query) async {
    try {
      final response = await _innertube.getSearchAsync(query);
      return response['contents']['sectionListRenderer'];
    } catch (err) {
      return {};
    }
  }
} 