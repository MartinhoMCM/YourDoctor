class Doctor{
   int pk_medico;
   int fk_pessoa;
   int especialidade;
   String descricao_esp;
   String data_criacao;
   String data_modificacao;
   String data_nascimento ;
   int pk_pessoa;
   String nome;
   String sexo;

  Doctor({this.pk_medico, this.fk_pessoa, this.especialidade, this.descricao_esp, this.data_criacao,
     this.data_modificacao, this.pk_pessoa, this.nome, this.data_nascimento, this.sexo});

    Doctor.fromJson(Map<String , dynamic> maps){
            pk_medico=maps['pk_medico'];
            fk_pessoa=maps['fk_pessoa'];
            especialidade=maps['especialidade'];
            descricao_esp= maps['descricao_esp'];
            data_criacao=maps['data_criacao'];
            //data_modificacao=maps['data_modificacao'];
            pk_pessoa=maps['pk_pessoa'];
            nome= maps['nome'];
            data_nascimento= maps['data_nascimento'];
            sexo=maps['sexo'];

   }
}