import 'package:flutter/material.dart';
import 'FollowingPage.dart';
import 'UserProvider.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(),
        child: MaterialApp(
          home: HomePage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _StateHomePage createState() => _StateHomePage();
}

class _StateHomePage extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  void _getUser() {
    if (_controller.text == '') {
      Provider.of<UserProvider>(context, listen: false)
          .setMessage('Please Enter your username');
    } else {
      Provider.of<UserProvider>(context, listen: false)
          .fetchUser(_controller.text)
          .then((value) {
        if (value) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FollowingPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = context.watch<UserProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 100),
              const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 40,
                backgroundImage: NetworkImage(
                    'https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png'),
              ),
              const SizedBox(height: 30),
              const Text("Github",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 150),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(.1),
                ),
                child: TextField(
                  onChanged: (value) {
                    Provider.of<UserProvider>(context, listen: false)
                        .setMessage(null);
                  },
                  controller: _controller,
                  enabled: !Provider.of<UserProvider>(context, listen: false)
                      .isLoading(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    errorText:
                        value.getMessage().isEmpty ? null : value.getMessage(),
                    border: InputBorder.none,
                    hintText: "Github username",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MaterialButton(
                padding: const EdgeInsets.all(20),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: _getUser,
                child: Align(
                  child: value.isLoading()
                      ? const CircularProgressIndicator(
                          backgroundColor: Colors.white, strokeWidth: 2)
                      : const Text('Get Your Followers Now',
                          style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
