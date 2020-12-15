import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitsi_meet/feature_flag/feature_flag_enum.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:jitsi_meet_example/models/consulta.dart';
import 'package:jitsi_meet_example/models/message.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/service/messsage_service.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
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

class MessageState extends State<MessageUser> with TickerProviderStateMixin{
  final serverText = TextEditingController();
  final roomText = TextEditingController(text: "plugintestroom");
  final subjectText = TextEditingController(text: "My Plugin Test Meeting");
  final nameText = TextEditingController(text: "Plugin Test User");
  final emailText = TextEditingController(text: "fake@email.com");
  var isAudioOnly = false;
  var isAudioMuted = false;
  var isVideoMuted = false;
    bool _videoTerminated=false;

  

  //Firestore

  
  
  // form principais

  ServiceMessage _serviceMessage = new ServiceMessage();
  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  TextEditingController sms = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   String email="";
   final _myDuration = Duration(seconds: 1);
   AnimationController _resizableController;

  ScrollController _controller=new ScrollController();
  var itemSize = 500.0;

  var _myValue=0.0;

  String url="";

  String nome="";

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
         itemSize=_controller.offset;
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

@override
void dispose()
{
  _resizableController.dispose();
    JitsiMeet.removeAllListeners();
  super.dispose();
}


  // fim dos formularios
  @override
  void initState() {
       _serviceMessage.getAllMesaages(widget.consulta.pkMedico, widget.consulta.me);
//    _serviceMessage.getDoctorNotifcation(iddoctor: widget.consulta.pkMedico, idpatient: widget.consulta.me );
    
   _controller = ScrollController();
    _controller.addListener(_scrollListener);

    //Video
     JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));


    //Animation

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
    // ordenando as messagens
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
         email =Provider.of<Patient>(context).email;
         nome =Provider.of<Patient>(context).nomecompleto;

         print('pk medico ${widget.consulta.pkMedico}');
         print('me ${widget.consulta.me}');

    return Scaffold(
      key: _scaffoldKey,
              appBar: this.Header(),
          body: StreamBuilder<QuerySnapshot>
      (
        stream: Firestore.instance.collection("VideoCall").where("iddoctor", isEqualTo: widget.consulta.pkMedico).where("idpaciente", isEqualTo: widget.consulta.me).where("statusnome", isEqualTo: "solicitado").snapshots(),
        builder: (context, snapshot) {
            if(((snapshot.hasData && snapshot.data.documents.length==0) || !snapshot.hasData) && !_videoTerminated)
            {
               return Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: .0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 600,
                    child: Stack(
                      children: <Widget>[
                    Positioned(
                          top: 0,
                          left: 0,
                          height: 500.0,
                          child: SingleChildScrollView(
                          
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 500,
                              padding: EdgeInsets.only(
                                top: 20,
                                left: 8,
                                right: 16.0,
                              ),
                              child: StreamBuilder<List<MessageUserFirebase>>(
                                stream: this._serviceMessage.saidaMessagem,
                                builder: (_, dadosChat) {
                                  if (dadosChat.hasError) {
                                    return Text("Server Error");
                                  } else {
                                    if (dadosChat.hasData) {
                                      return ListView.builder(
                                        controller: _controller,
                                          itemCount: dadosChat.data.length,
                                          itemBuilder: (_, index) {
                                            return dadosChat.data[index].email ==
                                                    '$email'
                                                ? MeuSMS(dadosChat.data[index])
                                                : TeuSMS(dadosChat.data[index]);
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
                            margin:
                                EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
                            child: Form(
                              key: _formState,
                              child: TextFormField(
                                controller: sms,
                                decoration: InputDecoration(
                                    hintText: "Chat on",
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                        borderSide: BorderSide(color: Colors.grey)),
                                    suffixIcon: IconButton(
                                        icon: Icon(Icons.send),
                                        onPressed: () {
                                          MessageUserFirebase _send =
                                              new MessageUserFirebase(
                                                  iddoctor: widget.consulta.pkMedico,
                                                  idpaciente: widget.consulta.me,
                                                  email: email,
                                                  message: sms.text,
                                                  senddateTime:
                                                      FieldValue.serverTimestamp());
                                          _serviceMessage.EnviarMessage(_send);
                                          sms.clear();
                                         
                                          _moveDown();
                                        }
                                        )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                
              ); 
             
            }
            else  
             {

              Notify notify=Notify.fromJson(snapshot.data.documents[0].data);
            return  Container(
                color: blueColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   AnimatedBuilder(
                     animation: _resizableController,
                     builder: (context, child)=>
                                      
                                       Center(
                                         child: Container(
                       height: 150.0,
                       width: 150.0,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         border: Border.all(color: Colors.blue, width: _resizableController.value*10),
                         image:DecorationImage(
                           image: AssetImage('assets/doctor.png'),
                           fit: BoxFit.cover
                           )
                       ),
                     ),
                                       ),
                   ),
                   UIHelper.verticalSpaceMedium(),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       IconButton(
                         icon: Icon(Icons.call_end, color: Colors.red, size: 30.0,), 
                         onPressed: (){

                           setState(() {
       _videoTerminated=true;
       print('video terminado');
     });
                         }),

                         UIHelper.horizontalSpaceMedium(),
                            IconButton(
                         icon: Icon(Icons.call, color: Colors.white, size: 30.0,), 
                         onPressed: (){
                           _joinMeeting(roomName: notify.url);
                         }),

                     ],
                   )

                  ],
                ),
              );
        }



        }),
    );
  }

  Widget MeuSMS(MessageUserFirebase sms) {
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
                color: blueColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(5),
                  topRight: Radius.circular(5),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(5),
                  topRight: Radius.circular(5),
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
        centerTitle: true,
        title: Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
      );



  _joinMeeting({String roomName}) async {
  
    try {
      // Enable or disable any feature flag here
      // If feature flag are not provided, default values will be used
      // Full list of feature flags (and defaults) available in the README
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      };

      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }

      // Define meetings options here
      var options = JitsiMeetingOptions()
        ..room = roomName
        ..serverURL = "https://meet.jit.si"
        ..subject = ""
        ..userDisplayName = nome
        ..userEmail = emailText.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted
        ..featureFlags.addAll(featureFlags);

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    //debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    //debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
   // debugPrint("_onConferenceTerminated broadcasted with message: $message");
    print("_onConferenceTerminated broadcasted with message: $message");
     setState(() {
       _videoTerminated=true;
     });
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

   _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }


}