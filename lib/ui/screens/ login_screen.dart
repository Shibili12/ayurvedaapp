import 'package:ayurvedaapp/ui/screens/patients_list_screen.dart';
import 'package:ayurvedaapp/ui/widgets/myButton.dart';
import 'package:ayurvedaapp/ui/widgets/mytextfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PatientsListScreen()),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed. Please try again.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 217,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/splash.jpg",
                      ),
                      fit: BoxFit.fitHeight,
                      opacity: .3)),
              child: Center(
                child: Image.asset(
                  "assets/assetsmall.png",
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Text("Login or register to book your appointments",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Color.fromRGBO(64, 64, 64, 1))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 8),
              child: Text("Email",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color.fromRGBO(64, 64, 64, 1))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
              child: MyTextfieldWidget(
                controller: _usernameController,
                hint: "Enter your Email",
                onpressed: () {},
                validator: (val) {
                  return val == null || val.isEmpty ? "Enter username" : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Text("Password",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color.fromRGBO(64, 64, 64, 1))),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 8),
              child: MyTextfieldWidget(
                controller: _passwordController,
                hint: "Enter password",
                onpressed: () {},
                validator: (val) {
                  val == null || val.isEmpty ? "Enter password" : null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 8),
              child: Mybutton(
                  title: "Login", onTap: authProvider.loading ? null : _login),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 39, 16, 8),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'By creating or logging into an account you are agreeing with our ',
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(64, 64, 64, 1),
                          fontWeight: FontWeight.w300,
                          fontSize: 12),
                    ),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(0, 40, 252, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(64, 64, 64, 1),
                          fontWeight: FontWeight.w300,
                          fontSize: 12),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(0, 40, 252, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                    TextSpan(
                      text: '.',
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(64, 64, 64, 1),
                          fontWeight: FontWeight.w300,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )

        //  Center(
        //   child: SingleChildScrollView(
        //     padding: const EdgeInsets.all(24),
        //     child: Form(
        //       key: _formKey,
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           // App title or logo
        //           const Text(
        //             "Ayurvedic Centre",
        //             style: TextStyle(
        //               fontSize: 28,
        //               fontWeight: FontWeight.bold,
        //             ),
        //           ),
        //           const SizedBox(height: 40),

        //           // Username
        //           TextFormField(
        //             controller: _usernameController,
        //             decoration: const InputDecoration(
        //               labelText: "Username",
        //               border: OutlineInputBorder(),
        //             ),
        //             validator: (val) =>
        //                 val == null || val.isEmpty ? "Enter username" : null,
        //           ),
        //           const SizedBox(height: 16),

        //           // Password
        //           TextFormField(
        //             controller: _passwordController,
        //             obscureText: true,
        //             decoration: const InputDecoration(
        //               labelText: "Password",
        //               border: OutlineInputBorder(),
        //             ),
        //             validator: (val) =>
        //                 val == null || val.isEmpty ? "Enter password" : null,
        //           ),
        //           const SizedBox(height: 24),

        //           // Login button
        //           SizedBox(
        //             width: double.infinity,
        //             height: 48,
        //             child: ElevatedButton(
        //               onPressed: authProvider.loading ? null : _login,
        //               child: authProvider.loading
        //                   ? const CircularProgressIndicator(
        //                       color: Colors.white,
        //                     )
        //                   : const Text("Login"),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        );
  }
}
