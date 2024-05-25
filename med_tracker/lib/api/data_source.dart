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

  Future<Map<String, dynamic>> updateUserById(String id, Map<String, dynamic> requestBody) {
    return MedTrackerBaseNetwork.put('user/$id', requestBody);
  }

  Future<Map<String, dynamic>> deleteUserById(String id) {
    return MedTrackerBaseNetwork.delete('user/$id');
  }
}

class ExchangeDataSource {
  Future<Map<String, dynamic>> getExchangeRate(String currency) {
    return MedTrackerBaseNetwork.get('currencies/$currency.json');
  }

  Future<Map<String, dynamic>> getCurrencies() {
    return MedTrackerBaseNetwork.get('currencies.json');
  }
}