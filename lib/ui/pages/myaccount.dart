part of 'pages.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Account"),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton.icon(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await AuthServices.signOut().then((value) {
                  if (value == true) {
                    setState(() {
                      isLoading = false;
                    });
                    ActivityServices.showToast("Logout Success", Colors.green);
                    Navigator.pushReplacementNamed(context, Login.routeName);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    ActivityServices.showToast("Logout Failed", Colors.green);
                  }
                });
              },
              icon: Icon(Icons.login_rounded),
              label: Text("Logout"),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange[400],
                elevation: 0,
              ),
            ),
          ),
          isLoading == true ? ActivityServices.loadings() : Container()
        ],
      ),
    );
  }
}
