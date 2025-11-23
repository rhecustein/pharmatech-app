import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Pick image from camera
  Future<File?> pickImageFromCamera({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from camera: $e');
      rethrow;
    }
  }

  // Pick image from gallery
  Future<File?> pickImageFromGallery({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      rethrow;
    }
  }

  // Pick multiple images from gallery
  Future<List<File>> pickMultipleImages({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality ?? 85,
      );

      return images.map((image) => File(image.path)).toList();
    } catch (e) {
      print('Error picking multiple images: $e');
      rethrow;
    }
  }

  // Pick video from camera
  Future<File?> pickVideoFromCamera({
    Duration? maxDuration,
  }) async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: maxDuration,
      );

      if (video != null) {
        return File(video.path);
      }
      return null;
    } catch (e) {
      print('Error picking video from camera: $e');
      rethrow;
    }
  }

  // Pick video from gallery
  Future<File?> pickVideoFromGallery({
    Duration? maxDuration,
  }) async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: maxDuration,
      );

      if (video != null) {
        return File(video.path);
      }
      return null;
    } catch (e) {
      print('Error picking video from gallery: $e');
      rethrow;
    }
  }

  // Show source selection dialog (camera or gallery)
  Future<File?> pickImageWithDialog({
    required bool useCamera,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    if (useCamera) {
      return await pickImageFromCamera(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
    } else {
      return await pickImageFromGallery(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
    }
  }
}

// Provider
final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerService();
});
