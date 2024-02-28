import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_ease_app/core/extensions/context_extension.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/features/activity/data/models/comment_model.dart';
import 'package:social_ease_app/features/activity/presentation/cubit/cubit/activity_cubit.dart';

class CommentInputField extends StatefulWidget {
  final String activityId;

  const CommentInputField({Key? key, required this.activityId})
      : super(key: key);

  static final _formKey = GlobalKey<FormState>();

  @override
  _CommentInputFieldState createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Form(
        key: CommentInputField._formKey,
        child: TextFormField(
          keyboardType: TextInputType.text,
          controller: _controller,
          minLines: 1,
          maxLines: 2,
          style: TextStyle(fontSize: 14, fontFamily: Fonts.poppins),
          decoration: InputDecoration(
            hintText: "Comment",
            hintStyle: TextStyle(
              color: AppColors.secondaryTextColor,
              fontFamily: Fonts.poppins,
            ),
            filled: true,
            fillColor: AppColors.fieldInputColor,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 22,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            suffixIcon: Transform.scale(
              scale: .8,
              child: Material(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: IconButton(
                    onPressed: () {
                      _onAddCommentPressed(context);
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onAddCommentPressed(BuildContext context) {
    final comment = _controller.text.trim();
    if (comment.isEmpty) return;
    context.read<ActivityCubit>().addComment(
          activityId: widget.activityId,
          comment: CommentModel.empty().copyWith(
            content: comment,
            createdBy: context.currentUser!.uid,
          ),
        );
    _controller.clear();
  }
}
