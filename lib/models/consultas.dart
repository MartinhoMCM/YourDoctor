

class Consultas
{
    String especialidade;
    String nomeDoctor;
    String data;

   Consultas.fromJson(Map json)
   {
     especialidade =json['especialidade'];
     nomeDoctor =json['nomeDoctor'];
     data =json['data'];
   }

}