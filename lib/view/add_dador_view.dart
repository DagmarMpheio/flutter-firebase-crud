import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/view_model/dador_viewmodel.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';

class AddDadorView extends StatefulWidget {
  const AddDadorView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddDadorViewState createState() => _AddDadorViewState();
}

class _AddDadorViewState extends State<AddDadorView> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final dadorViewModel = Get.put(DadorViewModel());

  final List<String> _provincias = [
    "Bengo",
    "Benguela",
    "Bié",
    "Cabinda",
    "Cuando-Cubango",
    "Cuanza Norte",
    "Cuanza Sul",
    "Cunene",
    "Huambo",
    "Huíla",
    "Luanda",
    "Lunda Norte",
    "Lunda Sul",
    "Malanje",
    "Moxico",
    "Namibe",
    "Uíge",
    "Zaire"
  ];
  String? _selectedProvinciaValue;

  final List<String> _gruposSanguineos = [
    "A+",
    "A-",
    "AB+",
    "AB-",
    "B+",
    "B-",
    "O+",
    "O-"
  ];
  String? _selectedGrupoSanguineo;

  String? mobileCode;

  bool _isObscure = true;

  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  chooseProfilePicture() async {
    //escolher a imagem da galeria
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Adicionar Dador")),
        body: Obx(
          () => LoadingOverlay(
            isLoading: dadorViewModel.isLoading.value,
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 24),
                    imageFile == null
                        ? InkWell(
                            onTap: () {
                              chooseProfilePicture();
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              chooseProfilePicture();
                            },
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(imageFile!),
                                  fit: BoxFit.cover,
                                ),
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "Nome",
                        hintText: "Digite o seu nome",
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        labelText: "Email",
                        hintText: "Digite o seu email",
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CountryCodePicker(
                              onChanged: (country) {
                                //actualizar view model com o codigo selecionado
                                mobileCode = country.dialCode.toString();
                              },
                              hideMainText: true,
                              initialSelection: "+351",
                              showCountryOnly: true,
                              showOnlyCountryWhenClosed: true,
                              favorite: const [
                                "+244",
                                "+351",
                                "+55",
                                "+258",
                                "+264"
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: telefoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: "Insira o telefone",
                                labelText: "Telefone",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: senhaController,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Senha",
                          hintText: "Digite a sua Senha",
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
                          )),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        hint: const Text(
                          "Selecione a provincia",
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 60,
                        buttonPadding:
                            const EdgeInsets.only(left: 20, right: 10),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: _provincias
                            .map((provincia) => DropdownMenuItem<String>(
                                  value: provincia,
                                  child: Text(
                                    provincia,
                                  ),
                                ))
                            .toList(),
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value == null) {
                            return "Por favor, seleccione a provincia";
                          }
                        },
                        onChanged: (value) {
                          //mostrar dinamicamente a provincia
                          setState(() {
                            _selectedProvinciaValue = value.toString();
                          });
                        },
                        onSaved: (value) {
                          _selectedProvinciaValue = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: DropdownButtonFormField2(
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        hint: const Text(
                          "Grupo Sanguineo",
                        ),
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black45,
                        ),
                        iconSize: 30,
                        buttonHeight: 60,
                        buttonPadding:
                            const EdgeInsets.only(left: 20, right: 10),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        items: _gruposSanguineos
                            .map((grupoSanguineo) => DropdownMenuItem<String>(
                                  value: grupoSanguineo,
                                  child: Text(
                                    grupoSanguineo,
                                  ),
                                ))
                            .toList(),
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (value == null) {
                            return "Por favor, seleccione o grupo sanguineo.";
                          }
                        },
                        onChanged: (value) {
                          //mostrar dinamicamente a provincia
                          setState(() {
                            _selectedGrupoSanguineo = value.toString();
                          });
                        },
                        onSaved: (value) {
                          _selectedGrupoSanguineo = value.toString();
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (imageFile != null &&
                              nameController.text.isNotEmpty &&
                              emailController.text.isNotEmpty &&
                              mobileCode!.isNotEmpty &&
                              telefoneController.text.isNotEmpty &&
                              senhaController.text.isNotEmpty &&
                              _selectedProvinciaValue!.isNotEmpty &&
                              _selectedGrupoSanguineo!.isNotEmpty) {
                                
                            dadorViewModel.addDador(
                                imageFile!,
                                nameController.text,
                                emailController.text,
                                mobileCode.toString(),
                                telefoneController.text,
                                senhaController.text,
                                _selectedProvinciaValue!,
                                _selectedGrupoSanguineo!);

                            //limpar os campos
                            nameController.text = "";
                            emailController.text = "";
                            telefoneController.text = "";
                            senhaController.text = "";
                            _selectedProvinciaValue =
                                "Por favor, seleccione a provincia";
                            _selectedGrupoSanguineo =
                                "Por favor, seleccione o grupo sanguineo";
                            mobileCode = "";
                            imageFile = null;


                          } else {
                            Get.snackbar(
                              "Validação do Formulário",
                              "Por favor, preencha todos os campor e tente novamente.",
                              colorText: Colors.white,
                              backgroundColor: Colors.red,
                            );

                            // ignore: avoid_print
                            print(
                                // ignore: unnecessary_brace_in_string_interps
                                "${_selectedGrupoSanguineo} -  -- ${_selectedProvinciaValue} --- ${mobileCode!}");
                          }
                        },
                        child: const Text("Registar",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
