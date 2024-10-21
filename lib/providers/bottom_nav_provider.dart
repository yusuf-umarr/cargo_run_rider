import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier { 

    int currentIndex = 0;

  dynamic socketIo;

  setSocketIo(socket) {
    socketIo = socket;
    notifyListeners();
  }

  setNavbarIndex(index) {
    currentIndex = index;
    notifyListeners();
  }

}