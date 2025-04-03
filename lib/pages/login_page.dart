// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:in_out/models/users.dart';
import 'package:in_out/pages/home_page.dart';
import 'package:in_out/servicies/login_service.dart';
import 'package:in_out/utils/string_validations.dart';
import 'package:in_out/widgets/login_info_dialog.dart';
import 'package:in_out/widgets/my_button.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final user = User();
  final passcontroller = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (user.email.isNotEmpty && user.pass.isNotEmpty) {
      passcontroller.text = user.pass;
      emailController.text = user.email;
      _login(context, user.email, user.pass);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: kblack,
        body: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black12,
                        Colors.black38,
                        Colors.black54,
                        Colors.black54,
                        Colors.black38,
                        Colors.black12,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: kLittleSpace + 4,
                      right: kLittleSpace + 4,
                      bottom: kLittleSpace,
                      top: kLittleSpace,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text.rich(
                            const TextSpan(children: [
                              TextSpan(
                                text: 'Your\n',
                              ),
                              TextSpan(
                                text: 'financial\n',
                              ),
                              TextSpan(
                                  text: 'growth\n', style: TextStyle(color: kLightGreen)),
                              TextSpan(
                                text: 'starts\n',
                              ),
                              TextSpan(
                                text: 'here.',
                              ),
                            ]),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: kBlueGrey,
                                fontSize: MediaQuery.of(context).size.height * .085),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _enterAsGuest(context);
                          },
                          child: const Text(
                            'Tap here to enter as guest',
                            style: TextStyle(color: kRed),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return LoginInfo(
                                  email: emailController.text,
                                  pass: passcontroller.text,
                                );
                              },
                            );
                          },
                          child: const Text(
                            'First time? create an account now',
                            style: TextStyle(color: kBlueGrey),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .85,
                          padding: const EdgeInsets.all(kSpace),
                          decoration: BoxDecoration(boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 3,
                              offset: Offset(2, 2),
                            )
                          ], color: kBlueGrey, borderRadius: 20.toRadio()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                ),
                              ),
                              TextField(
                                controller: passcontroller,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: const InputDecoration(hintText: 'Password'),
                              ),
                              const SizedBox(height: kSpace),
                            ],
                          ),
                        ),
                        const SizedBox(height: kSpace),
                        MyButton(
                          tittle: 'Log in',
                          onTap: () async {
                            if (emailController.text.isNotEmpty &&
                                passcontroller.text.isNotEmpty) {
                              _login(
                                context,
                                emailController.text,
                                passcontroller.text,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: kSpace),
                        MyButton(
                          tittle: 'Sign in',
                          onTap: () {
                            if (emailController.text.isEmail() &&
                                isValidPassword(passcontroller.text)) {
                              return _signIn(
                                context,
                                emailController.text,
                                passcontroller.text,
                              );
                            } else {
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return LoginInfo(
                                    email: emailController.text,
                                    pass: passcontroller.text,
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
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

  Future<void> _enterAsGuest(BuildContext context) async {
    await Provider.of<LoginService>(context, listen: false).createGuest();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  Future<void> _login(BuildContext context, String mail, String pass) async {
    final isLogged = await Provider.of<LoginService>(
      context,
      listen: false,
    ).logIn(mail, pass);

    if (isLogged) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  Future<void> _signIn(BuildContext context, String mail, String pass) async {
    final isSigned = await Provider.of<LoginService>(
      context,
      listen: false,
    ).addUser(mail, pass);

    if (isSigned) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  ///Al menos 8 caracteres, una mayúscula, una minúscula, un número.
  bool isValidPassword(String pass) {
    return pass.hasCapital() && pass.hasMinus() && pass.hasNumber() && pass.hasLength();
  }
}
