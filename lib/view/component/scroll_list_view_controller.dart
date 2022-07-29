class ScrollListViewController {
  int _currentIdx = 0;

  ScrollListViewController();

  int getCurrentIndex() => _currentIdx;
  void setCurrentIndex(int idx) => _currentIdx = idx;
}