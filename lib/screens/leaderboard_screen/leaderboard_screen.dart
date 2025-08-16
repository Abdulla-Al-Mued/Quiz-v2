
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz/screens/leaderboard_screen/widgets/leaderboard_widgets.dart';
import 'leaderboard_controller.dart';

class LeaderboardScreen extends GetView<LeaderboardController> {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Gradient
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Get.theme.primaryColor.withOpacity(0.8),
                    Get.theme.primaryColor.withOpacity(0.7),
                    Get.theme.primaryColor.withOpacity(0.5),
                  ],
                ),
              ),
              child: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.leaderboard,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Leaderboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
            ),
            actions: [
              Obx(() {
                if (controller.scores.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'clear') {
                            controller.showClearDialog();
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'clear',
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: const Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red, size: 20),
                                  SizedBox(width: 12),
                                  Text('Clear All', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Obx(() {
              if (controller.isLoading.value) {
                return SizedBox(
                  height: Get.height * 0.6,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Get.theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading leaderboard...',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (controller.scores.isEmpty) {
                return buildEmptyState(controller);
              }

              return Column(
                children: [
                  // Modern Stats Header
                  buildModernStatsHeader(controller),
                  const SizedBox(height: 8),

                  // Leaderboard List
                  RefreshIndicator(
                    onRefresh: () async => controller.loadScores(),
                    color: Get.theme.primaryColor,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: controller.scores.length,
                      itemBuilder: (context, index) {
                        final score = controller.scores[index];
                        final rank = index + 1;
                        return buildLeaderboardItem(controller, score, rank);
                      },
                    ),
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ],
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Get.theme.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: controller.goToHome,
          backgroundColor: Get.theme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          icon: const Icon(Icons.home_rounded),
          label: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}