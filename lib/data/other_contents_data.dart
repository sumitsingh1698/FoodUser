import 'package:Belly/models/other_content_model.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';

class OtherContentsData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final String baseUrl = BaseUrl().mainUrl;
  static final String helpContents = baseUrl + "help/";
  static final String aboutContents = baseUrl + "aboutbelly/";
  static final String paymentContents = baseUrl + "payment/";

  /// this is the repository to get wasedeli app data in the profile tab

  Future<OtherContentModel> getHelpContents() {
    return _netUtil.getUniversities(helpContents).then((dynamic res) async {
      OtherContentModel response;
      if (res['results'].isNotEmpty) {
        print('resulltsssssssssss ${res['results']}');
        response = OtherContentModel.fromJson(res['results'][0]);
      }
      return response;
    }).catchError((onError) {
      print('errror');
      print(onError);
    });
  }

  Future<OtherContentModel> getAboutWasederiContents() {
    return _netUtil.getUniversities(aboutContents).then((dynamic res) async {
      OtherContentModel response;
      if (res['results'].isNotEmpty) {
        response = OtherContentModel.fromJson(res['results'][0]);
      }
      return response;
    });
  }

  Future<OtherContentModel> getPaymentContents() {
    return _netUtil.getUniversities(paymentContents).then((dynamic res) async {
      OtherContentModel response;
      if (res['results'].isNotEmpty) {
        response = OtherContentModel.fromJson(res['results'][0]);
      }
      return response;
    });
  }
}
