import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flixquest/models/custom_exceptions.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';
import '/models/images.dart';
import '/models/person.dart';
import '/models/tv.dart';
import '/models/videos.dart';
import '/models/watch_providers.dart';
import 'package:http/http.dart' as http;
import '/models/credits.dart';
import '/models/genres.dart';
import '/models/external_id_lookup.dart';
import '/models/movie.dart';

Future<List<Movie>> fetchMovies(
  String api,
  bool isProxyEnabled,
  String proxyUrl, {
  String? debugLabel,
}) async {
  MovieList movieList;
  final startedAt = Stopwatch()..start();
  try {
    final originalUri = Uri.parse(api);
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    if (debugLabel != null) {
      final proxyHost = Uri.tryParse(proxyUrl)?.host;
      debugPrint(
        '[$debugLabel][HTTP_REQUEST] '
        'host=${originalUri.host} path=${originalUri.path} '
        'language=${originalUri.queryParameters['language']} '
        'page=${originalUri.queryParameters['page']} '
        'proxyEnabled=$isProxyEnabled '
        'proxyConfigured=${proxyUrl.isNotEmpty} '
        'proxyHost=${proxyHost?.isNotEmpty == true ? proxyHost : 'none'}',
      );
    }
    final res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    final decoded = await compute(jsonDecode, res.body);
    if (debugLabel != null) {
      final decodedMap = decoded is Map<String, dynamic> ? decoded : null;
      debugPrint(
        '[$debugLabel][HTTP_RESPONSE] '
        'status=${res.statusCode} elapsedMs=${startedAt.elapsedMilliseconds} '
        'contentType=${res.headers['content-type']} bytes=${res.bodyBytes.length} '
        'keys=${decodedMap?.keys.join(',') ?? decoded.runtimeType} '
        'tmdbSuccess=${decodedMap?['success']} '
        'tmdbStatusCode=${decodedMap?['status_code']} '
        'tmdbStatusMessage=${decodedMap?['status_message']}',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object from movie API');
    }
    movieList = MovieList.fromJson(decoded);
    if (debugLabel != null) {
      debugPrint(
        '[$debugLabel][PARSED] '
        'page=${movieList.page} totalResults=${movieList.totalMovies} '
        'totalPages=${movieList.totalPages} '
        'parsedMovies=${movieList.movies?.length ?? 0}',
      );
    }
  } catch (error, stackTrace) {
    if (debugLabel != null) {
      debugPrint(
        '[$debugLabel][HTTP_ERROR] '
        'elapsedMs=${startedAt.elapsedMilliseconds} '
        'type=${error.runtimeType} error=$error',
      );
      debugPrintStack(
          label: '[$debugLabel][HTTP_STACK]', stackTrace: stackTrace);
    }
    rethrow;
  } finally {
    
  }

  return movieList.movies ?? [];
}

Future<List<Movie>> fetchCollectionMovies(
    String api, bool isProxyEnabled, String proxyUrl) async {
  CollectionMovieList collectionMovieList;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      () => httpClient.get(Uri.parse(api)).timeout(timeOut),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    collectionMovieList = CollectionMovieList.fromJson(decodeRes);
  } finally {
    
  }
  return collectionMovieList.movies ?? [];
}

Future<CollectionDetails> fetchCollectionDetails(
    String api, bool isProxyEnabled, String proxyUrl) async {
  CollectionDetails collectionDetails;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      () => httpClient.get(Uri.parse(api)).timeout(timeOut),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    collectionDetails = CollectionDetails.fromJson(decodeRes);
  } finally {
    
  }
  return collectionDetails;
}

Future<List<Movie>> fetchPersonMovies(
    String api, bool isProxyEnabled, String proxyUrl) async {
  PersonMoviesList personMoviesList;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      () => httpClient.get(Uri.parse(api)).timeout(timeOut),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    personMoviesList = PersonMoviesList.fromJson(decodeRes);
  } finally {
    
  }
  return personMoviesList.movies ?? [];
}

