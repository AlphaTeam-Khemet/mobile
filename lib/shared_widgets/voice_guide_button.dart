import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../localization/app_localization.dart';
import 'language_manager.dart';
import '../core/network/voice_service.dart';
import 'dart:async';

class VoiceGuideButton extends StatefulWidget {
  final String artifactId;
  final String artifactName;
  final String artifactDescription;

  const VoiceGuideButton({
    Key? key,
    required this.artifactId,
    required this.artifactName,
    required this.artifactDescription,
  }) : super(key: key);

  @override
  State<VoiceGuideButton> createState() => _VoiceGuideButtonState();
}

class _VoiceGuideButtonState extends State<VoiceGuideButton> {
  bool isLoading = false;
  bool isPlaying = false;
  String? audioUrl;
  String? errorMessage;
  bool slowRequest = false;

  late AudioPlayer audioPlayer;
  Timer? slowTimer;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant VoiceGuideButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.artifactId != widget.artifactId || 
        LanguageManager.currentLanguage.value != LanguageManager.currentLanguage.value) {
      audioPlayer.stop();
      setState(() {
        audioUrl = null;
        isPlaying = false;
        errorMessage = null;
        slowRequest = false;
      });
    }
  }

  @override
  void dispose() {
    slowTimer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _handleFetchNarration() async {
    if (audioUrl != null) {
      _togglePlay();
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      slowRequest = false;
    });

    slowTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          slowRequest = true;
        });
      }
    });

    try {
      final url = await VoiceService().generateNarration(
        artifactId: widget.artifactId,
        artifactName: widget.artifactName,
        artifactDescription: widget.artifactDescription,
        language: LanguageManager.currentLanguage.value,
      );

      if (mounted) {
        if (url != null) {
          setState(() {
            audioUrl = url;
          });
          await audioPlayer.play(UrlSource(url));
        } else {
          setState(() {
            errorMessage = 'Audio unavailable.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load voice guide.';
        });
      }
    } finally {
      if (mounted) {
        slowTimer?.cancel();
        setState(() {
          isLoading = false;
          slowRequest = false;
        });
      }
    }
  }

  void _togglePlay() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.currentLanguage.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: isLoading ? null : _handleFetchNarration,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC5A059), Color(0xFF8B6D3A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Opacity(
              opacity: isLoading ? 0.7 : 1.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  else if (isPlaying)
                    const Icon(Icons.pause, color: Colors.white, size: 22)
                  else
                    const Icon(Icons.mic, color: Colors.white, size: 22),
                  
                  const SizedBox(width: 10),
                  
                  Text(
                    isLoading
                        ? (lang == 'ar' ? 'جارٍ التوليد...' : 'Generating audio...')
                        : isPlaying
                            ? (lang == 'ar' ? 'يتم التشغيل...' : 'Playing Story...')
                            : (lang == 'ar' ? 'استمع للقصة' : 'Hear the Story'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        if (isLoading && slowRequest)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              lang == 'ar'
                  ? '⏳ قد يستغرق هذا لحظة في أول مرة...'
                  : '⏳ Generating audio — please wait a moment...',
              style: const TextStyle(
                color: Color(0xFF795548),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          
        if (errorMessage != null)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Color(0xFFD32F2F), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Color(0xFFD32F2F), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
