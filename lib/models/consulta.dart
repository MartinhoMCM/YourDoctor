
class Consulta
{
  String dataConsulta;
  int pkMedico;
  String especialidade;
  String nomeDoctor;
  String emailDoctor;

  Consulta.fromJson(Map map)
  {
    print('ma $map');
    dataConsulta=map['data_consulta'];
    //especialidade=map['especialidade'];
    nomeDoctor =map['nome'];
    pkMedico =map['pk_medico'];
    emailDoctor=map['email_medico'];

    print('consulta $dataConsulta');
  }
}