Future<Images> fetchImages(
    String api, bool isProxyEnabled, String proxyUrl) async {
  Images images;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    images = Images.fromJson(decodeRes);
  } finally {
    
  }
  return images;
}

Future<PersonImages> fetchPersonImages(
    String api, bool isProxyEnabled, String proxyUrl) async {
  PersonImages personImages;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    personImages = PersonImages.fromJson(decodeRes);
  } finally {
    
  }
  return personImages;
}

Future<Videos> fetchVideos(
    String api, bool isProxyEnabled, String proxyUrl) async {
  Videos videos;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    videos = Videos.fromJson(decodeRes);
  } finally {
    
  }
  return videos;
}

Future<Credits> fetchCredits(
    String api, bool isProxyEnabled, String proxyUrl) async {
  Credits credits;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    credits = Credits.fromJson(decodeRes);
  } finally {
    
  }
  return credits;
}

Future<List<Person>> fetchPerson(
    String api, bool isProxyEnabled, String proxyUrl) async {
  PersonList credits;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    credits = PersonList.fromJson(decodeRes);
  } finally {
    
  }
  return credits.person ?? [];
}

Future<List<Genres>> fetchGenre(
    String api, bool isProxyEnabled, String proxyUrl) async {
  GenreList newGenreList;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    newGenreList = GenreList.fromJson(decodeRes);
  } finally {
    
  }
  return newGenreList.genre ?? [];
}

Future<ExternalLinks> fetchSocialLinks(
    String api, bool isProxyEnabled, String proxyUrl) async {
  ExternalLinks externalLinks;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    externalLinks = ExternalLinks.fromJson(decodeRes);
  } finally {
    
  }
  return externalLinks;
}

Future fetchBelongsToCollection(
    String api, bool isProxyEnabled, String proxyUrl) async {
  BelongsToCollection belongsToCollection;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    belongsToCollection = BelongsToCollection.fromJson(decodeRes);
  } finally {
    
  }
  return belongsToCollection;
}

Future<MovieDetails> fetchMovieDetails(
    String api, bool isProxyEnabled, String proxyUrl) async {
  MovieDetails movieDetails;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    movieDetails = MovieDetails.fromJson(decodeRes);
  } finally {
    
  }
  return movieDetails;
}

// Future<Credits> fetchPerson(String api) async {
//   Credits credits;
//   var res = await httpClient.get(Uri.parse(api));
//   var decodeRes = await compute(jsonDecode, res.body);
//   credits = Credits.fromJson(decodeRes);
//   return credits;
// }

Future<PersonDetails> fetchPersonDetails(
    String api, bool isProxyEnabled, String proxyUrl) async {
  PersonDetails personDetails;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    personDetails = PersonDetails.fromJson(decodeRes);
  } finally {
    
  }
  return personDetails;
}

Future<WatchProviders> fetchWatchProviders(
    String api, String country, bool isProxyEnabled, String proxyUrl) async {
  WatchProviders watchProviders;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    watchProviders = WatchProviders.fromJson(decodeRes, country);
  } finally {
    
  }
  return watchProviders;
}

Future<List<TV>> fetchTV(
    String api, bool isProxyEnabled, String proxyUrl) async {
  TVList tvList;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    tvList = TVList.fromJson(decodeRes);
  } finally {
    
  }
  return tvList.tvSeries ?? [];
}

Future<TVDetails> fetchTVDetails(
    String api, bool isProxyEnabled, String proxyUrl) async {
  TVDetails tvDetails;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    tvDetails = TVDetails.fromJson(decodeRes);
  } finally {
    
  }
  return tvDetails;
}

Future<List<TV>> fetchPersonTV(
    String api, bool isProxyEnabled, String proxyUrl) async {
  PersonTVList personTVList;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      (() => httpClient.get(Uri.parse(api)).timeout(timeOut)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    personTVList = PersonTVList.fromJson(decodeRes);
  } finally {
    
  }
  return personTVList.tv ?? [];
}

Future<Movie> getMovie(String api, bool isProxyEnabled, String proxyUrl) async {
  Movie movie;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      () => httpClient.get(Uri.parse(api)).timeout(timeOut),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    movie = Movie.fromJson(decodeRes);
  } finally {
    
  }
  return movie;
}

