//import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:path/path.dart';

String _basicAuth = 'Basic ' + base64Encode(utf8.encode('wael:wael12345'));

Map<String, String> myheaders = {'authorization': _basicAuth};

mixin class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  postRequest(String uri, Map data) async {
    try {
      var response = await http.post(
        Uri.parse(uri),
        body: data,
        headers: myheaders,
      );
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("Error ${response.statusCode}");
      }
    } catch (e) {
      print("Error catch $e");
    }
  }

  /*
  postRequestWithFile(String uri, Map data, File file) async {
    //من اجل رفع الملف
    var request = await http.MultipartRequest("POST", Uri.parse(uri));
    //من أجل التعامل مع الملف
    var length = await file.length();
    var stream = await http.ByteStream(file.openRead());
    var multipartFile = await http.MultipartFile(
      "file",
      stream,
      length,
      filename: basename(file.path),
    );

    request.files.add(multipartFile);
    //ايضا بدي ارفع الداتا مع الملف
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    //ارسال الريقويست
    var myrequest = await request.send();
    //الحصول على الريسبونس
    var responsee = await http.Response.fromStream(myrequest);

    if (responsee.statusCode == 200) {
      return jsonDecode(responsee.body);
    } else {
      print("Error: ${responsee.statusCode}");
    }
  }*/
  //نفس الشي
  //بس بدل ما اجيب ملف من نوع File بجيب ملف من نوع Uint8List
  //لحتى يعمل على فلاتر ويب مش فلاتر موبايل
  /*
   في Flutter Web لا يوجد:
      File
      openRead()
      ByteStream
      path
      length()
  */
  postRequestWithFile(
    String uri,
    Map data,
    Uint8List fileBytes,
    String fileName,
  ) async {
    var request = http.MultipartRequest("POST", Uri.parse(uri));
    request.headers.addAll(myheaders);

    request.files.add(
      http.MultipartFile.fromBytes("file", fileBytes, filename: fileName),
    );

    data.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      return jsonDecode(responseBody.body);
    } else {
      print("Error: ${response.statusCode}");
    }
  }
}
