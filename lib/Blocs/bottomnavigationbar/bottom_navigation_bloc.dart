import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'bottom_navigation_event.dart';
part 'bottom_navigation_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  BottomNavigationBloc() : super(BottomNavigationState(currentIndex: 0)) {
    on<TabChangedEvent>((event, emit) {
    emit(BottomNavigationState(currentIndex: event.index));
    });
  }
}


