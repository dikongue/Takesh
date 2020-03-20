import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Models/commande.dart';

abstract class TrackingContract {
  void onLoadingSuccess(PositionModel post, PositionModel prest);
  void onLoadingError();
  void onConnectionError();
}

class TrackingPresenter {
  TrackingContract _view;

  RestDatasource api = new RestDatasource();

  TrackingPresenter(this._view);

  loadPostions(String token, String postId, int prestataireId) {
    api.getPositionById(token, postId).then((PositionModel position) {
      api
          .getPositionPrestatire(token, prestataireId)
          .then((PositionModel posPresta) {
        _view.onLoadingSuccess(position, posPresta);
      });
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
