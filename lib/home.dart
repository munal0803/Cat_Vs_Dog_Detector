import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';

class hoome extends StatefulWidget {
  @override
  _hoomeState createState() => _hoomeState();
}

class _hoomeState extends State<hoome> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      title: Text("DOGS VS CATS" , style: TextStyle(
        color: Colors.brown,
        fontWeight:FontWeight.w700,
        fontSize:20,
      ),),
      seconds: 2,
      navigateAfterSeconds:Mainscreen(),
      image: Image.asset('assets/3.1 cat.png'),
    );
  }
}


class Mainscreen extends StatefulWidget {
  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  bool _loading = true;
  late File _image;
  late List _output;
  final picker = ImagePicker();


  void initState(){
    super.initState();
    loadModel().then((value){
      setState(() {
      });
    });
  }
  classifyImage(File image) async{
    var output = await Tflite.runModelOnImage(path: image.path,numResults: 2,threshold: 0.5,imageMean: 127.5,imageStd: 127.5,);
  setState(() {
    _output = output!;
    _loading = false;
  });
  }

  loadModel() async{
  await Tflite.loadModel(model: 'assets/model_unquant.tflite',labels: 'assets/labels.txt');
  }

void dispose(){
    Tflite.close();
    super.dispose();
}
pickImage() async{
    var image = await picker.getImage(source:ImageSource.camera);
    if(image == null){
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }
  pickGalleryImage() async{
    var image = await picker.getImage(source:ImageSource.gallery);
    if(image == null){
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding:EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height:40,
          ),
         SizedBox(
           height: 20,
         ),
          Text("Using CNN in Flutter",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 10,
            decoration: TextDecoration.none,
          ),),
          SizedBox(
            height:15,
          ),
          Text("Cat and Dog Detector",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            decoration: TextDecoration.none,
          ),),
          SizedBox(
            height: 40,
          ),

          Center(
            child:_loading ? Container(
              width: 280,
              child: Column(
                children: [
                  Image.asset("assets/3.1 cat.png"),
                ],
              ),
            ) : Container(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: Image.file(_image),
                  ),
                  SizedBox(
                    height:20,
                  ),
                  _output != null ?
                  Text('${_output[0]['label']}' ,style: TextStyle(
                    color:Colors.white,
                    decoration: TextDecoration.none,),):Container(),

                  SizedBox(
                    height:20,
                  ),
                ],
              ),
            ),

          ),

          Container(
            width: MediaQuery.of(context).size.width,
            child:
              Column(
                children: [
                GestureDetector(
                  onTap:pickImage,
                  child: Container(
                    width:MediaQuery.of(context).size.width-140,
                    alignment: Alignment.center,
                    padding: 
                    EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                    decoration: BoxDecoration(
                      color:Colors.redAccent,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: Text("Take a Photo",style:TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                        decoration: TextDecoration.none,
                    )),
                  ),
                ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap:pickGalleryImage,
                    child: Container(
                      width:MediaQuery.of(context).size.width-140,
                      alignment: Alignment.center,
                      padding:
                      EdgeInsets.symmetric(horizontal: 24,vertical: 10),
                      decoration: BoxDecoration(
                          color:Colors.redAccent,
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text("Camera Roll",style:TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        decoration: TextDecoration.none,


                      )),
                    ),
                  ),
                ],
              )
          ),
        ],
      )
    );
  }
}
