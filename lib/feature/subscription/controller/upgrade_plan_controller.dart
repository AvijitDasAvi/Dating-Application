import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elias_creed/core/services_class/shared_preference/shared_preferences_helper.dart';
import 'package:elias_creed/feature/payment/screen/payment_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class UpgradePlanController extends GetxController {
  final plans = [
    {
      "plan_name": "Basic",
      "price": 0.0,
      "access_list": [
        "Create and Edit Profile",
        "Swipe Match",
        "Limited Daily Swipes",
      ],
    },
    {
      "plan_name": "Premium",
      "price": 9.99,
      "access_list": [
        "All Free Membership Features",
        "Daily 10 Favor",
        "Unlimited Daily Swipes",
        "Able to directly send date ideas before matching",
      ],
    },
  ].obs;
  final selectedSubscription = ''.obs;
  final price = 0.0.obs;

  void payment() async {
    if (selectedSubscription.value == 'Basic') return;
    final bool result = await Get.to(
      () => PaymentMethodScreen(),
      arguments: price.value,
    );
    if (result) {
      final uid = await SharedPreferencesHelper.getUserUid() ?? '';
      updateSubscriptionStatus(uid);
    }
  }

  Future<void> updateSubscriptionStatus(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'subscriptionPlan': 'Premium',
        'subscriptionDate': FieldValue.serverTimestamp(),
      });
      if (kDebugMode) {
        print("✅ Subscription updated successfully!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error updating subscription: $e");
      }
    }
  }
}
