import 'package:social_ease_app/core/enums/activity_category.dart';
import 'package:social_ease_app/core/res/media_res.dart';

class CategoryInfoMapper {
  static final Map<ActivityCategory, CategoryInfo> categoryInfo =
      _initializeCategoryInfo();

  static Map<ActivityCategory, CategoryInfo> _initializeCategoryInfo() {
    return {
      ActivityCategory.charity: CategoryInfo(
        name: 'Charity',
        image: MediaRes.charity,
      ),
      ActivityCategory.animalWelfare: CategoryInfo(
        name: 'Animal Welfare',
        image: MediaRes.animalWelfare,
      ),
      ActivityCategory.foodAndHunger: CategoryInfo(
        name: 'Hunger',
        image: MediaRes.foodAndHunger,
      ),
      ActivityCategory.education: CategoryInfo(
        name: 'Education',
        image: MediaRes.education,
      ),
      ActivityCategory.environment: CategoryInfo(
        name: 'Environment',
        image: MediaRes.environment,
      ),
      ActivityCategory.elderlyCare: CategoryInfo(
        name: 'Elderly Care',
        image: MediaRes.elderlyCare,
      ),
      ActivityCategory.homelessness: CategoryInfo(
        name: 'Homelessness',
        image: MediaRes.homelessness,
      ),
      ActivityCategory.disasterRelief: CategoryInfo(
        name: 'Disaster Relief',
        image: MediaRes.disasterRelief,
      ),
    };
  }
}

class CategoryInfo {
  final String name;
  final String image;

  CategoryInfo({
    required this.name,
    required this.image,
  });
}
