import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elias_creed/core/services_class/firebase_service/file_upload_service/image_upload_service.dart';
import 'package:elias_creed/core/services_class/shared_preference/shared_preferences_helper.dart';
import 'package:elias_creed/feature/profile/controller/profile_controller.dart';
import 'package:elias_creed/feature/profile/model/profile_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditProfileController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void onInit() {
    initializeField();
    super.onInit();
  }

  final UserProfile? userProfileArgs = Get.arguments;

  ImageUploadService imageUploadService = ImageUploadService();

  // Images: 5 slots, can be null or URL
  List<Rx<File?>> images = List<Rx<File?>>.generate(5, (_) => Rx<File?>(null));

  List<String> uploadedImageUrlList = List.filled(5, "");

  RxList<String> urlImages = <String>[].obs;

  Map<String, dynamic>? postUserData;

  // Form fields
  final nameController = TextEditingController(text: 'Monica');
  final nationality = 'American'.obs;
  String gender = ''; // Fixed
  final dobController = TextEditingController(text: '02/12/2001');
  final weightController = TextEditingController(text: '48');
  final educationController = TextEditingController(
    text: 'University of Arts and Design',
  );
  final aboutMeController = TextEditingController(
    text:
        "Living life one pose at a time. As a model, I've learned to embrace beauty in all its forms. When I'm not on the runway, I'm exploring new places and creating art with my own unique style.",
  );
  final feetController = TextEditingController();
  final inchController = TextEditingController();

  // Social links
  RxMap<String, String> socialLinks = RxMap({
    'facebook': '',
    'instagram': '',
    'tiktok': '',
    'twitter': '',
    'linkedin': '',
  });

  // Nationality options
  final List<String> nationalityOptions = [
    'American',
    'Canadian',
    'British',
    'Australian',
    'Other',
    '',
  ];

  // Date picker logic can be handled in the view

  void allUpdatedData() {
    int totalInch =
        (int.tryParse(feetController.text)! * 12) +
        int.tryParse(inchController.text)!;
    postUserData = {
      'name': nameController.text.trim(),
      'dateOfBirth': dobController.text,
      'heightInch': totalInch,
      'weightKg': weightController.text,
      'university': educationController.text,
      'about_me': aboutMeController.text,
      'social_media': socialLinks,
      'nationality': nationality.value,
    };
    if (uploadedImageUrlList.isNotEmpty) {
      postUserData!.addAll({'photos': uploadedImageUrlList.where((e) => e.isNotEmpty).toList(),});
    }
    debugPrint("Final update profile data: $postUserData");
  }

  //upload image in firebase

  Future<void> uploadInFirebaseStorage() async {
    final String? userUid = await SharedPreferencesHelper.getUserUid();
    try {
      if (userUid == null) return;
      EasyLoading.show();
      for (int i = 0; i < images.length; i++) {
        if (images[i].value != null) {
          final String imagePath = images[i].value!.path;
          final downloadUrl = await imageUploadService.uploadToFirebase(
            imagePath: imagePath,
            uid: userUid,
          );
          if (downloadUrl != null) {
            uploadedImageUrlList[i] =
                downloadUrl; // replace exact index for new one
          }
        } else {
          // keep old if exists
          if (i < urlImages.length) {
            uploadedImageUrlList[i] = urlImages[i]; // keep existing unchanged
          }
        }
      }

      EasyLoading.dismiss();
      debugPrint('upload image url list: $uploadedImageUrlList');
    } catch (e) {
      debugPrint("image upload error : $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  //update in firebase

  Future<bool> updateUserProfile(Map<String, dynamic> updatedData) async {
    final uid = await SharedPreferencesHelper.getUserUid();
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

    try {
      if (uid == null) throw Exception("User not logged in");

      await userRef.update(updatedData);

      debugPrint("Profile updated successfully!");
      return true;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return false;
    }
  }

  //ontap save change
  Future<void> onTapSaveChange() async {
    try {
      await uploadInFirebaseStorage();
      allUpdatedData();
      await updateUserProfile(postUserData ?? {});
      Get.back(result: true);
    } catch (e) {
      debugPrint("update profile error : $e");
    }
  }

  void initializeField() {
    if (userProfileArgs == null) return;

    final Map<String, dynamic> feetInch = inchesToFeetInch(
      userProfileArgs!.heightInch,
    );
    final String feet = feetInch['feet'].toString();
    final String inch = feetInch['inch'].toString();

    nameController.text = userProfileArgs?.name ?? '';
    nationality.value = userProfileArgs?.nationality ?? '';
    gender = userProfileArgs?.gender ?? '';
    dobController.text = userProfileArgs?.dateOfBirth ?? '';
    feetController.text = feet.toString();
    inchController.text = inch.toString();
    weightController.text = userProfileArgs?.weightKg ?? '';
    educationController.text = userProfileArgs?.university ?? '';
    aboutMeController.text = userProfileArgs?.aboutMe ?? '';
    final socialLink = profileController.userProfile.value!.socialMedia;
    socialLinks['facebook'] = socialLink['facebook'] ?? '';
    socialLinks['twitter'] = socialLink['twitter'] ?? '';
    socialLinks['tiktok'] = socialLink['tiktok'] ?? '';
    socialLinks['instagram'] = socialLink['instagram'] ?? '';
    socialLinks['linkedin'] = socialLink['linkedin'] ?? '';
    urlImages.value = userProfileArgs!.photos;
  }

  @override
  void onClose() {
    nameController.dispose();
    feetController.dispose();
    inchController.dispose();
    weightController.dispose();
    educationController.dispose();
    aboutMeController.dispose();
    super.onClose();
  }

  /// Convert totalInches to feet + inch pair
  Map<String, int> inchesToFeetInch(int totalInches) {
    int feet = totalInches ~/ 12;
    int inch = totalInches % 12;
    return {'feet': feet, 'inch': inch};
  }
}
