part of 'bottom_navigation_bloc.dart';

@immutable
sealed class BottomNavigationEvent {
  const BottomNavigationEvent();
}
class TabChangedEvent extends BottomNavigationEvent{

  final int index;
  const TabChangedEvent({
    required this.index,
  });
}
