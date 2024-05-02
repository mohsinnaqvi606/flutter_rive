import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  var animationLink = 'images/login-bear.riv';
  SMITrigger? failTrigger, successTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  StateMachineController? stateMachineController;
  Artboard? artboard;

  @override
  void initState() {
    rootBundle.load(animationLink).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(art, "Login Machine");

      if (stateMachineController != null) {
        art.addController(stateMachineController!);

        for (var element in stateMachineController!.inputs) {
          if (element.name == "isChecking") {
            isChecking = element as SMIBool;
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
          } else if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
          } else if (element.name == "trigFail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "numLook") {
            lookNum = element as SMINumber;
          }
        }
      }
      setState(() => artboard = art);
    });
    super.initState();
  }

  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(value) {
    lookNum?.change(value.length.toDouble() * 2);
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void loginClick() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    if (emailController.text == "mohsin@gmail.com" &&
        passController.text == "123456") {
      successTrigger?.fire();
    } else {
      failTrigger?.fire();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6E2EA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            if (artboard != null)
              SizedBox(
                width: MediaQuery.sizeOf(context).width - 150,
                height: 300,
                child: Rive(
                  artboard: artboard!,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 50),
            SizedBox(
              height: 60,
              child: TextFormField(
                onTap: lookAround,
                onChanged: ((value) => moveEyes(value)),
                onTapOutside: (event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  isChecking?.change(false);
                },
                maxLines: 1,
                controller: emailController,
                style: const TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black54),
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 55,
              child: TextFormField(
                onTap: handsUpOnEyes,
                onTapOutside: (event) {
                  lookAround();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                obscureText: true,
                controller: passController,
                style: const TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.black54),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder()),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 250,
              decoration: BoxDecoration(
                  color: const Color(0xFFB04863),
                  borderRadius: BorderRadius.circular(25)),
              child: MaterialButton(
                clipBehavior: Clip.antiAlias,
                onPressed: () => {
                  loginClick(),
                },
                shape: const StadiumBorder(),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
