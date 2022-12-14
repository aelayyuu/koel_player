import 'package:koel_player/providers/auth_provider.dart';
import 'package:koel_player/ui/screens/data_loading.dart';
import 'package:koel_player/ui/screens/login.dart';
import 'package:koel_player/ui/widgets/spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatefulWidget {
  static const routeName = '/';

  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _resolveAuthenticatedUser();
  }

  Future<void> _resolveAuthenticatedUser() async {
    context.read<AuthProvider>().tryGetAuthUser().then((user) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            user == null ? const LoginScreen() : const DataLoadingScreen(),
        transitionDuration: Duration.zero,
      ));
    }, onError: (_) async {
      await Navigator.of(context, rootNavigator: true).pushReplacementNamed(
        LoginScreen.routeName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const ContainerWithSpinner();
  }
}
