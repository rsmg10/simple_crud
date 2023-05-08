import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class BaseEvent {
  const BaseEvent();
}

@immutable
class StudentEvent extends BaseEvent {
  const StudentEvent();
}
@immutable
class UpdateStudent extends BaseEvent {
  late Students student;

  UpdateStudent({required this.student});
}
@immutable
class addStudent extends BaseEvent {
  late String firstName;
  late String lastName;
  addStudent({required this.firstName,required this.lastName,});
}


@immutable
class DeleteStudent extends BaseEvent {
  late int Id;

  DeleteStudent({required this.Id});
}

@immutable
class FirstPageState {
  final bool? isLoading;
  final bool? signedIn;
  late bool? studentAction = false;
  late String? errors = null;
  late List<Students>? studentsList = null;

  //const ButtonState();
  FirstPageState(
      {required this.isLoading,
      required this.signedIn,
      required this.studentAction,
      required this.errors,
      required this.studentsList});

  FirstPageState.Empty()
      : isLoading = false ?? false,
        signedIn = false;
}

class Students {
  Students(
      {required this.Id,
      required this.FirstName,
      required this.LastName,
      required this.DOB});

  late int Id;
  late String FirstName;
  late String LastName;
  late DateTime DOB;
}

class FirstPageBloc extends Bloc<BaseEvent, FirstPageState> {
  FirstPageBloc() : super(FirstPageState.Empty()) {
    on<StudentEvent>(
      (event, emit) async {
        await Future.delayed(
          Duration(seconds: 1),
        );
        var students = StudentApi.instance().getStudents();
        emit(FirstPageState(
            isLoading: students == null,
            studentAction: false,
            signedIn: true,
            errors: null,
            studentsList: students));
      },
    );

    on<UpdateStudent>(
      (event, emit) {
        //loading

        var studentUpdated =
            StudentApi.instance().updateStudent(event.student!);
        emit(FirstPageState(
            isLoading: false,
            signedIn: true,
            studentAction: true,
            errors: null,
            studentsList: studentUpdated));
      },
    );
    on<DeleteStudent>(
      (event, emit) {
        //loading

        var studentUpdated = StudentApi.instance().deleteStudent(event.Id);
        emit(FirstPageState(
            isLoading: false,
            studentAction: false,
            signedIn: true,
            errors: null,
            studentsList: studentUpdated));
      },
    );
    on<addStudent>(
      (event, emit) {
        var students = StudentApi.instance().addStudent(event.firstName, event.lastName);
        emit(FirstPageState(
            isLoading: students == null,
            studentAction: true,
            signedIn: true,
            errors: null,
            studentsList: students));
      },
    );
  }
}

@immutable
class StudentApi {
  StudentApi._sharedInstance();

  static late final _shared = StudentApi._sharedInstance();

  factory StudentApi.instance() => _shared;

  List<Students>? _students;

  List<Students>? getStudents() {
    if (_students == null) {
      _students = List.generate(
          10,
          (index) => new Students(
              Id: index + 1,
              FirstName: "Student $index",
              LastName: "LastName $index",
              DOB: DateTime(1998, index + 1)));
    }
    return _students;
  }

  List<Students>? updateStudent(Students student) {
    int index = _students!.indexWhere((item) => item.Id == student.Id);
    _students![index].FirstName = student.FirstName;
    _students![index].LastName = student.LastName;
    _students![index].DOB = student.DOB;
    return _students;
  }

  List<Students>? deleteStudent(int Id) {
    _students!.removeWhere((item) => item.Id == Id);
    return _students;
  }

  List<Students>? addStudent(String firstName, String lastName) {
    var student = Students(Id: _students!.last.Id + 1, FirstName: firstName, LastName: lastName, DOB: DateTime(62));
    _students?.add(student);
    return _students;

  }
}
