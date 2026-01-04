// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController {
  final double price = Get.arguments;

  final String _secretKey = '';
  // You can store payment intent data here
  Map<String, dynamic>? paymentIntent;
  RxBool paymentSucced = false.obs;

  /// Create a new payment
  Future<void> makePayment(double amount, BuildContext context) async {
    try {
      // 1️⃣ Create PaymentIntent
      paymentIntent = await _createPaymentIntent(amount, 'usd');

      // 2️⃣ Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Test Store',
        ),
      );

      // 3️⃣ Present the Payment Sheet
      await _presentPaymentSheet(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Payment failed: $e')));
    }
  }

  /// Present payment sheet
  Future<void> _presentPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      paymentSucced.value = true;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('✅ Payment Successful')));
      paymentIntent = null;
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Payment cancelled: ${e.error.localizedMessage}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  /// Create Payment Intent (only for test mode)
  Future<Map<String, dynamic>> _createPaymentIntent(
    double amount,
    String currency,
  ) async {
    try {
      final body = {
        'amount': (amount * 100).toInt().toString(), // in cents
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey', // ⚠️ Test secret key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      return jsonDecode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
