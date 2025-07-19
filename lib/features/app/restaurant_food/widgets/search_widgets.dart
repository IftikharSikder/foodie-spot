import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/app_routes.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_dimensions.dart';
import '../../../../constants/app_strings.dart';

class SearchWidgets extends StatelessWidget {
  const SearchWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.addressPaddingHorizontal,
        AppDimensions.searchPaddingTop,
        AppDimensions.addressPaddingHorizontal,
        AppDimensions.searchPaddingBottom,
      ),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(Screens.search.name);
        },
        child: Material(
          elevation: AppDimensions.searchElevation,
          borderRadius: BorderRadius.circular(AppDimensions.shadowBlurRadius),
          child: Container(
            height: AppDimensions.searchHeight,
            decoration: BoxDecoration(
              color: AppColors.searchBackground,
              borderRadius: BorderRadius.circular(
                AppDimensions.shadowBlurRadius,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: AppDimensions.searchContentPaddingLeft),
                Expanded(
                  child: Text(
                    AppStrings.searchPlaceholder,
                    style: GoogleFonts.poppins(
                      fontSize: AppDimensions.searchFontSize,
                      fontWeight: FontWeight.w400,
                      color: AppColors.navigationInactive,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: AppDimensions.addressPaddingHorizontal,
                  ),
                  child: Icon(
                    Icons.search,
                    color: AppColors.navigationInactive,
                    size: AppDimensions.homeIconSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
