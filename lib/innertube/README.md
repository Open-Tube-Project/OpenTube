# InnerTube API Documentation

The InnerTube API is OpenTube's core YouTube data access layer, providing a comprehensive interface to YouTube's internal API endpoints. This documentation covers initialization, available methods, and usage examples.

## 🚀 Quick Start

### Creating an InnerTube Instance

First, create an InnerTube instance with error handling:

```dart
import 'package:opentube/innertube/innertube.dart';
import 'package:opentube/innertube/youtube.dart';

// Create InnerTube instance with error callback
Innertube.createAsync((message, isError, [shortMessage]) {
  if (shortMessage != null) {
    print('Status: $shortMessage');
  }
  if (isError) {
    print('Error: $message');
  }
}).then((innertube) {
  // InnerTube instance is ready to use
  print('InnerTube initialized successfully');
});
```

**Error Callback Parameters:**
- `message`: Detailed error or status message
- `isError`: Boolean indicating if this is an error message
- `shortMessage`: Optional brief status update

## 📋 Core InnerTube Methods

### 1. Video Recommendations

Get YouTube's recommended videos for the home feed:

```dart
Future<Map<String, dynamic>> getRecommendations() async {
  try {
    final response = await innertube.getRecommendationsAsync();
    return response;
  } catch (e) {
    print('Error getting recommendations: $e');
    return {};
  }
}
```

### 2. Continuation Handling

Load additional content using continuation tokens:

```dart
Future<Map<String, dynamic>> loadMoreContent(String token, String type) async {
  try {
    final response = await innertube.getContinuationsAsync(token, type);
    return response;
  } catch (e) {
    print('Error loading continuation: $e');
    return {};
  }
}
```

**Continuation Types:**
- `browse`: For home feed and channel content (most common)
- `search`: For search result pagination
- `next`: For related videos and comments

**Finding Continuation Tokens:**
Continuation tokens are located in response JSON at:
- `continuationCommand.token`
- `reloadContinuationData.continuation`
- `nextContinuationData.continuation`

### 3. Video Information

Get detailed information about a specific video:

```dart
// Method 1: Using getVidAsync
Future<Map<String, dynamic>> getVideoInfo(String videoId) async {
  try {
    final response = await innertube.getVidAsync(videoId);
    return response;
  } catch (e) {
    print('Error getting video info: $e');
    return {};
  }
}

// Method 2: Using VidInfoAsync (alias)
Future<Map<String, dynamic>> getVideoDetails(String videoId) async {
  return await innertube.VidInfoAsync(videoId);
}
```

### 4. Search Functionality

Search for videos using text queries:

```dart
Future<Map<String, dynamic>> searchVideos(String query) async {
  try {
    final response = await innertube.getSearchAsync(query);
    return response;
  } catch (e) {
    print('Error searching: $e');
    return {};
  }
}
```

### 5. Thumbnail URLs

Generate thumbnail URLs for videos:

```dart
String getVideoThumbnail(String videoId, [String resolution = 'maxresdefault']) {
  return innertube.getThumbnail(videoId, resolution);
}
```

**Available Resolutions:**
- `maxresdefault`: Highest quality (1280x720)
- `hqdefault`: High quality (480x360)
- `mqdefault`: Medium quality (320x180)
- `sddefault`: Standard quality (640x480)
- `default`: Basic quality (120x90)

## 🎨 Enhanced YouTube Methods

The `Youtube` class provides additional functionality and simplified interfaces:

```dart
// Create Youtube instance from InnerTube
Youtube youtube = Youtube(innertube);
```

### 1. Search Auto-Complete

Get search suggestions as the user types:

```dart
Future<List<String>> getSearchSuggestions(String partial) async {
  try {
    final suggestions = await youtube.autoComplete(partial);
    return List<String>.from(suggestions);
  } catch (e) {
    print('Error getting suggestions: $e');
    return [];
  }
}
```

### 2. SponsorBlock Integration

Get sponsor segment information for videos:

```dart
Future<Map<String, dynamic>?> getSponsorSegments(String videoId) async {
  try {
    final sponsorData = await youtube.getSponsorBlock(videoId);
    return sponsorData;
  } catch (e) {
    print('Error getting sponsor data: $e');
    return null;
  }
}
```

### 3. Return YouTube Dislike

Get dislike count and engagement metrics:

```dart
Future<Map<String, dynamic>> getDislikeData(String videoId) async {
  try {
    final dislikeData = await youtube.getReturnYoutubeDislike(videoId);
    return dislikeData;
  } catch (e) {
    print('Error getting dislike data: $e');
    return {};
  }
}
```

### 4. Enhanced Search

Perform full search with formatted results:

```dart
Future<Map<String, dynamic>> performSearch(String query) async {
  try {
    final searchResults = await youtube.search(query);
    return searchResults;
  } catch (e) {
    print('Error performing search: $e');
    return {};
  }
}
```

