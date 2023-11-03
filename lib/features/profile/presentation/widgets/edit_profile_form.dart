import 'package:flutter/material.dart';
import 'package:social_ease_app/core/common/widgets/i_field.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/extensions/string_extensions.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.oldPasswordController,
    required this.bioController,
    super.key,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController oldPasswordController;
  final TextEditingController bioController;

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IField(
          controller: widget.fullNameController,
          labelText: 'Full Name',
        ),
        const SizedBox(
          height: 20,
        ),
        IField(
          controller: widget.emailController,
          labelText: 'E-mail',
          hintText: context.currentUser!.email.obscureEmail,
        ),
        const SizedBox(
          height: 20,
        ),
        IField(
          controller: widget.oldPasswordController,
          labelText: 'Current password',
          hintText: '******',
        ),
        const SizedBox(
          height: 20,
        ),
        StatefulBuilder(builder: (_, setState) {
          widget.oldPasswordController.addListener(() => setState(() {}));
          return IField(
            controller: widget.passwordController,
            labelText: 'New password',
            hintText: '******',
            readOnly: widget.oldPasswordController.text.isEmpty,
          );
        }),
        const SizedBox(
          height: 20,
        ),
        IField(
          controller: widget.bioController,
          labelText: 'Bio',
          hintText: context.currentUser!.bio,
        )
      ],
    );
  }
}
