import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_ease_app/core/enums/report_enum.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/auth/domain/entites/user.dart';
import 'package:social_ease_app/features/reports/data/models/report_model.dart';
import 'package:social_ease_app/features/reports/presentation/cubit/report_cubit.dart';

class UserProfileModal extends StatefulWidget {
  final LocalUser user;

  const UserProfileModal({super.key, required this.user});

  @override
  State<UserProfileModal> createState() => _UserProfileModalState();
}

class _UserProfileModalState extends State<UserProfileModal> {
  bool isMessageFieldVisible = false;
  bool isReportFieldVisible = false;
  final messageController = TextEditingController();
  final reportController = TextEditingController();
  ReportCategory? selectedCategory;
  final _messageFormKey = GlobalKey<FormState>();
  final _reportFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    messageController.dispose();
    reportController.dispose();
    super.dispose();
  }

  void toggleMessageField() {
    setState(() {
      isMessageFieldVisible = !isMessageFieldVisible;
      if (isMessageFieldVisible) isReportFieldVisible = false;
    });
  }

  void toggleReportField() {
    setState(() {
      isReportFieldVisible = !isReportFieldVisible;
      if (isReportFieldVisible) isMessageFieldVisible = false;
    });
  }

  void sendMessage() {
    String message = messageController.text;
    // Your send message logic here
    // Clear the message field after sending
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        backgroundImage: widget.user.profilePic != null
                            ? NetworkImage(widget.user.profilePic!)
                            : const AssetImage(MediaRes.defaultAvatarImage)
                                as ImageProvider,
                        radius: 30.0,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.user.fullName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(widget.user.accountLevel.label,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white70)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      widget.user.bio ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryTextColor,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (widget.user != context.currentUser!) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite_outline,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              toggleMessageField();
                            },
                            icon: const Icon(
                              Icons.mail_outline,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              toggleReportField();
                            },
                            icon: const Icon(
                              Icons.flag_outlined,
                            ),
                          )
                        ],
                      ),
                    ],
                    if (isMessageFieldVisible) ...[
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.secondaryTextColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40),
                              child: Form(
                                key: _messageFormKey,
                                child: TextFormField(
                                  controller: messageController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the message';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your message here',
                                    border: InputBorder.none,
                                    errorStyle: TextStyle(height: 2),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                  ),
                                  maxLines: null,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.black),
                              onPressed: () {
                                if (_messageFormKey.currentState?.validate() ??
                                    false) {
                                  context
                                      .read<ReportCubit>()
                                      .addReport(ReportModel.empty());
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (isReportFieldVisible) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Colors.blueAccent, width: 2),
                                color: Colors.white,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<ReportCategory>(
                                  value: selectedCategory,
                                  hint: const Text('Select Report Category'),
                                  isExpanded: true,
                                  items: ReportCategory.values
                                      .map((ReportCategory category) {
                                    return DropdownMenuItem<ReportCategory>(
                                      value: category,
                                      child: Text(
                                          category.toString().split('.').last),
                                    );
                                  }).toList(),
                                  onChanged: (ReportCategory? newValue) {
                                    setState(() {
                                      selectedCategory = newValue;
                                    });
                                  },
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  dropdownColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.secondaryTextColor,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: Form(
                                  key: _reportFormKey,
                                  child: TextFormField(
                                    controller: reportController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please describe the issue';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'Describe the issue',
                                      border: InputBorder.none,
                                      errorStyle: TextStyle(height: 2),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                    maxLines: null,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (_reportFormKey.currentState?.validate() ??
                                    false) {
                                  context
                                      .read<ReportCubit>()
                                      .addReport(ReportModel.empty());
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Submit Report'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showUserProfileModal(BuildContext context, LocalUser user) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return UserProfileModal(user: user);
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 500),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
