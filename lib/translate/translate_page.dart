import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

import '../forgot_password/verification_code.dart';
import '../localization/app_localization.dart';
import 'TranslationResultPage.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  CameraController? _cameraController;
  bool isHieroglyphMode = true;
  bool isFlashOn = false;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Camera permission denied')));

      return;
    }

    final cameras = await availableCameras();

    final firstCamera = cameras.first;

    _cameraController = CameraController(firstCamera, ResolutionPreset.medium);

    await _cameraController!.initialize();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null) return;

    isFlashOn = !isFlashOn;

    await _cameraController!.setFlashMode(
      isFlashOn ? FlashMode.torch : FlashMode.off,
    );

    setState(() {});
  }

  Future<void> _openGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) => ImagePreviewPage(imagePath: image.path),
        ),
      );
    }
  }

  void _showScanOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.translate, color: Color(0xFFB68D4C)),
                title: Text(
                  AppLocalization.translate("translate_hieroglyphs"),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    isHieroglyphMode = true;
                  });

                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.museum, color: Color(0xFFB68D4C)),
                title: Text(
                  AppLocalization.translate("scan_artifact"),
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    isHieroglyphMode = false;
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        alignment: Alignment.center,

        children: [
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.brown),
                )
              : CameraPreview(_cameraController!),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),

              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),

          Center(
            child: Container(
              width: screenWidth * 0.7,

              height: screenWidth * 0.7,

              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFB68D4C), width: 3),

                borderRadius: BorderRadius.circular(12),
              ),

              child: const Icon(Icons.add, color: Color(0xFFB68D4C), size: 30),
            ),
          ),

          Positioned(
            top: screenHeight * 0.08,

            left: 0,
            right: 0,

            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,

                    color: Colors.white,

                    size: 20,
                  ),

                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                Expanded(
                  child: Text(
                    isHieroglyphMode
                        ? AppLocalization.translate("translate_hieroglyphs")
                        : AppLocalization.translate("scan_artifact"),

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ),

                IconButton(
                  onPressed: _showScanOptions,

                  icon: const Icon(
                    Icons.tune,
                    color: Color(0xFFB68D4C),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 40,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                IconButton(
                  icon: Icon(
                    isFlashOn ? Icons.flash_on : Icons.flash_off,

                    color: Colors.white,

                    size: 28,
                  ),

                  onPressed: _toggleFlash,
                ),

                const SizedBox(width: 40),

                Container(
                  width: 80,

                  height: 80,

                  decoration: BoxDecoration(
                    color: const Color(0xFFB68D4C),

                    shape: BoxShape.circle,

                    border: Border.all(color: Colors.white, width: 3),
                  ),

                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt,

                      color: Colors.white,

                      size: 36,
                    ),

                    onPressed: () async {
                      if (_cameraController == null ||
                          !_cameraController!.value.isInitialized)
                        return;

                      await _cameraController!.takePicture();

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => TranslationResultPage(
                            isHieroglyphMode: isHieroglyphMode,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 40),

                IconButton(
                  icon: const Icon(
                    Icons.photo_library,

                    color: Colors.white,

                    size: 28,
                  ),

                  onPressed: _openGallery,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;

  const ImagePreviewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selected Image")),

      body: Center(child: Image.file(File(imagePath), fit: BoxFit.contain)),
    );
  }
}
