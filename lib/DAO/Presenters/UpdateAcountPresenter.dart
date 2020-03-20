import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Models/clients.dart';

abstract class UpdateAccountContract {
  void onRequestSuccess(Client1 client);
  void onRequestError();
  void onConnectionError();
}

class UpdateAccountPresenter {
  UpdateAccountContract _view;
  RestDatasource api = new RestDatasource();
  UpdateAccountPresenter(this._view);

  updateAccountDatas(Client1 client, String token) {
    api.updateClient(client, token).then((Client1 clt) {
      clt != null ? _view.onRequestSuccess(client) : _view.onRequestError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
