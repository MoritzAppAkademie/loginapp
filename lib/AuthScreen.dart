import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback onSignIn;

  AuthScreen({required this.onSignIn});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool _isLogin = true;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (_isLogin) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _email, password: _password);
        }
        widget.onSignIn();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(_isLogin ? 'Login' : 'Register'),
                onPressed: _submitForm,
              ),
              TextButton(
                child: Text(_isLogin
                    ? 'Need an account? Register'
                    : 'Have an account? Login'),
                onPressed: () => setState(() => _isLogin = !_isLogin),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
