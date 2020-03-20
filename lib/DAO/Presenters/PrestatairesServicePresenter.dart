import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Models/prestataires.dart';

abstract class PresetataireServiceContract {
  void onLoadingSuccess(List<PrestataireService> prestataires);
  void onLoadingError();
  void onConnectionError();
}

class PresetataireServicePresenter {
  PresetataireServiceContract _view;

  RestDatasource api = new RestDatasource();
  PresetataireServicePresenter(this._view);

  loadPrestataires(String token, int serviceId) {
    api
        .getAllPrestatairesServices(token, serviceId)
        .then((List<PrestataireService> prestataires) {
      
      if (prestataires != null) {
        _view.onLoadingSuccess(prestataires);
      } else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
