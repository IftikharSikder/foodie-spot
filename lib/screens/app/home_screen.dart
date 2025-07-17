import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/base_widgets/custom_snackbar_widgets.dart';
import '../../constants/app_strings.dart';
import '../../features/banner/widgets/banner_carousel_widget.dart';
import '../../helper/network_info.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final isConnected = internetProvider.hasConnection;

          if (isConnected != internetProvider.lastStatus) {
            internetProvider.setLastStatus(isConnected);

            customSnackBar(
              AppStrings.noInternetMsg,
              isError: !isConnected,
              context,
            );
          }
        });

        return const Scaffold(body: Column(children: [BannerCarouselWidget()]));
      },
    );
  }
}
