// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/model/dador_model.dart';
import 'package:get/get.dart';

class DadorViewModel extends GetxController {
  var isLoading = false.obs;
  var allDadoresList = <DadorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllDador();
  }

  //auth

  login(String email, String senha) async {
    //isLoading.value = true;

    DadorModel dadorModel = DadorModel();
    dadorModel.email = email;
    dadorModel.senha = senha;

    Get.defaultDialog(
      title: "Processando",
      barrierDismissible: false,
      content: const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: dadorModel.email!.trim(), password: dadorModel.senha!.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Get.snackbar(
        "Erro ao no login",
        e.message!,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }

    //fechar o progressbar
    Get.back(closeOverlays: true);
  }


/* registerUser({required String email, required String senha}) async {
    Get.defaultDialog(
      barrierDismissible: false,
      content: const Center(child: CircularProgressIndicator()),
    );

    try {
      //firebase auth
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: senha.trim());
      //retornar uid
    } on FirebaseAuthException catch (e) {
      print(e);

      Get.snackbar(
        "Erro ao criar conta",
        e.message!,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }

    //fechar o progressbar
    Get.back(closeOverlays: true);
  } */

  forgotPassword(String email) async {
    Get.defaultDialog(
      barrierDismissible: false,
      content: const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());

      Get.snackbar(
        "Reposição de Senha",
        "Enviamos um link para repôr a senha no seu email",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );

      Get.back(closeOverlays: true);
    } on FirebaseAuthException catch (error) {
      Get.snackbar(
        "Reposição de Senha",
        error.message!,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );

      Get.back(closeOverlays: true);
    }
  }

  sendVerificationEmail() async {
    try{
      final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    }catch(error){
      Get.snackbar(
        "Verificação de Email",
        error.toString(),
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );

      Get.back(closeOverlays: true);
    }
    
  }

  fetchAllDador() async {
    isLoading.value = true;
    allDadoresList.clear();
    await FirebaseFirestore.instance
        .collection("dadores")
        .get()
        .then((QuerySnapshot snapshot) {
      for (var u in snapshot.docs) {
        allDadoresList.add(DadorModel(
          id: u['id'],
          name: u['name'],
          email: u['email'],
          mobileCode: u['mobileCode'],
          telefone: u['telefone'],
          provincia: u['provincia'],
          grupoSanguineo: u['grupoSanguineo'],
          profilePicture: u['profilePicture'],
        ));
      }
      if (allDadoresList != null) {
        isLoading.value = false;
      }
    });
  }

  addDador(
      File profilePicture,
      String name,
      String email,
      String mobileCode,
      String telefone,
      String senha,
      String provincia,
      String grupoSanguineo) async {
    isLoading.value = true;

    UserCredential result= await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), password: senha.trim());
    User? user = result.user;

    //upload das imagens
    /* int uniqueId = DateTime.now().microsecondsSinceEpoch; */
    String uniqueId = user!.uid.toString();
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("dadores/$uniqueId")
        .putFile(profilePicture);

    TaskSnapshot snapshot = await uploadTask;
    String downloadImageURL = await snapshot.ref.getDownloadURL();

    if (downloadImageURL != null) {
      DadorModel dadorModel = DadorModel();
      dadorModel.id = uniqueId.toString();
      dadorModel.name = name;
      dadorModel.email = email;
      dadorModel.mobileCode = mobileCode;
      dadorModel.telefone = telefone;
      dadorModel.senha = senha;
      dadorModel.provincia = provincia;
      dadorModel.grupoSanguineo = grupoSanguineo;
      dadorModel.profilePicture = downloadImageURL;

      //add dados na BD
      FirebaseFirestore.instance
          .collection("dadores")
          .doc(uniqueId.toString())
          .set(dadorModel.toMap())
          .then((value) {
        isLoading.value = false;
        //carregador os dados
        fetchAllDador();
        //ir para pagina principal
        Get.back();

        Get.snackbar(
          "Cadastro de Dador",
          "Dador foi adicionado com sucesso.",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }).catchError((error) {
        isLoading.value = false;
        Get.snackbar(
          "Cadastro de Dador",
          "Falha ao cadastrar o dador.",
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    }
  }

//actualizar dador
  updateDador(
    File profilePicture,
    String name,
    String email,
    String mobileCode,
    String telefone,
    String senha,
    String provincia,
    String grupoSanguineo,
    int id,
  ) async {
    isLoading.value = true;

//upload das imagens
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("dadores/$id")
        .putFile(profilePicture);

    TaskSnapshot snapshot = await uploadTask;
    String downloadImageURL = await snapshot.ref.getDownloadURL();

    if (downloadImageURL != null) {
      //actulizar dados na BD
      FirebaseFirestore.instance
          .collection("dadores")
          .doc(id.toString())
          .update({
        'name': name,
        'email': email,
        'mobileCode': mobileCode,
        'telefone': telefone,
        'senha': senha,
        'provincia': provincia,
        'grupoSanguineo': grupoSanguineo,
        'profilePicture': downloadImageURL,
      }).then((value) {
        isLoading.value = false;
        //carregador os dados
        fetchAllDador();
        //ir para pagina principal
        Get.back();

        Get.snackbar(
          "Actualização de Dador",
          "Dador foi actualizado com sucesso.",
          colorText: Colors.white,
          backgroundColor: Colors.green,
        );
      }).catchError((error) {
        isLoading.value = false;
        Get.snackbar(
          "Actualização de Dador",
          "Falha ao actualizar o dador\n Erro: $error",
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      });
    }
  }

  deleteDador(DadorModel dadorModel) async {
    FirebaseStorage.instance.ref().child("dadores/${dadorModel.id}").delete();

    allDadoresList.remove(dadorModel);

    await FirebaseFirestore.instance
        .collection("dadores")
        .doc(dadorModel.id.toString())
        .delete()
        .then((value) {
      isLoading.value = false;

      Get.snackbar(
        "Exclusão de Dador",
        "Dador foi excluíd com sucesso.",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    }).catchError((error) {
      isLoading.value = false;
      Get.snackbar(
        "Exclusão de Dador",
        "Falha ao excluir o dador\n Erro: $error",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    });
  }
}
