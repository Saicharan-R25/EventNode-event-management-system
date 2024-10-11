import 'package:event_node/screens/calendarscreen.dart';
import 'package:event_node/screens/chatscreen.dart';
import 'package:event_node/screens/eventscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Blocs/bottomnavigationbar/bottom_navigation_bloc.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavigationBloc>(
            create: (context) => BottomNavigationBloc()),
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) {
        return Scaffold(
          body:  IndexedStack(
            index: state.currentIndex,
            children: [
              Eventscreen(),
              Chatscreen(),
              Calendarscreen(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: state.currentIndex,
              selectedItemColor: Colors.blue,
              selectedFontSize: 16,
              onTap: (index)=>context.read<BottomNavigationBloc>().add(TabChangedEvent(index: index)),
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home),label: "Events"),
                BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outlined),label: "Chats"),
                BottomNavigationBarItem(icon: Icon(Icons.calendar_month),label: 'Schedule')
              ]),
        );
      },
    );
  }
}


