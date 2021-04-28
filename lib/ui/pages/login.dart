part of 'pages.dart';

class Login extends StatefulWidget {
  static const String routeName = "/login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();
  final ctrlPassword = TextEditingController();
  bool isVisible = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(32),
              child: ListView(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Image.asset("assets/images/LogoFinal.png"),
                          SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            controller: ctrlEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: "Email",
                                prefixIcon: Icon(Icons.mail_outline_rounded),
                                border: OutlineInputBorder()),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please fill the field";
                              } else {
                                if (!EmailValidator.validate(value)) {
                                  return "Email isn't valid!";
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                          SizedBox(height: 24),
                          TextFormField(
                            controller: ctrlPassword,
                            obscureText: isVisible,
                            decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.vpn_key),
                                border: OutlineInputBorder(),
                                suffixIcon: new GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                  child: Icon(isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                )),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return value.length < 6
                                  ? "Password must have at least 6 characters!"
                                  : null;
                            },
                          ),
                          SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                String msg = await AuthServices.signIn(
                                    ctrlEmail.text, ctrlPassword.text);
                                if (msg == "success") {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ActivityServices.showToast(
                                      "Login Success", Colors.green);
                                  Navigator.pushReplacementNamed(
                                      context, MainMenu.routeName);
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  ActivityServices.showToast(msg, Colors.red);
                                }

                                //melanjutkan ke tahap berikutnya
                                // Navigator.pushNamed(
                                //     context, MainMenu.routeName);
                              } else {
                                //kosongkan aja
                                Fluttertoast.showToast(
                                    msg: "Please check the fields!",
                                    backgroundColor: Colors.red);
                              }
                            },
                            icon: Icon(Icons.login_rounded),
                            label: Text("Login"),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.deepOrange[400], elevation: 4),
                          ),
                          SizedBox(height: 24),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, Register.routeName);
                            },
                            child: Text(
                              "Not registered yet? Join Now.",
                              style: TextStyle(
                                color: Colors.deepOrange[400],
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ))
                ],
              ),
            ),
            isLoading == true ? ActivityServices.loadings() : Container()
          ],
        ),
      ),
    );
  }
}
