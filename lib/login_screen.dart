import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:login_demo/home_screen.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:sprung/sprung.dart';

import 'navigation/fade_route.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreenState createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {

  final int _animationDuration = 300;
  final Curve _animationCurve = Sprung(damped: Damped.over);
  final Duration _rectAnimationDuration = Duration(milliseconds: 600);
  final Duration _rectDelay = Duration(milliseconds: 300);

  String direction = Direction.FORWARD;

  bool white = true;
  Size size;
  bool login = true;
  bool _btnClicked = false;
  GlobalKey rectGetterKey = RectGetter.createGlobalKey();
  Rect rect;


  OutlineInputBorder _inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(
          Radius.circular(30)
      ),
      borderSide: BorderSide(
        color: Colors.blueGrey[100],
        style: BorderStyle.none,
        width: 0,
      )
  );

  AnimationController _flipController;
  Animation _flipAnimation;
  Animation _loginBtnFlipAnimation;
  AnimationController _loginBtnFlipController;
  double _flipValue=1.0;

  double _cnfPassHeight = 0;//max 68
  AnimationController _cnfPassHeightController;
  Animation _cnfPassHeightAnimation;

  double _cnfPassPosition = -400;
  AnimationController _cnfPassPositionController;
  Animation _cnfPassPositionAnimation;

  double _inputWidth = 0;
  AnimationController _inputWidthController;
  Animation _inputWidthAnimation;

  double _buttonTextPosition = 0;
  AnimationController _btnTextController;
  Animation _btnTextAnimation;

  double _iconSize = 0;
  AnimationController _iconSizeController;
  Animation _iconSizeAnimation;

  double _btnPosition = 0;
  AnimationController _btnPositionController;
  Animation _btnPositionAnimation;

  double _loginBtnSize = 120;
  AnimationController _loginBtnSizeController;
  Animation _loginBtnSizeAnimation;


  double _containerSize = 0;
  AnimationController _containerSizeController;
  Animation _containerSizeAnimation;

  double _colorContainerPosition;
  double _colorContainerSize;
  AnimationController _colorContainerPosController;
  Animation _colorContainerPosAnimation;
  AnimationController _colorContainerSizeController;
  Animation _colorContainerSizeAnimation;

  double _rotateValue = 1.0;
  AnimationController _rotationController;
  Animation _rotateAnimation;

  double _containerShiftValue = 0;
  AnimationController _containerShiftController;
  Animation _containerShiftAnimation;

  double _containerTiltValue = 0;
  AnimationController _containerTiltController;
  Animation _containerTiltAnimation;

  @override
  void initState() {

    _colorContainerPosition = _containerSize+45;

    _colorContainerSize = _containerSize;

    initAnimationControllers();

    initializeAnimations();

    super.initState();

    initializeLayout();

  }


  void goToHomePage() {
    setState(() => rect = RectGetter.getRectFromKey(rectGetterKey));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() =>
      rect = rect.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      Future.delayed(_rectAnimationDuration + _rectDelay, _goToNextPage);
    });
  }

  void _goToNextPage() {
    Navigator.of(context)
        .push(FadeRouteBuilder(page: HomeScreen()))
        .then((_) => setState(() => rect = null));
  }


  void initAnimationControllers(){

    _rotationController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _containerShiftController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _containerTiltController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );

    _colorContainerSizeController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _colorContainerPosController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    _containerSizeController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _flipController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _loginBtnFlipController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _cnfPassPositionController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _cnfPassHeightController = AnimationController(
      duration:Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _inputWidthController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _iconSizeController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _btnPositionController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _btnTextController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

    _loginBtnSizeController = AnimationController(
      duration: Duration(milliseconds: _animationDuration),
      vsync: this,
    );

  }

  void initializeAnimations(){

    _containerTiltAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _containerTiltController,
    )..addListener((){
      setState(() {
        _containerTiltValue = _containerTiltAnimation.value*0.1;
      });
    });

    _containerShiftAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
      parent: _containerShiftController,
    )..addListener((){
      setState(() {
        _containerShiftValue = _containerShiftAnimation.value*size.width;
        if(direction == Direction.FORWARD && _containerShiftValue>=size.width-50){
          _containerTiltController.reverse();
        }else if(direction == Direction.BACKWARD && _containerShiftValue<=200){
          _containerTiltController.reverse();
        }
      });
    });

    _rotateAnimation = CurvedAnimation(
      curve: _animationCurve,
      parent: _rotationController
    )..addListener((){
      setState(() {
        _rotateValue = _rotateAnimation.value*0.5;
      });
    });




    _colorContainerSizeAnimation = CurvedAnimation(
      curve: _animationCurve,
      parent: _colorContainerSizeController,
    )..addListener((){
      setState(() {
        _colorContainerSize = _colorContainerSizeAnimation.value*size.width*0.3;
      });
    });



    _colorContainerPosAnimation = CurvedAnimation(
      curve: Curves.easeInOutExpo,
      parent: _colorContainerPosController,
    )..addListener((){
      setState(() {
        _colorContainerPosition = _colorContainerPosAnimation.value*(_containerSize-45);
      });
    });




    _containerSizeAnimation = CurvedAnimation(
      curve: _animationCurve,
      parent: _containerSizeController,
    )..addListener((){
      setState(() {
        _containerSize = _containerSizeAnimation.value<=0.3?size.width*0.3:_containerSizeAnimation.value*(size.width*0.7);
        _colorContainerPosition = _containerSize;
        _colorContainerSize = _containerSize;
      });
    });



    _flipAnimation = Tween(begin: 0.0,end: 1.0)
        .animate(_flipController)
      ..addListener((){
        setState(() {
          _flipValue = 1.0*_flipAnimation.value;
        });
      });




    _loginBtnFlipAnimation = Tween(begin: 0.0,end: 1.0)
        .animate(_loginBtnFlipController)
      ..addListener((){
        setState(() {

        });
      });



    _cnfPassPositionAnimation = CurvedAnimation(
      curve: _animationCurve,
      parent: _cnfPassPositionController,
    )..addListener((){
      setState(() {
        _cnfPassPosition = (-size.width*0.8) + (_cnfPassPositionAnimation.value*size.width*0.8);
        //_cnfPassColorOpacity = 1-_cnfPassPositionAnimation.value;
      });
    });


    _cnfPassHeightAnimation = CurvedAnimation(
        curve: _animationCurve,
        parent: _cnfPassHeightController
    )..addListener((){
      setState(() {
        _cnfPassHeight = _cnfPassHeightAnimation.value*(70);
        //_cnfPassColorOpacity = _cnfPassHeightController.value*1;
      });
    });




    _inputWidthAnimation = CurvedAnimation(
      curve: Curves.linearToEaseOut,
      parent: _inputWidthController,
    )..addListener((){
      setState(() {
        _inputWidth = (_inputWidthAnimation.value*size.width*0.7);
      });
    });



    _iconSizeAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _iconSizeController,
    )..addListener((){
      setState(() {
        _iconSize = _iconSizeAnimation.value*50;
      });
    });



    _btnPositionAnimation = CurvedAnimation(
      curve: _animationCurve,
      parent: _btnPositionController,
    )..addListener((){
      setState(() {
        _btnPosition = _btnPositionAnimation.value*50;
      });
    });



    _btnTextAnimation = CurvedAnimation(
      curve: Curves.easeInOutExpo,
      parent: _btnTextController,
    )..addListener((){
      setState(() {
        _buttonTextPosition = (_btnTextAnimation.value*50);
      });
    });



    _loginBtnSizeAnimation = CurvedAnimation(
      curve: _animationCurve,
      parent: _loginBtnSizeController,
    )..addListener((){
      setState(() {
        _loginBtnSize = size.width*0.35 - (_loginBtnSizeAnimation.value*size.width*0.35);
      });
    });
  }


  void initializeLayout(){
    Future.delayed(Duration(milliseconds: 500)).then((a){
      _containerSizeController.forward();
      _colorContainerPosController.forward();
      _colorContainerSizeController.forward();
      _flipController.forward().then((b){
        Future.delayed(Duration(milliseconds: 100)).then((c){
          _iconSizeController.forward().then((d){
            _inputWidthController.forward().then((e){

            });
            _loginBtnFlipController.animateTo(1,curve: _animationCurve).then((f){
              _btnPositionController.forward();
              setState(() {
                white = false;
              });
            });
          });
        });
      });
    });
  }



  Color kBlueColor = Color(0xFF448AFF);
  Color kBlueColorDark = Color(0xFF0D47A1);



  @override
  Widget build(BuildContext context) {


    List<Color> kBlueGradient = [
      kBlueColor,
      kBlueColorDark,
    ];

    size = MediaQuery.of(context).size;


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: kBlueGradient,
            )
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0-_containerShiftValue,
              child: Container(
                height: size.height,
                width: size.width,
                child: Center(
                  child: Transform(
                    alignment: FractionalOffset.centerLeft,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateY(-pi*_containerTiltValue),
                    child: Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.002)
                      ..rotateX(pi * _flipValue)
                      ..rotateZ(-pi*_rotateValue),
                      child: _flipValue<=0.5?
                      SizedBox():
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.all(
                          Radius.circular(_containerSize*0.1),
                        ),
                        child: Transform(
                          alignment: FractionalOffset.center,
                          transform:Matrix4.rotationZ(-pi*1),
                          child: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.rotationX(pi*1),
                            child: Container(
                              width: _containerSize,
                              height: (_containerSize*1.3)+_cnfPassHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(_containerSize*0.1),
                                ),
                                color: Colors.white
                              ),
                              child: Stack(
                                children: <Widget>[
                                  RectGetter(
                                    key: rectGetterKey,
                                    child: Container(
                                      child: _containerSizeAnimation.value<1?SizedBox():Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 30),
                                                child: Container(
                                                  height: 120,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 25-((_iconSize*0.1)*3),right: 10,top: 15-((_iconSize*0.1)*3)),
                                                        child: Container(
                                                          width: _inputWidth+_iconSize,
                                                          height: _iconSize,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(30),
                                                            ),
                                                            color: Colors.blue[100].withOpacity(0.5),
                                                          ),
                                                          child: TextField(
                                                            cursorWidth: 1,
                                                            decoration: InputDecoration(
                                                              border: _inputBorder,
                                                              disabledBorder: _inputBorder,
                                                              enabledBorder: _inputBorder,
                                                              errorBorder: _inputBorder,
                                                              focusedErrorBorder: _inputBorder,
                                                              contentPadding: EdgeInsets.all(0),
                                                              prefixIcon: Icon(
                                                                Icons.person,
                                                                size: _iconSize*0.5,
                                                              ),
                                                              labelText: 'Email',
                                                              focusColor: Colors.blueGrey[100],
                                                              fillColor: Colors.blueGrey[100],
                                                            ),
                                                            onChanged: (String value){
                                                              //TODO:
                                                            },
                                                            onSubmitted: (String value){
                                                              //TODO:
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 20,),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 25-((_iconSize*0.1)*3),right: 10,top: 15-((_iconSize*0.1)*3)),
                                                        child: Container(
                                                          width: _inputWidth+_iconSize,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(30),
                                                            ),
                                                            color: Colors.blue[100].withOpacity(0.5),
                                                          ),
                                                          child: TextField(
                                                            cursorWidth: 1,
                                                            decoration: InputDecoration(
                                                              border: _inputBorder,
                                                              disabledBorder: _inputBorder,
                                                              enabledBorder: _inputBorder,
                                                              errorBorder: _inputBorder,
                                                              focusedErrorBorder: _inputBorder,
                                                              contentPadding: EdgeInsets.all(0),
                                                              prefixIcon: Icon(
                                                                Icons.lock,
                                                                size: _iconSize*0.5,
                                                              ),
                                                              labelText: 'Passowrd',
                                                              focusColor: Colors.blueGrey[100],
                                                              fillColor: Colors.blueGrey[100],
                                                            ),
                                                            onChanged: (String value){
                                                              //TODO:
                                                            },
                                                            onSubmitted: (String value){
                                                              //TODO:
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10,),
                                              Container(
                                                color: _cnfPassHeight<=1||_cnfPassPosition==0?Colors.white:Colors.orange.withOpacity(1),
                                                height: _cnfPassHeight,
                                                width: size.width*0.7,
                                                child: Stack(
                                                  children: <Widget>[
                                                    Positioned(
                                                      top: 0,
                                                      left: _cnfPassPosition,
                                                      child: Container(
                                                        height: _cnfPassHeight,
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(10.0),
                                                          child: Container(
                                                            width: _inputWidth<=20?0:(_inputWidth-20),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(30),
                                                              ),
                                                              color: Colors.blue[100].withOpacity(0.5),
                                                            ),
                                                            child: Center(
                                                              child: TextField(
                                                                cursorWidth: 1,
                                                                decoration: InputDecoration(
                                                                  border: _inputBorder,
                                                                  disabledBorder: _inputBorder,
                                                                  enabledBorder: _inputBorder,
                                                                  errorBorder: _inputBorder,
                                                                  focusedErrorBorder: _inputBorder,
                                                                  contentPadding: EdgeInsets.all(0),
                                                                  prefixIcon: Icon(
                                                                    Icons.lock,
                                                                    size: _iconSize*0.5,
                                                                  ),
                                                                  suffixIcon: Icon(
                                                                    Icons.remove_red_eye,
                                                                    size: _iconSize*0.5,
                                                                  ),
                                                                  labelText: 'Confirm Password',
                                                                  focusColor: Colors.blueGrey[100],
                                                                  fillColor: Colors.blueGrey[100],
                                                                ),
                                                                onChanged: (String value){
                                                                  //TODO:
                                                                },
                                                                onSubmitted: (String value){
                                                                  //TODO:
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20,),
                                          Transform(
                                            alignment: FractionalOffset.center,
                                            transform: Matrix4.identity()
                                              ..setEntry(3, 2, 0.002)
                                              ..rotateY(pi*_loginBtnFlipAnimation.value),
                                            child: _loginBtnFlipAnimation.value<=0.5?
                                            Container(
                                              height: 110,
                                              width: 120,
                                            ):
                                            Transform(
                                              alignment: FractionalOffset.center,
                                              transform: Matrix4.rotationY(pi*1.0),
                                              child: Center(
                                                child: Container(
                                                  height: 110,
                                                  width: 150,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        top: 55-_btnPosition,
                                                        child: InkWell(
                                                          onTap: (){
                                                            direction = Direction.FORWARD;
                                                            _containerTiltController.forward();
//                                                            Future.delayed(Duration(milliseconds: 100)).then((a){
//                                                              _containerShiftController.forward();
//                                                            });
                                                            _containerShiftController.forward();
                                                          },
                                                          child: Container(
                                                            width: 150,
                                                            child: Center(
                                                              child: Text(
                                                                'Forgot Password?',
                                                                style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 10,),
                                                      Positioned(
                                                        bottom: 45-_btnPosition,
                                                        child: Container(
                                                          width: 150,
                                                          height: 30,
                                                          child: Center(
                                                            child: GestureDetector(
                                                              onTap: (){
                                                                setState(() {
                                                                  if(login){
                                                                    _cnfPassHeightController.animateTo(1).then((value){
                                                                      _cnfPassPositionController.animateTo(1);
                                                                    });
                                                                    _btnTextController.forward();
                                                                    login = !login;
                                                                  }else{
                                                                    //TODO:
                                                                    _cnfPassPositionController.reverse().then((value){
                                                                      _cnfPassHeightController.animateTo(0);
                                                                    });
                                                                    _btnTextController.reverse();
                                                                    login = !login;
                                                                  }
                                                                });
                                                              },
                                                              child: Stack(
                                                                children: <Widget>[
                                                                  Positioned(
                                                                    bottom:5+_buttonTextPosition,
                                                                    child: Container(
                                                                      width: 150,
                                                                      child: Center(
                                                                        child: Text(
                                                                          'SIGN UP',
                                                                          style: TextStyle(
                                                                            color: kBlueColor,
                                                                            fontSize: 20,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom:-45+_buttonTextPosition,
                                                                    child: Container(
                                                                      width: 150,
                                                                      child: Center(
                                                                        child: Text(
                                                                          'LOGIN',
                                                                          style: TextStyle(
                                                                            color: kBlueColor,
                                                                            fontSize: 20,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          setState(() {
                                                            if(!_btnClicked){
                                                              _btnClicked = true;
                                                              _loginBtnSizeController.forward().then((value){
                                                              });

                                                              Future.delayed(Duration(seconds: 3)).then((a){
                                                                _loginBtnSizeController.reverse().then((b){
                                                                  _btnClicked = false;
                                                                  _btnPositionController.reverse().then((c){
                                                                    _loginBtnFlipController.animateTo(0,curve: Curves.easeInExpo).then((d){

                                                                    });
                                                                  });
                                                                  _inputWidthController.reverse().then((e){
                                                                    _iconSizeController.reverse().then((f){
                                                                      _containerSizeController.reverse().then((g){
                                                                        _colorContainerPosController.reverse().then((h){
                                                                         _colorContainerSizeController.animateTo(0).then((i){
                                                                            white=true;
                                                                            goToHomePage();
                                                                          });
                                                                        });
                                                                      });
                                                                    });
                                                                  });
                                                                });
                                                              });
                                                            }else{

                                                            }
                                                          });
                                                        },
                                                        child: Center(
                                                          child: Material(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(20)
                                                            ),
                                                            elevation: 10,
                                                            child: Container(
                                                              height: _loginBtnSize<=40?_loginBtnSize:40,
                                                              width: _loginBtnSize,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.all(
                                                                      Radius.circular(20)
                                                                  ),
                                                                  color: kBlueColor,
                                                              ),
                                                              child: Stack(
                                                                children: <Widget>[
                                                                  Positioned(
                                                                    top: -50+_buttonTextPosition,
                                                                    child: Container(
                                                                      height: 40,
                                                                      width: _loginBtnSize,
                                                                      child: Center(
                                                                        child: Text(
                                                                          'SIGN UP',
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: _buttonTextPosition,
                                                                    child: Container(
                                                                      height: 40,
                                                                      width: _loginBtnSize,
                                                                      child: Center(
                                                                        child: Text(
                                                                          'LOGIN',
                                                                          style: TextStyle(
                                                                            fontSize: 20,
                                                                            color: Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      _btnClicked?Center(
                                                        child: Container(
                                                          height: 40,
                                                          width: _loginBtnSizeAnimation.value*size.width*0.35,
                                                          decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(40)
                                                              )
                                                          ),
                                                        ),
                                                      ):SizedBox(),
                                                      _btnClicked?Center(
                                                        child: CircularProgressIndicator(
                                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                                        ),
                                                      ):SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -(_colorContainerPosition*1.3)+(_colorContainerSize>=size.width*0.3?0:((size.width*0.3)/2)-(_colorContainerSize/2)),
                                    left: _colorContainerSize>=size.width*0.3?0:((size.width*0.3)/2)-(_colorContainerSize/2),
                                    child: _flipAnimation.value<0.5?SizedBox():Transform(
                                      alignment: FractionalOffset.center,
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.002)
                                        ..rotateZ(-pi*_rotateValue),
                                      child: _flipAnimation.value<=0.5?SizedBox():Container(
                                        width: _colorContainerSize,
                                        height: _colorContainerSize*1.3,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(_containerSize*0.1),
                                          ),
                                          color:white?Colors.transparent:Colors.orange,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: size.width-_containerShiftValue,
              child: Transform(
                alignment: FractionalOffset.centerRight,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.002)
                  ..rotateY(pi*_containerTiltValue),
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: Center(
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.all(
                        Radius.circular(_containerSize*0.1)
                      ),
                      child: Container(
                        width: size.width*0.7,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(_containerSize*0.1)
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 10,right: 10,top: 30),
                              child: Container(
                                width: _inputWidth+_iconSize,
                                height: _iconSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  color: Colors.blue[100].withOpacity(0.5),
                                ),
                                child: TextField(
                                  cursorWidth: 1,
                                  decoration: InputDecoration(
                                    border: _inputBorder,
                                    disabledBorder: _inputBorder,
                                    enabledBorder: _inputBorder,
                                    errorBorder: _inputBorder,
                                    focusedErrorBorder: _inputBorder,
                                    contentPadding: EdgeInsets.all(0),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      size: _iconSize*0.5,
                                    ),
                                    labelText: 'Email',
                                    focusColor: Colors.blueGrey[100],
                                    fillColor: Colors.blueGrey[100],
                                  ),
                                  onChanged: (String value){
                                    //TODO:
                                  },
                                  onSubmitted: (String value){
                                    //TODO:
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'An email will be sent to your registered email address with a password recovery link.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30)
                              ),
                              child: Container(
                                height: 40,
                                width: size.width*0.3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30)
                                  ),
                                  color: kBlueColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'HELP ME',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: (){
                                direction = Direction.BACKWARD;
                                _containerTiltController.forward();
//                                Future.delayed(Duration(milliseconds: 100)).then((a){
//                                  _containerShiftController.reverse();
//                                });
                                _containerShiftController.reverse();
                              },
                              child: Text(
                                'GO BACK',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: kBlueColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ),
                  )
                ),
              ),
            ),
            _ripple(),
          ],
        ),
      ),
    );
  }

  Widget _ripple() {
    if (rect == null) {
      return Container();
    }
    return AnimatedPositioned(
      duration: _rectAnimationDuration,
      left: rect.left+51,
      right: MediaQuery.of(context).size.width - rect.right-51,
      top: rect.top+51,
      bottom: MediaQuery.of(context).size.height - rect.bottom-51,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(_containerSize*0.5),
          ),
          color: Colors.white,
        ),
      ),
    );
  }

}

class Direction{

  static const String FORWARD = 'forward';
  static const String BACKWARD = 'backward';

}
