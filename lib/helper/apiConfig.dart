// import 'package:http/http.dart';

// sendData() async {
//   request = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'http://localhost/service%20app/api/user/index.php?accessKey=9999999999999999'));
//   request.fields.addAll({
//     'name': 'Testing User',
//     'email': 'testing000@testing.com',
//     'phone': '1234567890',
//     'password': 'manu1234',
//     'register': '',
//     'longitude': '0',
//     'latitude': '0',
//     'address': 'auto'
//   });
//   request.files
//       .add(await http.MultipartFile.fromPath('profileImage', '/path/to/file'));

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     print(await response.stream.bytesToString());
//   } else {
//     print(response.reasonPhrase);
//   }
// }
