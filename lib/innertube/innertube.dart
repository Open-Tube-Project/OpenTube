import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:string_unescape/string_unescape.dart';
import 'constants.dart';

class Innertube {
  final Function(String, bool, [String?])? errorCallback;
  int retryCount = 0;
  String playerParams = "";
  int signatureTimestamp = 0;
  String Function(String)? nFunction = (n) => n; // Placeholder: identity function
  String visitorData = "";
  String getPot = "";
  String pot = "";
  String secretArrayName = "";
  String? key;
  Map<String, dynamic>? context;
  bool? loggedIn;
  Map<String, String>? header;
  Function? decodeUrl;

  Innertube(this.errorCallback);

  bool checkErrorCallback() {
    return errorCallback != null;
  }
/*
* Decipher methods, that can't be implemented in Dart language (flutter_js maybe?)
*
  List<String>? getSecretArray(String secretArrayName, String rootPageBody) {
    final re1 = RegExp('var ${secretArrayName.replaceAll(r'$', r'\$')}=("|\').*("|\').split\\(".*"\\)\\n', multiLine: true);
    var array = re1.firstMatch(rootPageBody);

    if (array == null) {
      final re2 = RegExp('var ${secretArrayName.replaceAll(r'$', r'\$')}=\'(.*)\'.split\\("(.*)"\\)', multiLine: true);
      array = re2.firstMatch(rootPageBody);
    }

    if (array == null) {
      final re3 = RegExp('var ${secretArrayName.replaceAll(r'$', r'\$')}=\\[(.*.*\\n.*)\\n.*\\]', multiLine: true);
      array = re3.firstMatch(rootPageBody);
    }

    if (array == null) {
      final re4 = RegExp('var ${secretArrayName.replaceAll(r'$', r'\$')}=\\[(.*.*\n.*)\\]', multiLine: true);
      array = re4.firstMatch(rootPageBody);
    }

    if (array != null) {
      final arrayStr = "${array.group(0)!}; return $secretArrayName;";
      final cleanArrayStr = arrayStr.replaceAll("),\n; return ", ") \n; return ");
      return _executeArrayFunction(cleanArrayStr);
    }
    return null;
  }

  List<String>? _executeArrayFunction(String functionStr) {
    try {
      final arrayMatch = RegExp(r'\[(.*)\]').firstMatch(functionStr);
      if (arrayMatch != null) {
        final arrayContent = arrayMatch.group(1)!;
        return arrayContent.split(',').map((e) => e.trim().replaceAll('"', '')).toList();
      }
    } catch (e) {
      print('Error executing array function: $e');
    }
    return null;
  }

  String decodeFunctionWithSecretArray(String functionBody, List<String> secretArray, String secretArrayName) {
    final regex = RegExp('(${secretArrayName.replaceAll(r'$', r'\$')})\\[([0-9]+)\\]', multiLine: true);
    return functionBody.replaceAllMapped(regex, (match) {
      final index = int.parse(match.group(2)!);
      return secretArray[index].replaceAllMapped(RegExp(r'''(["'\\])'''), (match) => '\\${match[0]}');
    });
  }

  String processFunctionWithSecretArray(RegExpMatch helpDecipher, String functionBody, String rootDocumentBody) {
    RegExp secretArrayPattern = RegExp(r'\[([A-z0-9$]+)\[[A-z0-9$]+\]');
    RegExpMatch? secretArray = secretArrayPattern.firstMatch(helpDecipher.group(0)!);

    if (secretArray != null) {
      String secretArrayName = secretArray.group(1)!;
      List<String>? splitDataFromSecretArray = getSecretArray(secretArrayName, rootDocumentBody);
      return decodeFunctionWithSecretArray(functionBody, splitDataFromSecretArray!, secretArrayName);
    }

    return functionBody;
  }

  String? processFunctionWithKnownSecretArray(String functionBody, String rootDocumentBody) {
    final splitDataFromSecretArray = getSecretArray(secretArrayName, rootDocumentBody);
    if (splitDataFromSecretArray != null) {
      return decodeFunctionWithSecretArray(functionBody, splitDataFromSecretArray, secretArrayName);
    }
    return null;
  }

  Future<void> makeDecipherFunction(Map<String, dynamic> baseJs) async {
    try {
      RegExpMatch? isMatch;

      RegExp pattern1 = RegExp(r';var [A-Za-z$]+=\{[A-Za-z0-9]+:function\([^)]*\)\{[^}]*\},\n[A-Za-z0-9]+:function\(a\)\{[^}]*\},\n[A-Za-z0-9]+:function\([^)]*\)\{[^}]*\}\};');
      isMatch = pattern1.firstMatch(baseJs['data']);

      if (isMatch == null) {
        RegExp pattern2 = RegExp(r'var [A-z0-9$]+=\{[A-Za-z0-9]+:function\([^)]*\)\{[^}]*\},\n[A-Za-z0-9]+:function\([^)]*\)\{[^}]*\},\n[A-Za-z0-9]+:function\([^)]*\)\{[^}]*\}\}\;');
        isMatch = pattern2.firstMatch(baseJs['data']);
      }

      if (isMatch != null) {
        String? firstPart = isMatch.group(0)!;
        dynamic helpDecipher;

        RegExp pattern3 = RegExp(r'\{[A-Za-z$]=[A-z0-9$]\.split\(""\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);return [A-z0-9$]\.join\(""\)\};');
        isMatch = pattern3.firstMatch(baseJs['data']);

        if (isMatch == null) {
          RegExp pattern4 = RegExp(r'{[A-Za-z$]=[A-z0-9$]\.split\(""\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);return +[A-z0-9$]\.join\(""\)};');
          isMatch = pattern4.firstMatch(baseJs['data']);
        }

        if (isMatch == null) {
          RegExp pattern5 = RegExp(r'\{[A-Za-z$]=[A-z0-9$]\.split\(""\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);return +[A-z0-9$]\.join\(""\)};');
          isMatch = pattern5.firstMatch(baseJs['data']);
        }

        if (isMatch == null) {
          RegExp pattern6 = RegExp(r'\{[A-Za-z]=[A-Za-z]\.split\(""[^"]*""\)\};', caseSensitive: false);
          isMatch = pattern6.firstMatch(baseJs['data']);
        }

        if (isMatch == null) {
          RegExp pattern7 = RegExp(r'\{a=a\.split\(""\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);return a\.join\(""\)\};');
          isMatch = pattern7.firstMatch(baseJs['data']);
        }

        if (isMatch == null) {
          RegExp pattern8 = RegExp(r'\{[A-Za-z$]=[A-z0-9$]\.split\(""\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);[A-z0-9$]+\.[A-Za-z0-9]+\([^)]*\);return +[A-z0-9$]\.join\(""\)};');
          isMatch = pattern8.firstMatch(baseJs['data']);
        }

        if (isMatch == null) {
          RegExp pattern9 = RegExp(r'{[A-Za-z]=[A-Za-z]\.split\(""\);.*return [A-Za-z]\.join\(""\)};');
          isMatch = pattern9.firstMatch(baseJs['data']);
        }

        if (isMatch == null) {
          RegExp pattern10 = RegExp(r'{[A-Za-z]=[A-Za-z]\.split\(.*\);return [A-Za-z]\.join\(.*\)};');
          helpDecipher = pattern10.firstMatch(baseJs['data']);
          if (helpDecipher != null) {
            String? processed = processFunctionWithSecretArray(helpDecipher, helpDecipher.group(0)!, baseJs['data']);

            RegExp regex = RegExp(helpDecipher);
            isMatch = regex.firstMatch(processed!);
          }
        }

        if (isMatch == null) {
          RegExp pattern11 = RegExp(r'{[A-Za-z]=[A-Za-z]\[[A-Za-z$]+\[[0-9]+\]\]\([A-Za-z$]+\[[0-9]+\]\).*');
          helpDecipher = pattern11.firstMatch(baseJs['data']);
          if (helpDecipher != null) {
            String? processed = processFunctionWithSecretArray(helpDecipher, helpDecipher.group(0)!, baseJs['data']);

            RegExp regex = RegExp(helpDecipher);
            isMatch = regex.firstMatch(processed!);
          }
        }

        if (isMatch == null) {
          print("Warning: The second part of decipher string does not match the regex pattern.");
          return;
        }

        String functionArg = "";
        String matchedString = isMatch.group(0)!;

        if (helpDecipher != null) {
          matchedString = matchedString.replaceAll(RegExp(r'\[\"([A-z0-9$]+)\"\]'), r'.$1');
          firstPart = processFunctionWithKnownSecretArray(firstPart, baseJs['data']);
          firstPart = firstPart?.replaceAll(RegExp(r'([A-z0-9$])\["([A-z0-9$]+)"\]'), r'$1.$2');
          firstPart = firstPart?.replaceAll(RegExp(r'\[\"([A-z0-9$]+)\"\]'), r'.$1');
        }

        RegExp joinPattern = RegExp(r'(\w+)\.join\(\s*""\s*\)');
        RegExpMatch? joinMatch = joinPattern.firstMatch(matchedString);

        if (joinMatch != null) {
          functionArg = joinMatch.group(1)!;
        }

        String secondPart = "var decodeUrl=function($functionArg)$matchedString return decodeUrl;";
        String decodeFunction = firstPart! + secondPart;

        decodeUrl = parseAndCreateDecodeFunction(decodeFunction, firstPart, matchedString);

        RegExp signaturePattern = RegExp(r'\.sts="[0-9]+";');
        RegExpMatch? signatureMatch = signaturePattern.firstMatch(baseJs['data']);

        if (signatureMatch != null) {
          String signatureStr = signatureMatch.group(0)!;
          signatureTimestamp = int.parse(signatureStr.replaceAll(RegExp(r'\D'), ''));
        }
      } else {
        print("Warning: The first part of decipher string does not match the regex pattern.");
      }

    } catch (e) {
      print('Error in makeDecipherFunction: $e');
      if (errorCallback != null) {
        errorCallback!(e.toString(), true, 'Failed to create decipher function');
      }
    }
  }


Function parseAndCreateDecodeFunction(String functionCode, String firstPart, String secondPart) {
  RegExp objPattern = RegExp(r'var ([A-Za-z$]+)=\{([^}]+)\}');
  RegExpMatch? objMatch = objPattern.firstMatch(firstPart);

  Map<String, Function> decipherFunctions = {};

  if (objMatch != null) {
    String objContent = objMatch.group(2)!;
    RegExp funcPattern = RegExp(r'([A-Za-z0-9]+):function\(([^)]*)\)\{([^}]*)\}');
    Iterable<RegExpMatch> funcMatches = funcPattern.allMatches(objContent);

    for (RegExpMatch match in funcMatches) {
      String funcName = match.group(1)!;
      String body = match.group(3)!;

      if (body.contains('reverse')) {
        decipherFunctions[funcName] = (List<String> arr) => arr.reversed.toList();
      } else if (body.contains('splice')) {
        RegExp numPattern = RegExp(r'splice\([^,]*,\s*(\d+)\)');
        RegExpMatch? numMatch = numPattern.firstMatch(body);
        int count = numMatch != null ? int.parse(numMatch.group(1)!) : 1;
        decipherFunctions[funcName] = (List<String> arr) {
          arr.removeRange(0, count.clamp(0, arr.length));
          return arr;
        };
      } else if (body.contains('[0]') && body.contains('%')) {
        decipherFunctions[funcName] = (List<String> arr, int index) {
          if (arr.isEmpty) return arr;
          int idx = index % arr.length;
          String temp = arr[0];
          arr[0] = arr[idx];
          arr[idx] = temp;
          return arr;
        };
      }
    }
  }

  RegExp callPattern = RegExp(r'([A-Za-z$]+)\.([A-Za-z0-9]+)\(([^)]*)\)');
  Iterable<RegExpMatch> callMatches = callPattern.allMatches(secondPart);

  List<Map<String, dynamic>> operations = [];
  for (RegExpMatch match in callMatches) {
    String funcName = match.group(2)!;
    String params = match.group(3)!;

    List<String> paramList = params.split(',').map((s) => s.trim()).toList();
    operations.add({
      'function': funcName,
      'params': paramList
    });
  }

  return (String input) {
    List<String> chars = input.split('');

    for (Map<String, dynamic> op in operations) {
      String funcName = op['function'];
      List<String> params = op['params'];

      if (decipherFunctions.containsKey(funcName)) {
        Function func = decipherFunctions[funcName]!;

        if (params.length > 1 && params[1].isNotEmpty) {
          int? param = int.tryParse(params[1]);
          if (param != null) {
            chars = func(chars, param);
          }
        } else {
          chars = func(chars);
        }
      }
    }

    return chars.join('');
  };
}

*/
  Future<void> initAsync() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.URLS["YT_MOBILE"]}?hl=en'),
      );

      if (response.statusCode == 200) {
        final baseJsUrl = '${Constants.URLS["YT_MOBILE"]}${_getBetweenStrings(response.body, '"jsUrl":"', '","')}';

        final baseJsResponse = await http.get(Uri.parse(baseJsUrl));
        if (baseJsResponse.statusCode == 200) {
          // await this.makeDecipherFunction({'data': baseJsResponse.body});
          final extracted = _getBetweenStrings(response.body, "ytcfg.set({", ");");
          var trimmed = "{" + unescape(extracted.trim());
          trimmed = trimmed.replaceAll('"/error_204"', "");
          trimmed = trimmed.replaceAll('\\"/error_204\\"', "");
          final data = json.decode(trimmed);

          // final data = json.decode('{${_getBetweenStrings(response.body, "ytcfg.set({", ");")}}');
          visitorData = data['VISITOR_DATA'] ?? data['EOM_VISITOR_DATA'];

          if (data['INNERTUBE_CONTEXT'] != null) {
            key = data['INNERTUBE_API_KEY'];
            context = data['INNERTUBE_CONTEXT'];
            loggedIn = data['LOGGED_IN'];

            context!['client'] = Constants.INNERTUBE_CLIENT(context!['client']);
            header = Constants.INNERTUBE_HEADER(context!['client']).cast<String, String>();
          }
        }
      }
    } catch (e) {
      if (errorCallback != null) {
        errorCallback!(e.toString(), true);
      }

      if (retryCount < 10) {
        retryCount++;
        if (errorCallback != null) {
          errorCallback!(
              'retry count: $retryCount',
              false,
              'An error occurred while trying to init the innertube API. Retrial number: $retryCount/10'
          );
        }
        await Future.delayed(Duration(seconds: 5));
        await initAsync();
      } else {
        if (errorCallback != null) {
          errorCallback!(
              'Failed to retrieve Innertube session',
              true,
              'An error occurred while retrieving the innertube session. Check the Logs for more information.'
          );
        }
      }
    }
  }

  static Future<Innertube> createAsync(Function(String, bool, [String?])? errorCallback) async {
    final created = Innertube(errorCallback);
    await created.initAsync();
    return created;
  }

  // API Calls
  Future<Map<String, dynamic>> browseAsync(String actionType, [Map<String, dynamic>? args]) async {

    args = Map<String, dynamic>.from(args ?? {});
    Map<String, dynamic> data = {
      'context': {
        'client': Constants.INNERTUBE_CLIENT(context!['client']),
      },
    };

    switch (actionType) {
      case 'recommendations':
        args['browseId'] = 'FEwhat_to_watch';
        break;
      case 'trending':
        args['browseId'] = 'FEtrending';
        break;
      case 'aboutChannelInfo':
      args = {
          'context': {
            'client': Constants.INNERTUBE_CLIENT_FOR_CHANNEL(context!['client']),
          },
        };
      args['context']['client'] = {
          ...?args['context']['client'],
          'clientFormFactor': 'LARGE_FORM_FACTOR',
        };
      args['context'] = {
          ...?args['context'],
          'request': Constants.INNERTUBE_REQUEST(),
        };
        break;
      case 'channel':
        args = {
          'context': {
            'client': Constants.INNERTUBE_CLIENT_FOR_CHANNEL(context!['client']),
          },
        };
        args['context']['client'] = {
          ...?args['context']['client'],
          'clientFormFactor': 'LARGE_FORM_FACTOR',
        };
        args['context'] = {
          ...?args['context'],
          'request': Constants.INNERTUBE_REQUEST(),
        };
        if (args['browseId'] == null) {
          throw Exception('No browseId provided');
        }
        break;
    }

    data = {...data, ...args};

    try {
      final response = await http.post(
        Uri.parse('${Constants.URLS["YT_BASE_API"]}/browse?key=$key'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'status_code': response.statusCode,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'status_code': response.statusCode,
          'message': response.body,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'status_code': 500,
        'message': e.toString(),
      };
    }
  }

  /// Fetches continuations for browse, search, or next.
  Future<Map<String, dynamic>> getContinuationsAsync(String continuation, String type, {Map<String, dynamic>? contextAdditional}) async {
    var data = <String, dynamic>{
      'context': <String, dynamic>{...(contextAdditional?["context"] ?? {})},
      "continuation" : continuation
    };
    if (contextAdditional != {}) {
      (data) = {
        ...?contextAdditional
      };
    }
    if ((contextAdditional?['context']['client'] as Map<String, dynamic>?)?['clientName'] == 'MWEB') {
      (data['context'] as Map<String, dynamic>)['client'] = {
        ...Constants.INNERTUBE_VIDEO(context?['client']),
        'clientName': (contextAdditional?['context']['client'] as Map<String, dynamic>?)?['clientName'],
        'clientVersion': (contextAdditional?['context']['client'] as Map<String, dynamic>?)?['clientVersion'],
      };
    } else {
      (data['context'] as Map<String, dynamic>)['client'] = Constants.INNERTUBE_CLIENT(context?['client']);
    }

    String url;
    if (type == 'browse') {
      url = '${Constants.URLS['YT_BASE_API']}/browse?key=$key';
    } else if (type == 'search') {
      url = '${Constants.URLS['YT_BASE_API']}/search?key=$key';
    } else {
      url = '${Constants.URLS['YT_BASE_API']}/next?key=$key';
    }
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(data),
      headers: Constants.INNERTUBE_HEADER(context?['client']).cast<String, String>(),
    );

    if (response.statusCode != 200) {
      return {
        'success': false,
        'status_code': response.statusCode,
        'message': response.reasonPhrase,
      };
    }

    return {
      'success': true,
      'status_code': response.statusCode,
      'data': json.decode(response.body),
    };
  }

  /// Fetches video information.
  Future<Map<String, dynamic>> getVidAsync(String id) async {
    var data = <String, dynamic>{
      'context': <String, dynamic>{
        'client': Constants.INNERTUBE_VIDEO(context?['client']),
      },
      'videoId': id,
    };
    var dataForNext = <String, dynamic>{
      'context': <String, dynamic>{
        'client': <String, dynamic>{
          ...Constants.INNERTUBE_VIDEO(context?['client']),
          'clientName': Constants.YT_API_VALUES['CLIENT_WEB_M'],
          'clientVersion': Constants.YT_API_VALUES['VERSION_WEB'],
          'gl': context?['client']?['gl'],
          'hl': context?['client']?['hl'],
          'remoteHost': context?['client']?['remoteHost'],
        },
      },
      'videoId': id,
    };

    final responseNext = await http.post(
      Uri.parse('${Constants.URLS['YT_BASE_API']}/next?key=$key'),
      body: jsonEncode(dataForNext),
      headers: Constants.INNERTUBE_HEADER(context?['client']).cast<String, String>(),
    );

    var response;
    final clientConfigs = Constants.CLIENT_CONFIGS;
    for (final config in clientConfigs) {
      (data['context'] as Map<String, dynamic>)['client']['clientName'] = config['CLIENTNAME'];
      (data['context'] as Map<String, dynamic>)['client']['clientVersion'] = config['VERSION_WEB'];
      (data['context'] as Map<String, dynamic>)['client']['clientScreen'] = config['clientScreen'];
      if (config['clientScreen'] == 'EMBED' && config['CLIENTNAME'] == 'WEB_EMBEDDED_PLAYER') {
        (data['context'] as Map<String, dynamic>)['thirdParty'] = {
          'embedUrl': 'https://www.youtube.com/embed/$id',
        };
      }

      response = await http.post(
        Uri.parse('${Constants.URLS['YT_BASE_API']}/player?key=$key'),
        body: jsonEncode(data),
        headers: Constants.INNERTUBE_HEADER(context?['client']).cast<String, String>(),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['streamingData'] != null) {
          break;
        }
      }
    }

    if (response.statusCode != 200) {
      return {
        'success': false,
        'status_code': response.statusCode,
        'message': response.reasonPhrase,
      };
    }

    final responseData = json.decode(response.body);
    final nextData = json.decode(responseNext.body);

    return {
      'success': true,
      'status_code': response.statusCode,
      'data': {
        ...responseData,
        'next': nextData,
      },
    };
  }

  /// Performs a search query.
  Future<Map<String, dynamic>> getSearchAsync(String query) async {
    final data = <String, dynamic>{
      'context': <String, dynamic>{
        'client': Constants.INNERTUBE_CLIENT(context?['client']),
      },
      'query': query,
    };

    final response = await http.post(
      Uri.parse('${Constants.URLS['YT_BASE_API']}/search?key=$key'),
      body: jsonEncode(data),
      headers: Constants.INNERTUBE_HEADER(context?['client']).cast<String, String>(),
    );

    if (response.statusCode != 200) {
      return {
        'success': false,
        'status_code': response.statusCode,
        'message': response.reasonPhrase,
      };
    }

    return {
      'success': true,
      'status_code': response.statusCode,
      'contents': json.decode(response.body)['contents'],
    };
  }

  /// Static method to get thumbnail URL.
  String getThumbnail(String id, [String resolution = 'maxresdefault']) {
    return 'https://i.ytimg.com/vi/$id/$resolution.jpg';
  }

  /// Simple wrapper for recommendations.
  Future<Map<String, dynamic>> getRecommendationsAsync() async {
    return await browseAsync('recommendations');
  }

  /// Gets video information.
  Future<Map<String, dynamic>> VidInfoAsync(String id) async {
    return await getVidAsync(id);
  }

  static String _getBetweenStrings(String source, String start, String end) {
    final startIndex = source.indexOf(start);
    final endIndex = source.indexOf(end, startIndex + start.length);

    if (startIndex == -1 || endIndex == -1) {
      return '';
    }
    return source.substring(startIndex + start.length, endIndex);
  }
}