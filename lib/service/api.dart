import 'dart:async';
import 'package:async/async.dart';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jitsi_meet_example/models/Doctor.dart';
import 'package:jitsi_meet_example/models/candidatedoctor.dart';
import 'package:jitsi_meet_example/models/consulta.dart';
import 'package:jitsi_meet_example/models/consultas.dart';
import 'package:jitsi_meet_example/models/mixmodel.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/models/province.dart';
import 'package:jitsi_meet_example/models/symptom.dart';
import 'package:jitsi_meet_example/models/user.dart';
import 'package:path/path.dart';

class Api {
  static const server = 'http://192.168.137.241:3000';
  //Endpoint
  static const endpoint = '$server/api/login';
  static const endpoint1 = '$server/api/sintomasFind';
  static const endpoint2 = '$server/api/obter-sintomas';
  static const provinceEndpoint = '$server/api/obter-provincias';
  static const countiesEndpoint = '$server/api/obter-municipiosAll';
  static const checkEmailEndpoint = '$server/api/EmailExistente';
  static const checkCodeValidationEndpoint = '$server/api/EnvioCodigoValidacao';
  static const firstLog = '$server/api/UpdatePrimeiroLogin';
  static const findDoctor = '$server/api/notificacao-consulta-response-aceite';
  static const findPrice = '$server/api/obter-preco-especialidade';
  static const obterReceibo = '$server/api/obter-recibo';
  static const FinalizarConsulta = '$server/api/FinalizarConsulta';
  static const consultarConsulta='$server/api/consultarConsulta';

  static const ListOfEndpoints = [
    '$server/api/sintomas-clinicaGeral',
    '$server/api/sintomas-clinicaGeral',
    '$server/api/obter-sintomas',
    '$server/api/sintomas-Cardiologia',
    '$server/api/sintomas-Cardiologia',
  ];

  var client = new http.Client();
  static String error = "null";
  final StreamController<List<CandidateDoctor>> myStreamCtrl =
      StreamController<List<CandidateDoctor>>.broadcast();
  Stream<List<CandidateDoctor>> get onVariableChanged => myStreamCtrl.stream;

  final StreamController<List<Consulta>> myStreamConsulta =
      StreamController<List<Consulta>>.broadcast();
  Stream<List<Consulta>> get onConsutlaChanged => myStreamConsulta.stream;

  Future<User> getUserProfile(
      {int userId, String email, String password}) async {
    User user;
    try {
     
      var response = await client.post('$endpoint',
          body: {'email': '$email', 'password': '$password'});

      if (response.statusCode >= 200 && response.statusCode <= 400) {
        // Convert and return

        user = User.fromJson(json.decode(response.body));
        print(' userid ${user.pkUsuario}');
      } else {
        error = "Email ou senha errada";
        return null;
      }
      return user;
    } catch (e) {
      //print('bug');
      error = "Falha de conexao com servidor $e";
    }
    return null;
  }

  Future<Patient> getPatient({int pkUsuario}) async {
    Patient patient;
    try {
      print('pkPaciente $pkUsuario');
      var response =
          await client.post('http://192.168.137.241:3000/api/obter-dados-paciente', body: {
        "pkUsuario": "$pkUsuario",
      });
    print('response ${response.body}');
      if (response.statusCode >= 200 && response.statusCode <= 400) {
        Map map = json.decode(response.body);
        patient = Patient.fromJson(map);

        print('patient ${patient.nomecompleto}');
      }
    } catch (e) {
      //client.close();
      error = "Falha de conexao com servidor $e";
    }
    return patient;
  }

  // ignore: missing_return
  Future<List<Symptom>> symptoms({String localEndPoint}) async {
    try {
      List<Symptom> list = List();

      //THE CODE
      var response = await client.get(localEndPoint);
      if (response.statusCode >= 200 && response.statusCode <= 400) {
        List<dynamic> symptons = json.decode(response.body);
        symptons.forEach((element) {
          list.add(Symptom(
              pkSintomaEspecialidade: element['pkSintomaEspecialidade'],
              sintoma: element['sintoma'],
              fk_sintomas: element['fk_sintoma'],
              fk_especialidade: element['fk_especialidade']));
        });

        return list;
      } else {
        error = response.body;
        return null;
      }
      return list;
    } on Exception {
      error = "Falha de conexao com servidor";
    }
  }

