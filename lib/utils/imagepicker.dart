import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/widgets/custom_snackbar.dart';

pickImage(ImageSource source,BuildContext context) async {
  final _imagepicker = ImagePicker();

  XFile? _file = await _imagepicker.pickImage(source: source);

  if (_file !=null) {
    return await _file.readAsBytes();
  }
  else{
   customSnackbar(context, 'Select an Image');
  }
}
