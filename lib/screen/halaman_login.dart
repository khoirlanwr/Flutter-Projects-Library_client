import 'package:flutter/material.dart';
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/model/model_user_login.dart';
import 'package:library_client/service/size_config.dart';
import 'package:library_client/screen/halaman_register.dart';

class HalamanLogin extends StatefulWidget {
  static const String id = "HALAMANLOGIN";

  HalamanLogin({this.user, this.loginCallback});

  final BaseUser user;
  final VoidCallback loginCallback;

  @override
  _HalamanLoginState createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  ResponseUserLogin responseUserLogin;
  SizeConfig sizeConfig;

  bool _isLoading;
  String _username;
  String _password;
  String _errorMessage;


  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {

    _controller = AnimationController(vsync: this);
    sizeConfig = new SizeConfig();

    _isLoading = false;
    _errorMessage = "";

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void setToRegisterPage() {
    setState(() {
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => HalamanRegister()) 
      );            
    });
  }

  void validateAndSubmit() async {

    setState(() {
      _errorMessage = "";
      _isLoading = true;      
    });

    if (validateAndSave()) {
      String _userID = "";
      try {
        _userID =  await widget.user.signIn(_username, _password);            


        setState(() {
          _isLoading = false;
        });

        if (_userID == "404") {
          print('Wrong username or password!');
          setState(() {
            _isLoading = false;
            _errorMessage = 'Wrong username or password!';
            _formKey.currentState.reset();
          });
          
        } else if ((_userID.length > 0) && (_userID != "404")) {
          print('signed in: $_userID');
          widget.loginCallback();
        } 
      } catch(e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e;
          _formKey.currentState.reset();
        });
      }
    } 
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(sizeConfig.getBlockHorizontal(10)),
        child: Stack(
          children: <Widget> [showForm(), showCircularProgress()]
        ),
      )
    );
  }

  Widget showForm() {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(sizeConfig.getBlockHorizontal(3)),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(), 
              showUsernameInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showErrorMessage()
            ],
          )
        ),
      ),
    );
  }


  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, sizeConfig.getBlockHorizontal(20), 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: sizeConfig.getBlockHorizontal(20),
          child: Image.asset('images/simbol.png'),
        ),
      ),
    );
  }  

  Widget showUsernameInput() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(10), 0, 0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'username',
          icon: new Icon(Icons.person, color: Color(0xFF1E90FF)),
        ),
        validator: (value) => value.isEmpty ? 'username can\'t be empty': null,
        onSaved: (value) => _username = value,
      ),
    );
  }

  Widget showPasswordInput() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(1), 0, 0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        obscureText: true,
        decoration: new InputDecoration(
          hintText: 'password',
          icon: new Icon(Icons.lock, color: Color(0xFF1E90FF)),
        ),
        validator: (value) => value.isEmpty ? 'password can\'t be empty':null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(5), 0, 0),
      child: SizedBox(
        height: sizeConfig.getBlockVertical(6),
        child: RaisedButton(
          elevation: 5.0,
          onPressed: validateAndSubmit,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(sizeConfig.getBlockHorizontal(5))
          ),
          color: Color(0xFF1E90FF),
          child: new Text('login',
            style: new TextStyle(fontSize: sizeConfig.getBlockHorizontal(5), color: Colors.white)),
        ),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(5), 0, 0),
      child: SizedBox(
        height: sizeConfig.getBlockVertical(6),
        child: RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(sizeConfig.getBlockHorizontal(5))
          ),
          color: Colors.white,
          child: new Text('register',
            style: new TextStyle(fontSize: sizeConfig.getBlockHorizontal(5), color: Color(0xFF1E90FF))),
          onPressed: setToRegisterPage,
        ),
      ),
    );
  }  

  Widget showErrorMessage() {
    if ((_errorMessage.length > 0 ) || (_errorMessage != null)) {
      return new Padding(
        padding: EdgeInsetsDirectional.only(start: sizeConfig.getBlockHorizontal(7), top: sizeConfig.getBlockVertical(5)),
        // padding: EdgeInsets.symmetric(vertical: sizeConfig.getBlockVertical(5), horizontal: sizeConfig.getBlockHorizontal(4)),
        child: Text(
          _errorMessage,
          style: TextStyle(
            fontSize: sizeConfig.getBlockHorizontal(5),
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300
          ),
        ),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }    
  }


}