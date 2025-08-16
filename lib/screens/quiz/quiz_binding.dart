import 'package:get/get.dart';
import 'package:quiz/screens/quiz/QuizController.dart';
import 'package:quiz/screens/resultScreen/results_controller.dart';

class ResultBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<QuizController>(
            ()=> QuizController()
    );
  }

}