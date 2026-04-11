import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for controlling the bottom navigation index
final navigationIndexProvider = StateProvider<int>((ref) => 0);

/// Indices for each tab
class NavigationTab {
  static const int chat = 0;
  static const int files = 1;
  static const int browser = 2;
  static const int devices = 3;
  static const int terminal = 4;
  static const int settings = 5;
}
