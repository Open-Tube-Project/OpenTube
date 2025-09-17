# How to use innertube
## Example code:
First of all, you need to create instance of innertube:
```dart
Innertube.createAsync((message, isError, [shortMessage]) {
      if (shortMessage != null) {
        print(shortMessage);
      }
      if (isError) {
        print('Error: $message');
      }
    }).then((innertube) {
      // Another code
    });
```
`message`, `isError` and `shortMessage` can receive error message, if it appears while creating instance.

Available methods:
1. ```innertube.getRecommendationsAsync()``` - get YT recommendations
2. ```innertube.getContinuationsAsync("token", "type_of_continuation")``` - receive additional data (for instance, main page contains 10 video cards. If you need to get another 10 videos, you need to get continuation token from JSON from ```innertube.getRecommendationsAsync()``` and select type_of_continuation - `browse` (in most of cases), `search` or `next`). 
3. ```innertube.getVidAsync("video_id")``` or ```innertube.VidInfoAsync("video_id")``` - get data about video
4. ```innertube.getSearchAsync("search text recommendations)``` - searchbox results
5. ```innertube.getThumbnail("video_id", "maxresdefault_or_another_type")``` - get video thumbnail in different qualities

"Visual" methods:
```dart
Youtube youtube = Youtube(innertube);
```
1. ```youtube.autoComplete("Auto sugge")``` - get autocomplete from YT searchbox
2. ```youtube.getSponsorBlock("video_id")``` - get sponsorblock data
3. ```youtube.getReturnYoutubeDislike("video_id")``` - get RYD data
4. ```youtube.search("Search text")``` - get search page results (as you clicked Enter on searchbox)
5. ```youtube.recommend()``` - same as innertube.getRecommendationsAsync(), but returns result in different type

All data returned in JSON.
Continuation tokens located in `continuationCommand.token`, `reloadContinuationData.continuation`, `nextContinuationData.continuation`.

Functions for deciphering video streams better execute in native JS (i can't recreate it in dart).

```dart
Innertube.createAsync((message, isError, [shortMessage]) {
      if (shortMessage != null) {
        print(shortMessage);
      }
      if (isError) {
        print('Error: $message');
      }
    }).then((innertube) {
      // print(innertube);
      innertube.getRecommendationsAsync().then((response) {

      });
      // Now you can use the innertube instance
      Youtube youtube = Youtube(innertube);

      // Example usage:
      youtube.recommend().then((response) {
        // print(response);
      });
      innertube.getContinuationsAsync("4qmFsgKV....jMFZDT0dGQ1FXZHpSVU5C", "browse").then((response) {
        // print(response);
      });
      innertube.getVidAsync("iTz5niEWD7w").then((response) {
        // print(response);
      });
      innertube.getSearchAsync("Search").then((response) {
       //  print(response);
      });
      youtube.autoComplete("Auto sugge").then((response) {
        // print(response);
      });
      youtube.getSponsorBlock("iTz5niEWD7w").then((response) {
        // print(response);
      });
      youtube.getReturnYoutubeDislike("iTz5niEWD7w").then((response) {
        // print(response);
      });
      var url = innertube.getThumbnail("iTz5niEWD7w");
      innertube.getContinuationsAsync("", "browse", contextAdditional: {
        'browseId': "UCgKkNPU2Ib7_TcyAl8M2S-w",
        'context': {
          'client': Constants.INNERTUBE_CLIENT_FOR_CHANNEL(innertube.context!['client']),
        },
      }).then((response) {
        // print(response);
      });
      youtube.search("RRUUUH").then((response) {

        // print(response);
      });
      youtube.recommend().then((response) {

        print(response);
      });
    });
```