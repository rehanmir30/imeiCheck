
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:imei/screens/add_fund/add_fund_screen.dart';
import 'package:imei/utils/app_text_styles.dart';
import 'package:imei/utils/colors.dart';

import '../screens/account/account_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/imei/imei_check_screen.dart';
import '../screens/result/result_screen.dart';

class CustomBottomNavigation extends StatefulWidget {

  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigation();
}

class _CustomBottomNavigation extends State<CustomBottomNavigation>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  static  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    IMEICheckScreen(),
    ResultScreen(),
    AddFundScreen(),
    AccountScreen()  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<BottomNavigationBarItem> _bottomNavigationBarItem = [
    const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
        tooltip: 'Home',
        backgroundColor: AppColors.kPrimary
    ),
    const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'IMEI CHECK',
        backgroundColor: AppColors.kPrimary
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Result',
      backgroundColor: AppColors.kPrimary,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.payments_sharp),
      label: 'Add Fund',
      backgroundColor:AppColors.kPrimary,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Account',
      backgroundColor: AppColors.kPrimary,
    ),
  ];


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
        bottomNavigationBar: BottomNavigationBar(
            items:  _bottomNavigationBarItem,
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.kWhiteColor,
            unselectedItemColor: AppColors.kBlackTextColor,
            unselectedFontSize: 10,
            showUnselectedLabels: true,
            iconSize: 27,
            onTap: _onItemTapped,
            elevation: 10,
          selectedFontSize: 10,
        ),
    );
  }
}
