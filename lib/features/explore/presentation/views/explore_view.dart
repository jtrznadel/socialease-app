import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/common/widgets/gradient_background.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/explore/presentation/refactors/explore_body.dart';
import 'package:social_ease_app/features/explore/presentation/widgets/explore_app_bar.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ExploreAppBar(),
      body: GradientBackground(
        image: MediaRes.dashboardGradient,
        child: ExploreBody(),
      ),
    );
  }
}
