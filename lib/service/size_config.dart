import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  double _screenWidth, _screenHeight;
  double _blockSizeHorizontal, _blockSizeVertical;

  double _safeAreaHorizontal, _safeAreaVertical;
  double _safeBlockSizeH, _safeBlockSizeV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    _blockSizeHorizontal = _screenWidth/100;
    _blockSizeVertical = _screenWidth/100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    _safeBlockSizeH = (_screenWidth - _safeAreaHorizontal) / 100;
    _safeBlockSizeV = (_screenHeight - _safeAreaVertical)/ 100;
  }

  double getBlockHorizontal(int userDefinedNum) {
    return userDefinedNum * _safeBlockSizeH; 
  }

  double getBlockVertical(int userDefinedNum) {
    return userDefinedNum * _safeBlockSizeV; 
  }
}
