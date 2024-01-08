enum PointsValue {
  orderKeeping(value: 30),
  violation(value: 50),
  activityCreated(value: 60),
  activityCompleted(value: 80);

  const PointsValue({required this.value});

  final int value;
}
