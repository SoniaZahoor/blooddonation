// ignore_for_file: avoid_print
import 'package:assignmen_1/model/user_model.dart';
import 'package:assignmen_1/shared_pref/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'accepterhome.dart';
import 'accpterregister.dart';

class AccepterLogin extends StatelessWidget {
  const AccepterLogin({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement
    String accepteremail = '', accepterpassword = '';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Image.asset(
                'assets/images/donate.png',
                height: 300,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                onChanged: (value) {
                  accepteremail = value;
                },
                keyboardType: TextInputType.emailAddress,
                focusNode: FocusNode(),
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  hintText: 'Your Email',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.person,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                onChanged: (value) {
                  accepterpassword = value;
                },
                keyboardType: TextInputType.name,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  hintText: 'Password',
                  suffixIcon: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.visibility,
                      color: Colors.red,
                    ),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.lock,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: const Size(350, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () async {
                  try {
                    // ignore: unused_local_variable
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: accepteremail,
                      password: accepterpassword,
                    );
                    await SharedPrefClient().setUser(UserModel(
                        credential.user!.uid, credential.user!.email!));
                    Get.offAll(() => const AccepterHome());
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 25),
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Do not have account?'),
                TextButton(
                  onPressed: () {
                    Get.to(const AccepterRegister());
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
