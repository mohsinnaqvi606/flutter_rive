import 'package:flutter/material.dart';
import 'package:flutter_rive/screen/login_viewmodel.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginViewModel viewModel = Get.put(LoginViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            artBoard(context),
            textField(
              hint: 'Email',
              controller: viewModel.emailController,
              onTap: () => viewModel.lookAround(),
              onChange: (value) => viewModel.moveEyes(value),
            ),
            textField(
              hint: 'Password',
              obscureText: true,
              controller: viewModel.passController,
              onTap: () => viewModel.handsUpOnEyes(),
            ),
            loginBtn(),
          ],
        ),
      ),
    );
  }

  Widget artBoard(BuildContext context) {
    return Obx(
      () => viewModel.isInitialized.value
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              height: 300,
              child: Rive(
                artboard: viewModel.artBoard!,
                fit: BoxFit.contain,
              ),
            )
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 120.0),
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget textField({
    bool obscureText = false,
    required String hint,
    VoidCallback? onTap,
    void Function(String?)? onChange,
    TextEditingController? controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        onTap: onTap,
        onTapOutside: (event) => viewModel.onTapOutSide(),
        obscureText: obscureText,
        onChanged: onChange,
        controller: controller,
        style: const TextStyle(
          color: Colors.deepPurpleAccent,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black54),
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget loginBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: MaterialButton(
        minWidth: 250,
        height: 50,
        color: const Color(0xFFB04863),
        clipBehavior: Clip.antiAlias,
        onPressed: () => {
          viewModel.loginClick(),
        },
        shape: const StadiumBorder(),
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
