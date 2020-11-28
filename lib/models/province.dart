class Provincia{

     int  pkProvincia ;
     String descricao ;
     int status_;

     Provincia({this.pkProvincia,this.descricao ,this.status_});
     factory  Provincia.jsonFormato(Map<String  , dynamic> maps){
            return  Provincia(
                pkProvincia : maps['pkProvincia'],
                descricao:maps['descricao'],
                status_:maps['status_']
            );
     }

}
class Municipio{

  int  pk_municipio;
  String descricao ;
  int fk_provincia;
  int status_ ;


  Municipio({this.pk_municipio,this.fk_provincia ,this.descricao ,this.status_});


  factory Municipio.jsonFormato(Map<String,dynamic> maps){
    return Municipio(
        pk_municipio:maps['pk_municipio'],
        descricao:maps['descricao'],
        status_:maps['status_'],
        fk_provincia:maps['fk_provincia']
    );
  }

}