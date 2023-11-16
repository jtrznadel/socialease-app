import 'package:flutter/material.dart';
import 'package:social_ease_app/core/res/colors.dart';
import 'package:social_ease_app/core/res/fonts.dart';
import 'package:social_ease_app/core/res/media_res.dart';
import 'package:social_ease_app/features/activity/domain/entities/activity.dart';

class RequestViewer extends StatefulWidget {
  const RequestViewer({super.key, required this.requests});

  final List<Activity> requests;

  @override
  State<RequestViewer> createState() => _RequestViewerState();
}

class _RequestViewerState extends State<RequestViewer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(
                  child: widget.requests[_currentIndex].image == null
                      ? Image.asset(MediaRes.defaultActivityBackground)
                      : Image.network(widget.requests[_currentIndex].image!),
                ),
                const Divider(
                  color: Colors.black,
                ),
                Text('Title: ${widget.requests[_currentIndex].title}',
                    style: const TextStyle(fontSize: 24)),
                const Divider(
                  color: Colors.black,
                ),
                Text(
                    'Description: ${widget.requests[_currentIndex].description}',
                    style: const TextStyle(fontSize: 16)),
                const Divider(
                  color: Colors.black,
                ),
                Text('Tags: ${widget.requests[_currentIndex].tags.join(' ,')}',
                    style: const TextStyle(fontSize: 16)),
                const Divider(
                  color: Colors.black,
                ),
                Text('Location: ${widget.requests[_currentIndex].location}',
                    style: const TextStyle(fontSize: 16)),
                const Divider(
                  color: Colors.black,
                ),
                const Text('Time: 23rd December 2023',
                    //TODO: implement time property
                    style: TextStyle(fontSize: 16)),
                const Divider(
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              color: AppColors.secondaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      setState(() {
                        _currentIndex =
                            (_currentIndex + 1) % widget.requests.length;
                      });
                    },
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Colors.red,
                      child: Text(
                        'Deny',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: Fonts.poppins,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Colors.green,
                      child: Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: Fonts.poppins,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      setState(() {
                        _currentIndex =
                            (_currentIndex - 1) % widget.requests.length;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
