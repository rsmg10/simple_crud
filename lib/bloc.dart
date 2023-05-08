import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class BaseEvent {
  const BaseEvent();
}

@immutable
abstract class ButtonEvent extends BaseEvent {
  const ButtonEvent();
}

@immutable
class LoginEvent implements ButtonEvent {
  var email;
  var password;


   LoginEvent({
    required this.email,
    required this.password,
  });
}

@immutable
class ButtonState {
  final bool? isLoading;
  final bool? signedIn;

  //const ButtonState();
   const ButtonState({required this.isLoading, required this.signedIn,});
   ButtonState.Empty(): isLoading = false, signedIn = false;
}

class AppBloc extends Bloc<ButtonEvent, ButtonState> {
  AppBloc() : super(ButtonState.Empty())  {
    on<LoginEvent>(
      (event, emit) async {
        var signed = state.signedIn;
         emit(ButtonState(isLoading: true, signedIn: signed));

         await Future.delayed(Duration(seconds: 1));
          if(event.email == 'rads' && event.password == 'rads')
            signed = true;
          else
            signed = false;
         emit(ButtonState(isLoading: false, signedIn: signed));
      },
    );
  }
}
