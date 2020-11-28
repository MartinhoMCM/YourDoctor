import 'dart:async';
import 'package:jitsi_meet_example/main.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/models/province.dart';
import 'package:jitsi_meet_example/service/ServicePaciente.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:jitsi_meet_example/ui/screens/loginview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import '../colors/colorsUI.dart';

class HomePacienteRegister extends StatefulWidget {
  State<StatefulWidget> createState() => new HomeDoctor();
}

class HomeDoctor extends State<HomePacienteRegister> {
  Api api;

  GlobalKey<FormState> _firstFormState = new GlobalKey<FormState>();
  GlobalKey<FormState> _secondFormState = new GlobalKey<FormState>();
  GlobalKey<FormState> _thirdFormState = new GlobalKey<FormState>();

  // os campos para o registro
  TextEditingController _nomeCompleto = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _senha = new TextEditingController();
  TextEditingController _altura = new TextEditingController();
  TextEditingController _peso = new TextEditingController();
  TextEditingController _grupo_sanguineo = new TextEditingController();
  TextEditingController _telephone = new TextEditingController();
  String _genero = "Sexo";
  double width = 200.0;

  TextEditingController _data_nascimento = new TextEditingController();
  DateTime _dataNascimentoUser;

  int currentStep = 0;
  bool isLoading = false;

  File _image = null;

  //Check if _stepState is completed or disable
  StepState _stepState0, _stepState1, _stepState2, _stepState3;
  bool _ativeStep2, _ativeStep3, _ativeStep4;

  //User Address proprieties
  TextEditingController province = new TextEditingController();
  TextEditingController county = new TextEditingController();
  TextEditingController district = new TextEditingController();
  TextEditingController neighborhood = new TextEditingController();
  TextEditingController street = new TextEditingController();
  TextEditingController buildingNumber = new TextEditingController();
  TextEditingController block = new TextEditingController();
  TextEditingController houseNumber = new TextEditingController();
  TextEditingController _codeCaptured = new TextEditingController();

  String error = "";

 //Pin Code
  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  int pinLength = 6;
  bool hasError = false;
  String errorMessage;

  //Code Validation
  String _code;
  bool _isCodeWrong = false;
  bool _continue = false;
  bool _back = false;
  Color color = Colors.grey;

  bool isRegistered = false;

  bool isCountinue = false;

  List<Provincia> _listadeProvincias = new List<Provincia>();
  List<Municipio> _listadeMunicipiosGeral = new List<Municipio>();
  Municipio municipioAtual;
  Provincia ProvinciaAtual;

  bool carregandoProvincias = false;
  bool carregandoMunicipios = false;
  List<Municipio> _listaMunicipiosDrop = new List<Municipio>();

  bool _autoValidate =false;

  // fim dos dados

  // pegando as imagens da Galeria
  Future getImagefromCamera() async {
    try {
      var image = await ImagePicker.pickImage(
          source: ImageSource.camera, maxWidth: 60, maxHeight: 60);
      setState(() {});
      _image = image;
    } catch (e) {
      print(e);
    }
  }

  // fim das imagens

  void dispose() {
    _nomeCompleto.dispose();
    _email.dispose();
    _senha.dispose();
    _altura.dispose();
    _peso.dispose();
    _grupo_sanguineo.dispose();
    _data_nascimento.dispose();
    super.dispose();
  }

  Future getImagefromGallery() async {
    try {
      var image = await ImagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 60, maxHeight: 60);
      setState(() {});
      _image = image;
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    api = new Api();
    _stepState0 = StepState.editing;
    _stepState1 = StepState.disabled;
    _stepState2 = StepState.disabled;
    _stepState3 = StepState.disabled;
    _ativeStep2 = false;
    _ativeStep3 = false;
    _ativeStep4 = false;
    _code = "";

    api.ListadeProvincia().then((ListaProvinciasServer) {
      if (ListaProvinciasServer.length != 0) {
        setState(() {
          this._listadeProvincias = ListaProvinciasServer;

          this.ProvinciaAtual = this._listadeProvincias[0];
          BuscarMunicipioDaProvincia(this.ProvinciaAtual);
        });
      }
    });

    api.ListadeMunicipios().then((ListaMunicipiosServer) {
      if (ListaMunicipiosServer.length != 0) {
        setState(() {
          this._listadeMunicipiosGeral = ListaMunicipiosServer;
        });
      }
    });

    super.initState();
  }

