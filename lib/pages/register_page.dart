import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:handong_manna/constants/color_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key:key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  File? _image;
  final formKey = GlobalKey<FormState>();

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this._image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name_v1 = basename(imagePath);
    final image = File('${directory.path}/$name_v1');

    return File(imagePath).copy(image.path);
  }

  String name = '';
  String student_id = '';
  String age = '';
  String major = '';
  String photo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.mainBlue,
      ),
        body: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          child: Scrollbar(
            thickness: 4.0,
            radius: Radius.circular(8.0),
            isAlwaysShown: true,
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: this.formKey,
                    child: Column(
                      children: [
                        _image != null
                            ? Image.file(_image!,
                            width: 250, height: 250, fit: BoxFit.cover)
                            : Image.file(File('assets/HandongMannaLogo.png')),
                        // Image.network('https://picsum.photos/250?image=9'),
                        SizedBox(height:30),
                        Column(
                            crossAxisAlignment : CrossAxisAlignment.start,
                            children: [
                              Text(
                                "사진",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 30),
                              CustomButton(
                                title: "Pick an Image",
                                icon: Icons.image_outlined,
                                onClick: () => getImage(ImageSource.gallery),
                              ),
                              SizedBox(height: 30),
                              renderTextFormField(
                                label: '이름',
                                onSaved: (val) {
                                  setState(() {
                                    this.name = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '필수 필드입니다.';
                                  }
                                  return null;
                                },
                              ),
                              renderTextFormField(
                                label: '학번',
                                onSaved: (val) {
                                  setState(() {
                                    this.student_id = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '필수 필드입니다.';
                                  }
                                  return null;
                                },
                              ),
                              renderTextFormField(
                                label: '나이',
                                onSaved: (val) {
                                  setState(() {
                                    this.age = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '필수 필드입니다.';
                                  }
                                  return null;
                                },
                              ),
                              renderTextFormField(
                                label: '전공/직업',
                                onSaved: (val) {
                                  setState(() {
                                    this.major = val;
                                  });
                                },
                                validator: (val) {
                                  if (val.length < 1) {
                                    return '필수 필드입니다.';
                                  }
                                  return null;
                                },
                              ),

                            ]),

                        // renderTextFormField(
                        //   label: '사진',
                        //   onSaved: (val) {
                        //     setState(() {
                        //       this.photo = val;
                        //     });
                        //   },
                        //   validator: (val) {
                        //     if(val.length < 1){
                        //       return '필수 필드입니다.' ;
                        //     }
                        //     return null;
                        //   },
                        // ), // 여기에 폼을 작성할거예요!
                        renderSubmitButton(),
                        renderStates(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  renderStates() {
    return Column(
      children: [
        Text(
          '이름: $name',
        ),
        Text(
          '학번: $student_id',
        ),
        Text(
          '나이: $age',
        ),
        Text(
          '전공/직업: $major',
        ),
        Text(
          '사진: $photo',
        ),
      ],
    );
  }

  renderSubmitButton() {
    return ElevatedButton(
      child: Text(
        'Saved!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        if (this.formKey.currentState?.validate() ?? false) {
          this.formKey.currentState?.save();
          Get.snackbar(
            '저장성공',
            '폼이 저장되었습니다!',
            backgroundColor: Colors.white,
          );
        }
      },
    );
  }

  renderTextFormField({
    required String label,
    required FormFieldSetter? onSaved,
    required FormFieldValidator? validator,
  }) {
    assert(label != null);
    assert(onSaved != null);
    assert(validator != null);

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.always,
        ),
        Container(height: 16.0),
      ],
    );
  }

  Widget CustomButton({
    required String title,
    required IconData icon,
    required VoidCallback onClick,
  }) {
    return Container(
      child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          children: [
            Icon(icon),
            SizedBox(
              width: 20,
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
