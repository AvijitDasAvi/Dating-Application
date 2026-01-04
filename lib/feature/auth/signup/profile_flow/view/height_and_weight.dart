import 'package:elias_creed/core/global_widegts/custom_button.dart';
import 'package:elias_creed/core/global_widegts/custom_text_field.dart';
import 'package:elias_creed/core/style/global_text_style.dart'
    show globalTextStyle;
import 'package:elias_creed/feature/auth/signup/profile_flow/controller/profile_flow_controller.dart';
import 'package:elias_creed/feature/auth/signup/profile_flow/view/education.dart'
    show Education;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class HeightAndWeight extends StatelessWidget {
  HeightAndWeight({super.key});

  final ProfileFlowController controller = Get.find<ProfileFlowController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please enter your Height",
              style: globalTextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 40),

            /// HEIGHT PICKER UI (2 textfields)
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: controller.feetController,
                    hintText: "Feet",
                    isNumber: true,
                    readOnly: true,
                    onTap: () => _openFeetPicker(context),
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: CustomTextField(
                    controller: controller.inchController,
                    hintText: "Inch",
                    isNumber: true,
                    readOnly: true,
                    onTap: () => _openInchPicker(context),
                  ),
                ),
              ],
            ),

            Spacer(),
            CustomButton(
              title: "Next",
              ontap: () {
                if (controller.feetController.text.isEmpty ||
                    controller.inchController.text.isEmpty) {
                  EasyLoading.showError('Please Select Height');
                  return;
                }

                /// storing same place you were storing (in inch)
                controller.heightController.text = controller.totalInch
                    .toString();

                debugPrint('total inch: ${controller.totalInch}');

                Get.to(() => Education());
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _openFeetPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6,),
                    Text("Select Feet", style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 6,),
                    NumberPicker(
                      value: controller.feet.value,
                      minValue: 1,
                      maxValue: 12,
                      onChanged: (v) => controller.feet.value = v,
                      selectedTextStyle: TextStyle(color: Colors.blue,fontSize: 28),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        controller.feetController.text = controller.feet.value
                            .toString();
                        Get.back();
                      },
                      child: Text("Done", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openInchPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12)
              ),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6,),
                    Text("Select Inch", style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 6,),
                    NumberPicker(
                      value: controller.inch.value,
                      minValue: 0,
                      maxValue: 11,
                      onChanged: (v) => controller.inch.value = v,
                      selectedTextStyle: TextStyle(color: Colors.blue,fontSize: 28),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        controller.inchController.text = controller.inch.value
                            .toString();
                        Get.back();
                      },
                      child: Text("Done", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
