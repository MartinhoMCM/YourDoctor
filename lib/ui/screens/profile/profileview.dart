import 'package:jitsi_meet_example/models/province.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';

import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileViewState();
  }
}

class ProfileViewState extends State<ProfileView> {
  int _currentTab = 0;

  TextEditingController _emailController, _nameController, _phoneController;
  bool _isEditingEmailText = false,
      _isEditingUserNameText = false,
      _isEditingPhoneText = false,
      _isEditingLocation = false;

  String _emailInitialText = "martinhoC@gmail.com",
      _nameInitialText="Cepp Dev",
      _phoneInitialText = "946691711",
      _locationInitialText = "Luanda, Samba";

  TextEditingController _locationController = TextEditingController();

  bool _autovalidate = false;
  final _formKey = GlobalKey<FormState>();
  List<Provincia> _listadeProvincias;
  
   Provincia ProvinciaAtual;


  setTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    

    //AddProvince
    _listadeProvincias =[new Provincia(descricao: 'Luanda', pkProvincia: 1),new Provincia(descricao: 'Bengo', pkProvincia: 2) ];
    ProvinciaAtual =_listadeProvincias[0];
   
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          title: Text('Meu Perfil', style: titleStyle),
          centerTitle: true,
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child:  Form(
      autovalidate: _autovalidate,
      key: _formKey,
      child:
             ListView(children: <Widget>[
              Container(
                child: Center(
                    child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2.0, color: Colors.black38),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50.0),
                          )),
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/profileuser.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Positioned(
                        left: 70.0,
                        right: 0.0,
                        bottom: 0.0,
                        height: 110.0,
                        // width: 60.0,
                        child: IconButton(
                            icon: Icon(
                              Icons.photo_camera,
                              color: blueColor,
                              size: 30.0,
                            ),
                            onPressed: () {})),
                  ],
                )),
              ),
              UIHelper.verticalSpaceMedium(),
              Center(
                  child: Text(
                'Luanga-Samba',
                style: patternTextStyle,
              )),
              UIHelper.verticalSpaceLarge(),

            Text(
                'Dados do Usuario',
                style: patternTextStyle,
              ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Divider(
                color: Colors.grey,
              ),
            ),

              UIHelper.verticalSpaceTooSmall(),
              Text(
                'Nome do Usuário',
                style: appoSubtitleStyle,
              ),
              UIHelper.verticalSpaceTooSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _editNameTextField(),
                  !_isEditingUserNameText
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _isEditingUserNameText = true;
                            });
                          },
                          child: Text('Editar',
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  color: blueColor,
                                  decoration: TextDecoration.underline)))
                      : Container()
                ],
              ),
              UIHelper.verticalSpaceMedium(),
              Text(
                'Email',
                style: appoSubtitleStyle,
              ),
              UIHelper.verticalSpaceTooSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: _editEmailText()),
                  !_isEditingEmailText
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _isEditingEmailText = true;
                            });
                          },
                          child: Text('Editar',
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  color: blueColor,
                                  decoration: TextDecoration.underline)))
                      : Container()
                ],
              ),
              UIHelper.verticalSpaceMedium(),
              Text(
                'Telefone',
                style: appoSubtitleStyle,
              ),
              UIHelper.verticalSpaceTooSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _editTextPhoneField(),
                  !_isEditingPhoneText
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _isEditingPhoneText = true;
                            });
                          },
                          child: Text('Editar',
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  color: blueColor,
                                  decoration: TextDecoration.underline)))
                      : Container()
                ],
              ),
              UIHelper.verticalSpaceMedium(),
              Text(
                'Localizacao',
                style: appoSubtitleStyle,
              ),
              UIHelper.verticalSpaceTooSmall(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _editLocationTextField(),
                  !_isEditingLocation
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _isEditingLocation = true;
                            });
                          },
                          child: Text('Editar',
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                  color: blueColor,
                                  decoration: TextDecoration.underline)))
                      : Container()
                ],
              ),
              UIHelper.verticalSpaceMedium(),
              Center(
                child: FlatButton(
                  onPressed: () => _validateSubmit(),
                  child: Container(
                    width: 300.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        shape: BoxShape.rectangle,
                        color: blueColor),
                    child: Center(
                      child: Text(
                        'Cadastrar',
                        style: patternWhiteStyle,
                      ),
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpaceSmall(),
              Center(
                child: FlatButton(
                  onPressed: () => {
                    setState(() {
          
          _isEditingUserNameText=false;
          _isEditingEmailText=false;
          _isEditingLocation=false;
          _isEditingPhoneText=false;

        })
                  },
                  child: Container(
                    width: 300.0,
                    height: 45.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        shape: BoxShape.rectangle,
                        border: Border.all(color: blueColor),
                        color: whiteColor),
                    child: Center(
                      child: Text(
                        'Anular',
                        style: patternBlueStyle,
                      ),
                    ),
                  ),
                ),
              ),
              UIHelper.verticalSpaceMedium(),
            ]
            ),
          
          
    )
            )
            );
  }

  Widget _editEmailText() {
    if (_isEditingEmailText) {
      return  Flexible(
              child: TextFormField(
            decoration: new InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.grey)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
            ),
            validator: validateEmail,
            onSaved: (newvalue) {
              _emailInitialText = newvalue;

              _isEditingEmailText = false;
            },
            autofocus: true,
            controller: _emailController,
          ),
      );
      
    }
    return Text(
      '$_emailInitialText',
      style: patternTextBoldStyle,
    );
  }

  Widget _editNameTextField() {
    if (_isEditingUserNameText) {
      return Flexible(
              child: TextFormField(
            validator: validateName,
            decoration: new InputDecoration(
              hintText: 'Nome do Usuário',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.grey)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
            ),
            onSaved: (newvalue) {
              _nameInitialText = newvalue;
              print('newvalue $newvalue');
              _isEditingUserNameText = false;
            },
            autofocus: true,
            controller: _nameController,
          ),
      );
    }
    return Text(
      '$_nameInitialText',
      style: patternTextBoldStyle,
    );
  }

  Widget _editLocationTextField() {
    if (_isEditingLocation) {
      return  Flexible(
              child: DropProvincias(),
      );
    }
    return Text(
      '$_locationInitialText',
      style: patternTextBoldStyle,
    );
  }


  Widget _editTextPhoneField() {
    if (_isEditingPhoneText) {
      return Flexible(
              child: TextFormField(
                  validator: (value)=>value.isEmpty && value.length<9?"Número do Telefone tem que ter 9 dígitos ":null,
            decoration: new InputDecoration(
              hintText: 'Telefone',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.grey)),
              contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
            ),
            onSaved: (newvalue) {
              _nameInitialText = newvalue;
              _isEditingPhoneText = false;
            },
            autofocus: true,
            controller: _phoneController,
          
        ),
      );
    }
    return Text(
      '$_phoneInitialText',
      style: patternTextBoldStyle,
    );
  }

  String validateName(String value) {
    print('valor de value $value');
    if (value.length > 4) {
      List<String> split = value.split(' ');
      print('cumpre $value');
      for (int i = 0; i < split.length; i++) {
        if (split[i] == '') return 'Escreva o nome e o sobrenome';
      }
      return split.length > 1 ? null : 'Escreva o nome e o sobrenome';
    }
    //return 'Nome ter que ter mais de 4 caracteres';
    else
      return 'Escreva o nome e o sobrenome';
  }

  String validateMobile(String value) {
    // Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Numero de telefone tem que ter 9 dígitos';
    else
      return null;
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

  void _validateSubmit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {

        setState(() {
          
          _isEditingUserNameText=false;
          _isEditingEmailText=false;
          _isEditingLocation=false;
          _isEditingPhoneText=false;

        });
        print('Funcionando bem');
      } catch (e) {
        print('something wrpng $e');
      }
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
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
         // BuscarMunicipioDaProvincia(this.ProvinciaAtual);
        });
      },
    );
  }
}
