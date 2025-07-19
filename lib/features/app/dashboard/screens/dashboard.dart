import 'package:flutter/material.dart';

import '../../../web/dashboard/dashboard_web.dart';
import '../provider/landing_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return LandingPage();
        } else {
          return DashboardWeb();
        }
      },
    );
  }
}