  // fim dos campos
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Align(
            alignment: Alignment.topLeft,
            child: Text("Registrar", style: titleStyle),
          ),
          iconTheme: IconThemeData(
            color: blueColor,
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => MyApp()),
                    (route) => false);
              }),
        ),
        body: Stepper(
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            return currentStep == 4
                ? SizedBox.shrink()
                : Row(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed: !_isCodeWrong ? onStepContinue : null,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0)),
                            child: const Text('Continuar',
                                style: TextStyle(color: Colors.white)),
                            color: primaryColor,
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(10),
                          ),
                          FlatButton(
                            onPressed: onStepCancel,
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(50.0)),
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ],
                  );
          },
          type: StepperType.vertical,
          steps: _theSteps(),
          currentStep: currentStep,
          onStepTapped: (step) {
            setState(() {
              currentStep = step;
              //debugPrint('_currentStep ${currentStep}');
            });
          },
          onStepContinue: () async {
            //debugPrint('_currentStep ${currentStep}');
            if (this.currentStep <= 0) {
              if (!_firstFormState.currentState.validate()) return;

              setState(() {
                this.currentStep += 1;
                _ativeStep2 = true;
                if (currentStep == 2) {
                  _ativeStep3 = true;
                }
                setStepState(currentStep);
              });
              // debugPrint('_currentStep ${currentStep}');
            } else if (this.currentStep == 1) {
              if (!_secondFormState.currentState.validate()) return;

              setState(() {
                this.currentStep += 1;
                _ativeStep3 = true;
              });
              setStepState(currentStep);
              //debugPrint('_currentStep1 ${currentStep}');
            } else if (this.currentStep == 2) {
              if (!_thirdFormState.currentState.validate()) return;
              else{
                _autoValidate=true;
                setState(() {
                  
                });
              }
              try {
                //debugPrint('_currentStep2 ${currentStep}');
                setState(() {
                  isLoading = true;
                });
                // debugPrint('EMAIL ${_email.text}');
                String check = await api
                    .checkEmail(_email.text)
                    .whenComplete(() => setState(() {
                          isLoading = false;
                        }));
                if (check != null) {
                  if (check.contains("false")) {
                    setState(() {
                      this.currentStep += 1;
                      _isCodeWrong = true;
                      _ativeStep4 = true;
                    });
                    setStepState(currentStep);

                    Timer(Duration(seconds: 5), () async {
                      String code = await api
                          .receivedCode(_email.text)
                          .whenComplete(() => setState(() {
                                isLoading = false;
                              }));
                      _code = code.trim();
                      debugPrint('Code ${code}');
                    });
                  } else {
                    setState(() {
                      error = "Este email ja foi registrado";
                    });
                  }
                }
              } on Exception catch (e) {
                error = "Falha ao conectar com o servidor";
              }
            } else if (this.currentStep == 3) {
              setStepState(currentStep);
              _ativeStep4 = true;
              setState(() {
                _back = true;
                //this.currentStep += 1;
              });
              // Objecto do paciente
              Patient novoPaciente = Patient(
                senha: _senha.text,
                peso: _peso.text,
                email: _email.text,
                genero: _genero,
                altura: _altura.text,
                telephone: _telephone.text,
                grupo_sanguineo: _grupo_sanguineo.text,
                data_nascimento: _data_nascimento.text,
                nomecompleto: _nomeCompleto.text,
                tipo_Usuario: 1,
                province: ProvinciaAtual.pkProvincia.toString(),
                county: municipioAtual.pk_municipio.toString(),
              );
              // Paciente;

              // adicionanod om paciente na BD
              ServicePaciente adicionar = new ServicePaciente();
              isRegistered =
                  await adicionar.RegistrarPaciente(novoPaciente, context)
                      .whenComplete(() {
                //limpando os dados do usuario
                _nomeCompleto.clear();
                _data_nascimento.clear();
                _grupo_sanguineo.clear();
                _altura.clear();
                _email.clear();
                _senha.clear();
                _peso.clear();
                _dataNascimentoUser = null;
                // fim do limpando dos dados

                if (_image != null) {
                  adicionar.GetUploadFile(_image);
                }
              }).then((value) {
                switch (value) {
                  case true:
                    sucessRegister();
                    break;
                  case false:
                    errorRegistering();
                    break;
                }
                return true;
              });

              if (ServicePaciente.status == "error") {
                connectionError();
              }
              this.currentStep = 0;
            }
          },
          onStepCancel: () {
            if (this.currentStep > 0) {
              setState(() {
                this.currentStep -= 1;
                _isCodeWrong = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ));
  }

  setStepState(int index) {
    switch (index) {
      case 0:
        setState(() {
          _stepState0 = StepState.editing;
          _stepState1 = StepState.disabled;
          _stepState2 = StepState.disabled;
          _stepState3 = StepState.disabled;
        });

        break;

      case 1:
        setState(() {
          _stepState0 = StepState.complete;
          _stepState1 = StepState.editing;
          _stepState2 = StepState.disabled;
          _stepState3 = StepState.disabled;
        });
        break;

      case 2:
        setState(() {
          _stepState0 = StepState.complete;
          _stepState1 = StepState.complete;
          _stepState2 = StepState.editing;
          _stepState3 = StepState.disabled;
        });
        break;

      case 3:
        setState(() {
          _stepState0 = StepState.complete;
          _stepState1 = StepState.complete;
          _stepState2 = StepState.complete;
          _stepState3 = StepState.editing;
        });
        break;

      case 4:
        setState(() {
          _stepState0 = StepState.complete;
          _stepState1 = StepState.complete;
          _stepState2 = StepState.complete;
          _stepState3 = StepState.complete;
        });
        break;
    }
  }

  List<Step> _theSteps() {
    List<Step> _steps = [
      Step(
          state: _stepState0,
          title: Text(
            "Dados Pessoais",
            style: titleStyle,
          ),
          content: userPersonalDataWidget(),
          isActive: this.currentStep >= 0),
      Step(
          state: _stepState1,
          title: Text("Endereço", style: titleStyle),
          content: _listadeProvincias != null && _listadeMunicipiosGeral != null
              ? userAddress()
              : Dialog(
                  backgroundColor: whiteColor,
                  child: Container(
                    width: 80.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: whiteColor,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text('Carregado próxima fase'),
                        Center(
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          isActive: _ativeStep2),
      Step(
          state: _stepState2,
          title: Text("Dados do Usuário", style: titleStyle),
          content: userDataWidget(),
          isActive: _ativeStep3),
      Step(
          state: _stepState3,
          title: Text("Confirmação do código", style: titleStyle),
          content: ConfirmCodeVerification(),
          isActive: _ativeStep4),
    ];

    return _steps;
  }

  Widget userPersonalDataWidget() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(0.0),
        child: Form(
          key: _firstFormState,
          autovalidate: _autoValidate,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: 132.0,
                        height: 60.0,
                        child: TextFormField(
                          controller: _altura,
                          keyboardType: TextInputType.numberWithOptions(),
                          validator: (altura) {
                            if (altura.isEmpty) {
                              return "Insira a altura porfavor!";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            // hintText: "Altura",
                            labelText: 'Altura',
                            enabled: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.grey),),
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.grey)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 2.0),
                          ),
                          style: subtitleStyle,
                        ),
                      ),
                    ),
                    UIHelper.horizontalSpaceSmall(),
                    Expanded(
                      child: Container(
                        width: 130.0,
                        height: 60.0,
                        child: TextFormField(
                          decoration: InputDecoration(
                            // hintText: "Peso",
                            labelText: 'Peso',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.0,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.grey)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                          ),
                          controller: _peso,
                          validator: (peso) {
                            if (peso.isEmpty) {
                              return "Inserir o peso por favor!";
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.numberWithOptions(),
                          style: subtitleStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // width: 160.0,
                child: TextFormField(
                  controller: _grupo_sanguineo,
                  decoration: InputDecoration(
                    labelText: "Grupo Sanguíneo",
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.grey)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  ),
                  style: subtitleStyle,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: 120.0,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            elevation: 10,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconSize: 18.0,
                            value: _genero,
                            items: <String>['Masculino', 'Feminino', 'Sexo']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: subtitleStyle,
                                ),
                              );
                            }).toList(),
                            onChanged: (genero) {
                              setState(() {});
                              this._genero = genero;
                              print('genero in setState  ${_genero}');
                            },
                          ),
                        ),
                      ),
                      UIHelper.horizontalSpaceSmall(),
                      Expanded(
                        child: Container(
                          width: 150,
                          child: TextFormField(
                            controller: _data_nascimento,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      BorderSide(color: Colors.black12)),
                              hintText: 'Data de Nascimento',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            ),
                            style: subtitleStyle,
                            onTap: () {
                              var data_nascimento = showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2018),
                                lastDate: DateTime(2030),
                              );
                              data_nascimento.then((datetime) {
                                setState(() {
                                  _dataNascimentoUser = datetime;
                                  _data_nascimento = new TextEditingController(
                                      text: datetime.day.toString() +
                                          '/' +
                                          datetime.month.toString() +
                                          '/' +
                                          _dataNascimentoUser.year.toString());
                                });
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              UIHelper.verticalSpaceMedium(),
            ],
          ),
        ),
      ),
    );
  }

  Widget userDataWidget() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            backgroundColor: primaryColor,
          ))
        : SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(0.0),
              child: Form(
                key: _thirdFormState,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                        child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text("Photo de Perfil"),
                                  content: Container(
                                    width: 80,
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            getImagefromGallery();
                                            Navigator.of(context).pop();
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          minWidth: 200,
                                          child: Text(
                                            "Galeria",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          color: primaryColor,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            getImagefromCamera();
                                            Navigator.of(context).pop();
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          minWidth: 200,
                                          child: Text(
                                            "Camera",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 4.0, color: Colors.grey),
                            color: primaryColor),
                        child: _image == null
                            ? Icon(
                                Icons.person_add,
                                color: Colors.white,
                                size: 30,
                              )
                            : ClipOval(
                                child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                                height: 60,
                                width: 60,
                              )),
                      ),
                    )),
                    UIHelper.verticalSpaceMedium(),
                    TextFormField(
                      controller: _nomeCompleto,
                      decoration: new InputDecoration(
                        hintText: 'Nome do Usuário',
                        icon: new Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                      ),
                      style: subtitleStyle,
                      validator: (nome) {
                        if ( nome.length<4) {
                          return "O nome tem que ter mais de 4 caracteres!";
                        } else {
                          return null;
                        }
                      },
                    ),
                    UIHelper.verticalSpaceSmall(),
                    TextFormField(
                      controller: _email,
                      onTap: () {
                        setState(() {
                          error = "";
                        });
                      },
                      decoration: new InputDecoration(
                        hintText: 'Email',
                        icon: new Icon(
                          Icons.mail,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                      ),
                      style: subtitleStyle,
                      validator: validateEmail,
                    ),
                    error.length > 1
                        ? Container(
                            child: Text(
                              '${error}',
                              style: warningStyle,
                            ),
                          )
                        : Container(),
                    UIHelper.verticalSpaceSmall(),
                    TextFormField(
                      controller: _senha,
                      obscureText: true,
                      decoration: new InputDecoration(
                        hintText: 'Senha',
                        icon: new Icon(
                          Icons.lock,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                      ),
                      style: subtitleStyle,
                      validator:validateSenha,
                    ),
                    UIHelper.verticalSpaceSmall(),
                    TextFormField(
                      controller: _telephone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        // mobileFormatter,
                      ],
                      decoration: InputDecoration(
                        hintText: "Telefone",
                        icon: new Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.grey)),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                      ),
                      style: subtitleStyle,
                      validator: (phone) => (phone.substring(0).contains('9') &&
                              phone.length == 9)
                          ? null
                          : "O número deve começar com nove",
                    ),
                    UIHelper.verticalSpaceSmall(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget userAddress() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Form(
          key: _secondFormState,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                    width: 140.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: DropProvincias()),
              ),
              UIHelper.horizontalSpaceSmall(),
              Expanded(
                child: Container(
                    width: 120.0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: DropMunicipios()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ConfirmCodeVerification() {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PinCodeTextField(
                autofocus: true,
                controller: controller,
                hideCharacter: false,
                highlight: true,
                highlightColor: blueColor,
                defaultBorderColor: Colors.black,
                hasTextBorderColor: color,
                maxLength: pinLength,
                pinBoxHeight: 35,
                pinBoxWidth: 30,
                hasError: hasError,
                onTextChanged: (text) {
                  setState(() {
                    hasError = false;
                  });
                },
                onDone: (text) {
                  print("DONE CONTROLLER ${controller.text}");
                  if (controller.text.contains(_code)) {
                    setState(() {
                      color = primaryColor;
                      _isCodeWrong = false;
                    });
                  } else {
                    setState(() {
                      _isCodeWrong = true;
                      color = Colors.redAccent;
                    });
                  }
                },
               // wrapAlignment: WrapAlignment.start,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                pinTextStyle: TextStyle(fontSize: 15.0),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.defaultNoTransition,
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                highlightAnimationBeginColor: Colors.black,
                highlightAnimationEndColor: Colors.white12,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          UIHelper.verticalSpaceSmall(),
          Text(
            " Insira o código que foi enviado para o \n seu email ",
            style: normalStyle,
          ),
          Visibility(
            visible: _isCodeWrong,
            child: Text(
              "Falha na correspondência ",
              style: warningStyle,
            ),
          ),
        ]));
  }

  void sucessRegister() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                width: 300,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: primaryColor, size: 32),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Cadastrado com Sucesso",
                      style: TextStyle(color: Colors.green),
                    )
                  ],
                ),
              ),
            ));
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) =>LoginView()), (route) => false);
  }

  void errorRegistering() {
    showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                width: 300,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Erro ao cadastrar porfavor tenta novamente!"),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Sair",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ))
                  ],
                ),
              ),
            ));
  }

  void connectionError() {
    showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                width: 300,
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Erro de conexão com o servidor"),
                    FlatButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                        },
                        child: Text(
                          "Sair",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ))
                  ],
                ),
              ),
            ));
  }

  Widget DropMunicipios() {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      elevation: 10,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconSize: 18.0,
      value: this.municipioAtual,
      items: this._listaMunicipiosDrop.map((Municipio value) {
        return DropdownMenuItem<Municipio>(
          value: value,
          child: new Text(value.descricao, style: subtitleStyle),
        );
      }).toList(),
      onChanged: (esp) {
        setState(() {
          this.municipioAtual = esp;
          print(this.municipioAtual.pk_municipio);
        });
      },
    );
  }

  void BuscarMunicipioDaProvincia(Provincia novo) {
    //limpando as lista
    this._listaMunicipiosDrop.clear();
    // limpando os campos

    for (int i = 0; i < this._listadeMunicipiosGeral.length; ++i) {
      print("this the pk_municipio:" +
          _listadeMunicipiosGeral[i].pk_municipio.toString());

      if (novo.pkProvincia == this._listadeMunicipiosGeral[i].fk_provincia) {
        setState(() {
          _listaMunicipiosDrop.add(_listadeMunicipiosGeral[i]);
        });
      }
    }

    if (this._listaMunicipiosDrop.length != 0) {
      setState(() {
        this.municipioAtual = this._listaMunicipiosDrop[0];
      });
    }

    print("this is the length:" + _listaMunicipiosDrop.length.toString());
  }

  Widget DropProvincias() {
    return DropdownButtonFormField(
      isExpanded: true,
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
      elevation: 10,
      icon: Icon(Icons.arrow_drop_down_circle),
      iconSize: 18.0,
      value: this.ProvinciaAtual,
      items: this._listadeProvincias.map((Provincia value) {
        return DropdownMenuItem<Provincia>(
          value: value,
          child: new Text(value.descricao, style: subtitleStyle),
        );
      }).toList(),
      onChanged: (esp) {
        setState(() {
          this.ProvinciaAtual = esp;
          BuscarMunicipioDaProvincia(this.ProvinciaAtual);
        });
      },
    );
  }

    String validateSenha(String value) {
    if (value == null) {
      return 'Senha deve possuir mais de 6 caracteres';
    } else {
      if (value.length < 6 || value.isEmpty)
        return 'Senha deve possuir mais de 6 caracteres';
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Insira o Email';
    else
      return null;
  }
}
