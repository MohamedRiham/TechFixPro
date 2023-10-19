import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
class FileSelectionService {
  Future<String?> selectFile() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      // The user canceled image selection
      return null;
    }
    return image.path;
  }

Future<String?> SelectDocument() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    PlatformFile file = result.files.first;
    if (file != null) {
      // Use the selected file path or do something with it
      String? filePath = file.path;
      return filePath;
    }
  }
  // Return null if no file was selected or an error occurred
  return null;
}

}//end class
