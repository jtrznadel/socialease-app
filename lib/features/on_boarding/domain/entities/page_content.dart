import 'package:equatable/equatable.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.title,
    required this.description,
    required this.image,
  });

  factory PageContent.firstPage() {
    return const PageContent(
        title: 'Welcome to Community Care',
        description:
            "Discover how our app connects you with vital social services and support. Let's get started on your journey to a stronger, more supported community.",
        image: MediaRes.onBoardingImage1);
  }
  factory PageContent.secondPage() {
    return const PageContent(
        title: 'Empowerment Starts Here',
        description:
            "This is where you take control. Learn how our app empowers you to access social resources, make a difference, and build a better future for your community.",
        image: MediaRes.onBoardingImage2);
  }
  factory PageContent.thirdPage() {
    return const PageContent(
        title: 'Your Social Compass',
        description:
            "Navigate the landscape of social assistance effortlessly with our app. We're here to guide you through the resources and help available to you and your community.",
        image: MediaRes.onBoardingImage3);
  }

  final String title;
  final String description;
  final String image;

  @override
  List<Object?> get props => [title, description, image];
}
