import 'package:flutter/material.dart';

final pages = [
  new PageViewModel(
//      const Color(0xFF548CFF),
    'assets/images/presentation/Present1.png',
//      'assets/images/plane.png'
  ),
  new PageViewModel(
//      const Color(0xFFE4534D),
    'assets/images/presentation/Present2.png',
//      'assets/images/calendar.png'
  ),
  new PageViewModel(
//    const Color(0xFFFF682D),
    'assets/images/presentation/Present3.png',
//    'assets/images/house.png',
  ),
  new PageViewModel(
//    const Color(0xFFFF682D),
    'assets/images/presentation/Present4.png',
//    'assets/images/house.png',
  ),
];

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;

  Page({
    this.viewModel,
    this.percentVisible = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
        width: double.infinity,
        decoration: new BoxDecoration(
            image: new DecorationImage(
          image: new AssetImage(viewModel.heroAssetPath),
          fit: BoxFit.fill,
        )),
//        color: viewModel.color,
        child: new Opacity(
          opacity: percentVisible,
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
//                new Transform(
//                  transform: new Matrix4.translationValues(
//                      0.0, 50.0 * (1.0 - percentVisible), 0.0),
////                  child: new Padding(
////                    padding: new EdgeInsets.only(bottom: 25.0),
////                    child: new Image.asset(viewModel.heroAssetPath,
////                        width: 200.0, height: 200.0),
////                  ),
//                ),
//                new Transform(
//                  transform: new Matrix4.translationValues(
//                      0.0, 30.0 * (1.0 - percentVisible), 0.0),
//                  child: new Padding(
//                    padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
//                    child: new Text(
//                      viewModel.title,
//                      style: new TextStyle(
//                        color: Colors.white,
//                        fontFamily: 'FlamanteRoma',
//                        fontSize: 34.0,
//                      ),
//                    ),
//                  ),
//                ),
//                new Transform(
//                  transform: new Matrix4.translationValues(
//                      0.0, 30.0 * (1.0 - percentVisible), 0.0),
//                  child: new Padding(
//                    padding: new EdgeInsets.only(bottom: 75.0),
//                    child: new Text(
//                      viewModel.body,
//                      textAlign: TextAlign.center,
//                      style: new TextStyle(
//                        color: Colors.white,
//                        fontFamily: 'FlamanteRomaItalic',
//                        fontSize: 18.0,
//                      ),
//                    ),
//                  ),
//                ),
              ]),
        ));
  }
}

class PageViewModel {
  final String heroAssetPath;
//  final String iconAssetPath;

  PageViewModel(
    this.heroAssetPath,
//    this.iconAssetPath,
  );
}
