import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/view/add_dador_view.dart';
import 'package:flutter_firebase_app/view/dador_update_view.dart';
import 'package:flutter_firebase_app/view_model/dador_viewmodel.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';

class DadorView extends StatefulWidget {
  const DadorView({super.key});

  @override
  State<DadorView> createState() => _DadorViewState();
}

class _DadorViewState extends State<DadorView> {
  final dadorViewModel = Get.put(DadorViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Lista de Dadores")),
        body: Obx(
          () => LoadingOverlay(
            isLoading: dadorViewModel.isLoading.value,
            child: Container(
              margin: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: dadorViewModel.allDadoresList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.to(const DadorUpdateView(),
                            arguments: dadorViewModel.allDadoresList[index]);
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: NetworkImage(dadorViewModel
                                    .allDadoresList[index].profilePicture!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(dadorViewModel
                                      .allDadoresList[index].name!),
                                  Text(dadorViewModel
                                      .allDadoresList[index].email!),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              dadorViewModel.deleteDador(
                                  dadorViewModel.allDadoresList[index]);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //Navegar para tela addDadorView
            Get.to(() => const AddDadorView());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
