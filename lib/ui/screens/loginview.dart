import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/locator.dart';
import 'package:jitsi_meet_example/service/authentication_service.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/viewmodel/logincontroller.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';

class LoginView extends StatefulWidget {
  // LoginView(this.key,);

  @override
  State<StatefulWidget> createState() {
    return _LoginViewState();
  }
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  final _formKey = new GlobalKey<FormState>();

  String email;
  String password;
  String _errorMessage;
  bool _isLoading;
  bool _isLogged;
  bool _visiblePassword = false;
  bool _autoValidate = false;
  bool _IsContextVisible = true;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(seconds: 0), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    animationController.forward();

    _isLoading = false;
    _isLogged = false;
    super.initState();
  }
  @override
  void dispose() {
    
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, widget) => ChangeNotifierProvider<LoginController>(
          create: (context) => locator<LoginController>(),
          child: Consumer<LoginController>(
            builder: (context, model, child) => Scaffold(
              body: Transform(
                transform:
                    Matrix4.translationValues(animation.value * width, 0, 0),
                child: Container(
                  color: whiteColor,
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  child: Stack(
                    children: <Widget>[
                      model.state==ViewState.Idle? _showForm(model) : Container(),
                      _showCircularProgress(model)
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
  }

  Widget _showForm(LoginController model) {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              Visibility(
                child: _showLogo(),
                visible: model.state == ViewState.Idle,
              ),
              UIHelper.verticalSpaceSmall(),
              Visibility(
                child: _showText(),
                visible: model.state == ViewState.Idle,
              ),
              UIHelper.verticalSpaceSmall(),
              Visibility(
                child: _createAccount(context),
                visible: model.state == ViewState.Idle,
              ),
              UIHelper.verticalSpaceSmall(),
              Visibility(
                child: showEmailInput(),
                visible: model.state == ViewState.Idle,
              ),
              UIHelper.verticalSpaceSmall(),
              Visibility(
                child: showPasswordInput(),
                visible: model.state == ViewState.Idle,
              ),
              UIHelper.verticalSpaceSmall(),
              Visibility(
                  visible: model.state == ViewState.Idle,
                  child: showErrorMessage(model)),
              Visibility(
                  visible: model.state == ViewState.Idle,
                  child: _showForgotPassword()),
              UIHelper.verticalSpaceMedium(),
              Visibility(
                child: showPrimaryButton(model),
                visible: model.state == ViewState.Idle,
              ),
            ],
          ),
        ));
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Email',
          icon: new Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
        validator: (value) =>
            (value.isEmpty ? 'Email não pode ser vazio' : null),
        onSaved: (value) => email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: !_visiblePassword,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'Palavra Passe',
          suffixIcon: IconButton(
              icon: IconButton(
                  onPressed: () {
                    setState(() {
                      _visiblePassword = !_visiblePassword;
                      print('set visisblePassword');
                    });
                  },
                  icon: Icon(
                    _visiblePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  )),
              onPressed: null),
          icon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
  
        ),
        validator: (value) =>
            value.isEmpty ? 'Palavra Passe não pode ser vazia' : null,
        onSaved: (value) => password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton(LoginController model) {
    return new Padding(
        padding: EdgeInsets.all(0.0),
        child: Center(
          child: SizedBox(
            height: 40.0,
            width: 280.0,
            child: new RaisedButton(
                elevation: 5.0,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(50.0)),
                color: primaryColor,
                child: new Text('Entrar',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                onPressed: () => validateAndSubmit(model)),
          ),
        ));
  }

  // Perform login or signup
  void validateAndSubmit(LoginController model) async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      setState(() {
        _IsContextVisible = false;
      });

      print('logging...');
     _isLogged = await model.login(
          userEmail: email, userPassword: password, userIdText: "1");
     
     if(_isLogged){
       print('Is Logged');
        Navigator.pushNamed(context, '/');
     }{
         print('Not Logged');
     }
    }
    else
    {
setState(() {
          _autoValidate = true;
          _IsContextVisible = true;
        });
    }
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text('Cria uma conta',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget _showCircularProgress(LoginController model) {
    if (model.state == ViewState.Busy) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: primaryColor,
      ));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showLogo() {
    return Container(
      height: 170.0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 50.0,
          child: Image.asset(
            'assets/logo.jpeg',
          ),
        ),
      ),
    );
  }
}

Widget _showForgotPassword() {
  return Container(
    child: Align(
        alignment: Alignment.bottomRight,
        child: Text(
          'Esqueceu a Palavra Passe?',
          style: normalStyle,
        )),
  );
}

Widget _createAccount(BuildContext context) {
  return Container(
      child: Row(
    children: <Widget>[
      Text(
        'Não tem uma conta?',
        style: normalStyle,
      ),
      GestureDetector(
        child: Text(
          'Criar uma conta.',
          style: warningStyle,
        ),
        onTap: () => Navigator.pushNamed(context, 'registerPatient'),
      ),
    ],
  ));
}

Widget showErrorMessage(LoginController model) {
  return model.errorMessage == null
      ? Container(
          width: 0.0,
          height: 0.0,
        )
      : Container(
          child: Text(
            '${model.errorMessage}',
            style: warningStyle,
          ),
        );
}

Widget _showText() {
  return Container(
    child: Text(
      'Login',
      style: headerStyleWithColorPropriety,
    ),
  );
}
