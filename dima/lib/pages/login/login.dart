import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 19, 243, 217),
                  Color.fromARGB(255, 22, 190, 67)
                ],
              ),
            ),
            child: Container(
              height: 420,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.only(top: 150, bottom: 300, left: 40, right: 40),
              padding: const EdgeInsets.all(20),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'username',
                        hintText: 'username',
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)
                        )
                      ),
                    ),
                    Column(
                      children: [
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'passwords',
                            hintText: 'passwords',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),                              ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('New user? Sign up!')
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {}, child: const Text('sign in')),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('sign in with Google'))
                    ]))),
          ),
        ));
  }
}
