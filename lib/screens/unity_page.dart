/*
  Page displaying Unity,
  - with rounded corners,
  - with Flutter UI around,
  - with a button (duplicates buton on app bar, but I wanted to make sure I can do it)
    that goes back to the previous page.

  This is based on
  - default Flutter template MyHomePage
  - "Communicating with and from Unity" sample from https://pub.dev/packages/flutter_unity_widget
  - with some tweaks and experiments.
*/

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class UnityPage extends StatefulWidget {
  const UnityPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<UnityPage> createState() => _UnityPageState();
}

class _UnityPageState extends State<UnityPage> {
  UnityWidgetController? _unityWidgetController;
  double _sliderValue = 0.0;
  String _rotationFromUnity = "";

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the UnityPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Card(
        margin: const EdgeInsets.all(8),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: <Widget>[
            UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityMessage: onUnityMessage,
              onUnitySceneLoaded: onUnitySceneLoaded,
              fullscreen: false,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              // <You need a PointerInterceptor here on web>
              child: Card(
                elevation: 10,
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Change position in Unity:"),
                    ),
                    Slider(
                      onChanged: (value) {
                        setState(() {
                          _sliderValue = value;
                        });
                        sendToUnity(value.toString());
                      },
                      value: _sliderValue,
                      min: 0.0,
                      max: 1.0,
                    ),
                    ElevatedButton(
                      onPressed: buttonBackPressed,
                      child: const Text('Back (page without Unity)'),
                    ),
                    Text(_rotationFromUnity),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void buttonBackPressed() {
    // see https://docs.flutter.dev/cookbook/navigation/navigation-basics
    Navigator.pop(context);
  }

  // Communication from Flutter to Unity
  void sendToUnity(String valueToSend) {
    _unityWidgetController?.postMessage(
      'Cube',
      'MessageFromFlutter',
      valueToSend,
    );
  }

  // Communication from Unity to Flutter
  void onUnityMessage(message) {
    debugPrint('Received message from unity: ${message.toString()}');
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // xxx without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _rotationFromUnity = message.toString();
    });
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  // Communication from Unity when new scene is loaded to Flutter
  void onUnitySceneLoaded(SceneLoaded? sceneInfo) {
    if (sceneInfo != null) {
      debugPrint('Received scene loaded from unity: ${sceneInfo.name}');
      debugPrint(
          'Received scene loaded from unity buildIndex: ${sceneInfo.buildIndex}');
    }
  }
}
