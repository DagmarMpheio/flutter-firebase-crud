import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/view/home_view.dart';
import 'package:flutter_firebase_app/view_model/dador_viewmodel.dart';
import 'package:get/get.dart';

class VerifyEmailView extends StatefulWidget {
  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  final dadorViewModel = Get.put(DadorViewModel());
  Timer? timer;

  @override
  void initState() {
    super.initState();

    //verficar se o email foi verificado
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      dadorViewModel.sendVerificationEmail();

      //verificar a cada 3 segundos se o email foi verificado
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    //chamar depois da verificacao de email
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (error) {
      Get.snackbar(
        "Verificação de Email",
        error.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );

      Get.back(closeOverlays: true);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomeView()
      : Scaffold(
          appBar: AppBar(
            title: const Text("Verificar email"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Uma verficação do email foi enviada para o seu email.",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.email, size: 32),
                  label: const Text(
                    "Enviar Novamente",
                    style: TextStyle(fontSize: 24),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () =>
                      canResendEmail ? sendVerificationEmail() : null,
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                      maximumSize: const Size.fromHeight(50)),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                )
              ],
            ),
          ),
        );
}
