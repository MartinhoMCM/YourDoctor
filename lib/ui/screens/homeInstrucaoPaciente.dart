import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/service/api.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeInstrucaoPaciente extends StatefulWidget {
  State<StatefulWidget> createState() => new HomeInstrucao();
}

class HomeInstrucao extends State<HomeInstrucaoPaciente>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  final PageController _pageController = new PageController(initialPage: 0);
  int PagePositionController = 0;
  Api _api;
  int _pkUsuario;
  bool disableButtom;


  void addToSF(){
    
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _api = new Api();
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    animation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    animationController.forward();
  }

  void OnPageChangeController(int value) {
    setState(() {
      this.PagePositionController = value;
    });
  }

  void ChangePageControllerPosition() async {
    setState(() {
      this.PagePositionController++;
    });
    if (this.PagePositionController > 2) {
      await nextNavigator(context);
    } else {
      _pageController.jumpToPage(PagePositionController);
    }
  }

  Widget build(BuildContext context) {
    _pkUsuario = Provider.of<Patient>(context).pkPaciente;
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, widget) => Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: Transform(
              transform:
                  Matrix4.translationValues(animation.value * width, 0, 0),
              child: PageView(
                controller: _pageController,
                onPageChanged: OnPageChangeController,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/especialistas.png"))),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Encontre a área clínica",
                                  style: patternStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Encontre na aplicação uma área clínica que atenda a sua necessidade",
                                  textAlign: TextAlign.center,
                                  style: patternTextStyle,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                          color: blueColor,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 6,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 6,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ButtonTheme(
                                  minWidth: 300,
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () =>
                                        ChangePageControllerPosition(),
                                    child: Text(
                                      "Próximo",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    color: blueColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ButtonTheme(
                                  minWidth: 300,
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: BorderSide(
                                          width: 1, color: blueColor)),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      await nextNavigator(context);
                                    },
                                    child: Text(
                                      "Pular",
                                      style: TextStyle(
                                        color: blueColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: AssetImage("assets/sintomas.png"))),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Triagem",
                                  style: patternStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Selecione o seus sintomas",
                                  textAlign: TextAlign.center,
                                  style: patternTextStyle,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 6,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 8,
                                      width: 8,
                                      decoration: BoxDecoration(
                                          color: blueColor,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 6,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ButtonTheme(
                                  minWidth: 300,
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () =>
                                        ChangePageControllerPosition(),
                                    child: Text(
                                      "Próximo",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    color: blueColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ButtonTheme(
                                  minWidth: 300,
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: BorderSide(
                                          width: 1, color: blueColor)),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      await nextNavigator(context);
                                    },
                                    child: Text(
                                      "Pular",
                                      style: TextStyle(
                                        color: blueColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Container(
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage(
                              "assets/image3.png",
                            ),
                          )),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Encontre seu médico",
                                  style: patternStyle,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Encontre o seu médico e se comunique no nosso chat.",
                                  textAlign: TextAlign.center,
                                  style: patternTextStyle,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 6,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 6,
                                      width: 6,
                                      decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: this.PagePositionController == 2
                                          ? 8
                                          : 4,
                                      width: this.PagePositionController == 2
                                          ? 8
                                          : 4,
                                      decoration: BoxDecoration(
                                          color:
                                              this.PagePositionController == 2
                                                  ? blueColor
                                                  : Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ButtonTheme(
                                  minWidth: 300,
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () =>
                                        ChangePageControllerPosition(),
                                    child: Text(
                                      "Próximo",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    color: blueColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ButtonTheme(
                                  minWidth: 300,
                                  height: 50,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      side: BorderSide(
                                          width: 1, color: blueColor)),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      await nextNavigator(context);
                                    },
                                    child: Text(
                                      "Pular",
                                      style: TextStyle(
                                        color: blueColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future nextNavigator(BuildContext context) async {
    //print('PKUSUARIO $_pkUsuario');
   // String _first = await _api.sendFirstLog(pkUsuario: _pkUsuario);
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}
