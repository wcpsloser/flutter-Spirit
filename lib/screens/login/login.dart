import 'package:flutter/material.dart';
import 'package:store_app/database/app_database.dart';
import 'package:store_app/screens/home/home.dart';
import 'package:store_app/screens/register/register.dart';

// Boolean variable for keeping track of form validation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool validationLogin = false;

  Future<void> login() async {
    // Implement login functionality here
    final username = usernameController.text;
    final password = passwordController.text;

    await AppDatabase.login(username, password).then((user) {
      if (user == null) {
        debugPrint('Login failed');
        setState(() {
          validationLogin = true;
        });

        return null;
      }

      // Clear text in password textfield
      passwordController.clear();

      // If login is success then go to Home screen and pass user who logged in
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 14, 14, 14),
      body: Center(
        child: Container(
          width: 500.0,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.0),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset:
                    const Offset(0, 3), // changes the position of the shadow
              ),
            ],
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Logo
                Image.asset("assets/pics/Spirit_House.png"),
                const SizedBox(height: 0.20),
                if (validationLogin)
                  RichText(
                      text: const TextSpan(
                          text: "*Username or Password incorrect",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold))),
                const SizedBox(height: 5.0),
                // Username Field
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Password Field
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Login Button
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 200, 32, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),

                // Register Button
                TextButton(
                  onPressed: () {
                    // Implement register button functionality here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Don’t have an account? Sign up',
                    style: TextStyle(
                        color: Color.fromARGB(255, 171, 4, 4), fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
