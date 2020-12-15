

class News
{
  String author;
  String content;
  String especialidade;
  String title;

  News.fromJson(Map json)
  {
    author =json['autor'];
    content=json['content'];
    especialidade=json['especialidade'];
    title =json['title'];
  }
}