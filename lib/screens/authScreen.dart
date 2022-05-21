import 'package:flutter/material.dart';
import 'package:test_tyba/widgets/loginWidget.dart';

/**
 * Screen in which the user can login, register or send a reset password email
 */
class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).colorScheme.primary),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                    transform: Matrix4.rotationZ(-0.05)..translate(0.0, -30.0),
                    child: Text(
                      '¡Restaurantes App!',
                      style: TextStyle(
                          fontSize: 35,
                          color: Theme.of(context).colorScheme.background),
                    ))),
            Flexible(
              flex: 2,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 400),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.all(15),
                  elevation: 10,
                  color: Theme.of(context).colorScheme.background,
                  child: LoginWidget(),
                ),
              ),
            ),
          ],
        )));
  }
}
