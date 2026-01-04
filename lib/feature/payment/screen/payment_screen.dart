import 'package:elias_creed/feature/payment/controller/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethodScreen extends StatelessWidget {
  PaymentMethodScreen({super.key});

  final PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Test Payment')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          Obx(
            () => controller.paymentSucced.value
                ? Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Payment successful',
                      style: TextStyle(color: Colors.green),
                    ),
                  )
                : Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () =>
                          controller.makePayment(controller.price, context),
                      child: Text(
                        'Pay \$ ${controller.price} (Test Mode)',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
          ),
          Obx(() {
            return controller.paymentSucced.value
                ? ElevatedButton(
                    onPressed: () {
                      Get.back(result: true);
                    },
                    child: Text('Go Back'),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
