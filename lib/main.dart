// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:userlist/user.dart';

late Box user;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(UserDataAdapter());
    user = await Hive.openBox("user");
  } catch (e) {
    log(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List users = [];
  void init() async {
    final String response =
        await rootBundle.loadString('assets/data/userdata.json');
    final data = await json.decode(response);
    setState(() {
      users = data[0]["users"];
    });

    if (user.get("user") != null) {
      UserData userdata = user.get("user");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) => UserDetails(
                id: int.parse(userdata.id),
                name: userdata.name,
                age: userdata.age,
                atype: userdata.atype,
                gender: userdata.gender,
              )),
        ),
      );
    }

    // try {
    //   UserData userdata = user.get("user");
    //   log(userdata.id.toString());
    //   log(userdata.name.toString());
    //   log(userdata.age.toString());
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff10b981),
        centerTitle: true,
        title: const Text(
          "USER LIST",
          textScaleFactor: 1,
        ),
      ),
      body: SafeArea(
          child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xff10b981),
                      child: Text(
                        users[index]["name"][0],
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    title: Text(
                      "[${users[index]["id"]}] ${users[index]["name"]}",
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black.withOpacity(0.85),
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      users[index]["atype"],
                      textScaleFactor: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(2),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff10b981)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          minimumSize: MaterialStateProperty.all(
                              const Size.fromHeight(40)),
                        ),
                        onPressed: () {
                          signAlert(context, users[index]["id"],
                              users[index]["name"], users[index]["atype"]);
                        },
                        child: const Text(
                          "Sign in",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  void signAlert(BuildContext context, String id, String name, String atype) {
    TextEditingController age = TextEditingController();
    String genderRadioBtnVal = "Male";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child:
            StatefulBuilder(builder: (BuildContext context, Function setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            contentPadding: const EdgeInsets.all(5),
            backgroundColor: Colors.white,
            content: Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.black.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Sign In",
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xff10b981),
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: TextField(
                        controller: age,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xfff3f4f6),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Age",
                          hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.45),
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Radio<String>(
                        value: "Male",
                        hoverColor: const Color(0xff10b981),
                        activeColor: const Color(0xff10b981),
                        groupValue: genderRadioBtnVal,
                        onChanged: (value) {
                          setState(() {
                            genderRadioBtnVal = value!;
                          });
                        },
                      ),
                      Text(
                        "Male",
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w500),
                      ),
                      Radio<String>(
                        value: "Female",
                        hoverColor: const Color(0xff10b981),
                        activeColor: const Color(0xff10b981),
                        groupValue: genderRadioBtnVal,
                        onChanged: (value) {
                          setState(() {
                            genderRadioBtnVal = value!;
                          });
                        },
                      ),
                      Text(
                        "Female",
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w500),
                      ),
                      Radio<String>(
                        value: "Other",
                        hoverColor: const Color(0xff10b981),
                        activeColor: const Color(0xff10b981),
                        groupValue: genderRadioBtnVal,
                        onChanged: (value) {
                          setState(() {
                            genderRadioBtnVal = value!;
                          });
                        },
                      ),
                      Text(
                        "Other",
                        textScaleFactor: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.65),
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(2),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xff10b981)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            minimumSize: MaterialStateProperty.all(
                                const Size.fromHeight(40)),
                          ),
                          onPressed: () {
                            if (age.text == "") {
                              const snackBar = SnackBar(
                                backgroundColor: Color(0xffef4444),
                                content: Text(
                                  'Please Enter the age',
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              );

                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              user.put(
                                  "user",
                                  UserData(
                                    id: id,
                                    name: name,
                                    age: age.text,
                                    atype: atype,
                                    gender: genderRadioBtnVal,
                                  ));

                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserDetails(
                                            id: int.parse(id),
                                            name: name,
                                            age: age.text,
                                            atype: atype,
                                            gender: genderRadioBtnVal,
                                          )));
                            }
                          },
                          child: const Text(
                            "Done",
                            textAlign: TextAlign.center,
                            textScaleFactor: 1,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class UserDetails extends StatefulWidget {
  final int id;
  final String name;
  final String age;
  final String gender;
  final String atype;

  const UserDetails({
    super.key,
    required this.id,
    required this.name,
    required this.age,
    required this.atype,
    required this.gender,
  });

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff10b981),
        centerTitle: true,
        title: Text(
          widget.name,
          textScaleFactor: 1,
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xff10b981),
                child: Text(
                  widget.name[0],
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 55,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.name,
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black.withOpacity(0.85),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Age : ${widget.age}",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.65),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Gender : ${widget.gender}",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.65),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(2),
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xffef4444)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  minimumSize:
                      MaterialStateProperty.all(const Size.fromHeight(40)),
                ),
                onPressed: () async {
                  await user.delete("user");
                  Navigator.pop(context);
                },
                child: const Text(
                  "Sign Out",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
