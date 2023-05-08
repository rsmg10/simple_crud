import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simplest_bloc/bloc.dart';
import 'package:simplest_bloc/first_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final emailController = TextEditingController(text: "rads");
  final passwordController = TextEditingController(text: "rads");
  var isLoading = false;
  var signed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
          create: (context) => AppBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: BlocConsumer<AppBloc, ButtonState>(
          listener: (context, appState) {
            isLoading = appState.isLoading ?? false;
            signed = appState.signedIn ?? false;
            if ((appState.signedIn ?? false)  && !(appState.isLoading ?? false)) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FirstPage()));
            }
          },
          builder: (context, state) {
            print('signed $signed');
            print('isLoading $isLoading');

            if (isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your Faviourite Sign In Page",
                      style: TextStyle(
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextField(

                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,

                      decoration: const InputDecoration(

                        label: Text("Email"),
                        hintText: "Enter you Email",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        label: Text("Password"),
                        hintText: "Enter you Password ",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AppBloc>().add(
                              new LoginEvent(
                                  email: emailController.text,
                                  password: passwordController.text),
                            );
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/*
1 show loading
2 get the request
3 if correct go to next page
4 if not remain
 */
