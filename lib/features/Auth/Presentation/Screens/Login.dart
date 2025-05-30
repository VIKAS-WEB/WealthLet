import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthlet/core/utils/Colorfields.dart';
import 'package:wealthlet/features/Auth/Bloc/auth_bloc.dart';
import 'package:wealthlet/features/Auth/Bloc/auth_event.dart';
import 'package:wealthlet/features/Auth/Bloc/auth_state.dart';
import 'package:wealthlet/features/Auth/Presentation/Screens/SignUp.dart';
import 'package:wealthlet/features/Home/Presentation/Screens/HomeScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Navigate to HomeScreen on success
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (context) =>  HomeScreen()),
            );
          } else if (state is AuthFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: ColorsField.offerRed,),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 60.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Image.asset('assets/images/WealthLet.png', width: 250),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                          child: Divider(color: Colors.black12, thickness: 1),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          "LOGIN",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Let's fill up this form and fill it correctly",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 50.0),
                        // Email TextField
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email, color: Colors.grey),
                            hintText: 'Email',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Password TextField
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                            suffixIcon: const Icon(Icons.visibility, color: Colors.grey),
                            hintText: 'Password',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Implement forgot password logic here
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                color: const Color(0xFFD1493B),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Conditional Login Button or Progress Indicator
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) {
                              return CircularProgressIndicator(
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD1493B)),
                              );
                            }
                            return ElevatedButton(
                              onPressed: () {
                                // Dispatch login event to BLoC
                                context.read<AuthBloc>().add(
                                      LoginRequested(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ),
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD1493B),
                                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40.0),
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, CupertinoPageRoute(builder: (context) => const SignUp()));
                          },
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: const Color(0xFFD1493B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}