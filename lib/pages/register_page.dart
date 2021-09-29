import 'package:flutter/material.dart';
import 'package:nearby_restaurants/controllers/register_controller.dart';
import 'package:nearby_restaurants/helpers/helpers.dart';
import 'package:nearby_restaurants/pages/find_page.dart';
import 'package:nearby_restaurants/pages/login_page.dart';
import 'package:nearby_restaurants/theme/my_color.dart';

import 'package:nearby_restaurants/widgets/custom_input.dart';
import 'package:nearby_restaurants/widgets/custom_submit_button.dart';
import 'package:nearby_restaurants/widgets/labels.dart';
import 'package:nearby_restaurants/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Logo(
                assetName: 'assets/logo.png',
                isSubtitle: true,
                subtitle: 'Registro',
              ),
              _Form(),
              Labels(
                  page: LoginPage(),
                  titulo: '¿Ya tienes una cuenta?',
                  subTitulo: 'Ingresa ahora!'),
              Text(
                'Términos y condiciones de uso',
                style: TextStyle(fontWeight: FontWeight.w200),
              )
            ],
          ),
        ),
      )),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final registerCtrl = RegisterController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          CustomSubmitButton(
            text: 'Ingrese',
            onPressed: () {
              register();
            },
          )
        ],
      ),
    );
  }

  void _showMessageError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '$message',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: MyColor.warning,
      //duration: Duration(milliseconds: 5000),
    ));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '$message',
      ),
      //duration: Duration(milliseconds: 3500),
    ));
  }

  void register() async {
    if (nameCtrl.text.isEmpty) {
      _showMessageError('Ingrese un nombre');
      return;
    }
    if (emailCtrl.text.isEmpty) {
      _showMessageError('Ingrese un correo');
      return;
    }
    if (passCtrl.text.isEmpty) {
      _showMessageError('Ingrese una contraseña');
      return;
    }

    _showProgress(context);

    await Future.delayed(Duration(milliseconds: 2000));

    bool check = await registerCtrl.registerUser(
        nameCtrl.text, emailCtrl.text, passCtrl.text);

    _hideProgress(context);

    if (check) {
      //Navigator.pushReplacementNamed(context, 'login');
      // Navigator.pushReplacement(context, navegarFadeIn(context, FindPage()));
    }
  }

  void _showProgress(BuildContext context) {
    // Iniciar mostrar dialogo.
    showDialog(
        context: context,
        // Indica que el dialogo no se puede cerrar. Solo con acciones.
        barrierDismissible: false,
        // Construir.
        builder: (context) {
          // Devolver una nueva alerta de dialogo.
          return AlertDialog(
            // Poner un contorno de bordes redondos.
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text('Creando usuario'),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 16.0),
                Text('Por favor espere...'),
              ],
            ),
          );
        });
  }

  void _hideProgress(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, 'find');
  }
}
