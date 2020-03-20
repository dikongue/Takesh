import 'dart:async';

import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Models/commande.dart';
import 'package:etakesh_client/Models/prestataires.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../courses_page.dart';
import '../home_page.dart';

class ProgressBouton extends StatefulWidget {
  List<CommandeDetail> ncmds;
  int indexC;
  String token;
  @override

  ProgressBouton({Key key, this.ncmds, this.indexC ,this.token}) : super(key: key);
  _ProgressBoutonState createState() => _ProgressBoutonState();
}

class _ProgressBoutonState extends State<ProgressBouton> with SingleTickerProviderStateMixin {
  bool _isPressed=false;
  int state=0;
  double width=100.0;
  Animation _animation;
  GlobalKey globalKey=GlobalKey();
  RestDatasource api = new RestDatasource();
  @override

  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.red,
      elevation: _isPressed ? 6.0 : 4.0,
      borderRadius: BorderRadius.circular(50.0),
      child: Container(
        key: globalKey,
        height: 40.0,
        width: width,

        child: RaisedButton(

          padding: EdgeInsets.all(0.0),
          color: state==2? Colors.red : Colors.red,
          
          child: buildButtonChild(),
        onPressed:(){
           // if(state==3)

        },
        onHighlightChanged:(isPressed){
          setState(() {
           _isPressed=isPressed;
           if(state==0){
             animetdBouton();
            // Navigator.of(context).pop();
           }
          });
        }
        ),

      ),


    );
  }

  void animetdBouton(){
   double initialWidth=globalKey.currentContext.size.width;
   print("good.....");
   print(initialWidth);
   var controller=
      AnimationController(duration: Duration(milliseconds: 250),vsync:this);
      _animation=Tween(begin:0.0, end:1.0).animate(controller )..addListener((){
        setState((){
          width = initialWidth - ((initialWidth - 47.0) * _animation.value);
        });
      });
      controller.forward();
      setState(() {
       state=1;
       print(state);
      });
   controller.forward();
     Timer(Duration(milliseconds: 2900), (){
        setState(() {
          state=2;
          print(state);
        });
      });


    Timer(Duration(milliseconds: 3300), (){
     setState(() {
       state=3;
       width=100;
       print(state);
     });
   });
   Timer(Duration(milliseconds: 4000), ()
   {
    // widget.ncmds.remove(widget.indexC);
     Navigator.of(context).pop();
      setState(() {
               widget.ncmds.removeAt(widget.indexC);
          });

    /* Navigator.of(globalKey.currentContext)
     .pushAndRemoveUntil( new MaterialPageRoute(builder: (context) => CoursesPage()),
        ModalRoute.withName( Navigator.defaultRouteName)
        );*/
      });
   
  }
  

  Widget buildButtonChild(){
    if(state==0){
      return Text(
         "ANNULER",
          style: TextStyle(color:Colors.white),
          );
    }else if(state==1){
      return CircularProgressIndicator(value: null,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white));
    }else if(state==2){
      
      RestDatasource().updateCmdStatus1(widget.ncmds[widget.indexC], widget.token).then((data) {

        if(data!=null){
          print('commande annuler avec sucess........');
          print(widget.ncmds[widget.indexC].prestation.prestataireId.toString());
          print(data.status);

          print("prestatairesId ......."+data.prestataireId.toString());
          String prestataireId=widget.ncmds[widget.indexC].prestation.prestataireId.toString();

        api.getPrestataires1(widget.token,prestataireId).then((List<PrestataireOnline> prestataires) {
      
      if (prestataires != null) {
       // for (int i = 0; i < prestataires.length; i++) {
          print("fababy........");

         // if (prestataires[i].prestataires.prestataireid.toString() == widget.ncmds[widget.indexC].prestation.prestataireId.toString()) {
              
                  api.updatPresta(prestataires[0], "false", widget.token);
            print("ces vrai.......");
            print("ces vrai.......");
            print("ces vrai.......");
         // }
       // }
      }
        
     
            
       });

          print("cmd update");
        }
      });
      return Icon(Icons.check, color:Colors.white);

    }else if(state==3) {
     // width=double.infinity;
      return Text(
        "ANNULER..",
        style: TextStyle(color: Colors.white),
      );
    }
  }

}