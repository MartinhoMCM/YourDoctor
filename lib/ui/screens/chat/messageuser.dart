import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/models/consulta.dart';
import 'package:jitsi_meet_example/models/message.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/service/messsage_service.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:jitsi_meet_example/viewmodel/logincontroller.dart';
import 'package:jitsi_meet_example/viewmodel/videocontroller.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class MessageUser extends StatefulWidget {
  Patient paciente;
  String iddoctor;
  String doctorName;
  final ValueChanged<int> onPush;
  final Consulta consulta;

  MessageUser({this.paciente, this.iddoctor, this.doctorName, this.onPush, this.consulta});
  @override
  State<StatefulWidget> createState() {
    return MessageState();
  }
}

class MessageState extends State<MessageUser> with TickerProviderStateMixin {


  List<Notify> datas = new List();

  //
  // form principais

  ServiceMessage _ServiceMessage = new ServiceMessage();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  TextEditingController sms = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ///Animated Controller

  AnimationController _resizableController;
  VideoController _videoController;

  ScrollController _controller;
  var itemSize = 500.0;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        itemSize = _controller.offset;
        print("reach the bottom");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the top");
      });
    }
  }

  _moveDown() {
    _controller.animateTo(_controller.offset + itemSize,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  // fim dos formularios
  @override
  void initState() {
    _ServiceMessage.getAllMesaages('2', '1');
    _ServiceMessage.getDoctorNotifcation();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 1000,
      ),
    );

    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
  
    super.initState();
  }




  Stream<List<Notify>> getResponse(VideoController controller) {
    this._ServiceMessage.saidaNotify.listen((event) {
      if (event == null) {
        controller.setState(ViewState.Idle);
      } else if (event.length <= 0) {
        print('quantidades menores ou igual a ${event.length}');
        controller.setState(ViewState.Idle);
      } else {
        print('quantidades ${event.length}');
        controller.setState(ViewState.Busy);
      }
    });

    return this._ServiceMessage.saidaNotify;
  }

  @override
  void dispose() {
    this._ServiceMessage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ControllerLoginUser usuariologado = Provider.of<ControllerLoginUser>(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: this.Header(),
        body: ChangeNotifierProvider<VideoController>(
            create: (_) => VideoController(),
            child: Consumer<VideoController>(
                builder: (context, videoController, widgetController) {
              _videoController = videoController;
              return videoController.viewState == ViewState.Idle
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: .0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 600,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                                top: 0,
                                left: 0.0,
                                height: 15.0,
                                child: StreamBuilder<List<Notify>>(
                                  stream: getResponse(videoController),
                                  builder: (_, snapshot) {
                                    if (snapshot.hasData) {
                                      datas = snapshot.data;
                                      if (datas.length > 0)
                                        print('data ${datas[0].doctorId}');
                                      //  videoController
                                      //   .setVisible(ViewState.Busy);

                                      return Container(
                                        height: 0.0,
                                        width: 0.0,
                                      );
                                    } else {
                                      return Center(
                                        child: Container(
                                          height: 50.0,
                                          
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: blueColor
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('Carregando ...', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500,  color: whiteColor),),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                )),
                            Positioned(
                              top: 8,
                              left: 0,
                              height: 500.0,
                              child: SingleChildScrollView(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 500,
                                  padding: EdgeInsets.only(
                                      top: 0.0,
                                      left: 8,
                                      right: 16.0,
                                      bottom: 8.0),
                                  child:
                                      StreamBuilder<List<MessageUserFirebase>>(
                                    stream: this._ServiceMessage.saidaMessagem,
                                    builder: (_, dadosChat) {
                                      if (dadosChat.hasError) {
                                        return Text("Server Error");
                                      } else {
                                        if (dadosChat.hasData) {
                                          return ListView.builder(
                                              controller: _controller,
                                              itemCount: dadosChat.data.length,
                                              itemBuilder: (_, index) {
                                                return dadosChat.data[index]
                                                            .email ==
                                                        'martinho@gmail.com'
                                                    ? MeuSMS(
                                                        dadosChat.data[index])
                                                    : TeuSMS(
                                                        dadosChat.data[index]);
                                              });
                                        } else {
                                          return SizedBox.shrink();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0.0,
                              right: 0.0,
                              bottom: 0.0,
                              //top: MediaQuery.of(context).size.height-118,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 8.0),
                                child: Form(
                                  key: _formState,
                                  child: TextFormField(
                                    controller: sms,
                                    validator: (value) =>
                                        value.isEmpty ? "" : null,
                                    decoration: InputDecoration(
                                        hintText: "Chat on",
                                        fillColor: Colors.grey[300],
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: blueColor
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 20.0, 20.0, 5.0),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                        suffixIcon: IconButton(
                                            icon: Icon(Icons.send),
                                            onPressed: () {
                                              if (_formState.currentState
                                                  .validate()) {
                                                _formState.currentState.save();
                                                MessageUserFirebase _send =
                                                    new MessageUserFirebase(
                                                        iddoctor: '2',
                                                        idpaciente: '1',
                                                        email:
                                                            'martinho@gmail.com',
                                                        message: sms.text,
                                                        senddateTime: FieldValue
                                                            .serverTimestamp());
                                                _ServiceMessage.EnviarMessage(
                                                    _send);
                                                sms.clear();

                                                _moveDown();
                                              }
                                            })),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: blueColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          UIHelper.verticalSpaceLarge(),
                          UIHelper.verticalSpaceLarge(),
                          Text('Chamando ...',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          UIHelper.verticalSpaceMedium(),
                          AnimatedBuilder(
                            animation: _resizableController,
                            builder: (context, child) => Container(
                              height: 150.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.grey[400],
                                      width: _resizableController.value * 5),
                                  image: DecorationImage(
                                      image: AssetImage('assets/doctor.png'),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          UIHelper.verticalSpaceMedium(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                //color: whiteColor,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: whiteColor),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      videoController.setState(ViewState.Idle);
                                    }),
                              ),
                              UIHelper.horizontalSpaceMedium(),
                              Container(
                                width: 40.0,
                                height: 40.0,
                                //color: whiteColor,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: whiteColor),
                                child: IconButton(
                                    icon: Icon(
                                      Icons.call,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                     // widget.onPush(2);
                                    }),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
            })));
  }

  Widget MeuSMS(MessageUserFirebase sms) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(0.0),
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(0.0)
                )),
            child: Text(
              sms.message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget TeuSMS(MessageUserFirebase sms) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(0.0),
                  topRight: Radius.circular(10.0),

                )),
            child: Text(
              sms.message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget Header() => AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
      );
}
