import 'package:flutter/material.dart';

import 'package:easy_cal/features/home/presentation/screens/homeScreen.dart';
import 'package:easy_cal/features/history/presentation/screen/history_screen.dart';

import '../../../../data_models/nutrition_data_model.dart';
import '../../../bmi_calculator/presentation/screens/bmi_calculator.dart';
import '../../../bmr_calculator/presentation/screens/bmr_calculator.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  final List<FoodNutrition> _dailyHistory = [];
  DateTime _currentDate = DateTime.now();

  final GlobalKey _homeScreenKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkAndResetHistory();
  }

  void _checkAndResetHistory() {
    final now = DateTime.now();
    if (now.day != _currentDate.day || now.month != _currentDate.month || now.year != _currentDate.year) {
      setState(() {
        _dailyHistory.clear();
        _currentDate = now;
      });
    }
  }

  void _addToHistory(FoodNutrition nutrition) {
    setState(() {
      _dailyHistory.add(nutrition);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Homescreen(key: _homeScreenKey, onNutritionAnalyzed: _addToHistory),
          HistoryScreen(dailyHistory: _dailyHistory),
          BmrCalculator(),
          BmiCalculator(),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            label: 'BMR',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            label: 'BMI',
          ),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }
}