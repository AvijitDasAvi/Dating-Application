import 'package:elias_creed/core/const/icons_path.dart';
import 'package:elias_creed/core/model/global_user_model.dart';
import 'package:elias_creed/core/style/global_text_style.dart';
import 'package:elias_creed/feature/photo_carousel/screen/photo_carousel_screen.dart';
import 'package:elias_creed/feature/user_profile/controller/user_profile_controller.dart';
import 'package:elias_creed/feature/user_profile/widget/social_media_widget.dart';
import 'package:elias_creed/route/app_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileView extends StatelessWidget {
  UserProfileView({super.key});

  final UserProfileController controller = Get.put(UserProfileController());

  final GlobalUserModel userModel = Get.arguments as GlobalUserModel;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> feetInch = controller.inchesToFeetInch(
      userModel.heightInch,
    );
    final String feet = feetInch['feet'].toString();
    final String inch = feetInch['inch'].toString();

    return Scaffold(
      backgroundColor: const Color(0xFF040404),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 60,
          horizontal: 24,
        ).copyWith(bottom: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Center(child: PhotoCarousel(photos: userModel.photos)),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${userModel.name} (${userModel.age})',
                  style: globalTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(
                      AppRoute.messageScreen,
                      arguments: {'uid': userModel.uid, 'name': userModel.name},
                    );
                  },
                  child: Image.asset(IconsPath.selectedMessage, scale: 3),
                ),
              ],
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.female, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      userModel.gender,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.height, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "$feet feet $inch inch",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                if(userModel.university.isNotEmpty)
                Icon(Icons.school, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    userModel.university,
                    style: globalTextStyle(color: Colors.white, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Divider(color: Color(0xFF252525), height: 1),
            SizedBox(height: 24),
            if (userModel.aboutMe.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About me',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252525),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      userModel.aboutMe,
                      style: const TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: 18,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 10),
            const Text(
              'Prompts',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: userModel.about.entries.map((e) {
                return Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252525),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "❝ ",
                              style: TextStyle(color: Colors.blue),
                            ),
                            TextSpan(
                              text: "${e.key} : ",
                              style: TextStyle(
                                fontSize: 18,
                                height: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        e.value.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(height: 32),
            Text(
              'Social Media',
              style: globalTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 16),
            SocialMediaWidget(socialLink: userModel.socialMedia),
            SizedBox(height: 80), // Space for floating edit button
          ],
        ),
      ),
    );
  }
}
