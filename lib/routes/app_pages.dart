import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:quiz/screens/leaderboard_screen/leaderboard_binding.dart';
import 'package:quiz/screens/leaderboard_screen/leaderboard_screen.dart';
import 'package:quiz/screens/resultScreen/result_binding.dart';
import 'package:quiz/screens/resultScreen/results_screen.dart';

import '../screens/home/home_screens.dart';
import '../screens/quiz/quiz_screen.dart';

class AppPages{

  static const INITIAL = '/';

  static final routes = [
    GetPage(
        name: '/',
        page: () => const HomeScreen(),
    ),

    GetPage(
      name: '/leaderboard',
      page: () => const LeaderboardScreen(),
      binding: LeaderboardBinding()
    ),

    GetPage(
        name: '/results',
        page: () => const ResultsScreen(),
        binding: ResultBinding()
    ),

    GetPage(
        name: '/quiz',
        page: () => const QuizScreen(),
        binding: ResultBinding()
    ),

  ];

}