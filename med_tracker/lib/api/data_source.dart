import 'package:med_tracker/api/base_network.dart';

class MedTrackerDataSource {
  static MedTrackerDataSource instance = MedTrackerDataSource();

  // medicine

  Future<Map<String, dynamic>> createMedicine(Map<String, dynamic> requestBody) {
    return BaseNetwork.post('medicine/', requestBody);
  }

  Future<List<dynamic>> loadMedicines(String user) {
    return BaseNetwork.getList('medicine/$user');
  }

  Future<Map<String, dynamic>> getMedicineById(String id) {
    return BaseNetwork.get('medicine/id/$id');
  }

  Future<List<dynamic>> getMedicineByName(String user, name) {
    return BaseNetwork.getList('medicine/name/$user/$name');
  }

  Future<Map<String, dynamic>> updateMedicineById(String id, Map<String, dynamic> requestBody) {
    return BaseNetwork.put('medicine/$id', requestBody);
  }

  Future<Map<String, dynamic>> deleteMedicineById(String id) {
    return BaseNetwork.delete('medicine/$id');
  }

  // user

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> requestBody) {
    return BaseNetwork.post('user/', requestBody);
  }

  Future<Map<String, dynamic>> getUserById(String id) {
    return BaseNetwork.get('user/id/$id');
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) {
    return BaseNetwork.get('user/email/$email');
  }

  Future<Map<String, dynamic>> updateUserById(String id, Map<String, dynamic> requestBody) {
    return BaseNetwork.put('user/$id', requestBody);
  }

  Future<Map<String, dynamic>> deleteUserById(String id) {
    return BaseNetwork.delete('user/$id');
  }
}