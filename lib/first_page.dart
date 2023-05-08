import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'first_page_bloc.dart';

class FirstPage extends StatelessWidget {
  FirstPage({Key? key}) : super(key: key);
  late FirstPageBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false,
            // user must tap button!
            builder: (_) {
              final firstNameController = TextEditingController();
              final lastNameController = TextEditingController();

              DateTime selectedDate = DateTime.now();
              return AlertDialog(
                title: const Text('AlertDialog Title'),
                content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: firstNameController,
                          decoration: const InputDecoration(
                            label: Text("First Name"),
                            hintText: "First Name",
                          ),
                        ),
                        TextField(
                          controller: lastNameController,
                          decoration: const InputDecoration(
                            label: Text("Last Name"),
                            hintText: "Last Name",
                          ),
                        ),
                        TextButton(onPressed: () async {
                          final DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2015, 8),
                              lastDate: DateTime(2101)) ?? DateTime(54);
                          
                        }, child: Text("select date")),
                        TextButton(onPressed: () async {
                          showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),      //position where you want to show the menu on screen
                            items: [
                              PopupMenuItem<String>(
                                  child: const Text('menu option 1'), value: '1'),
                              PopupMenuItem<String>(
                                  child: const Text('menu option 2'), value: '2'),
                              PopupMenuItem<String>(
                                  child: const Text('menu option 3'), value: '3'),
                            ],
                            elevation: 8.0,
                          );

                        }, child: Text("select date")),
                      ],

                    )),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Approve'),
                    onPressed: () {
                      bloc.add(addStudent(
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                      ));
                    },
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.login),
        ),
        title: Text(
          "Second Page",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocProvider(
        create: (context) => FirstPageBloc(),
        child: Center(
          child: BlocConsumer<FirstPageBloc, FirstPageState>(
            listener: (context, state) => {
              bloc = context.read<FirstPageBloc>(),
              if (state.studentAction ?? false) {Navigator.of(context).pop()},
            },
            builder: (context, state) {
              if (state.errors == null && state.studentsList != null) {
                return Center(
                  child: ListView(
                    children: List.generate(
                      state.studentsList!.length ?? 0,
                      (index) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.studentsList![index].Id.toString()),
                              Text(state.studentsList![index].FirstName),
                              Text(state.studentsList![index].LastName),
                              Text(state.studentsList![index].DOB.year
                                  .toString()),
                              IconButton(
                                onPressed: () async {
                                  final firstNameController =
                                      TextEditingController(
                                          text: state
                                              .studentsList![index].FirstName);
                                  final lastNameController =
                                      TextEditingController(
                                          text: state
                                              .studentsList![index].LastName);
                                  final DOBController =
                                      TextEditingController(text: "rads");
                                  return showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder: (_) {
                                      return AlertDialog(
                                        title: const Text('AlertDialog Title'),
                                        content: SingleChildScrollView(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextField(
                                              controller: firstNameController,
                                              decoration: const InputDecoration(
                                                label: Text("First Name"),
                                                hintText: "First Name",
                                              ),
                                            ),
                                            TextField(
                                              controller: lastNameController,
                                              decoration: const InputDecoration(
                                                label: Text("Last Name"),
                                                hintText: "Last Name",
                                              ),
                                            ),
                                          ],
                                        )),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Approve'),
                                            onPressed: () {
                                              context.read<FirstPageBloc>().add(
                                                  UpdateStudent(
                                                      student: Students(
                                                          Id: state
                                                              .studentsList![
                                                                  index]
                                                              .Id,
                                                          FirstName:
                                                              firstNameController
                                                                  .text,
                                                          LastName:
                                                              lastNameController
                                                                  .text,
                                                          DOB: state
                                                              .studentsList![
                                                                  index]
                                                              .DOB)));
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () => context
                                    .read<FirstPageBloc>()
                                    .add(DeleteStudent(
                                        Id: state.studentsList![index].Id)),
                                icon: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Center(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<FirstPageBloc>().add(StudentEvent());
                      },
                      child: Text("Get Students"),
                    ),
                    Center(
                      child: PopupMenuButton<String>(
                        child: Text("button"),
                        initialValue: "selectedMenu",
                        // Callback that sets the selected popup menu item.
                        onSelected: (String item) {
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: "SampleItem.itemOne",
                            child: Text('Item 1'),
                          ),
                          const PopupMenuItem<String>(
                            value: "SampleItem.itemTwo",
                            child: Text('Item 2'),
                          ),
                          const PopupMenuItem<String>(
                            value: "SampleItem.",
                            child: Text('Item 3'),
                          ),
                        ],
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
