
class SendSymptons
{
  int pk_sintomas;

  SendSymptons({this.pk_sintomas});


  Map toJson() => {
    'fk_sintomas': pk_sintomas,
  };

}

class Description
{
  int pkSintomaEspecialidade;

  Description({this.pkSintomaEspecialidade});

  Map toJson() => {
    'pkSintomaEspecialidade': pkSintomaEspecialidade,
  };

}

class Mixed
{
  List<SendSymptons> pkSymptoms;
  List<Description> description;
  int pk_usuario;

  Mixed({this.pkSymptoms, this.description, this.pk_usuario});


  Map toJson()
  {
    List<Map> listPkSymptoms =this.pkSymptoms!=null?this.pkSymptoms.map((i) => i.toJson()).toList():null;
    List<Map> listDescription =this.description!=null?this.description.map((i) => i.toJson()).toList():null;

    return {
      'pk_sintomas':listPkSymptoms,
      'descricao':listDescription,
      'pk_usuario':this.pk_usuario
    };

  }

}