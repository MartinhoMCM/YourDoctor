
import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Symptom
{

  int fk_sintomas;
  String sintoma;
  int pkSintomaEspecialidade;
  String data_criacao;
  int fk_especialidade;

  Symptom({this.fk_sintomas, this.sintoma, this.data_criacao, this.pkSintomaEspecialidade, this.fk_especialidade});

  Symptom.fromJson(Map<String, dynamic> json){
    fk_sintomas =json['fk_sintoma'];
    sintoma =json['sintoma'];
    pkSintomaEspecialidade =json['pkSintomaEspecialidade'];
    data_criacao =json['data_criacao'];
    fk_especialidade =json['fk_especialidade'];
  }


  Map<String, dynamic> toJsonPkSymptom({Symptom symptom})
  {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['fk_sintoma']=symptom.fk_sintomas;
    return data;
  }
  Map<String, dynamic> toJsonPkDescription({Symptom symptom})
  {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    data['sintoma'] =symptom.sintoma;
    return data;
  }

  Map toSpecificJson({List<Symptom> symptoms, int pkUser})
  {
    final Map<String, dynamic> data =new Map<String, dynamic>();
    final List<Map> sym =symptoms!=null?symptoms.map((i) => i.toJsonPkSymptom(symptom: i)).toList():null;
    String str1 =jsonEncode(sym);
    debugPrint('str1 $sym');
    final List<Map> desc =symptoms!=null?symptoms.map((i) => i.toJsonPkDescription(symptom: i)).toList():null;
    String str2 =jsonEncode(desc);
    debugPrint('str2 $desc');

    data['fk_sintoma']=sym;
    data['sintoma'] =desc;
    data['pk_usuario'] =pkUser;

    String str =jsonEncode(data);
    debugPrint('str3 $str');

    return data;
  }
}