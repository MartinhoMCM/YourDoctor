
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as  http;
import 'package:flutter/material.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'dart:io';

import 'api.dart';


class ServicePaciente{

      Firestore firestore =Firestore.instance;
      static String status;
      // routing da apis
       String _URL = "${Api.server}/api/registrarUsuario";
      // fim da routing da apis;
      var client = new http.Client();

       Future GetUploadFile(File _image) async {
         final postUri = Uri.parse(_URL);
         http.MultipartRequest request = http.MultipartRequest('POST', postUri);
         http.MultipartFile multipartFile =
         await http.MultipartFile.fromPath('file',_image.path); //returns a Future<MultipartFile>
         request.files.add(multipartFile);
         http.StreamedResponse response = await request.send().then((value) {
          
           return value;
         });
       }
       Future<bool> RegistrarPaciente(Patient paciente ,BuildContext context) async{
        // cadastrando o paciente

         try{//  catc
         print('telefone ${paciente.telephone}');
     String _retorno;

           var response =await client.post(_URL, 
           body:{
             'nome':'${paciente.nomecompleto}',
             'email':'${paciente.email}',
             'altura':'${paciente.altura}',
             'sexo':'${paciente.genero}',
             'data_nascimento':'${paciente.data_nascimento}',
             'grupo_sanguineo':'${paciente.grupo_sanguineo}',
             'peso':'${paciente.peso}',
             'senha':'${paciente.senha}',
             'tipo_Usuario':'1',
             'telefone':'${paciente.telephone}',
             'provincia':'${paciente.province}',
             'municipio':'${paciente.county} '
      
             }
             );

           if(response.statusCode >=200 && response.statusCode<=400){
                _retorno =response.body;
              
                return _retorno=="true";
           }else{
             return false;
           }
           // files
         }catch(e){
          status="error $e";
         }
         // fim do cadastro do usuario
     }


  Future<void> addUser({String fileUrl, String email, String name}) async
  {

   Map map ={
     "fileUrl":fileUrl,
     "email":email,
     "name":name,
   }; 
   try{
     await firestore.collection('Users').document().setData(map);
   }
   catch(e){
     print('foto nao enviada');
   }
  

  }

}

