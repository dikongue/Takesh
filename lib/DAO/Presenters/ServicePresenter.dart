
import 'package:etakesh_client/DAO/Rest_dt.dart';
import 'package:etakesh_client/Models/services.dart';

abstract class ServiceContract {
  void onLoadingSuccess(List<CategorieService> service);
  void onLoadingError();
  void onConnectionError();
}

class ServicePresenter {
  ServiceContract _view;

  RestDatasource api = new RestDatasource();

  ServicePresenter(this._view);

  // loadServices(String token) {
  //   api.loadServicesLocal(token).then((List<CategorieService> services) {
  //     print(services);
  //     if (services != null) {
  //       _view.onLoadingSuccess(services);
  //     } else
  //       _view.onLoadingError();
  //   }).catchError((onError) {
  //     _view.onConnectionError();
  //   });
  // }
// TODO : remove to uncomment after update server side
  loadServices(String token) {
    api.getServiceCat(token).then((List<CategorieService> services) {
      print(services);
      if (services != null) {
        _view.onLoadingSuccess(services);
      } else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}

abstract class ServiceContract1 {
  void onLoadingSuccess(List<Service> service);
  void onLoadingError();
  void onConnectionError();
}

class ServicePresenter1 {
  ServiceContract1 _view;

  RestDatasource api = new RestDatasource();

  ServicePresenter1(this._view);

  loadServices(String token) {
    api.getService(token).then((List<Service> services) {
      print(services);
      if (services != null) {
        _view.onLoadingSuccess(services);
      } else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }

  loadServices1(String token) {
    api.getService2(token).then((List<Service> services) {
      print(services);
      if (services != null) {
        _view.onLoadingSuccess(services);
      } else
        _view.onLoadingError();
    }).catchError((onError) {
      _view.onConnectionError();
    });
  }
}
