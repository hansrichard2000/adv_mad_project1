part of 'services.dart';

class AuthServices {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  static DocumentReference userDoc;

  static Future<String> signUp(Users users) async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    String token;
    String uid;
    String msg;

    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: users.email, password: users.password);

    uid = userCredential.user.uid;
    token = await FirebaseMessaging.instance.getToken();
    // token = await userCredential.user.getIdToken();

    await userCollection.doc(uid).set({
      'uid': uid,
      'name': users.name,
      'phone': users.phone,
      'email': users.email,
      'password': users.password,
      'token': token,
      'createdAt': dateNow,
      'updatedAt': dateNow,
    }).then((value) {
      msg = "success";
    }).catchError((onError) {
      msg = onError;
    });

    auth.signOut();

    return msg;
  }

  static Future<String> signIn(String email, String password) async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    String uid;
    String msg;
    String token;

    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    uid = userCredential.user.uid;
    token = await FirebaseMessaging.instance.getToken();

    await userCollection.doc(uid).update({
      'isOn': '1',
      'token': token,
      'updatedAt': dateNow,
    }).then((value) {
      msg = "success";
    }).catchError((onError) {
      msg = onError;
    });

    return msg;
  }

  static Future<bool> signOut() async {
    await Firebase.initializeApp();
    String dateNow = ActivityServices.dateNow();
    String uid = auth.currentUser.uid;

    await auth.signOut().whenComplete(() {
      userCollection.doc(uid).update({
        'isOn': '0',
        'token': '-',
        'updatedAt': dateNow,
      });
    });

    return true;
  }
}
