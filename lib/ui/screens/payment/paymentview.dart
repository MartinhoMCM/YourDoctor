import 'dart:io';
import 'package:jitsi_meet_example/enums/enums.dart';
import 'package:jitsi_meet_example/models/candidatedoctor.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:jitsi_meet_example/ui/screens/payment/capturedfile.dart';
import 'package:jitsi_meet_example/ui/screens/payment/simpledialog.dart';
import 'package:jitsi_meet_example/viewmodel/paymentcontroller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

class PaymentView extends StatefulWidget {
  final CandidateDoctor candidateDoctor;
  final double price;
  final ValueChanged<int> onPush;
  final ValueChanged<CandidateDoctor> onGetDoctor;

  PaymentView(
      {this.candidateDoctor, this.price, this.onPush, this.onGetDoctor});
  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView>
    with TickerProviderStateMixin {
  double begin = -1, end = 0.0;
  //a variable to control when Bottom Camera is ative to take a picture
  bool capturedImage;
  File _image;
  final picker = ImagePicker();
  bool _showDialog = false;
  String nomecompleto;
  CandidateDoctor _doctor;

  bool exitSimpleDialog = false;

  @override
  void initState() {
    _doctor = widget.candidateDoctor;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.candidateDoctor != null)
      print('candidate ${widget.candidateDoctor}');
    else {
      print('no candidate pego');
    }
    nomecompleto = Provider.of<Patient>(context).nomecompleto;
    var pacienteId = Provider.of<Patient>(context).pkPaciente;

    return ChangeNotifierProvider<PaymentController>(
      create: (_) => PaymentController(),
      child: Consumer<PaymentController>(
        builder: (context, value, widgets) => value.state == ViewState.Idle
            ? Scaffold(
                backgroundColor: whiteColor,
                appBar: AppBar(
                  title: Text(''),
                  leading: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back,
                        color: blueColor,
                      )),
                  backgroundColor: whiteColor,
                  elevation: 0.0,
                ),
                body: value.payment == PaymentResult.NOTSENT
                    ? Container(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 300,
                                height: 200,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('assets/cartao.png')),
                                  ),
                                ),
                              ),
                              UIHelper.verticalSpaceLarge(),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        'To continue you have to withdrawal',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.black),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceSmall(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        '1.Make a depoist or withdrawal',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceSmall(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        '2.Account Number 999999999',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceSmall(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        '3.Envie o comprovativo, por meio das opcoes',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceSmall(),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 30.0),
                                      child: Text(
                                        'a. Tirar uma fotografia- clica em Camera',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceMedium(),
                                    UIHelper.verticalSpaceMedium(),
                                    SizedBox(
                                      height: 50.0,
                                      child: FlatButton(
                                        onPressed: () {
                                          setState(() {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SimpleDialog(
                                                    title: Text(
                                                      'Comprovativo do Pagamento',
                                                      style: chatTitleStyle,
                                                    ),
                                                    children: [
                                                      SimpleDialogItem(
                                                        icon:
                                                            Icons.photo_camera,
                                                        color: Colors.orange,
                                                        text: 'Camera',
                                                        onPressed: () {
                                                          getImageFromCamera()
                                                              .whenComplete(
                                                                  () => {
                                                                        print(
                                                                            'camera selected'),
                                                                        showDialogGallery(
                                                                            context,
                                                                            'Camera',
                                                                            controller:
                                                                                value),
                                                                        _showDialog =
                                                                            true
                                                                      });
                                                        },
                                                      ),
                                                      SimpleDialogItem(
                                                        icon: Icons.image,
                                                        color: Colors.green,
                                                        text:
                                                            'Imagem na Galeria',
                                                        onPressed: () {
                                                          getImageFromGallery()
                                                              .whenComplete(
                                                                  () => {
                                                                        showDialogGallery(
                                                                            context,
                                                                            'Imagem na Galeria',
                                                                            controller:
                                                                                value)
                                                                      });
                                                        },
                                                      ),
                                                      SimpleDialogItem(
                                                        icon: Icons.file_upload,
                                                        color: ColdColor,
                                                        text: 'Ficheiro no pdf',
                                                        onPressed: () {
                                                          getPdfFile()
                                                              .whenComplete(
                                                            () => {
                                                              showDialogGallery(
                                                                  context,
                                                                  'Imagem na Galeria',
                                                                  controller:
                                                                      value),
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          });
                                        },
                                        child: Container(
                                          height: 50.0,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                            elevation: 2.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                  shape: BoxShape.rectangle,
                                                  color: blueColor),
                                              child: Center(
                                                child: Text(
                                                  'Confirmar o pagamento',
                                                  style: chatTitleWhiteStyle,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceTooSmall(),
                                    SizedBox(
                                      height: 50.0,
                                      child: FlatButton(
                                        onPressed: () {
                                          widget.onPush(19);
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          elevation: 2.0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                shape: BoxShape.rectangle,
                                                color: whiteColor,
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: blueColor)),
                                            child: Center(
                                              child: Text(
                                                'Cancelar',
                                                style: chatTitleStyle,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceMedium()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : ChangeNotifierProvider<PaymentController>(
                        create: (_) => PaymentController(),
                        child: Consumer<PaymentController>(
                          builder: (context, value, widg) => Container(
                            color: whiteColor,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 8.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 64.0),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 150.0,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Text(
                                        'O teu pagamento foi aceite.',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                    UIHelper.verticalSpaceLarge(),
                                    UIHelper.verticalSpaceLarge(),
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                      elevation: 2.0,
                                      child: InkWell(
                                        onTap: () async {
                                          widget.onGetDoctor(
                                              widget.candidateDoctor);
                                          bool result =
                                              await value.finalizarConsulta(
                                                  pkMedico: widget
                                                      .candidateDoctor.fkMedico,
                                                  pkUsuario: pacienteId,
                                                  fkEspecialidade: widget
                                                      .candidateDoctor
                                                      .fkSpecialidade);

                                          if (result == null) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => Container(
                                                height: 50.0,
                                                child: AlertDialog(
                                                  title: Text(
                                                    'Problema de conexao',
                                                    style: normalStyle,
                                                  ),
                                                  actions: [
                                                    FlatButton(
                                                        onPressed: () {
                                                          widget.onPush(19);
                                                        },
                                                        child: Text(
                                                          'CANCELAR',
                                                          style: normalStyle,
                                                        )),
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'TENTAR OUTRA VEZ',
                                                          style:
                                                              normalStyleBlue,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else if (result) {
                                            showDialog(
                                                context: context,
                                                builder: (context) => Container(
                                                      height: 120.0,
                                                      width: 200.0,
                                                      child: AlertDialog(
                                                        title: Text(
                                                          'Contactando o doctor.',
                                                          style: normalStyle,
                                                        ),
                                                        content:
                                                            contentWidget(),
                                                        actions: [
                                                          FlatButton(
                                                              onPressed: () {
                                                                widget

                                                                    .onPush(19);
                                                                    Navigator.of(context).pop();
                                                              },
                                                              child: Text(
                                                                'AVANÇAR',
                                                                style:
                                                                    normalStyleBlue,
                                                              ))
                                                        ],
                                                      ),
                                                    ));
                                          }
                                          // widget.onPush(19);
                                          //print('print print');
                                        },
                                        child: Container(
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              shape: BoxShape.rectangle,
                                              color: Colors.green),
                                          child: Center(
                                            child: Text(
                                              'Terminar o processo de pagamento',
                                              style: chatTitleWhiteStyle,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ),
              )
            : Container(
                color: whiteColor,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }

  void showDialogGallery(BuildContext context, String text,
      {PaymentController controller, CandidateDoctor doctor}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            children: <Widget>[
              capturedFileView(
                price: widget.price,
                doctor: _doctor,
                controller: controller,
                icon: Icons.image,
                text: '$text',
                file: _image,
                onPressed: () {},
                onExit: () {
                  setState(() {
                    exitSimpleDialog = true;
                  });
                },
              )
            ],
          );
        });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future getPdfFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _image = File(result.files.single.path);
      });
    }
  }

  Widget contentWidget() {
    return Container(
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'O doctor irá ao teu encontro',
            style: normalStyle,
          ),
          UIHelper.verticalSpaceTooSmall(),
           Text(
            'Se pretendes conversar,pesquise as tuas consultas.',
            style: normalStyle,
          ),
          UIHelper.verticalSpaceTooSmall(),
          Flexible(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Clique neste ícone',
                style: normalStyle,
              ),
              UIHelper.horizontalSpaceTooSmall(),
              Icon(Icons.calendar_today),
            ],
          ))
        ],
      ),
    );
  }
}
