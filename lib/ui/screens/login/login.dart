import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:evently/data/firestore_utils.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/model/user_dm.dart';
import 'package:evently/ui/providers/theme_provider.dart';
import 'package:evently/ui/providers/language_provider.dart';
import 'package:evently/ui/utils/app_assets.dart';
import 'package:evently/ui/utils/app_colors.dart';
import 'package:evently/ui/utils/app_routes.dart';
import 'package:evently/ui/utils/dialog_utils.dart';
import 'package:evently/ui/widgets/custom_button.dart';
import 'package:evently/ui/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AppLocalizations l10n;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late LanguageProvider languageProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    languageProvider = Provider.of(context);
    themeProvider = Provider.of(context);
    l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                buildAppLogo(context),
                const SizedBox(height: 24),
                buildEmailTextField(),
                const SizedBox(height: 16),
                buildPasswordTextField(),
                const SizedBox(height: 16),
                buildForgetPasswordText(context),
                const SizedBox(height: 24),
                buildLoginButton(),
                const SizedBox(height: 24),
                buildSignUpText(),
                const SizedBox(height: 24),
                buildOrRow(),
                const SizedBox(height: 24),
                buildGoogleLogin(),
                const SizedBox(height: 16),
                buildLanguageToggle(),
                const SizedBox(height: 16),
                buildThemeToggle(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAppLogo(BuildContext context) => Image.asset(
    AppAssets.appVerticalLogo,
    height: MediaQuery.of(context).size.height * 0.2,
  );

  Widget buildEmailTextField() => CustomTextField(
    hint: l10n.emailHint,
    prefixIcon: AppSvg.icEmail,
    controller: emailController,
  );

  Widget buildPasswordTextField() => CustomTextField(
    hint: l10n.passwordHint,
    prefixIcon: AppSvg.icPassword,
    isPassword: true,
    controller: passwordController,
  );

  Widget buildForgetPasswordText(BuildContext context) => Container(
    width: double.infinity,
    child: Text(
      l10n.forgetPassword,
      textAlign: TextAlign.end,
      style: Theme.of(context).textTheme.labelMedium!.copyWith(
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
      ),
    ),
  );

  Widget buildLoginButton() => CustomButton(
    text: l10n.loginButton,
    onClick: () async {
      showLoading(context);
      try {
        var userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text);

        final firebaseUser = userCredential.user;

        if (firebaseUser != null) {
          final user = await getFromUserFirestore(firebaseUser.uid);
          if (user != null) {
            UserDM.currentUser = user;
            Navigator.pop(context);
            Navigator.pushReplacement(context, AppRoutes.home);
          } else {
            Navigator.pop(context);
            showMessage(context,
                content: "User data not found in Firestore.",
                posButtonTitle: "OK");
          }
        } else {
          Navigator.pop(context);
          showMessage(context,
              content: "Failed to sign in. Try again.",
              posButtonTitle: "OK");
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showMessage(context,
            content: e.message ?? "Something went wrong.",
            posButtonTitle: "OK");
      }
    },
  );

  Widget buildSignUpText() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        l10n.dontHaveAccount,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      InkWell(
        onTap: () => Navigator.push(context, AppRoutes.register),
        child: Text(
          l10n.createAccount,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ],
  );

  Widget buildOrRow() => Row(
    children: [
      const Expanded(child: Divider(indent: 24, endIndent: 24)),
      Text(l10n.orText, style: Theme.of(context).textTheme.labelMedium),
      const Expanded(child: Divider(indent: 24, endIndent: 24)),
    ],
  );

  Widget buildGoogleLogin() => CustomButton(
    onClick: () async {
      showLoading(context);
      await signInWithGoogle();
      Navigator.pop(context);
    },
    text: l10n.loginWithGoogle,
    icon: Image.asset('assets/images/google.png', height: 24),
    backgroundColor: Colors.white,
    textColor: Colors.black,
  );

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print("Google sign-in aborted.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      print("Access Token: ${googleAuth.accessToken}");
      print("ID Token: ${googleAuth.idToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        print("User Signed In: ${firebaseUser.email}");

        // You can now continue to your Firestore logic
        // ...
      } else {
        print("Firebase user is null");
      }
    } catch (e) {
      print("Google Sign-In failed: $e");
    }
  }


  Widget buildLanguageToggle() => AnimatedToggleSwitch<String>.dual(
    current: languageProvider.currentLocale,
    iconBuilder: (lang) =>
        Image.asset(lang == "ar" ? AppAssets.icEg : AppAssets.icUsa),
    first: "ar",
    second: "en",
    onChanged: (lang) => languageProvider.changeLanguage(lang),
  );

  Widget buildThemeToggle() => AnimatedToggleSwitch<ThemeMode>.dual(
    current: themeProvider.mode,
    iconBuilder: (mode) => Icon(
        mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
    first: ThemeMode.light,
    second: ThemeMode.dark,
    onChanged: (mode) => themeProvider.changeMode(mode),
  );
}
