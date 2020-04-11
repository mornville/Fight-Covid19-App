import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

// Global variables

const String SERVER_URI = "http://165.22.220.85";

class SmittyAPI {
  var client = http.Client();
  String token;

  /// Set the [token] for an already logged in user.
  ///
  /// @param token String token used for API authentication for a given user.
  /// @returns void
  ///
  /// ```dart
  /// SmittyAPI a = SmittyAPI();
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
      var resp = await client.post("$SERVER_URI/api-token-auth/",
          body: {'username': username, 'password': password});
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
  /// var a = SmittyAPI();
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
      return {"status": "success", "info": jsonDecode(resp.body)['results']};
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

  // Employee

  Future<Map> listOfEmployees() async {
    try {
      var resp = await client.get("$SERVER_URI/api/employee/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  Future<Map> createEmployee(String username, String emailId, String password,
      String firstName, String mobile, String streetAddress,
      {String lastName,
      String isActive,
      String isStaff,
      String isSuperUser,
      String gender,
      String birthDate,
      String userDp,
      String city,
      num postalCode,
      String country,
      String teamLead,
      num teamMembers,
      String dateJoined,
      String salaryType,
      num salary,
      num grossSalary}) async {
    Map<String, String> args = Map();

    // Adding mandatory fields to args Map
    // user
    args.addAll({"username": username});
    args.addAll({"password": password});
    args.addAll({"first_name": firstName});
    args.addAll({"email": emailId});
    //emp
    args.addAll({"mobile": mobile});
    args.addAll({"street_address": streetAddress});

    // Parameters for user
    if (lastName != null) {
      args.addAll({"last_name": lastName});
    }

    if (isActive != null) {
      args.addAll({"is_active": "True"});
    }

    if (isStaff != null) {
      args.addAll({"is_staff": "True"});
    }

    if (isSuperUser != null) {
      args.addAll({"is_superuser": "True"});
    }

    // Parameters for employee
    if (gender != null) {
      args.addAll({"gender": gender});
    }
    if (birthDate != null) {
      args.addAll({"birth_date": birthDate});
    }
    if (mobile != null) {
      args.addAll({"mobile": mobile});
    }
    if (userDp != null) {
      args.addAll({"user_dp": userDp});
    }
    if (streetAddress != null) {
      args.addAll({"street_address": streetAddress});
    }
    if (city != null) {
      args.addAll({"city": city});
    }
    if (postalCode != null) {
      args.addAll({"postal_code": postalCode.toString()});
    }
    if (country != null) {
      args.addAll({"country": country});
    }
    if (teamLead != null) {
      args.addAll({"team_lead": teamLead});
    }
    if (teamMembers != null) {
      args.addAll({"team_members_id": teamMembers.toString()});
    }
    if (dateJoined != null) {
      args.addAll({"date_joined": dateJoined});
    }
    if (salaryType != null) {
      args.addAll({"salary_type": salaryType});
    }
    if (salary != null) {
      args.addAll({"salary": salary.toString()});
    }
    if (grossSalary != null) {
      args.addAll({"gross_salary": grossSalary.toString()});
    }

    try {
      var resp = await client.post("$SERVER_URI/api/employee/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("gender") &&
          data.containsKey("birth_date") &&
          data.containsKey("mobile") &&
          data.containsKey("user_dp") &&
          data.containsKey("street_address") &&
          data.containsKey("city") &&
          data.containsKey("postal_code")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  Future<Map> getEmployee(int empId) async {
    try {
      var resp = await client.get("$SERVER_URI/api/employee/$empId/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  Future<Map> updateEmployee(int empId,
      {String gender,
      String birthDate,
      String mobile,
      String userDp,
      String streetAddress,
      String city,
      num postalCode,
      String country,
      String teamLead,
      String dateJoined,
      String salaryType,
      num teamMembers,
      num salary,
      num grossSalary,
      }) async {
    Map<String, String> args = Map();
    if (gender != null) {
      args.addAll({"gender": gender});
    }
    if (birthDate != null) {
      args.addAll({"birth_date": birthDate});
    }
    if (mobile != null) {
      args.addAll({"mobile": mobile});
    }
    if (userDp != null) {
      args.addAll({"user_dp": userDp});
    }
    if (streetAddress != null) {
      args.addAll({"street_address": streetAddress});
    }
    if (city != null) {
      args.addAll({"city": city});
    }
    if (postalCode != null) {
      args.addAll({"postal_code": postalCode.toString()});
    }
    if (country != null) {
      args.addAll({"country": country});
    }
    if (teamLead != null) {
      args.addAll({"team_lead": teamLead.toString()});
    }
    if (dateJoined != null) {
      args.addAll({"date_joined": dateJoined});
    }
    if (salaryType != null) {
      args.addAll({"salary_type": salaryType});
    }
    if (salary != null) {
      args.addAll({"salary": salary.toString()});
    }
    if (grossSalary != null) {
      args.addAll({"gross_salary": grossSalary.toString()});
    }
    try {
      var resp = await client.patch("$SERVER_URI/api/employee/$empId/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("gender") &&
          data.containsKey("mobile") &&
          data.containsKey("user_dp") &&
          data.containsKey("street_address") &&
          data.containsKey("city") &&
          data.containsKey("postal_code")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  Future<Map> deleteEmployee(int empyId) async {
    try {
      var resp = await client.delete("$SERVER_URI/api/employee/$empyId/",
          headers: {"Authorization": "Token ${this.token}"});
      if (resp.statusCode == 204) {
        return {"status": "success"};
      } else {
        return {"status": "failed", "info": jsonDecode(resp.body)};
      }
    } catch (e) {
      return {"status": "failed", "info": "$e"};
    }
  }

  Future<Map> teamMembers(int empId) async {
    // Getting the list of team members of employee
    Map<String, String> args = Map();
    // Adding mandatory fields to args Map
    args.addAll({"pk": empId.toString()});
    try {
      var resp = await client.post("$SERVER_URI/api/employee/get_team_members/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      List<dynamic> data = jsonDecode(resp.body);
      if (data[0].containsKey("gender") &&
          data[0].containsKey("birth_date") &&
          data[0].containsKey("mobile") &&
          data[0].containsKey("user_dp") &&
          data[0].containsKey("street_address") &&
          data[0].containsKey("city") &&
          data[0].containsKey("postal_code")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to handle Customers
  ///
  /// Function to create Customer
  Future<Map> createCustomer(
    String name,
    num mobile,
    double long,
    double lat, {
    String email,
    String gender,
    String street_address,
    String city,
    num postal_code,
    String country,
    String map_property,
  }) async {
    Map<String, String> args = Map();

    // Adding mandatory fields to args Map
    args.addAll({"name": name});
    args.addAll({"mobile": mobile.toString()});
    args.addAll({"long": long.toString()});
    args.addAll({"lat": lat.toString()});

    // Adding optional Fields to the args Map
    if (gender != null) {
      args.addAll({"gender": gender});
    }

    if (email != null) {
      args.addAll({"email": email});
    }

    if (street_address != null) {
      args.addAll({"street_address": street_address});
    }

    if (city != null) {
      args.addAll({"city": city});
    }

    if (postal_code != null) {
      args.addAll({"postal_code": postal_code.toString()});
    }

    if (country != null) {
      args.addAll({"country": country});
    }

    if (map_property != null) {
      args.addAll({"map_property": map_property});
    }
    try {
      var resp = await client.post("$SERVER_URI/api/customer/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("name") &&
          data.containsKey("mobile") &&
          data.containsKey("long") &&
          data.containsKey("lat") &&
          data.containsKey("gender") &&
          data.containsKey("street_address") &&
          data.containsKey("city") &&
          data.containsKey("postal_code")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get Customer
  Future<Map> getCustomer(int custId) async {
    try {
      var resp = await client.get("$SERVER_URI/api/customer/$custId/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get list of Customers
  Future<Map> listOfCustomers() async {
    try {
      var resp = await client.get("$SERVER_URI/api/customer/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to Update Customer
  Future<Map> updateCustomer(
    int custId, {
    String gender,
    String name,
    num mobile,
    String email,
    double long,
    double lat,
    String streetAddress,
    String city,
    String postalCode,
    String country,
    String map_property,
  }) async {
    Map<String, String> args = Map();
    if (gender != null) {
      args.addAll({"gender": gender});
    }
    if (name != null) {
      args.addAll({"name": name});
    }
    if (mobile != null) {
      args.addAll({"mobile": mobile.toString()});
    }
    if (email != null) {
      args.addAll({"email": email});
    }
    if (long != null) {
      args.addAll({"long": long.toString()});
    }
    if (lat != null) {
      args.addAll({"lat": lat.toString()});
    }
    if (streetAddress != null) {
      args.addAll({"street_address": streetAddress});
    }
    if (city != null) {
      args.addAll({"city": city});
    }
    if (postalCode != null) {
      args.addAll({"postal_code": postalCode.toString()});
    }
    if (country != null) {
      args.addAll({"country": country});
    }
    if (map_property != null) {
      args.addAll({"team_lead": map_property});
    }

    try {
      var resp = await client.patch("$SERVER_URI/api/customer/$custId/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("gender") &&
          data.containsKey("name") &&
          data.containsKey("mobile") &&
          data.containsKey("long") &&
          data.containsKey("lat") &&
          data.containsKey("email") &&
          data.containsKey("city") &&
          data.containsKey("postal_code")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to delete customer
  Future<Map> deleteCustomer(int custId) async {
    try {
      var resp = await client.delete("$SERVER_URI/api/customer/$custId/",
          headers: {"Authorization": "Token ${this.token}"});
      if (resp.statusCode == 204) {
        return {"status": "success"};
      } else {
        return {"status": "failed", "info": jsonDecode(resp.body)};
      }
    } catch (e) {
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to handle Jobs
  ///
  /// Function to create Job
  Future<Map> createJob(
    num service,
    num customer,
    num employee, {
    String payment_interval,
    String job_desc,
    String job_assigned_date,
    String job_assigned_time,
    bool recurrent_job,
    num recurrent_period,
    String recurrent_interval,
    num recurring_days,
    bool recurrent_end,
    String recurrent_end_date,
    num recurrent_end_occur,
  }) async {
    Map<String, String> args = Map();

    // Adding mandatory fields to args Map
    args.addAll({"service": service.toString()});
    args.addAll({"customer": customer.toString()});
    args.addAll({"employee": employee.toString()});

    // Adding optional field to args Map
    if (payment_interval != null) {
      args.addAll({"payment_interval": payment_interval});
    }

    if (job_desc != null) {
      args.addAll({"job_desc": job_desc});
    }

    if (job_assigned_date != null) {
      args.addAll({"job_assigned_date": job_assigned_date});
    }

    if (job_assigned_time != null) {
      args.addAll({"job_assigned_time": job_assigned_time});
    }

    if (recurrent_job != null) {
      args.addAll({"recurrent_job": recurrent_job.toString()});
    }

    if (recurrent_period != null) {
      args.addAll({"recurrent_period": recurrent_period.toString()});
    }

    if (recurrent_interval != null) {
      args.addAll({"recurrent_interval": recurrent_interval.toString()});
    }

    if (recurring_days != null) {
      args.addAll({"recurring_days": recurring_days.toString()});
    }

    if (recurrent_end != null) {
      args.addAll({"recurrent_end": recurrent_end.toString()});
    }

    if (recurrent_end_date != null) {
      args.addAll({"recurrent_end_date": recurrent_end_date.toString()});
    }

    if (recurrent_end_occur != null) {
      args.addAll({"recurrent_end_occur": recurrent_end_occur.toString()});
    }

    try {
      var resp = await client.post("$SERVER_URI/api/job/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("customer") &&
          data.containsKey("service") &&
          data.containsKey("employee") &&
          data.containsKey("job_desc") &&
          data.containsKey("payment_interval") &&
          data.containsKey("job_creation_date") &&
          data.containsKey("job_assigned_date")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get Job
  Future<Map> getJob(int jobId) async {
    try {
      var resp = await client.get("$SERVER_URI/api/job/$jobId/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to Update Customer
  Future<Map> updateJob(
    int jobId, {
    num customer,
    num service,
    num employee,
    String job_desc,
    String job_assigned_date,
    String job_assigned_time,
  }) async {
    Map<String, String> args = Map();

    if (customer != null) {
      args.addAll({"customer_id": customer.toString()});
    }

    if (service != null) {
      args.addAll({"service_id": service.toString()});
    }

    if (employee != null) {
      args.addAll({"employee_id": employee.toString()});
    }


    if (job_desc != null) {
      args.addAll({"job_desc": job_desc});
    }

    if (job_assigned_date != null) {
      args.addAll({"job_assigned_date": job_assigned_date});
    }

    if (job_assigned_time != null) {
      args.addAll({"job_assigned_time": job_assigned_time});
    }

    try {
      var resp = await client.patch("$SERVER_URI/api/job/$jobId/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("customer") &&
          data.containsKey("service") &&
          data.containsKey("employee") &&
          data.containsKey("job_desc") &&
          data.containsKey("payment_interval") &&
          data.containsKey("job_creation_date") &&
          data.containsKey("job_assigned_date")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get list of Jobs
  Future<Map> listOfJobs() async {
    try {
      var resp = await client.get("$SERVER_URI/api/job/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to delete Job
  Future<Map> deleteJob(int jobId) async {
    try {
      var resp = await client.delete("$SERVER_URI/api/job/$jobId/",
          headers: {"Authorization": "Token ${this.token}"});
      if (resp.statusCode == 204) {
        return {"status": "success"};
      } else {
        return {"status": "failed", "info": jsonDecode(resp.body)};
      }
    } catch (e) {
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get list of Pending Jobs
  Future<Map> pendingJobs() async {
    try {
      var resp = await client.get("$SERVER_URI/api/job/get_pending_jobs/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get list of Completed Jobs
  Future<Map> completedJobs() async {
    try {
      var resp = await client.get("$SERVER_URI/api/job/get_completed_jobs/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get list of Scheduled Jobs
  Future<Map> scheduledJobs() async {
    try {
      var resp = await client.get("$SERVER_URI/api/job/get_scheduled_jobs/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get list of In Progress Jobs
  Future<Map> inProgressJobs() async {
    try {
      var resp = await client.get("$SERVER_URI/api/job/get_inprogress_jobs/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get list of Jobs associated with the employee
  Future<Map> getJobsEmployee(int empId) async {
    Map<String, String> args = Map();

    // Adding mandatory fields to args Map
    args.addAll({"pk": empId.toString()});
    try {
      var resp = await client.post("$SERVER_URI/api/job/get_job_employee/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to Mark the Start of Job
  Future<Map> markJobStartOld(int jobId, String startTime, _beforeImage) async {
    Map<String, String> args = Map();

    // Adding mandatory fields to args Map
    args.addAll({"pk": jobId.toString()});
    args.addAll({"start_time": startTime});
    args.addAll({"start_picture": _beforeImage.toString()});
    try {
      var resp = await client.post("$SERVER_URI/api/job/mark_job_start/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to Mark the Start of Job
  Future<Map> markJobStart(int jobId, String startTime, _beforeImage) async {
    try {
      var postUri = Uri.parse("$SERVER_URI/api/job/mark_job_start/");
      var request = new http.MultipartRequest("POST", postUri);
      request.fields['start_time'] = startTime;
      request.fields['pk'] = jobId.toString();
      request.headers['Authorization'] = 'Token ${this.token}';
      request.files.add(await http.MultipartFile.fromPath(
        'start_picture',
        _beforeImage.toString(),
        contentType: new MediaType('application', 'image/png'),
      ));
      var streamedResp = await request.send();
      var body = await streamedResp.stream.bytesToString();
      print(body);
      if (streamedResp.statusCode == 200) {
        var data = jsonDecode(body);
        return {"status": "success", "info": data};
      } else {
        return {
          "status": "failed",
          "info": body,
          "statusCode": streamedResp.statusCode
        };
      }
    } catch (e) {
      return {"status": "failed", "info": e.toString()};
    }
  }

  /// Function to Mark the Start of Job
  Future<Map> markJobComplete(
      int jobId, String endTime, String jobDuration, _afterImage) async {
    try {
      var postUri = Uri.parse("$SERVER_URI/api/job/mark_job_complete/");
      var request = new http.MultipartRequest("POST", postUri);
      request.fields['end_time'] = endTime;
      request.fields['job_duration'] = jobDuration;
      request.fields['pk'] = jobId.toString();
      request.headers['Authorization'] = 'Token ${this.token}';
      request.files.add(await http.MultipartFile.fromPath(
        'end_picture',
        _afterImage.toString(),
        contentType: new MediaType('application', 'image/png'),
      ));
      var streamedResp = await request.send();
      var body = await streamedResp.stream.bytesToString();
      print(body);
      if (streamedResp.statusCode == 200) {
        var data = jsonDecode(body);
        return {"status": "success", "info": data};
      } else {
        return {
          "status": "failed",
          "info": body,
          "statusCode": streamedResp.statusCode
        };
      }
    } catch (e) {
      return {"status": "failed", "info": e.toString()};
    }
  }

  /// Function to handle Offered Services
  ///
  /// Function to create Offered Services
  Future<Map> createofferedService(
    String service, {
    double wage_team_lead,
    double wage_employee,
    String payment_interval,
    String serviceDesc,
  }) async {
    Map<String, String> args = Map();

    // Adding mandatory fields to args Map
    args.addAll({"service": service});

    if (wage_team_lead != null) {
      args.addAll({"wage_team_lead": wage_team_lead.toString()});
    }

    if (wage_employee != null) {
      args.addAll({"wage_employee": wage_employee.toString()});
    }
    if (payment_interval != null) {
      args.addAll({"payment_interval": payment_interval});
    }

    if (serviceDesc != null) {
      args.addAll({"service_desc": serviceDesc});
    }

    try {
      var resp = await client.post("$SERVER_URI/api/offeredService/",
          headers: {"Authorization": "Token ${this.token}"}, body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("service")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get offeredService
  Future<Map> getOfferedService(int serviceId) async {
    try {
      var resp = await client.get("$SERVER_URI/api/offeredService/$serviceId/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to Update Offered Service
  Future<Map> updateOfferedService(
    int serviceId, {
    String service,
    double wage_team_lead,
    double wage_employee,
    String payment_interval,
    String serviceDesc,
  }) async {
    Map<String, String> args = Map();

    if (service != null) {
      args.addAll({"service": service});
    }

    if (wage_team_lead != null) {
      args.addAll({"wage_team_lead": wage_team_lead.toString()});
    }

    if (wage_employee != null) {
      args.addAll({"wage_employee": wage_employee.toString()});
    }

    if (payment_interval != null) {
      args.addAll({"payment_interval": payment_interval});
    }

    if (serviceDesc != null) {
      args.addAll({"service_desc": serviceDesc});
    }

    try {
      var resp = await client.patch(
          "$SERVER_URI/api/offeredService/$serviceId/",
          headers: {"Authorization": "Token ${this.token}"},
          body: args);
      Map data = jsonDecode(resp.body);
      if (data.containsKey("service")) {
        return {"status": "success", "info": data};
      } else {
        return {"status": "failed", "info": data};
      }
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to get list of Offered Services
  Future<Map> listOfOfferedServices() async {
    try {
      var resp = await client.get("$SERVER_URI/api/offeredService/",
          headers: {"Authorization": "Token ${this.token}"});
      var data = jsonDecode(resp.body);
      return {"status": "success", "info": data};
    } catch (e) {
      print("Unable to parse response: $e");
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Function to delete Offered Service
  Future<Map> deleteOfferedService(int serviceId) async {
    try {
      var resp = await client.delete(
          "$SERVER_URI/api/offeredService/$serviceId/",
          headers: {"Authorization": "Token ${this.token}"});
      if (resp.statusCode == 204) {
        return {"status": "success"};
      } else {
        return {"status": "failed", "info": jsonDecode(resp.body)};
      }
    } catch (e) {
      return {"status": "failed", "info": "$e"};
    }
  }

  /// Close the persistent connection with the server.
  void close() {
    client.close();
  }
}

Future<void> main() async {
  SmittyAPI a = SmittyAPI();
  print("Tring to login");
  await a.login("aditya", "adi12345");
  print("Logged in.");
  var temp = await a.markJobComplete(39, '2020-02-26 11:11:11', "77:77:77",
      "/Users/aditya/Desktop/IMG_20180926_080916_Bokeh\ 3.jpg");
  print(temp);
}
