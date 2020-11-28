import 'dart:io';

import 'package:jitsi_meet_example/models/candidatedoctor.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';

import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:jitsi_meet_example/viewmodel/paymentcontroller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class capturedFileView extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData icon;
  final PaymentController controller;
  final double price;
  File file;
  final CandidateDoctor doctor;
    final VoidCallback onExit;

  capturedFileView({Key key, this.text, this.onPressed, this.icon, this.file, this.controller, this.doctor, this.price, this.onExit})
      : super(key: key);

  @override
  _capturedFileViewState createState() => _capturedFileViewState();
}

class _capturedFileViewState extends State<capturedFileView> {

  File path;
  String userName;
  bool tapped=false;

  @override
  void initState() {
     path=widget.file;
     
      
      

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     
     var pkPatient = Provider.of<Patient>(context).pkPaciente;
      

   
    return !tapped? Container(
      //height: 235.0,
      child: SimpleDialogOption(
        onPressed: widget.onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(
              padding: const EdgeInsetsDirectional.only(start: 0.0),
              child: Text(widget.text, style:  TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500,  color: blueColor),),
            ),
             UIHelper.verticalSpaceMedium(),
      widget.file!=null? Padding(
             padding: EdgeInsets.all(0.0),
               child: Text('${widget.file.path}', textAlign: TextAlign.justify,),              
            ):Container(),
            UIHelper.verticalSpaceSmall(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                onPressed: ()
                {
                  widget.onExit();
                  Navigator.pop(context);
                },
                child: Text('Voltar', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500,  color: blueColor),)),
              //UIHelper.horizontalSpaceSmall(),
              FlatButton(
                onPressed: () async{
                  setState(() {
                    tapped=true;
                  });
                    print('candidate ${widget.doctor.especialidade}');
                bool result= await widget.controller.postFiles(document: widget.file, pkPatient: pkPatient,pkSpecialidade:widget.doctor.fkSpecialidade, preco: widget.price ).
                whenComplete(() {
                 widget.onExit();
                Navigator.pop(context);
                });
                  print('post');
                },
                child: Text('Enviar', style:  TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500,  color: blueColor),))
            ]
            ,)
          ],
        ),
      ),
    ):Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
