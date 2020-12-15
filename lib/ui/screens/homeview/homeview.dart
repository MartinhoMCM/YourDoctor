import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitsi_meet_example/models/news.dart';
import 'package:jitsi_meet_example/models/paciente.dart';
import 'package:jitsi_meet_example/models/symptom.dart';
import 'package:jitsi_meet_example/ui/fonts/text_style.dart';
import 'package:jitsi_meet_example/ui/helper/UIHelper.dart';
import 'package:jitsi_meet_example/ui/colors/colorsUI.dart';
import 'package:jitsi_meet_example/ui/screens/userdatacard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final ValueChanged<int> onPush;
  static int controlSymptpons;

  HomeView({this.onPush});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Firestore firestore=Firestore.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Symptom> symptons;
  bool visible = false;
  String URL =
      'https://images.unsplash.com/photo-1512785470245-e9c5bf9016d8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60';

 

  @override
  void initState() {
    visible = false;
    super.initState();
  }

  void setKey() {
    setState(() {
      _scaffoldKey.currentState.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Patient>(context).nomecompleto;
    var province =Provider.of<Patient>(context).province;
    var county =Provider.of<Patient>(context).county;

    var weight = Provider.of<Patient>(context).peso;
    var height = Provider.of<Patient>(context).altura;
    var bloodGroup = Provider.of<Patient>(context).grupo_sanguineo;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1512785470245-e9c5bf9016d8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60'),
                      fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      'Especialidades',
                      style: subHeaderStyle,
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Divider(
                      height: 1,
                      color: Color(0xFF363636),
                    )
                  ],
                ),
                //  leading: Icon(Icons.assignment_return, size: 10.0,),
                subtitle: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Clínico geral',
                        style: subtitleStyle,
                      ),
                      leading: Icon(Icons.data_usage),
                      onTap: () {
                      setState(() {
                        HomeView.controlSymptpons=0;
                      });
                        widget.onPush(0);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Pediatria',
                        style: subtitleStyle,
                      ),
                      leading: Icon(Icons.assignment_return),
                      onTap: () {
                          setState(() {
                         HomeView.controlSymptpons=1;
                      });
                        widget.onPush(1);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Fisioterapia',
                        style: subtitleStyle,
                      ),
                      leading: Icon(Icons.assignment_return),
                      onTap: () {
                          setState(() {
                         HomeView.controlSymptpons=2;
                      });
                        widget.onPush(2);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Cardiologia',
                        style: subtitleStyle,
                      ),
                      leading: Icon(Icons.assignment_return),
                      onTap: () {
                          setState(() {
                         HomeView.controlSymptpons=3;
                      });
                        widget.onPush(3);
                      },
                    ),
                  ],
                ),
              ),
            ),
            /*   Divider(
                height: 1,
                color: Color(0xFF363636),
              ),*/
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: ListTile(
                title: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Outros serviços',
                      style: subHeaderStyle,
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Divider(
                      height: 1,
                      color: Color(0xFF363636),
                    )
                  ],
                ),
                // leading: Icon(Icons.assignment_return),

                subtitle: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Tratamento',
                        style: subtitleStyle,
                      ),
                      leading: Icon(Icons.assignment_return),
                      onTap: () {
                        widget.onPush(1);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Exames Laboratoriais',
                        style: subtitleStyle,
                      ),
                      leading: Icon(Icons.assignment_return),
                      onTap: () {
                        widget.onPush(1);
                      },
                    ),
                    Divider(
                      height: 1,
                      color: Color(0xFF363636),
                    )
                  ],
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: ListTile(
                    title: Text(
                      'Meu historico',
                      style: subtitleStyle,
                    ),
                    leading: Icon(Icons.assignment_return),
                    onTap: () {
                      widget.onPush(1);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: ListTile(
                    title: Text(
                      'Sair',
                      style: subHeaderStyle,
                    ),
                    leading: Icon(Icons.assignment_return),
                    onTap: () {

                      Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
              //forceElevated: true,
              pinned: false,
              floating: true,
              backgroundColor: whiteColor,
              expandedHeight: 40.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Dashboard', style: titleStyle),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    Icons.person,
                    size: 25,
                    color: blueColor,
                  ),
                  tooltip: 'Add new entry',
                ),
              ],

              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: blueColor,
                ),
                tooltip: 'Menu bottom',
                onPressed: setKey,
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Container(
                height: 70.0,
                margin: EdgeInsets.all(8.0),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          height: 50.0,
                          margin:
                              EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: NetworkImage(URL))),
                        ),
                        UIHelper.horizontalSpaceSmall(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                '${user}',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text('$province, $county',
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ])),
            SliverToBoxAdapter(
              child: Container(
                width: 200.0,
                height: 220.0,
                margin: EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    String title = "...";
                    if (index == 0) {
                      title = height.toString() + ' m';
                    } else if (index == 1) {
                      title = weight.toString() + ' Kg';
                    } else if (index == 2) {
                      title = bloodGroup;
                    }
                    return UserDataCard(
                      title: title,
                      index: index,
                    );
                  },
                  itemCount: 3,
                ),
              ),
            ),
          SliverList(
                delegate: SliverChildListDelegate([
              Container(
              
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child:
                      Text('News', style: patternTextBoldStyle
                      )
                      ),
            ])),
            SliverList(
                delegate: SliverChildListDelegate([
                  
                 FutureBuilder<DocumentSnapshot>(
                   future:firestore.collection('news').document('yVTHNbrDtwKh8mvoLAVh').get() ,
                  builder: (context, snapshot){
                       if(snapshot.hasData){

                         News news =News.fromJson(snapshot.data.data);
   
        return Container(
                      child: Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${news.title}', style: patternTextBoldStyle,),
                               InkWell(
                                 onTap: ()
                                 {
                                   seeMore(14);
                                 },
                                 child: Text('Ver mais', style:appoTextStyle))
                              ],
                              ),
                            subtitle: Text('Autor, ${news.author}', style: patternTextStyle,),
                
                          ),
                      ),
                    );
              
                       }
                       else return Container(height: 0.0,width: 0.0,);
                 }
                  ),
               

                        ])),    ],
        ),
      ),
    );

  }
   void seeMore(int activity)
    {
      widget.onPush(activity);
    }
}
