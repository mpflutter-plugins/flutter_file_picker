import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class FilePickerMP extends FilePicker {
  static final channel = MethodChannel('file_picker/mp');

  static final instance = FilePickerMP();

  @override
  Future<FilePickerResult?> pickFiles(
      {String? dialogTitle,
      String? initialDirectory,
      FileType type = FileType.any,
      List<String>? allowedExtensions,
      Function(FilePickerStatus p1)? onFileLoading,
      bool allowCompression = true,
      bool allowMultiple = false,
      bool withData = false,
      bool withReadStream = false,
      bool lockParentWindow = false}) async {
    final result = await channel.invokeMethod("pickFiles", {
      "dialogTitle": dialogTitle,
      "initialDirectory": initialDirectory,
      "type": type.index,
      "allowedExtensions": allowedExtensions,
      "allowCompression": allowCompression,
      "allowMultiple": allowMultiple,
      "withData": withData,
      "withReadStream": withReadStream,
      "lockParentWindow": lockParentWindow,
    });
    final mapedResult = <PlatformFile>[];
    if (result is List) {
      for (var element in result) {
        if (element is Map) {
          mapedResult.add(PlatformFile(
            path: element['path'],
            name: element['name'],
            size: element['size'],
            bytes: element['bytes'] != null
                ? base64.decode(element['bytes'])
                : null,
            identifier: element['identifier'],
          ));
        }
      }
    }
    return FilePickerResult(mapedResult);
  }

  @override
  Future<bool?> clearTemporaryFiles() async {
    return await channel.invokeMethod('clearTemporaryFiles');
  }

  @override
  Future<String?> getDirectoryPath(
      {String? dialogTitle,
      bool lockParentWindow = false,
      String? initialDirectory}) async {
    return await channel.invokeMethod('getDirectoryPath', {
      "dialogTitle": dialogTitle,
      "lockParentWindow": lockParentWindow,
      "initialDirectory": initialDirectory,
    });
  }

  @override
  Future<String?> saveFile(
      {String? dialogTitle,
      String? fileName,
      String? initialDirectory,
      FileType type = FileType.any,
      List<String>? allowedExtensions,
      bool lockParentWindow = false}) async {
    return await channel.invokeMethod('saveFile', {
      "dialogTitle": dialogTitle,
      "fileName": fileName,
      "initialDirectory": initialDirectory,
      "type": type.index,
      "allowedExtensions": allowedExtensions,
      "lockParentWindow": lockParentWindow,
    });
  }
}
