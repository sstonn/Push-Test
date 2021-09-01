import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pushy_flutter/pushy_flutter.dart';
import 'package:pushy_test/notification_service.dart';

void backgroundNotificationListener(Map<String, dynamic> data) {
  // Print notification payload data
  print('Received notification: $data');

  // Notification title
  String notificationTitle = 'MyApp';

  // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
  String notificationText = data['message'] ?? 'Hello World!';

  // Android: Displays a system notification
  // iOS: Displays an alert dialog
  NotificationService().showNotification();

  // Clear iOS app badge number
  Pushy.clearBadge();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Pushy.listen();
    pushyRegister();
    Pushy.setNotificationListener(backgroundNotificationListener);

    Pushy.setNotificationClickListener((data) {
      // Print notification payload data
      print('Received notification: $data');

      // Notification title
      String notificationTitle = 'MyApp';

      // Attempt to extract the "message" property from the payload: {"message":"Hello World!"}
      String notificationText = data['message'] ?? 'Hello World!';

      // Android: Displays a system notification
      // iOS: Displays an alert dialog
      Pushy.notify(notificationTitle, notificationText, data);

      // Clear iOS app badge number
      Pushy.clearBadge();
    });
  }

  Future pushyRegister() async {
    try {
      // Register the user for push notifications
      String deviceToken = await Pushy.register();

      // Print token to console/logcat
      print('Device token: $deviceToken');

      // Display an alert with the device token
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Pushy'),
                content: Text('Pushy device token: $deviceToken'),
                actions: [
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      })
                ]);
          });

      // Optionally send the token to your backend server via an HTTP GET request
      // ...
    } on PlatformException catch (error) {
      // Display an alert with the error message
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text('Error'),
                content: Text(error.message!),
                actions: [
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      })
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(),
      ),
    );
  }
}
