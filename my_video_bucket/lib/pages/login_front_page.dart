import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_photo_bucket/pages/email_password_auth_page.dart';

class LoginFrontPage extends StatefulWidget {
  const LoginFrontPage({super.key});

  @override
  State<LoginFrontPage> createState() => _LoginFrontPageState();
}

class _LoginFrontPageState extends State<LoginFrontPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  "Photo Bucket",
                  style: TextStyle(
                    fontSize: 56.0,
                  ),
                ),
              ),
            ),
            LoginButton(
              title: "Log in",
              callback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const EmailPasswordAuthPage(isNewUser: false);
                    },
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    print("TODO: Go to the next page to create an account in");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const EmailPasswordAuthPage(isNewUser: true);
                        },
                      ),
                    );
                  },
                  child: const Text("Sign Up Here"),
                ),
              ],
            ),
            const SizedBox(
              height: 60.0,
            ),
            LoginButton(
                title: "Or sign in with Google",
                callback: () {
                  print(
                      "TODO: Log in using Firebase Auth and an OAuth provider (like Google)");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SignInScreen(
                          // providers: [],
                          actions: [
                            AuthStateChangeAction((context, state) {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            }),
                          ],
                        );
                      },
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final String title;
  final Function() callback;
  const LoginButton({
    required this.title,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40.0,
        width: 250.0,
        margin: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: callback,
          child: Text(
            title,
            style: const TextStyle(fontSize: 16.0),
          ),
        ));
  }
}