import 'package:evently/model/event_dm.dart';
import 'package:evently/ui/screens/add_event/add_event.dart';
import 'package:evently/ui/screens/edit_event/edit_event.dart';
import 'package:evently/ui/screens/event_details/event_details.dart';
import 'package:evently/ui/screens/home/home.dart';
import 'package:evently/ui/screens/login/login.dart';
import 'package:evently/ui/screens/on_boarding/on_boarding.dart';
import 'package:evently/ui/screens/register/register.dart';
import 'package:flutter/material.dart';

abstract final class AppRoutes {
  static Route get login {
    return MaterialPageRoute(builder: (_) => const Login());
  }

  static Route get home {
    return MaterialPageRoute(builder: (_) => const Home());
  }

  static Route get register {
    return MaterialPageRoute(builder: (_) => const Register());
  }

  static Route get addEvent {
    return MaterialPageRoute(builder: (_) => const AddEvent());
  }

  static Route get onBoarding {
    return MaterialPageRoute(builder: (_) => const OnBoarding());
  }

  static Route eventDetails(EventDM event) {
    return MaterialPageRoute(builder: (_) => EventDetails(event: event));
  }

  static Route editEvent(EventDM event) {
    return MaterialPageRoute(builder: (_) => EditEvent(event: event));
  }

}