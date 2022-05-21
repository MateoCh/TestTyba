import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_tyba/models/authInfo.dart';
import 'package:test_tyba/providers/authProvider.dart';
import 'dart:convert';

import 'package:test_tyba/widgets/eyeToggle.dart';

/**
 * Widget with the forms for user authetication
 */
class LoginWidget extends StatefulWidget {
  LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

enum Action { login, register, forgotPassword }

class _LoginWidgetState extends State<LoginWidget> {
  Action _action = Action.login;
  bool _loading = false;
  bool _showPswd = false;
  bool _showPswdConfirm = false;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _pswdController = TextEditingController();
  AuthInfo _authData = new AuthInfo(email: '', password: '');
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _loading = true;
    });
    String errorMessage = 'Intenta nuevamente más tarde.';
    try {
      switch (_action) {
        case Action.login:
          await Provider.of<AuthProvider>(context, listen: false)
              .login(_authData);
          break;
        case Action.register:
          await Provider.of<AuthProvider>(context, listen: false)
              .singUp(_authData);
          break;
        default:
          await Provider.of<AuthProvider>(context, listen: false)
              .forgotPassword(_authData);
          _showSucces('Se envió el correo exitosamente');
      }
    } on HttpException catch (error) {
      if (error.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'Este correo está en uso';
      } else if (error.message.contains('INVALID_EMAIL')) {
        errorMessage = 'Correo invalido';
      } else if (error.message.contains('WEAK_PASSWORD')) {
        errorMessage = 'Contraseña insegura';
      } else if (error.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Correo no encontrado';
      } else if (error.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Contraseña incorrecta';
      }
      _showError(errorMessage);
    } catch (error) {
      _showError(errorMessage);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Correo'),
                    onSaved: (value) => _authData.email = value ?? '',
                    textInputAction: _action == Action.forgotPassword
                        ? TextInputAction.send
                        : TextInputAction.next,
                    validator: (value) => !(value != null &&
                            value.contains('@') &&
                            value.contains('.'))
                        ? 'Correo invalido'
                        : null,
                    onFieldSubmitted: (_) => _action == Action.forgotPassword
                        ? _submit()
                        : FocusScope.of(context)
                            .requestFocus(passwordFocusNode),
                  ),
                  if (_action != Action.forgotPassword)
                    TextFormField(
                        focusNode: passwordFocusNode,
                        obscureText: !_showPswd,
                        controller: _pswdController,
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            suffixIcon: EyeToggle(
                                fn: () {
                                  setState(() {
                                    _showPswd = !_showPswd;
                                  });
                                },
                                eyeState: _showPswd)),
                        onSaved: (value) => _authData.password = value ?? '',
                        textInputAction: _action == Action.login
                            ? TextInputAction.send
                            : TextInputAction.next,
                        onFieldSubmitted: (_) => _action == Action.login
                            ? _submit()
                            : FocusScope.of(context)
                                .requestFocus(confirmPasswordFocusNode),
                        validator: (value) => value == null || value == ''
                            ? 'Las contraseña no puede ser vacía'
                            : null),
                  if (_action == Action.register)
                    TextFormField(
                        focusNode: confirmPasswordFocusNode,
                        obscureText: !_showPswdConfirm,
                        decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            suffixIcon: EyeToggle(
                                fn: () {
                                  setState(() {
                                    _showPswdConfirm = !_showPswdConfirm;
                                  });
                                },
                                eyeState: _showPswdConfirm)),
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (value) => value != _pswdController.text
                            ? 'Las contraseñas no cuadran'
                            : null),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              _loading
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(child: CircularProgressIndicator()))
                  : Column(
                      children: [
                        SizedBox(
                          height: 50,
                          child: CupertinoButton(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(30),
                              child: Text(
                                _action == Action.login
                                    ? 'Iniciar sesión'
                                    : (_action == Action.register
                                        ? 'Crear Cuenta'
                                        : 'Enviar correo'),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background),
                              ),
                              onPressed: _submit),
                        ),
                        if (_action != Action.forgotPassword)
                          SizedBox(
                            height: 50,
                            child: CupertinoButton(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(30),
                                child: Text(
                                  _action == Action.login
                                      ? 'Cambiar a crear Cuenta'
                                      : 'Cambiar a iniciar sesión',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_action == Action.login) {
                                      _action = Action.register;
                                    } else {
                                      _action = Action.login;
                                    }
                                  });
                                }),
                          ),
                        if (_action != Action.register)
                          SizedBox(
                            height: 50,
                            child: CupertinoButton(
                                color: Theme.of(context).colorScheme.background,
                                borderRadius: BorderRadius.circular(30),
                                child: Text(
                                  _action == Action.forgotPassword
                                      ? 'Volver a iniciar sesión'
                                      : 'Olvidé mi contraseña',
                                  style: TextStyle(color: Colors.black),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_action != Action.forgotPassword) {
                                      _action = Action.forgotPassword;
                                    } else {
                                      _action = Action.login;
                                    }
                                  });
                                }),
                          ),
                      ],
                    ),
            ],
          )),
    );
  }

  void _showError(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Ocurrió un error'),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(), child: Text('Ok'))
              ],
            ));
  }

  void _showSucces(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('¡Exito!'),
              content: Text(message),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(), child: Text('Ok'))
              ],
            ));
  }
}
