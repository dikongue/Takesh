import 'dart:async';

import 'package:etakesh_client/Presentation/Animation_Gesture/page_dragger.dart';
import 'package:etakesh_client/Presentation/Animation_Gesture/page_reveal.dart';
import 'package:etakesh_client/Presentation/UI/pager_indicator.dart';
import 'package:etakesh_client/Presentation/UI/pages.dart';
import 'package:etakesh_client/Utils/AppSharedPreferences.dart';
import 'package:etakesh_client/pages/FirstLaunch/main_page.dart';
import 'package:flutter/material.dart';

class Presentation extends StatefulWidget {
  @override
  _PresentationState createState() => new _PresentationState();
}

class _PresentationState extends State<Presentation>
    with TickerProviderStateMixin {
  StreamController<SlideUpdate> slideUpdateStream;
  AnimatedPageDragger animatedPageDragger;

  int activeIndex = 0;
  SlideDirection slideDirection = SlideDirection.none;
  int nextPageIndex = 0;
  double slidePercent = 0.0;

  _PresentationState() {
    slideUpdateStream = new StreamController<SlideUpdate>();

    slideUpdateStream.stream.listen((SlideUpdate event) {
      setState(() {
        if (event.updateType == UpdateType.dragging) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;

          if (slideDirection == SlideDirection.leftToRight) {
            nextPageIndex = activeIndex - 1;
          } else if (slideDirection == SlideDirection.rightToLeft) {
            nextPageIndex = activeIndex + 1;
          } else {
            nextPageIndex = activeIndex;
          }
        } else if (event.updateType == UpdateType.doneDragging) {
          if (slidePercent > 0.5) {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.open,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );
          } else {
            animatedPageDragger = new AnimatedPageDragger(
              slideDirection: slideDirection,
              transitionGoal: TransitionGoal.close,
              slidePercent: slidePercent,
              slideUpdateStream: slideUpdateStream,
              vsync: this,
            );

            nextPageIndex = activeIndex;
          }

          animatedPageDragger.run();
        } else if (event.updateType == UpdateType.animating) {
          slideDirection = event.direction;
          slidePercent = event.slidePercent;
        } else if (event.updateType == UpdateType.doneAnimating) {
          activeIndex = nextPageIndex;

          slideDirection = SlideDirection.none;
          slidePercent = 0.0;

          animatedPageDragger.dispose();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppSharedPreferences().setAppFirstLaunch(false);
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (BuildContext context) {
            return MainLaunchPage();
          }));
        },
        tooltip: "Passer",
        child: Icon(Icons.arrow_forward),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF0C60A8),
//        shape: _DiamondBorder(),
      ),
//      bottomNavigationBar: BottomAppBar(
//        color: Colors.white,
//        child: Container(
//          height: 20.0,
//        ),
//      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: new Stack(
        children: [
          new Page(
            viewModel: pages[activeIndex],
            percentVisible: 1.0,
          ),
          new PageReveal(
            revealPercent: slidePercent,
            child: new Page(
              viewModel: pages[nextPageIndex],
              percentVisible: slidePercent,
            ),
          ),
          new PagerIndicator(
            viewModel: new PagerIndicatorViewModel(
              pages,
              activeIndex,
              slideDirection,
              slidePercent,
            ),
          ),
          new PageDragger(
            canDragLeftToRight: activeIndex > 0,
            canDragRightToLeft: activeIndex < pages.length - 1,
            slideUpdateStream: this.slideUpdateStream,
          ),
        ],
      ),
    );
  }
}

//class _DiamondBorder extends ShapeBorder {
//  const _DiamondBorder();
//
//  @override
//  EdgeInsetsGeometry get dimensions {
//    return const EdgeInsets.only();
//  }
//
//  @override
//  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
//    return getOuterPath(rect, textDirection: textDirection);
//  }
//
//  @override
//  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
//    return Path()
//      ..moveTo(rect.left + rect.width / 2.0, rect.top)
//      ..lineTo(rect.right, rect.top + rect.height / 2.0)
//      ..lineTo(rect.left + rect.width / 2.0, rect.bottom)
//      ..lineTo(rect.left, rect.top + rect.height / 2.0)
//      ..close();
//  }
//
//  @override
//  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}
//
//  // This border doesn't support scaling.
//  @override
//  ShapeBorder scale(double t) {
//    return null;
//  }
//}
