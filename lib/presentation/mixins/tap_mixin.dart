mixin TapMixin {
  bool _isTapped = false;
  bool get isChattering {
    if (_isTapped) {
      _isTapped = false;
    } else {
      _isTapped = true;
    }
    return !_isTapped;
  }
}
