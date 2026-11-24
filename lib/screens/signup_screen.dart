import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/custom_text_field.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must be at least 6 characters');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);

      await userCredential.user?.reload();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      String message;

      switch (error.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'invalid-email':
          message = 'Please enter a valid email';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'network-request-failed':
          message = 'Check your internet connection';
          break;
        default:
          message = error.message ?? 'Registration failed';
      }

      showMessage(message);
    } catch (error) {
      if (!mounted) return;

      showMessage('Something went wrong');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Image.asset(
                "assets/logo/logo1.jfif",
                width: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                hint: "Full Name",
                icon: Icons.person_outline,
controller: nameController,
),
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
CustomTextField(
hint: "Confirm Password",
icon: Icons.lock_outline,
isPassword: true,
controller: confirmPasswordController,
),
const SizedBox(height: 20),
SizedBox(
width: double.infinity,
height: 55,
child: ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primary,
),
onPressed: isLoading ? null : signUp,
child: isLoading
? const CircularProgressIndicator(
color: Colors.white,
)
    : const Text(
"Sign Up",
style: TextStyle(
color: Colors.white,
),
),
),
),
],
),
),
),
);
}
}