import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/view_model/dador_viewmodel.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final dadorViewModel = Get.put(DadorViewModel());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      appBar: AppBar(title: const Text("Repôr Senha")),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      hintText: "Insira o seu email",
                      labelText: "Email",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && EmailValidator.validate(email)
                            ? "Insira um email válido"
                            : null,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: (_emailController.text.isNotEmpty)
                          ? () {
                              //add a funcao
                            }
                          : null,
                      child: const Text("Repôr Senha",
                          style: TextStyle(fontSize: 24)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
