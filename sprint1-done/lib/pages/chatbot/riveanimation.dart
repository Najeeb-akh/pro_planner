// import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';

// class PlayOneShotAnimation extends StatefulWidget {
//   const PlayOneShotAnimation({Key? key}) : super(key: key);

//   @override
//   _PlayOneShotAnimationState createState() => _PlayOneShotAnimationState();
// }

// class _PlayOneShotAnimationState extends State<PlayOneShotAnimation> {
//   /// Controller for playback
//   late RiveAnimationController _controller;

//   /// Is the animation currently playing?
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     _controller = OneShotAnimation(
//       'bounce',
//       autoplay: false,
//       onStop: () => setState(() => _isPlaying = false),
//       onStart: () => setState(() => _isPlaying = true),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('One-Shot Example'),
//       ),
//       body: Center(
//         child: RiveAnimation.network(
//           'https://cdn.rive.app/animations/vehicles.riv',
//           animations: const ['idle', 'curves'],
//           controllers: [_controller],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         // disable the button while playing the animation
//         onPressed: () => _isPlaying ? null : _controller.isActive = true,
//         tooltip: 'Play',
//         child: const Icon(Icons.arrow_upward),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

// void main() => runApp(MaterialApp(
//       home: MyRiveAnimation(),
//     ));

class MyRiveAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body:  RiveAnimation.asset(
        'assets/rive_animations/cute_robot.riv',
        animations: ['idle', 'wave', 'point', 'walk'],
        fit: BoxFit.fill,
    
        alignment: Alignment(-1, 0),
        ),
    );
  }
}