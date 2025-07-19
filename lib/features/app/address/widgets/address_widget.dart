import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_dimensions.dart';
import '../../../../constants/app_strings.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppDimensions.addressPaddingTop,
        left: AppDimensions.addressPaddingHorizontal,
        right: AppDimensions.addressPaddingHorizontal,
        bottom: AppDimensions.addressPaddingTop,
      ),
      child: Row(
        children: [
          Icon(
            Icons.home,
            color: AppColors.iconGrey,
            size: AppDimensions.homeIconSize,
          ),
          SizedBox(width: AppDimensions.iconSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.defaultAddress,
                  style: GoogleFonts.inter(
                    fontSize: AppDimensions.addressFontSize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Icon(
                Icons.notifications,
                size: AppDimensions.notificationIconSize,
                color: AppColors.textColor,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: AppDimensions.notificationDotSize,
                  height: AppDimensions.notificationDotSize,
                  decoration: BoxDecoration(
                    color: AppColors.notificationDot,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.background,
                      width: AppDimensions.dotBorderWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
