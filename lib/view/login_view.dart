import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/view/add_dador_view.dart';
import 'package:flutter_firebase_app/view/home_view.dart';
import 'package:flutter_firebase_app/view/verify_email_view.dart';
import 'package:flutter_firebase_app/view_model/dador_viewmodel.dart';
import 'package:get/get.dart';

import 'forgot_password_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final dadorViewModel = Get.put(DadorViewModel());
  final _formKey = GlobalKey<FormState>();

  bool _isObscure = true;
  bool isValidated = false;

//ouvinte de valores

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /* appBar: AppBar(title: const Text("Login")),*/
        backgroundColor: Colors.white,
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Alguma coisa correu mal!\n Erro: ${snapshot.hasError}"),
              );
            } else if (snapshot.hasData) {
              //se o usuario fez login, abrir home view
              return VerifyEmailView();
            } else {
              return Container(
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !isEmailValid(email)
                                    ? "Insira um email válido"
                                    : null,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.only(left: 28, right: 28),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            obscureText: _isObscure,
                            controller: _senhaController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (senha) =>
                                senha != null && senha.length < 6
                                    ? "A senha deve ter no mínimo 6 caracteres"
                                    : null,
                            decoration: InputDecoration(
                              hintText: "Insira a password",
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
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
                                return ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: _senhaController,
                                  builder: (context, value, child) {
                                    return ElevatedButton.icon(
                                      label: const Text(
                                        "Login",
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      icon:
                                          const Icon(Icons.lock_open, size: 32),
                                      onPressed: value.text.isNotEmpty
                                          ? () {
                                              final isValid = _formKey
                                                  .currentState!
                                                  .validate();
                                              if (!isValid) return;

                                              //add a funcao
                                              dadorViewModel.login(
                                                  _emailController.text,
                                                  _senhaController.text);
                                            }
                                          : null,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 28,
                            right: 28,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  //forgot password
                                  Get.to(()=>const ForgotPasswordView());
                                },
                                child: Text(
                                  "Esqueci a senha",
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  //register view
                                  Get.to(() => const AddDadorView());
                                },
                                child: Text(
                                  "Já uma conta? Registe-se",
                                  style: Theme.of(context).textTheme.subtitle2,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
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
