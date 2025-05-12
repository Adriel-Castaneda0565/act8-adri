import 'dart:convert';
import 'package:flutter/material.dart';
import 'User.dart';
import 'GithubRequest.dart';
import 'UserProvider.dart';
import 'package:provider/provider.dart';

class FollowingPage extends StatefulWidget {
  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  User? user;
  List<User>? users;

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).getUSer();

    Github(user!.login).fetchFollowing().then((following) {
      final list = json.decode(following.body) as List;
      setState(() {
        users = list.map((model) => User.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
              backgroundColor: Colors.white,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(user!.avatar_url),
                    ),
                    const SizedBox(height: 20),
                    Text(user!.login, style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 600,
                  child: users != null
                      ? ListView.builder(
                          itemCount: users!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            users![index].avatar_url),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        users![index].login.length > 20
                                            ? users![index]
                                                .login
                                                .substring(0, 15)
                                            : users![index].login,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  const Text('Followers',
                                      style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(child: Text('Data is loading...')),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
