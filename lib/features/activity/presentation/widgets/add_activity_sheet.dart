import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/common/widgets/i_field.dart';
import 'package:social_ease_app/core/enums/activity_category.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/core/utils/core_utils.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';
import 'package:social_ease_app/features/activity/presentation/widgets/map_screen.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddActivitySheet extends StatefulWidget {
  const AddActivitySheet({Key? key}) : super(key: key);

  @override
  State<AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends State<AddActivitySheet> {
  ActivityCategory selectedCategory = ActivityCategory.charity;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageController = TextEditingController();
  final tagController = TextfieldTagsController();
  final locationController = TextEditingController();
  late double distanceToField;
  bool requestButtonPressed = false;
  final formKey = GlobalKey<FormState>();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  File? image;

  bool isFile = false;

  bool loading = false;

  LatLng? selectedLocation;

  @override
  void initState() {
    super.initState();
    imageController.addListener(() {
      if (isFile && imageController.text.trim().isEmpty) {
        image = null;
        isFile = false;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    imageController.dispose();
    tagController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActivityCubit, ActivityState>(
      listener: (_, state) {
        if (state is ActivityError) {
          CoreUtils.showSnackBar(context, state.message);
        } else if (state is AddingActivity) {
          loading = true;
          CoreUtils.showLoadingDialog(context);
        } else if (state is ActivityAdded) {
          if (loading) {
            loading = false;
            Navigator.pop(context);
          }
          CoreUtils.showSnackBar(
            context,
            'Request has been sent. Wait for a response from the moderator.',
          );
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Form(
            key: formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Request Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                IField(
                  controller: titleController,
                  labelText: 'Activity Title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                IField(
                  controller: descriptionController,
                  labelText: 'Description',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                IField(
                  controller: imageController,
                  labelText: 'Activity Image',
                  hintText: 'Enter image URL or pick from gallery',
                  hintStyle: const TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 12,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () async {
                      final image = await CoreUtils.pickImage();
                      if (image != null) {
                        isFile = true;
                        this.image = image;
                        final imageName = image.path.split('/').last;
                        imageController.text = imageName;
                      }
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.secondaryTextColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<ActivityCategory>(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    borderRadius: BorderRadius.circular(10),
                    hint: const Text("Select a Category"),
                    value: selectedCategory,
                    onChanged: (ActivityCategory? newValue) {
                      setState(() {
                        selectedCategory = newValue ?? ActivityCategory.charity;
                      });
                    },
                    items: ActivityCategory.values.map((category) {
                      return DropdownMenuItem<ActivityCategory>(
                        value: category,
                        child: Text(category.label),
                      );
                    }).toList(),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryTextColor,
                      fontFamily: Fonts.lato,
                    ),
                    underline: Container(
                      height: 0,
                    ),
                    dropdownColor: AppColors.bgColor,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    isExpanded: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("From "),
                    TimePickerSpinnerPopUp(
                      mode: CupertinoDatePickerMode.date,
                      initTime: startDate,
                      minTime:
                          DateTime.now().subtract(const Duration(minutes: 10)),
                      maxTime: DateTime.now().add(const Duration(days: 30)),
                      barrierColor: Colors.black12,
                      minuteInterval: 1,
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      cancelText: 'Cancel',
                      confirmText: 'OK',
                      pressType: PressType.singlePress,
                      timeFormat: 'dd/MM/yyyy',
                      onChange: (dateTime) {
                        setState(() {
                          startDate = dateTime;
                        });
                      },
                    ),
                    const Text(" To "),
                    TimePickerSpinnerPopUp(
                      mode: CupertinoDatePickerMode.date,
                      initTime: endDate.add(const Duration(days: 1)),
                      minTime:
                          DateTime.now().subtract(const Duration(minutes: 10)),
                      maxTime: DateTime.now().add(const Duration(days: 30)),
                      barrierColor: Colors.black12,
                      minuteInterval: 1,
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      cancelText: 'Cancel',
                      confirmText: 'OK',
                      pressType: PressType.singlePress,
                      timeFormat: 'dd/MM/yyyy',
                      onChange: (dateTime) {
                        setState(() {
                          endDate = dateTime;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: IField(
                        controller: locationController,
                        labelText: 'Location',
                        hintText: 'Enter location',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: (selectedLocation == null &&
                                        requestButtonPressed)
                                    ? Colors.red
                                    : AppColors.secondaryTextColor,
                                width: (selectedLocation == null &&
                                        requestButtonPressed)
                                    ? 1.3
                                    : 1),
                          ),
                          child: IconButton(
                            onPressed: () async {
                              final LatLng? result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MapScreen(),
                                ),
                              );
                              if (result != null) {
                                setState(
                                  () {
                                    selectedLocation = result;
                                  },
                                );
                              }
                            },
                            icon: Icon(
                              Icons.my_location,
                              color: (selectedLocation == null &&
                                      requestButtonPressed)
                                  ? Colors.red
                                  : AppColors.secondaryTextColor,
                            ),
                          ),
                        ),
                        if (selectedLocation == null &&
                            requestButtonPressed) ...[
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "Required",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFieldTags(
                  textfieldTagsController: tagController,
                  initialTags: const [
                    'pick',
                    'your',
                    'tags',
                  ],
                  textSeparators: const [' ', ','],
                  letterCase: LetterCase.normal,
                  inputfieldBuilder:
                      (context, tec, fn, error, onChanged, onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      return TextField(
                        controller: tec,
                        focusNode: fn,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2.0,
                            ),
                          ),
                          helperText: 'Enter tags to describe your activity...',
                          helperStyle: const TextStyle(
                            color: AppColors.primaryColor,
                          ),
                          hintText: tagController.hasTags ? '' : "Enter tag...",
                          errorText: error,
                          prefixIconConstraints:
                              BoxConstraints(maxWidth: distanceToField * 0.74),
                          prefixIcon: tags.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: sc,
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: tags.map((String tag) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          color: AppColors.primaryColor,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onTap: () {
                                                print("$tag selected");
                                              },
                                            ),
                                            const SizedBox(width: 4.0),
                                            InkWell(
                                              child: const Icon(
                                                Icons.cancel,
                                                size: 14.0,
                                                color: Color.fromARGB(
                                                  255,
                                                  233,
                                                  233,
                                                  233,
                                                ),
                                              ),
                                              onTap: () {
                                                onTagDelete(tag);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : null,
                        ),
                        onChanged: onChanged,
                        onSubmitted: onSubmitted,
                      );
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedLocation == null) {
                            setState(() {
                              requestButtonPressed = true;
                            });
                          }
                          if (formKey.currentState!.validate()) {
                            final now = DateTime.now();
                            final activity = ActivityModel.empty().copyWith(
                              title: titleController.text.trim(),
                              description: descriptionController.text.trim(),
                              image: imageController.text.trim().isEmpty
                                  ? MediaRes.defaultActivityBackground
                                  : isFile
                                      ? image!.path
                                      : imageController.text.trim(),
                              category: selectedCategory,
                              createdAt: now,
                              updatedAt: now,
                              startDate: startDate,
                              endDate: endDate,
                              latitude: selectedLocation!.latitude,
                              longitude: selectedLocation!.longitude,
                              location: locationController.text.trim(),
                              imageIsFile: isFile,
                              createdBy: context.currentUser!.uid,
                              tags: tagController.getTags,
                            );
                            context.read<ActivityCubit>().addActivity(activity);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Send a request'),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
