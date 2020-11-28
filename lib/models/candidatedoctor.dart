

class CandidateDoctor
{

  String name;
  String latitude;
  String longitude;
  String especialidade;
  int fkMedico;
  int fkSpecialidade;

  CandidateDoctor({this.name, this.latitude, this.longitude, this.especialidade, this.fkMedico, this.fkSpecialidade});

  CandidateDoctor.fromJson(Map json)
  {
    name=json['nome'];
    latitude =json['latitudeMedico'];
    longitude =json['LongitudeMedico'];
    especialidade=json['descricao_esp'];
    fkMedico =json['fkMedico'];
    
  }
}