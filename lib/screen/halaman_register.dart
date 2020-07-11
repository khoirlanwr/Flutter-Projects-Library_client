import 'package:flutter/material.dart';
import 'package:library_client/model/model_user_function.dart';
import 'package:library_client/model/model_user_login.dart';
import 'package:library_client/service/size_config.dart';
import 'package:library_client/service/api_service.dart';
import 'package:intl/intl.dart';

class HalamanRegister extends StatefulWidget {
  static const String id = "HALAMANREGISTER";

  @override
  _HalamanRegisterState createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  SizeConfig sizeConfig;

  bool _isLoading;
  String _username;
  String _namaMhs = "";
  String _email;
  String _password;
  String _confirmPassword;
  String _errorMessage;
  String _tglLahir;
  String result;
  
  final ApiService _api = new ApiService();
  final _formKey = new GlobalKey<FormState>();

  var controllerAutoName = TextEditingController();

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

  void validateAndSubmit() async {

    setState(() {
      _isLoading = true;      
    });

    if(validateAndSave()) {
      // print(_username);
      // print(_selectedDate);
      result = await _api.register(_username, _password, _confirmPassword, _tglLahir);

      // print(result);

      setState(() {
        _isLoading = false;      
      });

      showMessage();
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
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

  String _selectedDate = 'Plih tanggal lahir';
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime d = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(1990), 
      lastDate: DateTime(2023)
    );

    if ( d != null) {
      setState(() {
        _selectedDate = new DateFormat.yMMMMd("en_US").format(d);

        String dateIso8601;
        dateIso8601 = d.toIso8601String();
        _tglLahir = ApiService.timeParser(dateIso8601);

      });
    }
  }   

  Future<void> _cekUser() async {
    String resCekUser = await _api.cekUser(_username);
    if ((resCekUser != "false") && (resCekUser != "koneksi gagal!")) {
      print("berhasil ditemukan");
      print(resCekUser);

      _namaMhs = resCekUser;
      controllerAutoName.text = _namaMhs;
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
              inputNRP(),
              inputAutoNama(),
              inputTglLahir(),
              inputEmail(),
              inputPassword(),
              inputConfirmPassword(),
              showPrimaryButton(),
              showMessage()
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
        padding: EdgeInsets.fromLTRB(0.0, sizeConfig.getBlockHorizontal(10), 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: sizeConfig.getBlockHorizontal(20),
          child: Image.asset('images/simbol.png'),
        ),
      ),
    );
  }  

  Widget inputNRP() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(10), 0, 0),
      child: new TextFormField(
        onChanged: (value) {
          _username = value;
          _cekUser();
        },
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'input your NRP',
          icon: new Icon(Icons.person, color: Color(0xFF1E90FF)),
        ),
        validator: (value) => value.isEmpty ? 'username can\'t be empty': null,
        onSaved: (value) => _username = value,
      ),
    );
  }

  Widget inputAutoNama() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(1), 0, 0),
      child: new TextFormField(
        controller: controllerAutoName,
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'nama',
          icon: new Icon(Icons.person, color: Color(0xFF1E90FF)),          
        ),
        validator: (value) => value.isEmpty ? 'name can\'t be empty': null,
        // onSaved: (value) => _namaMhs = value,        
      ),
    );
  }

  Widget inputTglLahir() {
    return new Padding(
      padding: EdgeInsets.all(sizeConfig.getBlockHorizontal(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            child: Text(
              _selectedDate,
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF000000))
            ),
            onTap: () {
              _selectDate(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            tooltip: 'Tap to open date picker', 
            onPressed: () {
              _selectDate(context);
            }
          )
        ],
      ),
    );
  }

  Widget inputEmail() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(1), 0, 0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        decoration: new InputDecoration(
          hintText: 'input email',
          icon: new Icon(Icons.mail, color: Color(0xFF1E90FF)),          
        ),
        validator: (value) => value.isEmpty ? 'email can\'t be empty': null,
        onSaved: (value) => _email = value,        
      ),
    );
  }

  Widget inputPassword() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(1), 0, 0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        obscureText: true,
        decoration: new InputDecoration(
          hintText: 'input password',
          icon: new Icon(Icons.lock, color: Color(0xFF1E90FF)),
        ),
        validator: (value) => value.isEmpty ? 'password can\'t be empty':null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget inputConfirmPassword() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, sizeConfig.getBlockVertical(1), 0, 0),
      child: new TextFormField(
        maxLines: 1,
        autofocus: false,
        obscureText: true,
        decoration: new InputDecoration(
          hintText: 'confirm password',
          icon: new Icon(Icons.lock, color: Color(0xFF1E90FF)),
        ),
        validator: (value) => value.isEmpty ? 'password can\'t be empty':null,
        onSaved: (value) => _confirmPassword = value,
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
          child: new Text('register',
            style: new TextStyle(fontSize: sizeConfig.getBlockHorizontal(5), color: Colors.white)),
        ),
      ),
    );
  }

  Widget showMessage() {
    if ((result != null)) {
      return new Padding(
        padding: EdgeInsetsDirectional.only(start: sizeConfig.getBlockHorizontal(15), top: sizeConfig.getBlockVertical(5)),
        // padding: EdgeInsets.symmetric(vertical: sizeConfig.getBlockVertical(5), horizontal: sizeConfig.getBlockHorizontal(4)),
        child: Text(
          result,
          style: TextStyle(
            fontSize: sizeConfig.getBlockHorizontal(5),
            color: Colors.black38,
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