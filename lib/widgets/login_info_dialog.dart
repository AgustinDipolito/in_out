import 'package:flutter/material.dart';
import 'package:in_out/utils/constants.dart';
import 'package:in_out/utils/string_validations.dart';

class LoginInfo extends StatelessWidget {
  const LoginInfo({Key? key, required this.pass, required this.email}) : super(key: key);

  final String pass, email;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kBlueGrey,
      shape: RoundedRectangleBorder(
        borderRadius: 20.toRadio(),
        side: const BorderSide(color: kDarkGreen),
      ),
      title: const Text(
        'About Sign in',
        textAlign: TextAlign.center,
        style: TextStyle(color: kblack, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * .65,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              """Welcome to MyFinances. 
              If this is your first time you must create an account, it will only take a minute.
Enter the credentials you want to have and press 'Sign in'. 
All you need to do is respect the following rules.""",
              textAlign: TextAlign.justify,
              style: TextStyle(color: kblack, fontSize: 18),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Password:',
                  style:
                      TextStyle(color: kblack, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '\u2299 At least 6 characters.',
                  style: TextStyle(
                      color: pass.hasLength() ? kDarkGreen : kRed, fontSize: 16),
                ),
                Text(
                  '\u2299 At least 1 uppercase letter.',
                  style: TextStyle(
                      color: pass.hasCapital() ? kDarkGreen : kRed, fontSize: 16),
                ),
                Text(
                  '\u2299 At least 1 lowercase letter.',
                  style:
                      TextStyle(color: pass.hasMinus() ? kDarkGreen : kRed, fontSize: 16),
                ),
                Text(
                  '\u2299 At least 1 number.',
                  style: TextStyle(
                      color: pass.hasNumber() ? kDarkGreen : kRed, fontSize: 16),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Email:',
                  style:
                      TextStyle(color: kblack, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  '\u2299 Must be a valid email and not used.',
                  style:
                      TextStyle(color: email.isEmail() ? kDarkGreen : kRed, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
