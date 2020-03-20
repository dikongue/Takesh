import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Models/clients.dart';

abstract class SignUpContract {
  void onSignUpSuccess();
  void onSignUpError();
  void onConnectionError();
}

class SignUpPresenter {
  SignUpContract _view;
  RestDatasource api = new RestDatasource();
  SignUpPresenter(this._view);

  signUp(Client client) {}
}
