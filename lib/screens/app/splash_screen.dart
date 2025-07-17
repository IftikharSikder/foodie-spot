import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/app_routes.dart';
import '../../common/base_widgets/custom_snackbar_widgets.dart';
import '../../constants/app_strings.dart';
import '../../helper/network_info.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final internetProvider = Provider.of<InternetProvider>(
        context,
        listen: false,
      );
      final isConnected = internetProvider.hasConnection;
      if (isConnected != internetProvider.lastStatus) {
        internetProvider.setLastStatus(isConnected);
        customSnackBar(
          AppStrings.noInternetMsg,
          isError: !isConnected,
          context,
        );
      }

      if (!internetProvider.navigated) {
        internetProvider.setNavigated(true);
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            context.goNamed(screen.home.name);
          }
        });
      }
    });

    return const Scaffold(body: Center(child: Text("Splash Screen")));
  }
}
