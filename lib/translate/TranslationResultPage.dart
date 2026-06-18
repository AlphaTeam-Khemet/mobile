import 'dart:io';
import 'package:flutter/material.dart';
import '../localization/app_localization.dart';
import '../shared_widgets/language_manager.dart';
import '../core/network/scan_service.dart';
import '../shared_widgets/voice_guide_button.dart';

class TranslationResultPage extends StatefulWidget {
  final bool isHieroglyphMode;
  final String imagePath;

  const TranslationResultPage({
    super.key,
    required this.isHieroglyphMode,
    required this.imagePath,
  });

  @override
  State<TranslationResultPage> createState() => _TranslationResultPageState();
}

class _TranslationResultPageState extends State<TranslationResultPage> {
  bool _isLoading = true;
  String _title = '';
  String _description = '';
  String? _errorMessage;
  String? _artifactId;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    final langCode = LanguageManager.currentLanguage.value;
    ScanResult result;
    
    if (widget.isHieroglyphMode) {
      result = await ScanService().translateHieroglyph(widget.imagePath, langCode);
    } else {
      result = await ScanService().scanArtifact(widget.imagePath, langCode);
    }

    if (!mounted) return;

    if (result.success && result.data != null) {
      setState(() {
        _isLoading = false;
        if (widget.isHieroglyphMode) {
          final data = result.data!['data'];
          _title = AppLocalization.translate("translation_text");
          
          if (data?['detection']?['total_symbols'] == 0) {
             _description = "No clear hieroglyphs were detected in the image. Please try getting closer, ensuring good lighting, and keeping the symbols in focus.";
          } else {
             _description = data?['translation']?['text'] ?? "No translation available";
             if (data?['translation']?['combined_phonetics'] != null && 
                 data['translation']['combined_phonetics'].toString().isNotEmpty) {
               _description += "\n\nPhonetics: " + data['translation']['combined_phonetics'];
             }
          }
        } else {
          final monument = result.data!['monument'];
          if (monument != null) {
            _artifactId = monument['id']?.toString() ?? monument['_id']?.toString();
            _title = monument['name'] ?? 'Recognized Artifact';
            _description = result.data!['ai_guide_description'] ?? monument['description'] ?? 'No details available.';
          } else {
            _title = 'Artifact Not Found';
            _description = result.data!['message'] ?? 'Could not identify this artifact in the database.';
          }
        }
      });
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = result.errorMessage ?? 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF3EBDD),

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Row(

                children: [

                  IconButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    widget.isHieroglyphMode
                        ? AppLocalization.translate("translation_result")
                        : AppLocalization.translate("artifact_information"),

                    style: TextStyle(

                      fontSize: 28,

                      fontWeight: FontWeight.w700,

                      color: Colors.black87,

                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(
                  File(widget.imagePath),
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),
              
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFFC9A24D)),
                  ),
                )
              else if (_errorMessage != null)
                Expanded(
                  child: Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Expanded(

                child: Container(

                  width: double.infinity,

                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(

                    color: Colors.white.withOpacity(0.65),

                    borderRadius:
                    BorderRadius.circular(26),

                    border: Border.all(
                      color: const Color(0xFFE0C98F),
                      width: 1.4,
                    ),
                  ),

                  child: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [


                      Row(

                        children: [

                          const Icon(

                            Icons.translate,

                            size: 18,

                            color: Color(0xFF9B7B42),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            widget.isHieroglyphMode
                                ? AppLocalization.translate("translation_result")
                                : AppLocalization.translate("artifact_information"),

                            style: TextStyle(

                              fontSize: 11,

                              height: 1.1,

                              letterSpacing: 1,

                              fontWeight: FontWeight.w800,

                              color:
                              const Color(0xFF9B7B42)
                                  .withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 26),

                      Text(
                        _title.isNotEmpty ? _title :
                        (widget.isHieroglyphMode
                            ? AppLocalization.translate("translation_text")
                            : AppLocalization.translate("artifact_title")),

                        style: TextStyle(

                          fontSize: 22,

                          fontWeight: FontWeight.w800,

                          color: Colors.black87,

                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(

                        width: 46,
                        height: 2,

                        decoration: BoxDecoration(

                          color: const Color(0xFFD2B06A),

                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            _description,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black54,
                              height: 1.7,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      
                      if (!widget.isHieroglyphMode && _artifactId != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: VoiceGuideButton(
                            artifactId: _artifactId!,
                            artifactName: _title,
                            artifactDescription: _description,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              if (!_isLoading)


              Row(

                children: [

                  Expanded(

                    child: OutlinedButton(

                      style: OutlinedButton.styleFrom(

                        side: const BorderSide(
                          color: Color(0xFF9B7B42),
                          width: 1.4,
                        ),

                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                      ),

                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child:  Row(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Icon(
                            Icons.refresh,
                            color: Color(0xFF9B7B42),
                            size: 20,
                          ),

                          SizedBox(width: 8),

                          Text(
                            AppLocalization.translate("retry"),

                            style: TextStyle(

                              color: Color(0xFF9B7B42),

                              fontSize: 18,

                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(

                    flex: 2,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                        const Color(0xFFC9A24D),

                        elevation: 0,

                        padding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(18),
                        ),
                      ),

                      onPressed: () {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(

                           SnackBar(

                            backgroundColor:
                            Color(0xFFC9A24D),

                            content: Text(
                              AppLocalization.translate(
                                "save_to_collection",
                              ),

                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },

                      child:  Row(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Icon(
                            Icons.bookmark_border,
                            color: Colors.black,
                            size: 22,
                          ),

                          SizedBox(width: 10),

                          Text(
                            AppLocalization.translate(
                              "save_to_collection",
                            ),

                            textAlign: TextAlign.center,

                            style: TextStyle(

                              color: Colors.black,

                              fontSize: 18,

                              height: 1.2,

                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}