  Future<bool> sendSymptom(
      {List<Symptom> symptoms,
      int userId,
      int pkProvince,
      int pkCounty,
      double longitude,
      double latitude}) async {
    List<Doctor> doctors = List();
    List<SendSymptons> pkSymptoms = new List();
    List<Description> pkSymtomsSpeciality = new List();
    for (int i = 0; i < symptoms.length; i++) {
      pkSymptoms.add(new SendSymptons(pk_sintomas: symptoms[i].fk_sintomas));
      pkSymtomsSpeciality.add(new Description(
          pkSintomaEspecialidade: symptoms[i].pkSintomaEspecialidade));
    }

    List<Map> firstMap = pkSymptoms.map((e) => e.toJson()).toList();
    List<Map> secondMap = pkSymtomsSpeciality.map((e) => e.toJson()).toList();
    var pkSymptomsJson = jsonEncode(firstMap);
    var descriptionJson = jsonEncode(secondMap);
    var response = await client.post(endpoint2, body: {
      "fk_sintomas": pkSymptomsJson,
      "pkSintomaEspecialidade": descriptionJson,
      "fk_especialidade": '${symptoms[0].fk_especialidade}',
      "pk_Usuario": '$userId',
      "pkProvincia": '$pkProvince',
      "pkMunicipio": '$pkCounty',
      "latitude": '$latitude',
      "longitude": '$longitude'
    });
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      final data = response.body;
      print('response data after select symptons $data');
      return data == "true";
    } else {
      return false;
    }
  }

  Future<bool> GetUploadFile(File image) async {
    final postUri = Uri.parse("$server/api/registrarUsuario");
    http.MultipartRequest request = http.MultipartRequest('POST', postUri);
    http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'file', image.path); //returns a Future<MultipartFile>
    request.files.add(multipartFile);
    http.StreamedResponse response = await request.send().then((value) {
      return value;
    });
  }

  Future<List<Consultas>> historicoConsultas() async {
    List<Consultas> consultas = new List();

    var response = await client.get('');
    return consultas;
  }

  Future<double> getPrice(int fkEspecialidade) async {
    double valor = 0.0;
    try {
      print('fetching API');
      print('especialidade $fkEspecialidade');

      var response = await client
          .post(findPrice, body: {"pkEspecialidade": '$fkEspecialidade'});

      print('response body ${response.body}');
      Map map = json.decode(response.body);
      Object value = map['valor'];
      if (value is int) {
        valor = value.toDouble();
      } else {
        valor = map['valor'];
      }
    } catch (e) {
      print('catch error $e');
    }
    return valor;
  }

  Future<List<Municipio>> ListadeMunicipios() async {
    List<Municipio> _lista = [
      new Municipio(
          pk_municipio: 1, fk_provincia: 1, descricao: 'Belas', status_: 1)
    ];
    var response = await http.get(countiesEndpoint);
    // Lista de Provincias

    if (response.statusCode >= 200 && response.statusCode <= 400) {
      var listaJson = json.decode(response.body);
      print(response.body);
      for (var novoelemento in listaJson)
        _lista.add(new Municipio.jsonFormato(novoelemento));
      return _lista;
    }
    return _lista;
  }

  //get all provinces

  Future<String> checkEmail(String email) async {
    var response =
        await client.post(checkEmailEndpoint, body: {'email': '$email'});
    // debugPrint('Response body: ${response.body}');
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      // Convert and return
      return response.body;
    } else {
      error = response.body;
      //debugPrint('Response body: ${response.body}');
      return null;
    }
  }

  Future<String> receivedCode(String email) async {
    var client = new http.Client();
    var response = await client
        .post(checkCodeValidationEndpoint, body: {'email': '$email'});
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      // Convert and return
      //debugPrint('Response body: ${response.body}');
      String str = response.body;
      return str;
    } else {
      error = response.body;
      // debugPrint('Response body: ${response.body}');
      return "Alguma coisa deu errado";
    }
  }

  Future<String> sendFirstLog({int pkUsuario}) async {
    var response =
        await client.post('$firstLog', body: {'pkUsuario': '$pkUsuario'});
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      print('response ${response.body}');
      return response.body;
    }

    return null;
  }

  Future<List<Provincia>> ListadeProvincia() async {
    List<Provincia> _lista = [
      new Provincia(pkProvincia: 1, descricao: 'Luanda', status_: 1)
    ];
    var response = await http.get(provinceEndpoint);
    // Lista de Provincias
    // List<Provincia> _lista =  [] ;
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      var listaJson = json.decode(response.body);

      print(response.body);
      for (var novo in listaJson) {
        _lista.add(new Provincia.jsonFormato(novo));
      }
      return _lista;
    }

    return _lista;
  }

  Future<List<CandidateDoctor>> findOlineDoctor() async {
    List<CandidateDoctor> doctors;
    try {
      print('calling');
      print('');
      var response = await http.get(findDoctor);
      doctors = new List();

      if (response.statusCode >= 200 && response.statusCode <= 400) {
        List<dynamic> _dynamic = json.decode(response.body);
        print('response body $_dynamic');

        _dynamic.forEach((element) {
          doctors.add(CandidateDoctor.fromJson(element));
        });
      } else {
        print('request failed');
      }
    } catch (e) {
      print('error $e');
    }

    if (doctors != null) {
      print('length ${doctors.length}');
      myStreamCtrl.sink.add(doctors);
    }
    return doctors;
  }

  void dispose() {
    myStreamCtrl.close();
    myStreamConsulta.close();
  }

  Future<bool> PostFiles(
      {File document, int pkPatient, int pkSpecialidade, double preco}) async {
    print('file $document');
    bool result = false;

    var responses = await client.post(obterReceibo, body: {
      'pkPatient': '$pkPatient',
      'pkSpecialidade': '$pkSpecialidade',
      'preco': '$preco'
    });
    var stream = new http.ByteStream(DelegatingStream(document.openRead()));
    var length = await document.length();
    var uri = Uri.parse(obterReceibo);
    var request = new http.MultipartRequest("POST", uri)
      ..fields['pkPatient'] = '$pkPatient'
      ..fields['pkSpecialidade'] = '$pkSpecialidade'
      ..fields['preco'] = '$preco';
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(document.path));
    //contentType: new MediaType('image', 'png'));
    request.files.add(multipartFile);
    var response = await request.send();
    print("estou a tentar carregar o fil");
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print('value  $value');
      result = value == "true";
    });
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      return true;
    }
    return false;
  }

  Future<List<Consulta>> getConsultas({int pkPaciente}) async {
    print('pk Pacient $pkPaciente');

    List<Consulta> consultas = new List();

    var response =
        await client.post(consultarConsulta, body: {'pkPaciente': '$pkPaciente'});
    if (response.statusCode >= 200 && response.statusCode <= 400) {
      myStreamConsulta.sink.add(consultas);
    
       List<dynamic> _dynamic = json.decode(response.body);
        print('response body $_dynamic');

        _dynamic.forEach((element) {
          print('element $element');
          
          consultas.add(Consulta.fromJson(element));
        });
         return consultas;
     
    } else {
       print('response consultas ${response.body}');
      myStreamConsulta.sink.add(consultas);
  
    }
    return consultas;
  }

  Future<bool> finalizarConsulta({int pkPaciente, int pkUsuario,int fkEspecialidade}) async {
    
    var response = await client.post(FinalizarConsulta,
        body: {'pkMedico': '$pkPaciente', "pkPaciente": '$pkUsuario', 'fkSpecialidade':'$fkEspecialidade'});
    if (response.statusCode >= 200 && response.statusCode <= 400) {
     
      final data = response.body;
      print('response consultas $data');
      return data == "true";
    } else {
      print('not sent');
      return false;
    }
  }
}
