class Constants {
  static const Map<String, String> URLS = {
    'YT_URL': 'https://www.youtube.com',
    'YT_MOBILE': 'https://m.youtube.com',
    'YT_MUSIC_URL': 'https://music.youtube.com',
    'YT_BASE_API': 'https://m.youtube.com/youtubei/v1',
    'YT_SUGGESTIONS': 'https://suggestqueries-clients6.youtube.com/complete',
    'VT_GITHUB': 'https://api.github.com/repos/pixkk/VueTube',
    'VT_BETA_UPDATES': 'https://api.github.com/repos/pixkk/VueTube/actions/runs'
  };

  static const Map<String, String> YT_API_VALUES = {
    'VERSION': '19.09',
    'CLIENTNAME': 'ANDROID',
    'VERSION_WEB': '2.20250222.10.01',
    'USER_AGENT': 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
    'CLIENT_WEB_M': '2',
    'CLIENT_WEB_D': '1',
  };

  static const Map<String, String> ANDROID_VR_API_VAL = {
    'CLIENTNAME': 'ANDROID_VR',
    'clientScreen': 'EMBED',
    'VERSION_WEB': '1.37',
    'USER_AGENT': 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
    'CLIENT_WEB_M': '2',
    'CLIENT_WEB_D': '1',
  };

  static const Map<String, String> WEB_EMBEDDED_API_VAL = {
    'CLIENTNAME': 'WEB_EMBEDDED_PLAYER',
    'clientScreen': 'EMBED',
    'VERSION_WEB': '2.20250222.10.01',
    'USER_AGENT': 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
    'CLIENT_WEB_M': '2',
    'CLIENT_WEB_D': '1',
  };

  static const Map<String, String> TV_API_VAL = {
    'CLIENTNAME': 'TVHTML5',
    'clientScreen': 'WATCH',
    'VERSION_WEB': '7.20250212.16.00',
    'USER_AGENT': 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36',
    'CLIENT_WEB_M': '2',
    'CLIENT_WEB_D': '1',
  };

  static const List<Map<String, String>> CLIENT_CONFIGS = [
    WEB_EMBEDDED_API_VAL,
    ANDROID_VR_API_VAL,
    TV_API_VAL,
  ];

  static const Map<String, String> FILESYSTEM = {
    'plugins': 'plugins/',
  };

  static Map<String, dynamic> INNERTUBE_HEADER(Map<String, dynamic> info) {
    return {
      'accept': '*/*',
      'user-agent': info['userAgent'],
      'accept-language': '${info['hl']}-${info['gl']},${info['hl']};q=0.9',
      'content-type': 'application/json',
      'x-goog-authuser': '0',
      'x-goog-visitor-id': info['visitorData'] ?? '',
      'x-youtube-client-name': YT_API_VALUES['CLIENTNAME'],
      'x-youtube-client-version': YT_API_VALUES['VERSION'],
    };
  }

  static Map<String, dynamic> INNERTUBE_NEW_HEADER(Map<String, dynamic> info) {
    return {
      'accept': '*/*',
      'user-agent': YT_API_VALUES['USER_AGENT']!,
      'accept-language': '${info['hl']}-${info['gl']},${info['hl']};q=0.9',
      'content-type': 'application/json',
      'x-goog-authuser': '0',
      'x-goog-visitor-id': info['visitorData'] ?? '',
      'x-youtube-client-name': YT_API_VALUES['CLIENT_WEB_M'],
      'x-youtube-client-version': YT_API_VALUES['VERSION'],
    };
  }

  static Map<String, dynamic> INNERTUBE_CLIENT(Map<String, dynamic> info) {
    return {
      'gl': info['gl'],
      'hl': 'en', // This should be replaced with actual language preference
      'deviceMake': 'Google',
      'deviceModel': 'Nexus 5',
      'userAgent': YT_API_VALUES['USER_AGENT'],
      'clientName': YT_API_VALUES['CLIENTNAME'],
      'clientVersion': YT_API_VALUES['VERSION'],
      'osName': info['osName'],
      'osVersion': info['osVersion'],
      'platform': 'MOBILE',
      'playerType': 'UNIPLAYER',
      'originalUrl': info['originalUrl'],
      'configInfo': info['configInfo'],
      'remoteHost': info['remoteHost'],
      'visitorData': info['visitorData'],
    };
  }

  static Map<String, dynamic> INNERTUBE_CLIENT_FOR_CHANNEL(Map<String, dynamic> info) {
    return {
      'gl': info['gl'],
      'hl': 'en', // This should be replaced with actual language preference
      'deviceMake': 'Generic',
      'deviceModel': 'Android 15.0',
      'userAgent': YT_API_VALUES['USER_AGENT'],
      'clientName': 'MWEB',
      'clientVersion': YT_API_VALUES['VERSION_WEB'],
      'osName': info['osName'],
      'osVersion': info['osVersion'],
      'platform': 'MOBILE',
      'playerType': 'UNIPLAYER',
      'originalUrl': info['originalUrl'],
      'configInfo': info['configInfo'],
      'remoteHost': info['remoteHost'],
      'visitorData': info['visitorData'],
    };
  }

  static Map<String, dynamic> INNERTUBE_REQUEST() {
    return {
      'useSsl': true,
      'internalExperimentFlags': [],
    };
  }

  static Map<String, dynamic> INNERTUBE_VIDEO(Map<String, dynamic> info) {
    return {
      'gl': info['gl'],
      'hl': 'en', // This should be replaced with actual language preference
      'deviceMake': info['deviceMake'],
      'deviceModel': info['deviceModel'],
      'userAgent': info['userAgent'],
      'clientName': WEB_EMBEDDED_API_VAL['CLIENTNAME'],
      'clientVersion': WEB_EMBEDDED_API_VAL['VERSION_WEB'],
      'osName': info['osName'],
      'osVersion': info['osVersion'],
      'platform': 'TABLET',
      'playerType': 'UNIPLAYER',
      'originalUrl': info['originalUrl'],
      'configInfo': info['configInfo'],
      'remoteHost': info['remoteHost'],
      'visitorData': info['visitorData'],
      'clientFormFactor': 'LARGE_FORM_FACTOR',
      'timeZone': info['timeZone'],
      'browserName': info['browserName'] ?? "Chrome",
      'browserVersion': info['browserVersion']  ?? "136.0.0.0",
      'acceptHeader': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
      'deviceExperimentId': info['deviceExperimentId'],
      'utcOffsetMinutes': info['utcOffsetMinutes'],
      'userInterfaceTheme': 'USER_INTERFACE_THEME_LIGHT',
      'memoryTotalKbytes': '8000000',
      'clientScreen': 'EMBED',
      'mainAppWebInfo': {
        'webDisplayMode': 'WEB_DISPLAY_MODE_BROWSER',
        'isWebNativeShareAvailable': true,
      },
    };
  }
} 