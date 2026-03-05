import 'dart:convert';
import 'dart:typed_data';

import 'package:connectme_app/config/logger.dart';
import 'package:connectme_app/requests/urls.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;


/// Helper to convert data URL to Uint8List
Uint8List dataUrlToBytes(String dataUrl) {
  final base64 = dataUrl.split(',').last;
  return base64Decode(base64);
}


Future<String?> uploadToFirebaseAndGetDownloadURL(
    String userId,
    String userToken,
    Map<String,Uint8List> imageData) async {
  /// Client side upload method
  // final ref = FirebaseStorage.instance.ref().child('$filename');
  // final uploadTask = ref.putData(data, SettableMetadata(contentType: 'image/jpeg'));
  // final snapshot = await uploadTask;
  // final url = await snapshot.ref.getDownloadURL();
  // print('Download URL: $url');
  // return url;

  final uri = Uri.parse(image_upload_url);

  Map<String, String> encodedImages = imageData.map((filename, bytes) {
    return MapEntry(filename, base64Encode(bytes));
  });

  Map pdata = {
    "userId": userId,
    "authToken": userToken,
    "image_data": encodedImages};
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(pdata),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    lg.e('Upload failed: ${response.statusCode}');
    lg.t(response.body);
    return null;
  }
}

Future<Uint8List?> getDownloadUrlAndReturnFirebaseStorageImageAsBytes(String path) async {
  lg.t("[downloadFirebaseStorageImageAsBytes] called w path ~ " + path);
  try {
    // Get download URL
    final ref = FirebaseStorage.instance.ref().child(path);
    lg.t("[downloadFirebaseStorageImageAsBytes] getDownloadURL called");
    final url = await ref.getDownloadURL();

    // Fetch image from the URL
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes; // This is Uint8List
    } else {
      lg.e('Failed to fetch image. Status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    lg.e('Error downloading image: $e');
    return null;
  }
}

Future<Uint8List?> returnFirebaseStorageImageAsBytes(String dlUrl) async {
  lg.t("[returnFirebaseStorageImageAsBytes] called w dlUrl ~ " + dlUrl);
  try {
    // Fetch image from the URL
    final response = await http.get(Uri.parse(dlUrl));

    if (response.statusCode == 200) {
      return response.bodyBytes; // This is Uint8List
    } else {
      lg.e('Failed to fetch image. Status: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    lg.e('Error downloading image: $e');
    return null;
  }
}



Future<String?> getFBStorageDownloadImageUrlFromPath(String imagePath)async{
  // lg.t("[getFBStorageDownloadImageUrlFromPath] called");
  try {
    // lg.t("[getFBStorageDownloadImageUrlFromPath] try get storageRef");
    final storageRef = FirebaseStorage.instance.ref().child(imagePath);
    // final metadata = await storageRef.getMetadata();
    // lg.t("[getFBStorageDownloadImageUrlFromPath] get storageRef ~ " + storageRef.toString());
    var dl_url = await storageRef.getDownloadURL();
    // lg.t("[getFBStorageDownloadImageUrlFromPath] dl_url ~ " + dl_url.toString());
    return dl_url;
  }
  catch(e){
    // lg.e("[getFBStorageDownloadImageUrlFromPath] error ~ " + e.toString());
    return null;
  }
}