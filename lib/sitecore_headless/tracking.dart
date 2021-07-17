import 'package:sitecore_flutter/sitecore_headless/sitecore_headless.dart';
import 'package:sitecore_flutter/utils/utils.dart';
import 'package:sitecore_flutter/app_settings.dart';

class SitecoreTracking {
  Future<void> triggerGoal(String goalId) async {
    String apiUrl = "https://" +
        AppSettings.sitecoreHostname +
        "/sitecore/api/jss/track/event";
    await Requests.post(apiUrl, persistCookies: true, json: [
      {"goalId": goalId}
    ], queryParameters: <String, String>{
      'sc_apikey': AppSettings.sitecoreApiKey
    });
  }

  Future<void> flushSession() async {
    String apiUrl = "https://" +
        AppSettings.sitecoreHostname +
        "/sitecore/api/jss/track/flush";
    await Requests.get(apiUrl,
        persistCookies: true,
        queryParameters: <String, String>{
          'sc_apikey': AppSettings.sitecoreApiKey
        });
  }

  Future<ExperienceData?> getExperienceData() async {
    Response response = await doRequest("/services/v1/tracking/contact");
    if (response.success) {
      return ExperienceData.fromJson(response.json());
    }
    return null;
  }

  Future<Response> doRequest(String path) async {
    String apiUrl = "https://" + AppSettings.sitecoreHostname + path;
    return await Requests.get(apiUrl,
        persistCookies: true,
        queryParameters: <String, String>{
          'sc_apikey': AppSettings.sitecoreApiKey
        });
  }
}
