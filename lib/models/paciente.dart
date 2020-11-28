class Patient {
    String id;
    String nomecompleto;
    String email;
    String senha;
    String data_nascimento ;
    String grupo_sanguineo;
    String altura;
    String peso;
    String genero ;
    int tipo_Usuario;
    String photo;
    String telephone;
    String token;
    String password;
    int  pkPaciente;
    int primeiroLog;
    String province;
    String county;
    int pkProvince;
    int pkCounty;
    String descricao;
    String latitude;
    String longitude; 
 


    Patient.initial()
        : id = '',
          email = '',
          password = '',
          token ='';

    Patient({
      this.nomecompleto ,
      this.email ,
      this.photo,
      this.senha,
      this.genero,
      this.data_nascimento,
      this.grupo_sanguineo,
      this.altura ,
      this.peso ,
      this.tipo_Usuario,
      this.telephone,
      this.primeiroLog,
      this.token,
      this.pkPaciente,
      this.province,
      this.county,
      this.pkProvince,
      this.pkCounty,
      this.descricao,
      this.latitude,
      this.longitude,
    
    });
    
    Patient.fromJson(Map maps) {
      this.pkPaciente=maps["pk_paciente"];
       this.altura=maps["altura"];
      this.peso=maps["peso"];
      this.grupo_sanguineo=maps["grupo_sanguineo"];
       this.nomecompleto=maps["nome"];
       this.email=maps["email"];
       this.data_nascimento=maps["data_nascimento"];
         this.pkProvince=maps["fkProvincia"];
          this.pkCounty=maps["fkMunicipio"];
           this.longitude=maps["longitude"];
          this.latitude=maps["latitude"];
           this.tipo_Usuario=maps["tipo_usuario"];
           this.province=maps["provincia"];
           this.county=maps["municipio"]; 
    }
 

    Map toMapPaciente(){
        return {
           'nome':this.nomecompleto ,
           'email':this.email,
           'altura':this.altura,
           "sexo":this.genero,
           'data_nascimento':this.data_nascimento ,
           'grupo_sanguineo':this.grupo_sanguineo ,
           'peso':this.peso ,
           'senha':this.senha ,
           'tipo_Usuario':this.tipo_Usuario,
           'telefone':this.telephone,
           'provincia':this.province,
           'municipio':this.county,

        };
    }



}

class Address
{
  int pk_province;
  int pk_county;
  String district;
  String neighborhood;
  String street;
  String buildingNumber;
  String block;
  String houseNumber;

  Address({this.pk_province, this.pk_county, this.district, this.neighborhood, this.street, this.buildingNumber, this.block, this.houseNumber});

  Address.fromMap(Map<String, dynamic> json)
  {
    this.pk_province =json['pk_provincia'];
    this.pk_province =json['pk_municipio'];
    this.district =json['distrito'];
    this.neighborhood =json['bairro'];
    this.street =json['rua'];
    this.buildingNumber=json['numerodarua'];
    this.block=json['bloco'];

  }

  Map<String, dynamic> toJson()
  {
    return {
    "provincia":this.pk_province,
    "municipio":this.pk_county,
    "distrito":this.district,
    "bairro":this.neighborhood,
    "rua":this.street,
    "numero do predio": this.buildingNumber,
    "bloco":this.block
    };
  }

}

