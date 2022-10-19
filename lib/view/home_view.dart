import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/view/dador_view.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Olá, Seja Bem Vindo",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                user!.email.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton.icon(
                    onPressed: () => Get.to(() => const DadorView()),
                    icon: const Icon(Icons.list_alt),
                    style: TextButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).primaryColor)),
                    label: const Text(
                      "Ver Dadores",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.arrow_back, size: 32),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                label: const Text(
                  "Terminar Sessão",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onPressed: () => FirebaseAuth.instance.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
