import 'package:flutter/rendering.dart';
import 'package:savvy_parking_management/loading.dart';
import 'package:savvy_parking_management/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

@override
bool _passwordVisible = false;
void initState() {
  _passwordVisible = false;
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  String error = "";
  bool loding = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return loding
        ? Loading()
        : SafeArea(
            child: Scaffold(
              body: LayoutBuilder(builder: (context, snapshot) {
                if (screenSize.width <= 600) {
                  // Text('Hello');
                  return SingleChildScrollView(child: signInContent(context));
                } else {
                  return Container(
                    // padding: const EdgeInsets.symmetric(
                    //     vertical: 20, `horizontal: 0.0),
                    height: MediaQuery.of(context).copyWith().size.height,
                    child: (Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).copyWith().size.width *
                              0.35,
                          margin: EdgeInsets.all(60.0),
                          child: Center(child: Image.asset('assets/home.png')),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 00, horizontal: 120.0),
                                  child: signInContent(context))),
                        ),
                      ],
                    )),
                  );
                }
              }),
            ),
          );
  }

  Padding signInContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 60.0, 15.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            children: [
              Container(
                child: Text('Hello',
                    style:
                        TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                    child: Text('There',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0, 0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[900]))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0),
            child: TextFormField(
              controller: passwordController,
              obscureText:
                  !_passwordVisible, //This will obscure text dynamically
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[900])),
                // Here is key idea
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 5.0),
            child: Text(
              error,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  color: Colors.red[200]),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            width: double.infinity,
            height: 45.0,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  loding = true;
                });
                Future<String> err =
                    context.read<AuthenticationService>().signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                err.then((String result) {
                  if (result != null) {
                    setState(() {
                      error = result;
                      loding = false;
                    });
                  }
                });
              },
              child: Text(
                "Sign in",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
              style: ElevatedButton.styleFrom(shape: StadiumBorder()),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: double.infinity,
            height: 45.0,
            child: OutlinedButton(
              onPressed: () {
                context.read<AuthenticationService>().signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(AssetImage('assets/google.png')),
                  SizedBox(width: 10.0),
                  Text("Sign In With Google",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Colors.blue)),
                ],
              ),
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side: BorderSide(width: 2, color: Color(0xff212121)),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'New to SPM?',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/SignUpPage');
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
