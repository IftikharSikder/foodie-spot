import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetProvider with ChangeNotifier {
  bool _hasConnection = true;
  bool _notifiedOnce = false;
  bool _lastStatus = true;
  bool _navigated = false;
  bool _isInitialized = false;

  bool get hasConnection => _hasConnection;
  bool get lastStatus => _lastStatus;
  bool get navigated => _navigated;
  bool get isInitialized => _isInitialized;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  InternetProvider() {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await Connectivity()
          .checkConnectivity();
      _hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );
      _lastStatus = _hasConnection;
      _isInitialized = true;

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }

    _subscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      bool previous = _hasConnection;
      _hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (_hasConnection != previous) {
        if (!_hasConnection && !_notifiedOnce) {
          _notifiedOnce = true;
        }
        if (_hasConnection && !previous) {
          _notifiedOnce = false;
        }

        notifyListeners();
      }
    });
  }

  void setLastStatus(bool status) {
    _lastStatus = status;
  }

  void setNavigated(bool navigated) {
    _navigated = navigated;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
