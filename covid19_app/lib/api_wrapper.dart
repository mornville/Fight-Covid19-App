import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

// Global variables

const String SERVER_URI = "https://covid19.thepodnet.com";

class Covid19API {
  var client = http.Client();
  String token;

  /// Set the [token] for an already logged in user.
  ///
  /// @param token String token used for API authentication for a given user.
  /// @returns void
  ///
  /// ```dart
  /// Covid19API a = Covid19API();
  /// a.setToken(token);
  /// print(await a.listOfUsers());
  /// ```
  ///
  void setToken(String token) {
    this.token = token;
  }

  /// Fetch user token using the provided [username] and [password]
  Future<Map> login(String username, String password) async {
    try {
      var resp = await client.post("$SERVER_URI/auth-token/",
          body: {'username': username, 'password': password});
      print(resp.body);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("non_field_errors")) {
        return {"status": "error", "info": "incorrect login id and password."};
      } else if (data.containsKey("token")) {
        this.token = data['token'];
        return {"status": "success"};
      } else {
        return {"status": "error"};
      }
    } catch (e) {
      print("Error while logging in: $e");
      return {"info": "Unable to login", "status": "error"};
    }
  }

  /// Get details about the current user.
  ///
  /// ```dart
  /// var a = Covid19API();
  /// a.login(username, password);
  /// a.getCurrentUser();
  /// ```
  Future<Map> getCurrentUser() async {
    try {
      var resp = await client.get("$SERVER_URI/api/users/current_user/",
          headers: {"Authorization": "Token ${this.token}"});
      return {"status": "success", "info": jsonDecode(resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Get the list of all users
  Future<Map> listOfUsers() async {
    try {
      var resp = await client.get("$SERVER_URI/api/users/?format=json",
          headers: {"Authorization": "Token ${this.token}"});
      return {"status": "success", "info": jsonDecode(resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Create new user
  Future<Map> createUser(
      {String username,
      String password,
      String firstName,
      String lastName,
      String email,
      String name,
      bool isActive,
      bool isStaff,
      bool isSuperuser}) async {
    try {
      Map<String, String> args = Map();

      // If username is present
      if (username != null) {
        args.addAll({"username": username});
      }
      // If password is present
      if (password != null) {
        args.addAll({"password": password});
      }
      // If first_name is present
      if (firstName != null) {
        args.addAll({"first_name": firstName});
      }
      // If last_name is present
      if (lastName != null) {
        args.addAll({"last_name": lastName});
        name = firstName + " " + lastName;
        args.addAll({"name": name});
      } else if (lastName == null) {
        name = firstName;
        args.addAll({"name": name});
      }
      // If email is present
      if (email != null) {
        args.addAll({"email": email});
      }
      // If is_active is present
      if (isActive != null) {
        args.addAll({"is_active": isActive.toString()});
      }
      // If is_staff is present
      if (isStaff != null) {
        args.addAll({"is_staff": isStaff.toString()});
      }
      // If is_superuser is present
      if (isSuperuser == null) {
        args.addAll({"is_superuser": isSuperuser.toString()});
      }

      var resp = await client.post("$SERVER_URI/api/users/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("id") &&
          data.containsKey("url") &&
          data.containsKey("username") &&
          data.containsKey("first_name") &&
          data.containsKey("last_name") &&
          data.containsKey("name") &&
          data.containsKey("email")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Get a specific user using [userId]
  Future<Map> getUser(int userId) async {
    try {
      var resp = await client.get("$SERVER_URI/api/users/$userId/",
          headers: {"Authorization": "Token ${this.token}"});
      return {"status": "success", "info": jsonDecode(resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Update user information for the given [userId]
  Future<Map> updateUser(int userId,
      {String username,
      String password,
      String firstName,
      String lastName,
      String name,
      String email,
      bool isActive,
      bool isStaff,
      bool isSuperuser}) async {
    try {
      Map<String, String> args = Map();

      // If username is present
      if (username != null) {
        args.addAll({"username": username});
      }
      // If password is present
      if (password != null) {
        args.addAll({"password": password});
      }
      // If first_name is present
      if (firstName != null) {
        args.addAll({"first_name": firstName});
      }
      // If last_name is present
      if (lastName != null) {
        args.addAll({"last_name": lastName});
      }

      if (name != null) {
        args.addAll({"name": name});
      }
      // If email is present
      if (email != null) {
        args.addAll({"email": email});
      }
      // If is_active is present
      if (isActive != null) {
        args.addAll({"is_active": isActive.toString()});
      }
      // If is_staff is present
      if (isStaff != null) {
        args.addAll({"is_staff": isStaff.toString()});
      }
      // If is_superuser is present
      if (isSuperuser == null) {
        args.addAll({"is_superuser": isSuperuser.toString()});
      }

      var resp = await client.patch("$SERVER_URI/api/users/$userId/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("id") &&
          data.containsKey("url") &&
          data.containsKey("username") &&
          data.containsKey("first_name") &&
          data.containsKey("last_name") &&
          data.containsKey("name") &&
          data.containsKey("email")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      throw Exception("Unable to parse response: $e");
    }
  }

  /// Delete user with the given [userId]
  Future<Map> deleteUser(int userId) async {
    try {
      var resp = await client.delete("$SERVER_URI/api/users/$userId/",
          headers: {"Authorization": "Token ${this.token}"});
      if (resp.statusCode == 204) {
        return {"status": "success"};
      } else {
        return {"status": "failed", "info": jsonDecode(resp.body)};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  // Create Health Entry
  Future<Map> healthEntry(
      {

        int age,
      String gender,
      bool fever,
      bool cough,
      bool difficult_breathing,
      bool self_quarantine,
      String latitude,
      String longitude,
      String unique_id
      }) async {
    try {
      Map<String, String> args = Map();

      if (age != null) {
        args.addAll({"age": age.toString()});
      }
      if (gender != null) {
        args.addAll({"gender": gender});
      }


      if (fever != null) {
        args.addAll({"fever": fever.toString()});
      }

      if (cough != null) {
        args.addAll({"cough": cough.toString()});
      }

      if (difficult_breathing != null) {
        args.addAll({"difficult_breathing": difficult_breathing.toString()});
      }

      if (self_quarantine != null) {
        args.addAll({"self_quarantine": self_quarantine.toString()});
      }
      if (latitude != null) {
        args.addAll({"latitude": latitude});
      }
      if (longitude != null) {
        args.addAll({"longitude": longitude});
      }
      if (unique_id != null) {
        args.addAll({"unique_id": unique_id});
      }

      var resp = await client.post("$SERVER_URI/api/healthentry/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      print(resp.body);
      Map data = jsonDecode(resp.body);
      print(resp.body);
      if (data.containsKey("fever") &&
          data.containsKey("cough") &&
          data.containsKey("difficult_breathing") &&
          data.containsKey("latitude")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }


  // Corona Cases
  Future<Map> coronaCases() async {
    try {
      var resp = await client.get("$SERVER_URI/api/coronacases/?format=json",
          headers: {"Authorization": "Token ${this.token}"});
      return {"status": "success", "info": jsonDecode(resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }
  
  // Health Stat

  Future<Map> healthStat() async {
    try {
      var resp = await client.get("$SERVER_URI/api/healthstat/?format=json",
          headers: {"Authorization": "Token ${this.token}"});
      return {"status": "success", "info": jsonDecode(resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }
  Future<Map> getUniqueId() async {
    try {
      var resp = await client.get("$SERVER_URI/maps/generate_unique_key?format=json",
          headers: {"Authorization": "Token ${this.token}"});
      return {"status": "success", "info": jsonDecode(resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }


  // Get News

  Future<Map> getStateData() async {
    try {
      var resp = await client.get("https://api.covid19india.org/state_district_wise.json");
      return {"status": "success", "info": jsonDecode(resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }


  Future<Map> getNews() async {
    try {
      var resp = await client.get("$SERVER_URI/api/news/?format=json",
          headers: {"Authorization": "Token ${this.token}"});
      return {"status": "success", "info": jsonDecode(resp.body)};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Close the persistent connection with the server.
  void close() {
    client.close();
  }
}

Future<void> main() async {
  Covid19API a = Covid19API();



Map b = await a.login('mornville', 'apple007');
Map aa = await a.getUniqueId();
print(aa['info']['id']);
Map data = await a.healthEntry(age: 19, latitude: '12.22333', longitude: '11.22122', self_quarantine: false, fever: false, difficult_breathing: false, unique_id:'990', cough: false, gender: 'F');

print(data);
//  Map data =  await a.getStateData();
//  String state = 'Bihar';
//  List districts = data['info'][state]['districtData'].keys.toList();
//  for(int i=0;i<districts.length;i++){
//    int delConfirmed = data['info'][state]['districtData'][districts[i]].values.toList()[2]['confirmed'];
//    String dis = districts[i];
//    int confirmed = data['info'][state]['districtData'][districts[i]].values.toList()[0];
//    print(dis + delConfirmed.toString() + ' =' + confirmed.toString() );
//    d.add([dis, delConfirmed, confirmed]);
//  }
//  print(d[0][0]);

}
