import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../bloc/edge_detection_bloc.dart';
import '../widgets/image_preview.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_message.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edge Detection'), centerTitle: true),
      body: BlocBuilder<EdgeDetectionBloc, EdgeDetectionState>(
        builder: (context, state) {
          if (state is EdgeDetectionLoading) {
            return const LoadingIndicator();
          }

          if (state is EdgeDetectionError) {
            return ErrorMessage(message: state.message);
          }

          if (state is EdgeDetectionSuccess) {
            return Column(
              children: [
                Expanded(child: ImagePreview(imageFile: state.processedImage)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(context),
                        icon: const Icon(Icons.add_photo_alternate),
                        label: const Text('New Image'),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            () => _saveImage(context, state.processedImage),
                        icon: const Icon(Icons.save),
                        label: const Text('Save'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Select an image to detect edges',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(context),
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Select Image'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (context.mounted) {
          context.read<EdgeDetectionBloc>().add(
            ProcessImageEvent(File(pickedFile.path)),
          );
        }
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission to access photos is required'),
          ),
        );
      }
    }
  }

  void _saveImage(BuildContext context, File processedImage) {
    context.read<EdgeDetectionBloc>().add(SaveImageEvent(processedImage));
  }
}
