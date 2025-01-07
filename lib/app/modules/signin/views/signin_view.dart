import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xengistic_app/app/modules/signin/controllers/signin_controller.dart';
import 'package:xengistic_app/app/services/auth_service.dart';

class SignInView extends GetView<SignInController> {
  SignInView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> submitSignin(String? s) async {
    if (_formKey.currentState!.validate()) {
      // Get.dialog(
      //   const Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // );
      await AuthService.to.signin(
        controller.username.value.text,
        controller.password.value.text,
      );
      // Get.back();
    }
  }

  void btnSignup() {
    Get.toNamed('/sign-up');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.all(24),
          child: Container(
            width: context.width,
            height: context.height,
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 550),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 2,
              ),
            ),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.only(
                    left: 50,
                    right: 50,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      runSpacing: 15,
                      children: [
                        const Image(
                          image: AssetImage("assets/company/logo.png"),
                          height: 180,
                        ),
                        TextFormField(
                          controller: controller.username.value,
                          onFieldSubmitted: submitSignin,
                          decoration:
                              const InputDecoration(hintText: "Username"),
                        ),
                        TextFormField(
                          controller: controller.password.value,
                          onFieldSubmitted: submitSignin,
                          decoration:
                              const InputDecoration(hintText: "Password"),
                          obscureText: true,
                        ),
                        SizedBox(
                          width: context.width,
                          child: ElevatedButton(
                            onPressed: () => submitSignin(""),
                            style: const ButtonStyle(
                              enableFeedback: true,
                            ),
                            child: const Text("Sign in"),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