### 5. Formatted Recommendations

Get recommendations with enhanced formatting:

```dart
Future<Map<String, dynamic>> getFormattedRecommendations() async {
  try {
    final recommendations = await youtube.recommend();
    return recommendations;
  } catch (e) {
    print('Error getting formatted recommendations: $e');
    return {};
  }
}
```

## 🔄 Complete Usage Example

Here's a comprehensive example showing all major features:

```dart
import 'package:opentube/innertube/innertube.dart';
import 'package:opentube/innertube/youtube.dart';
import 'package:opentube/innertube/constants.dart';

void main() async {
  // Initialize InnerTube
  final innertube = await Innertube.createAsync((message, isError, [shortMessage]) {
    if (shortMessage != null) {
      print('Status: $shortMessage');
    }
    if (isError) {
      print('Error: $message');
    }
  });

  // Create YouTube helper
  final youtube = Youtube(innertube);

  try {
    // Get recommendations
    print('=== Getting Recommendations ===');
    final recommendations = await innertube.getRecommendationsAsync();
    print('Recommendations loaded: ${recommendations['success']}');

    // Search for videos
    print('\n=== Searching Videos ===');
    final searchResults = await innertube.getSearchAsync('Flutter tutorials');
    print('Search completed');

    // Get video information
    print('\n=== Video Information ===');
    final videoInfo = await innertube.getVidAsync('dQw4w9WgXcQ');
    print('Video info retrieved');

    // Get auto-complete suggestions
    print('\n=== Auto-Complete ===');
    final suggestions = await youtube.autoComplete('Flutter');
    print('Suggestions: $suggestions');

    // Get sponsor block data
    print('\n=== SponsorBlock Data ===');
    final sponsorData = await youtube.getSponsorBlock('dQw4w9WgXcQ');
    print('Sponsor data: ${sponsorData != null ? 'Available' : 'Not available'}');

    // Get dislike data
    print('\n=== Return YouTube Dislike ===');
    final dislikeData = await youtube.getReturnYoutubeDislike('dQw4w9WgXcQ');
    print('Dislikes: ${dislikeData['dislikes'] ?? 'N/A'}');

    // Get thumbnail URL
    print('\n=== Thumbnail URL ===');
    final thumbnailUrl = innertube.getThumbnail('dQw4w9WgXcQ', 'maxresdefault');
    print('Thumbnail URL: $thumbnailUrl');

    // Channel content with continuation
    print('\n=== Channel Content ===');
    final channelContent = await innertube.getContinuationsAsync(
      '', // continuation token (empty for initial request)
      'browse',
      contextAdditional: {
        'browseId': 'UCuAXFkgsw1L7xaCfnd5JJOw', // Example channel ID
        'context': {
          'client': Constants.INNERTUBE_CLIENT_FOR_CHANNEL(innertube.context!['client']),
        },
      }
    );
    print('Channel content loaded');

  } catch (e) {
    print('Error in example: $e');
  }
}
```

## 🔧 Advanced Configuration

### Custom Context for Channels

When accessing channel content, use specialized context:

```dart
final channelData = await innertube.getContinuationsAsync(
  continuationToken,
  'browse',
  contextAdditional: {
    'browseId': channelId,
    'context': {
      'client': Constants.INNERTUBE_CLIENT_FOR_CHANNEL(innertube.context!['client']),
    },
  }
);
```

### Error Handling Best Practices

Always wrap API calls in try-catch blocks:

```dart
Future<Map<String, dynamic>?> safeApiCall(Future<Map<String, dynamic>> apiCall) async {
  try {
    final result = await apiCall;
    if (result['success'] == true) {
      return result;
    } else {
      print('API call failed: ${result['message']}');
      return null;
    }
  } catch (e) {
    print('Exception in API call: $e');
    return null;
  }
}
```

## ⚠️ Important Notes

1. **Video Stream Deciphering**: Functions for deciphering video streams work better when executed in native JavaScript environments, as they cannot be easily recreated in Dart.

2. **Rate Limiting**: Be mindful of YouTube's rate limits when making frequent API calls.

3. **Response Format**: All data is returned in JSON format matching YouTube's internal API structure.

4. **Error Handling**: Always implement proper error handling as network conditions and API availability can vary.

5. **Continuation Tokens**: Save continuation tokens to implement infinite scrolling and pagination effectively.

## 🐛 Troubleshooting

### Common Issues

**Authentication Errors**
- Ensure proper initialization with error callbacks
- Check network connectivity
- Verify YouTube accessibility

**Empty Results**
- Check if the content is region-restricted
- Verify video IDs and channel IDs are correct
- Ensure continuation tokens are valid and not expired

**Performance Issues**
- Implement proper caching for frequently accessed data
- Use continuation tokens for pagination instead of loading everything at once
- Consider implementing request debouncing for search auto-complete
