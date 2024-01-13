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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Form(
        key: CommentInputField._formKey,
        child: TextField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          controller: _controller,
          minLines: 1,
          maxLines: 5,
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
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ),
          ),
          onSubmitted: (value) {
            _onAddCommentPressed();
          },
        ),
      ),
    );
  }

  void _onAddCommentPressed() {
    final comment = _controller.text.trim();
    if (comment.isEmpty) return;
    _controller.clear();
    context.read<ActivityCubit>().addComment(
          activityId: widget.activityId,
          comment: CommentModel.empty().copyWith(
            content: comment,
            createdBy: context.currentUser!.uid,
          ),
        );
  }
}
