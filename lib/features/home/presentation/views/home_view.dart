import 'package:flutter/material.dart';
import 'package:social_ease_app/features/home/presentation/refactors/home_body.dart';
import 'package:social_ease_app/features/home/presentation/widgets/home_app_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: HomeAppBar(),
      extendBodyBehindAppBar: false,
      body: HomeBody(),
    );
  }
}
