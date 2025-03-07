import 'package:flutter/material.dart';
import 'package:instaflurt3/provider/user_provider.dart';
import 'package:instaflurt3/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget mobile;
  final Widget web;

  const ResponsiveLayout({super.key, required this.mobile, required this.web});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userprovider = Provider.of(context, listen: false);
    userprovider.refreshUser(); // refresh user data
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > webScreenSize) {
        return widget.web;
      } else {
        return widget.mobile;
      }
    });
  }
}
