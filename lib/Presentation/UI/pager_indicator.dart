import 'dart:ui';

import 'package:etakesh_client/Presentation/UI/pages.dart';
import 'package:flutter/material.dart';

class PagerIndicator extends StatelessWidget {
  final PagerIndicatorViewModel viewModel;

  PagerIndicator({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    List<PageBubble> bubbles = [];
    for (var i = 0; i < viewModel.pages.length; ++i) {
      var percentActive;

      if (i == viewModel.activeIndex) {
        percentActive = 1.0 - viewModel.slidePercent;
      } else if (i == viewModel.activeIndex - 1 &&
          viewModel.slideDirection == SlideDirection.leftToRight) {
        percentActive = viewModel.slidePercent;
      } else if (i == viewModel.activeIndex + 1 &&
          viewModel.slideDirection == SlideDirection.rightToLeft) {
        percentActive = viewModel.slidePercent;
      } else {
        percentActive = 0.0;
      }

      bool isHollow = i > viewModel.activeIndex ||
          (i == viewModel.activeIndex &&
              viewModel.slideDirection == SlideDirection.leftToRight);

      bubbles.add(
        new PageBubble(
          viewModel: new PageBubbleViewModel(
//            page.iconAssetPath,
            isHollow,
            percentActive,
          ),
        ),
      );
    }

    final BUBBLE_WIDHT = 10.0;
    final baseTranslation =
        ((viewModel.pages.length * BUBBLE_WIDHT) / 2) - (BUBBLE_WIDHT / 2);
    var translation = baseTranslation - (viewModel.activeIndex * BUBBLE_WIDHT);

    if (viewModel.slideDirection == SlideDirection.leftToRight) {
      translation += BUBBLE_WIDHT * viewModel.slidePercent;
    } else if (viewModel.slideDirection == SlideDirection.rightToLeft) {
      translation -= BUBBLE_WIDHT * viewModel.slidePercent;
    }

    return new Column(
      children: <Widget>[
        new Expanded(child: new Container()),
        new Transform(
          transform: new Matrix4.translationValues(translation, 0.0, 0.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: bubbles,
          ),
        ),
      ],
    );
  }
}

enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

class PagerIndicatorViewModel {
  final List<PageViewModel> pages;
  final int activeIndex;
  final SlideDirection slideDirection;
  final double slidePercent;

  PagerIndicatorViewModel(
      this.pages, this.activeIndex, this.slideDirection, this.slidePercent);
}

class PageBubble extends StatelessWidget {
  final PageBubbleViewModel viewModel;

  PageBubble({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(5.0),
      width: 10.0,
      height: 20.0,
      child: new Center(
        child: new Container(
          width: lerpDouble(15.0, 40.0, viewModel.activePercent),
          height: lerpDouble(15.0, 40.0, viewModel.activePercent),
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: viewModel.isHollow
                ? const Color(0xFF0C60A8)
                    .withAlpha(0x88 * viewModel.activePercent.round())
                : const Color(0xFF0C60A8),
            border: new Border.all(
              color: viewModel.isHollow
                  ? const Color(0xFFFFFFFF).withAlpha(
                      (0x88 * (0.2 - viewModel.activePercent)).round())
                  : Colors.transparent,
              width: 3.0,
            ),
          ),
          child: new Opacity(
            opacity: viewModel.activePercent,
//            child: Image.asset(
//              viewModel.iconAssetPath,
//              color: viewModel.color,
//            ),
          ),
        ),
      ),
    );
  }
}

class PageBubbleViewModel {
//  final String iconAssetPath;
  final bool isHollow;
  final double activePercent;

  PageBubbleViewModel(
//    this.iconAssetPath,
    this.isHollow,
    this.activePercent,
  );
}
