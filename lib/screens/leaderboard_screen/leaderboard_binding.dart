import 'package:get/get.dart';
import 'package:quiz/screens/leaderboard_screen/leaderboard_controller.dart';

class LeaderboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<LeaderboardController>(
        ()=> LeaderboardController()
    );
  }

}