import 'dart:math';

import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Models/commande.dart';

abstract class CoursesContract {
  void onLoadingSuccess(List<CommandeDetail> ncmds, List<CommandeDetail> ocmds, List<CommandeDetail> acmds);
  void onLoadingError();
  void onConnectionError();
}

class CoursesPresenter {
  CoursesContract _view;

  RestDatasource api = new RestDatasource();

  CoursesPresenter(this._view);

  loadCmd(String token, int clientId) {
    api.getNewCmdClient(token, clientId).then((List<CommandeDetail> ncmds) {
      api.getOldCmdClient(token, clientId).then((List<CommandeDetail> ocmds) {
        api.getAnnCmdClient(token, clientId).then((List<CommandeDetail>acmds){
           _view.onLoadingSuccess(ncmds, ocmds, acmds);
        });
        
      });
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
  
  refresh(String token1, int clientId1){
    
    loadCmd(token1, clientId1);

  }

}

class CommandeNotifPresenter {
  RestDatasource api = new RestDatasource();

  double calculateDistance(lat1, lon1, lat2, lon2) {
    if(lat1!=null) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    }
  }
  ///position d'arriver .......
  Future<double> getposi(String token, String clientId, String prestataireId) {
    return api
         .getPositionById(token, clientId.toString())
        .then((PositionModel positionClient) {
          print("notification fabiol ");
      if (positionClient != null)
                  {
                    api.getPositionPrestatire(token, int.parse(prestataireId)).then((PositionModel positionPresta){
                      print("notification driver ");
                     if(positionPresta!=null){
                      double distance=calculateDistance(positionClient.latitude, positionClient.longitude, positionPresta.latitude, positionPresta.longitude);   
                       print(distance);
                       if(distance<50.0){
                          print("notification driver est la ");
                          print(distance);
                       return distance;
                       }
                       
                     }else 
                     return null;
                    });
                  }        
      else
        return null;
    }).catchError((onError) {
      print("Erreur liste cmd");
    });
  }

  ///commandes validees
  Future<List<CommandeDetail>> getCmdValideClient(String token, int clientId) {
    return api
        .getCmdValideClient(token, clientId)
        .then((List<CommandeDetail> commandes) {
      if (commandes != null)
        return commandes;
      else
        return null;
    }).catchError((onError) {
      print("Erreur liste cmd");
    });
  }

  ///detail sur une commande
  Future<CommandeDetail> loadCmdDetail(String token, int clientId, int cmdId) {
    return api
        .getCmdClient(token, clientId, cmdId)
        .then((CommandeDetail commande) {
      if (commande != null) {
        return commande;
      } else
        return null;
    }).catchError((onError) {
      print("Erreur get one cmd");
    });
  }

  ///commandes refusees
  Future<List<CommandeDetail>> getCmdRefuseClient(String token, int clientId) {
    return api
        .getCmdRefuseClient(token, clientId)
        .then((List<CommandeDetail> commandes) {
      if (commandes != null)
        return commandes;
      else
        return null;
    }).catchError((onError) {
      print("Erreur liste cmd");
    });
  }
   ///commandes annuler
  Future<List<CommandeDetail>> getCmdAnnulerClient(String token, int clientId) {
    return api
        .getCmdAnnulerClient(token, clientId)
        .then((List<CommandeDetail> commandes) {
      if (commandes != null)
        return commandes;
      else
        return null;
    }).catchError((onError) {
      print("Erreur liste cmd");
    });
  }
}
