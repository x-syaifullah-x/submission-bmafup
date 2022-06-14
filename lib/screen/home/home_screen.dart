import 'package:flutter/material.dart';
import 'package:submission_bmafup/data/note_repository.dart';
import 'package:submission_bmafup/data/repository.dart';
import 'package:submission_bmafup/data/user.dart';
import 'package:submission_bmafup/screen/base/base_material_app.dart';
import 'package:submission_bmafup/screen/home/editor.dart';
import 'package:submission_bmafup/screen/sign/sign_in_screen.dart';

class HomeScreen extends StatelessWidget {
  final User _user;

  const HomeScreen(this._user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: BaseMaterialApp(
        home: Scaffold(
          appBar: _appBar(context),
          drawer: _drawer(context),
          body: _Body(_user),
          floatingActionButton: const _FloatingActionButton(),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DrawerHeader(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.lightBlue, Colors.white],
                            ),
                          ),
                        ),
                      ),
                      const Text("Profile", style: TextStyle(fontSize: 20)),
                      const Text("List", style: TextStyle(fontSize: 20)),
                      const Text("Gird", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => _signOut(context),
                      child: const Text("Sign Out"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _signOut(BuildContext context) =>
      SignRepository.getInstance().signOut().then((isSuccess) {
        if (isSuccess) {
          Navigator.of(context).pop();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (builder) => const SignInScreen(),
            ),
            (route) => false,
          );
        }
      });
}

class _Body extends StatelessWidget {
  final User _user;

  const _Body(this._user);

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(40),
    //       child: GridView.count(
    //         crossAxisCount: 2,
    //         children: [
    //           Text("data"),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return SafeArea(
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
          Text("data"),
        ],
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        NoteRepository.getInstance().getData("test_test").then((value) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) => Editor(
                data: value,
              ),
            ),
          );
        });
      },
      child: const Icon(Icons.add),
    );
  }
}
