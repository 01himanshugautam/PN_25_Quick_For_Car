import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:http/http.dart" as http;
import 'package:service_app/functions/click_functions.dart';
import 'package:service_app/helper/helper.dart';
import 'package:service_app/models/CategoryModal.dart';
import 'package:service_app/models/MyServicesModal.dart';
import 'package:service_app/models/PagesModal.dart';
import 'package:service_app/models/SliderModal.dart';
import 'package:service_app/models/SubcategoryModal.dart';
import 'package:service_app/models/UserModal.dart';
import 'package:service_app/models/workWithUsModal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Http_Service {
  static const String urlForCateogry = API_URL +
      LATEST_CATEGORY_API +
      "?" +
      API_KEY_TEXT +
      "=" +
      API_KEY +
      "&data";
  static Future<List<LatestCategory>> getLatestCategory() async {
    try {
      final response = await http.get(Uri.parse(urlForCateogry));
      if (response.statusCode == 200) {
        List<LatestCategory> category = latestCategoryFromJson(response.body);
        return category;
      } else {
        return <LatestCategory>[];
      }
    } catch (e) {
      return <LatestCategory>[];
    }
  }

  static Future<String> getListofCategory() async {
    try {
      final response = await http.get(Uri.parse(urlForCateogry));
      if (response.statusCode == 200) {
        // List<LatestCategory> category = latestCategoryFromJson(response.body);
        var category = json.decode(response.body);
        print(category);
        return response.body;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  static Future<List<UserModal>> getCurerentUser() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Uri.parse(API_URL +
          USER_API +
          "?" +
          API_KEY_TEXT +
          "=" +
          API_KEY +
          "&uid=${prefs.getString("uid")}&user"));
      if (response.statusCode == 200) {
        List<UserModal> usermodal = currentUserFromJson(response.body);
        return usermodal;
      } else {
        return <UserModal>[];
      }
    } catch (e) {
      return <UserModal>[];
    }
  }

  static const String urlForSlider =
      API_URL + SLIDER_API + "?" + API_KEY_TEXT + "=" + API_KEY + "&data";
  static Future<List<SliderModal>> getSlider() async {
    try {
      final response = await http.get(Uri.parse(urlForSlider));
      if (response.statusCode == 200) {
        List<SliderModal> slider = sliderModalFromJson(response.body);
        return slider;
      } else {
        return <SliderModal>[];
      }
    } catch (e) {
      return <SliderModal>[];
    }
  }

  static const String urlForPages =
      API_URL + PAGES_API + "?" + API_KEY_TEXT + "=" + API_KEY + "&data";
  static Future<List<PagesModal>> getPages() async {
    try {
      final response = await http.get(Uri.parse(urlForPages));
      if (response.statusCode == 200) {
        List<PagesModal> pages = pagesModalFromJson(response.body);
        return pages;
      } else {
        return <PagesModal>[];
      }
    } catch (e) {
      return <PagesModal>[];
    }
  }

  static const String urlForSubCategory = API_URL +
      LATEST_CATEGORY_API +
      "?" +
      API_KEY_TEXT +
      "=" +
      API_KEY +
      "&subcategory";
  static Future<List<SubcategoryModal>> getSubCategory() async {
    try {
      final response = await http.get(Uri.parse(urlForSubCategory));
      if (response.statusCode == 200) {
        List<SubcategoryModal> subcategory =
            subcategoryModalFromJson(response.body);
        return subcategory;
      } else {
        return <SubcategoryModal>[];
      }
    } catch (e) {
      return <SubcategoryModal>[];
    }
  }

  static Future<String> getListofSubcategories() async {
    try {
      final response = await http.get(Uri.parse(urlForSubCategory));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  static const String urlForPlans =
      API_URL + PLANS_API + "?" + API_KEY_TEXT + "=" + API_KEY;
  static Future<String> getListofPlans() async {
    try {
      final response = await http.get(Uri.parse(urlForPlans));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "";
      }
    } catch (e) {
      return "";
    }
  }

  static Future<bool> checkProvider() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(Uri.parse(API_URL +
          CHECK_SERVICE_PROVIDER +
          "?" +
          API_KEY_TEXT +
          "=" +
          API_KEY +
          "&uid=${prefs.getString("uid")}"));
      var data = json.decode(response.body);
      bool status = false;
      if (response.statusCode == 200) {
        if (data['error'] == true) {
          status = false;
        } else {
          status = true;
        }
        return status;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static LatLng? position;
  static Future<List<WorkWithUs>> getWorkWithUsDataTowing() async {
    position = await getCurrentPosition();
    print("Longitude:${position!.longitude},Latitude:${position!.latitude}");
    // const String urlForWork = "https://admin.quickforcar.com/api/work_with_us/index.php?towing&accessKey=9999999999999999&latitude=28.9602335&longitude=78.25838540000001";
    String urlForWork = API_URL +
        WORK_WITH_US_API +
        "?" +
        API_KEY_TEXT +
        "=" +
        API_KEY +
        "&towing&latitude=" +
        position!.latitude.toString() +
        "&longitude=" +
        position!.longitude.toString();
    try {
      final response = await http.get(Uri.parse(urlForWork));
      if (response.statusCode == 200) {
        List<WorkWithUs> wwu = workWithUsFromJson(response.body);
        print(response.body);
        return wwu;
      } else {
        return <WorkWithUs>[];
      }
    } catch (e) {
      return <WorkWithUs>[];
    }
  }

  static Future<List<WorkWithUs>> getWorkWithUsWashing() async {
    position = await getCurrentPosition();
    print("Longitude:${position!.longitude},Latitude:${position!.latitude}");
    // const String urlForWork = "https://admin.quickforcar.com/api/work_with_us/index.php?towing&accessKey=9999999999999999&latitude=28.9602335&longitude=78.25838540000001";
    String urlForWork = API_URL +
        WORK_WITH_US_API +
        "?" +
        API_KEY_TEXT +
        "=" +
        API_KEY +
        "&washing&latitude=" +
        position!.latitude.toString() +
        "&longitude=" +
        position!.longitude.toString();
    try {
      final response = await http.get(Uri.parse(urlForWork));
      if (response.statusCode == 200) {
        List<WorkWithUs> wwu = workWithUsFromJson(response.body);
        print(response.body);
        return wwu;
      } else {
        return <WorkWithUs>[];
      }
    } catch (e) {
      return <WorkWithUs>[];
    }
  }

  static Future<List<WorkWithUs>> getWorkWithUsDataGeneral(String id) async {
    position = await getCurrentPosition();
    print("Longitude:${position!.longitude},Latitude:${position!.latitude}");
    // const String urlForWork = "https://admin.quickforcar.com/api/work_with_us/index.php?towing&accessKey=9999999999999999&latitude=28.9602335&longitude=78.25838540000001";
    String urlForWork = API_URL +
        WORK_WITH_US_API +
        "?" +
        API_KEY_TEXT +
        "=" +
        API_KEY +
        "&general&latitude=" +
        position!.latitude.toString() +
        "&longitude=" +
        position!.longitude.toString() +
        "&category=" +
        id;
    try {
      final response = await http.get(Uri.parse(urlForWork));
      if (response.statusCode == 200) {
        List<WorkWithUs> wwu = workWithUsFromJson(response.body);
        print(response.body);
        return wwu;
      } else {
        return <WorkWithUs>[];
      }
    } catch (e) {
      return <WorkWithUs>[];
    }
  }

  static Future<List<WorkWithUs>> getWorkWithUsDataGeneralForSubcategory(
      int id) async {
    position = await getCurrentPosition();
    print("Longitude:${position!.longitude},Latitude:${position!.latitude}");
    // const String urlForWork = "https://admin.quickforcar.com/api/work_with_us/index.php?generalForSubcategory&accessKey=9999999999999999&latitude=28.9602335&longitude=78.25838540000001&subcategory=6";
    String urlForWork = API_URL +
        SUBCATEGORY_GENERAL +
        "?" +
        API_KEY_TEXT +
        "=" +
        API_KEY +
        "&general_sub&subcategory=${id}&latitude=${position!.latitude.toString()}&longitude=${position!.longitude.toString()}";
    try {
      final response = await http.get(Uri.parse(urlForWork));
      if (response.statusCode == 200) {
        List<WorkWithUs> wwu = workWithUsFromJson(response.body);
        print(response.body);
        return wwu;
      } else {
        return <WorkWithUs>[];
      }
    } catch (e) {
      return <WorkWithUs>[];
    }
  }

  static Future<List<SubcategoryModal>> getSubcategoryForService(
      String id) async {
    position = await getCurrentPosition();
    print("Longitude:${position!.longitude},Latitude:${position!.latitude}");
    // const String urlForWork = "https://admin.quickforcar.com/api/work_with_us/index.php?towing&accessKey=9999999999999999&latitude=28.9602335&longitude=78.25838540000001";
    String urlForWork = API_URL +
        WORK_WITH_US_API +
        "?" +
        API_KEY_TEXT +
        "=" +
        API_KEY +
        "&subcategory&latitude=" +
        position!.latitude.toString() +
        "&longitude=" +
        position!.longitude.toString() +
        "&category=" +
        id;
    try {
      final response = await http.get(Uri.parse(urlForWork));
      if (response.statusCode == 200) {
        List<SubcategoryModal> wwu = subcategoryModalFromJson(response.body);
        print(response.body);
        return wwu;
      } else {
        return <SubcategoryModal>[];
      }
    } catch (e) {
      return <SubcategoryModal>[];
    }
  }

  static Future<List<WorkWithUs>> getWorkWithUsDataAlignMent() async {
    position = await getCurrentPosition();
    print("Longitude:${position!.longitude},Latitude:${position!.latitude}");
    // const String urlForWork = "https://admin.quickforcar.com/api/work_with_us/index.php?towing&accessKey=9999999999999999&latitude=28.9602335&longitude=78.25838540000001";
    String urlForWork = API_URL +
        WORK_WITH_US_API +
        "?" +
        API_KEY_TEXT +
        "=" +
        API_KEY +
        "&alignment&latitude=" +
        position!.latitude.toString() +
        "&longitude=" +
        position!.longitude.toString();
    try {
      final response = await http.get(Uri.parse(urlForWork));
      if (response.statusCode == 200) {
        List<WorkWithUs> wwu = workWithUsFromJson(response.body);
        print(response.body);
        return wwu;
      } else {
        return <WorkWithUs>[];
      }
    } catch (e) {
      return <WorkWithUs>[];
    }
  }

  static Future<List<WorkWithUs>> searchData(String search) async {
    position = await getCurrentPosition();
    print("Longitude:${position!.longitude},Latitude:${position!.latitude}");
    // const String urlForWork = "https://admin.quickforcar.com/api/work_with_us/index.php?towing&accessKey=9999999999999999&latitude=28.9602335&longitude=78.25838540000001";
    try {
      final response = await http.get(Uri.parse(
          "${API_URL}${SEARACH_API}?${API_KEY_TEXT}=${API_KEY}&latitude=${position!.latitude.toString()}&longitude=${position!.longitude.toString()}&search=${search}"));
      if (response.statusCode == 200) {
        List<WorkWithUs> wwu = workWithUsFromJson(response.body);
        print(response.body);
        return wwu;
      } else {
        return <WorkWithUs>[];
      }
    } catch (e) {
      return <WorkWithUs>[];
    }
  }

  static Future<List<MyServicesModal>> getMyServicesData() async {
    final prefs = await SharedPreferences.getInstance();
    position = await getCurrentPosition();
    print("Longitude:${position!.longitude},Latitude:${position!.latitude}");
    // const String urlForWork = "https://admin.quickforcar.com/api/work_with_us/index.php?towing&accessKey=9999999999999999&latitude=28.9602335&longitude=78.25838540000001";
    String urlForWork = API_URL +
        MY_SERVICES_API +
        "?" +
        API_KEY_TEXT +
        "=" +
        API_KEY +
        "&uid=${prefs.getString("uid")}";
    print(urlForWork);
    try {
      final response = await http.get(Uri.parse(API_URL +
          MY_SERVICES_API +
          "?" +
          API_KEY_TEXT +
          "=" +
          API_KEY +
          "&uid=${prefs.getString("uid")}"));
      if (response.statusCode == 200) {
        List<MyServicesModal> myservice =
            myServicesModalFromJson(response.body);
        print(response.body);
        return myservice;
      } else {
        return <MyServicesModal>[];
      }
    } catch (e) {
      return <MyServicesModal>[];
    }
  }
}
