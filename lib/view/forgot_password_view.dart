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
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Insira o seu email",
                        labelText: "Email",
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) =>
                          email != null && !isEmailValid(email)
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
                      child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _emailController,
                          builder: (context, value, child) {
                            return ElevatedButton.icon(
                              label: const Text(
                                "Repôr Senha",
                                style: TextStyle(fontSize: 24),
                              ),
                              icon: const Icon(Icons.link, size: 32),
                              onPressed: value.text.toString().isNotEmpty
                                  ? () {
                                      final isValid =
                                          _formKey.currentState!.validate();
                                      if (!isValid) return;

                                      //add a funcao
                                      dadorViewModel.forgotPassword(
                                          _emailController.text);
                                    }
                                  : null,
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //verificar se o email eh valido
  bool isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
