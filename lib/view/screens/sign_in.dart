import 'package:loginexample/core/bloc/signin_bloc.dart';
import 'package:loginexample/core/services/auth.dart';
import 'package:loginexample/view/screens/email_signin_screen.dart';
import 'package:loginexample/view/widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  final SigninBloc bloc;

  const SignInScreen({Key key, @required this.bloc}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<SigninBloc>(
      create: (_) => SigninBloc(auth: auth),
      dispose: (context, bloc) => bloc.dispose(),
      child: Consumer<SigninBloc>(
        builder: (context, bloc, _) => SignInScreen(bloc: bloc),
      ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(title: 'Sign in failed', exception: exception)
        .show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await bloc.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return SafeArea(
      child: Center(
        child: Container(
          child: _onSignInProgress(isLoading, context),
        ),
      ),
    );
  }

  Widget _onSignInProgress(bool isLoading, BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RaisedButton(
          onPressed: () => _signInWithGoogle(context),
          child: Text('Google'),
        ),
        SizedBox(
          height: 5,
        ),
        RaisedButton(
          onPressed: () => _signInWithFacebook(context),
          child: Text('Facebook'),
        ),
        SizedBox(
          height: 5,
        ),
        RaisedButton(
          onPressed: () => _signInWithEmail(context),
          child: Text('Email'),
        ),
        SizedBox(
          height: 5,
        ),
        RaisedButton(
          onPressed: () => _signInAnonymously(context),
          child: Text('Guest'),
        ),
      ],
    );
  }
}
