import 'package:sitecore_flutter/utils/utils.dart';
import 'package:sitecore_flutter/app_settings.dart';

class SitecoreLayoutServiceClient {
  Future<Response> requestLayout(String path) async {
    String apiUrl = "https://" +
        AppSettings.sitecoreHostname +
        "/sitecore/api/layout/render/jss";
    return Requests.get(apiUrl,
        persistCookies: true,
        queryParameters: <String, String>{
          'sc_site': AppSettings.sitecoreSite,
          'sc_apikey': AppSettings.sitecoreApiKey,
          'item': path,
          'sc_lang': AppSettings.sitecoreLanguage
        });
  }
}