Future<TV> getTV(String api, bool isProxyEnabled, String proxyUrl) async {
  TV tv;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      () => httpClient.get(Uri.parse(api)).timeout(timeOut),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    tv = TV.fromJson(decodeRes);
  } finally {
    
  }
  return tv;
}

/// One episode, addressed by its series and its two numbers.
Future<EpisodeList> getEpisode(
    String api, bool isProxyEnabled, String proxyUrl) async {
  EpisodeList episode;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      () => httpClient.get(Uri.parse(api)).timeout(timeOut),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    episode = EpisodeList.fromJson(decodeRes);
  } finally {
    
  }
  return episode;
}

/// What TMDB holds under an id belonging to another site, such as an IMDb id.
Future<ExternalIdLookup> findByExternalId(
    String api, bool isProxyEnabled, String proxyUrl) async {
  ExternalIdLookup lookup;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      () => httpClient.get(Uri.parse(api)).timeout(timeOut),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    if (decodeRes is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object from the find API');
    }
    lookup = ExternalIdLookup.fromJson(decodeRes);
  } finally {
    
  }
  return lookup;
}

/// A collection's own name and artwork, for one reached without a film in hand.
Future<BelongsToCollection> fetchCollectionSummary(
    String api, bool isProxyEnabled, String proxyUrl) async {
  BelongsToCollection collection;
  try {
    if (isProxyEnabled && proxyUrl.isNotEmpty) {
      api = '$proxyUrl?destination=$api';
    }
    var res = await retryOptions.retry(
      () => httpClient.get(Uri.parse(api)).timeout(timeOut),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    var decodeRes = await compute(jsonDecode, res.body);
    if (decodeRes is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object from collection API');
    }
    collection = BelongsToCollection.fromCollectionJson(decodeRes);
  } finally {
    
  }
  return collection;
}

Future<String> getVttFileAsString(String url) async {
  try {
    var response = await retryOptions.retry(
      () => httpClient.get(Uri.parse(url)).timeout(const Duration(seconds: 15)),
      retryIf: (e) => e is SocketException,
    );
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final decoded = utf8.decode(bytes);
      if (decoded.startsWith('<')) {
        return '';
      } else {
        return decoded;
      }
    } else {
      return '';
    }
  } catch (e) {
    rethrow;
  }
}

const Map<String, String> _vixSrcHeaders = {
  'accept': '*/*',
  'origin': 'https://vixsrc.to',
  'referer': 'https://vixsrc.to/',
  'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36',
};

Future<String> getVixSrcEmbedSrc(String api) async {
  try {
    final res = await retryOptionsStream.retry(
      (() => http
          .get(Uri.parse(api), headers: _vixSrcHeaders)
          .timeout(timeOutStream)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    final decodeRes = await compute(jsonDecode, res.body);

    if (res.statusCode != 200 ||
        decodeRes is! Map<String, dynamic> ||
        decodeRes['src'] == null ||
        decodeRes['src'].toString().isEmpty) {
      throw NotFoundException();
    }

    return decodeRes['src'].toString();
  } catch (e) {
    rethrow;
  }
}

Future<String?> getVixSrcEmbedHtml(String api) async {
  try {
    final res = await retryOptionsStream.retry(
      (() => http
          .get(Uri.parse(api), headers: _vixSrcHeaders)
          .timeout(timeOutStream)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (res.statusCode == 410) {
      return null;
    }

    if (res.statusCode != 200) {
      throw ServerDownException();
    }

    return res.body;
  } catch (e) {
    rethrow;
  }
}

Future<String> getVixSrcPlaylist(String api) async {
  try {
    final res = await retryOptionsStream.retry(
      (() => http
          .get(Uri.parse(api), headers: _vixSrcHeaders)
          .timeout(timeOutStream)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (res.statusCode != 200) {
      throw ServerDownException();
    }

    return res.body;
  } catch (e) {
    rethrow;
  }
}

// ===================== ANIMEKAI FUNCTIONS =====================
