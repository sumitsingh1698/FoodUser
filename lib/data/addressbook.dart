import 'package:Belly/models/addressBook.dart';
import 'package:Belly/utils/base_url.dart';
import 'package:Belly/utils/network_utils.dart';

class AddressDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final addressBook = baseUrl + 'addressbook/';
  Future postAddress(token, AddressBook address) {
    print(addressBook);
    return _netUtil.postAddress(addressBook, token, address);
  }
}
