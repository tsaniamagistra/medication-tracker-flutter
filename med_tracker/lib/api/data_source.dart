import 'package:med_tracker/api/base_network.dart';

class MedTrackerDataSource {
  static MedTrackerDataSource instance = MedTrackerDataSource();

  // medicine

  Future<Map<String, dynamic>> createMedicine(Map<String, dynamic> requestBody) {
    return MedTrackerBaseNetwork.post('medicine/', requestBody);
  }

  Future<List<dynamic>> loadMedicines(String user) {
    return MedTrackerBaseNetwork.getList('medicine/$user');
  }

  Future<Map<String, dynamic>> getMedicineById(String id) {
    return MedTrackerBaseNetwork.get('medicine/id/$id');
  }

  Future<List<dynamic>> getMedicineByName(String user, name) {
    return MedTrackerBaseNetwork.getList('medicine/name/$user/$name');
  }

  Future<Map<String, dynamic>> updateMedicineById(String id, Map<String, dynamic> requestBody) {
    return MedTrackerBaseNetwork.put('medicine/$id', requestBody);
  }

  Future<Map<String, dynamic>> deleteMedicineById(String id) {
    return MedTrackerBaseNetwork.delete('medicine/$id');
  }

  // user

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> requestBody) {
    return MedTrackerBaseNetwork.post('user/', requestBody);
  }

  Future<Map<String, dynamic>> getUserById(String id) {
    return MedTrackerBaseNetwork.get('user/id/$id');
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) {
    return MedTrackerBaseNetwork.get('user/email/$email');
  }

  // tidak dipakai, langsung pakai http.Multipartrequest di page
  Future<Map<String, dynamic>> updateUserById(String id, Map<String, dynamic> requestBody) {
    return MedTrackerBaseNetwork.put('user/update/$id', requestBody);
  }

  Future<Map<String, dynamic>> deleteUserById(String id) {
    return MedTrackerBaseNetwork.delete('user/$id');
  }
}

class ExchangeDataSource {
  static ExchangeDataSource instance = ExchangeDataSource();

  Future<Map<String, dynamic>> getExchangeRate(String baseCurrency) {
    return ExchangeBaseNetwork.get('currencies/$baseCurrency.json');
  }

  // tidak dipakai karena terlalu panjang untuk dimodelkan, beralih ke models/currency_list
  Future<Map<String, dynamic>> loadCurrencies() {
    return ExchangeBaseNetwork.get('currencies.json');
  }
}

class TimeAPIDataSource {
  static TimeAPIDataSource instance = TimeAPIDataSource();

  Future<Map<String, dynamic>> convertTimeZone(Map<String, dynamic> requestBody) {
    return TimeAPIBaseNetwork.post('Conversion/ConvertTimeZone', requestBody);
  }

  Future<List<String>> loadTimezones() {
    return TimeAPIBaseNetwork.getList('TimeZone/AvailableTimeZones');
  }
}