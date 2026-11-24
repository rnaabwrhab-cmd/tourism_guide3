import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final emailController = TextEditingController();
final passwordController = TextEditingController();

bool isLoading = false;

@override
void dispose() {
emailController.dispose();
passwordController.dispose();
super.dispose();
}

Future<void> login() async {
if (emailController.text.trim().isEmpty ||
passwordController.text.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Please enter email and password'),
),
);
return;
}

setState(() {
isLoading = true;
});

try {
await FirebaseAuth.instance.signInWithEmailAndPassword(
email: emailController.text.trim(),
password: passwordController.text,
);

if (!mounted) return;

Navigator.pushReplacement(
context,
MaterialPageRoute(
builder: (_) => HomeScreen(),
),
);
} on FirebaseAuthException catch (error) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(error.message ?? 'Login failed'),
),
);
} catch (error) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Something went wrong'),
),
);
} finally {
if (mounted) {
setState(() {
isLoading = false;
});
}
}
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.white,
body: SafeArea(
child: SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(25),
child: Column(
children: [
const SizedBox(height: 30),
const Text(
"Welcome Back",
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 15),
Image.asset(
"assets/logo/logo1.jfif",
width: 200,
),
const SizedBox(height: 30),
CustomTextField(
hint: "Email",
icon: Icons.email_outlined,
controller: emailController,
keyboardType: TextInputType.emailAddress,
),
CustomTextField(
hint: "Password",
icon: Icons.lock_outline,
isPassword: true,
controller: passwordController,
),
Align(
alignment: Alignment.centerRight,
child: TextButton(
onPressed: () {},
child: const Text("Forgot Password?"),
),
),
const SizedBox(height: 20),
SizedBox(
width: double.infinity,
height: 55,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primary,
),
onPressed: isLoading ? null : login,
child: isLoading
? const CircularProgressIndicator(color: Colors.white,
)
    : const Text(
  "Login",
  style: TextStyle(
    color: Colors.white,
  ),
),
),
),
  const SizedBox(height: 25),
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account?"),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SignupScreen(),
            ),
          );
        },
        child: const Text("Sign Up"),
      ),
    ],
  ),
],
),
),
),
),
);
}
}