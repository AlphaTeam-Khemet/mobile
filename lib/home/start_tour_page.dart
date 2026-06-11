import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../localization/app_localization.dart';

class StartTourPage extends StatefulWidget {
  const StartTourPage({Key? key}) : super(key: key);

  @override
  State<StartTourPage> createState() => _StartTourPageState();
}

class _StartTourPageState extends State<StartTourPage> {


  late VideoPlayerController controller;


  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(
      "assets/video/tour.mp4",
    )
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {

    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      body: SizedBox.expand(

        child: Stack(

          children: [

            Positioned.fill(

              child: Image.asset(
                "assets/image/BG.png",

                fit: BoxFit.cover,
              ),
            ),


            Positioned.fill(

              child: Container(
                color: Colors.black.withOpacity(0.45),
              ),
            ),

            SafeArea(

              bottom: false,

              child: LayoutBuilder(

                builder: (context, constraints) {

                  return SingleChildScrollView(

                    physics: const BouncingScrollPhysics(),

                    child: ConstrainedBox(

                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),

                      child: Padding(

                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            Row(
                              children: [

                                GestureDetector(

                                  onTap: () {
                                    Navigator.pop(context);
                                  },

                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Color(0xFFC9A24D),
                                  ),
                                ),

                                const Spacer(),

                                Column(
                                  children:  [
                                      Text(
                                        AppLocalization.translate("khemet"),                                      style: TextStyle(
                                        color: Color(0xFFC9A24D),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 2,
                                      ),
                                    ),

                                    SizedBox(height: 2),

                                    Text(
                                      AppLocalization.translate("start_tour"),

                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),
                              ],
                            ),

                            const SizedBox(height: 22),


                            Container(

                              width: double.infinity,

                              padding: const EdgeInsets.all(10),

                              decoration: BoxDecoration(

                                borderRadius:
                                BorderRadius.circular(20),

                                border: Border.all(
                                  color: const Color(0xFFC9A24D),
                                  width: 1.2,
                                ),
                              ),

                              child: ClipRRect(

                                borderRadius:
                                BorderRadius.circular(18),

                                child: Stack(

                                  alignment: Alignment.center,

                                  children: [


                                    controller.value.isInitialized

                                        ? SizedBox(

                                      width: double.infinity,

                                      height:
                                      isFullScreen ? 500 : 260,

                                      child: FittedBox(

                                        fit: BoxFit.cover,

                                        child: SizedBox(

                                          width:
                                          controller.value.size.width,

                                          height:
                                          controller.value.size.height,

                                          child: VideoPlayer(
                                            controller,
                                          ),
                                        ),
                                      ),
                                    )

                                        : Container(
                                      height: 260,
                                      color: Colors.black,
                                    ),


                                    if (!controller.value.isPlaying)

                                      GestureDetector(

                                        onTap: () {

                                          setState(() {
                                            controller.play();
                                          });
                                        },

                                        child: Container(

                                          width: 75,
                                          height: 75,

                                          decoration: BoxDecoration(

                                            color: const Color(0xFFC9A24D)
                                                .withOpacity(0.95),

                                            shape: BoxShape.circle,
                                          ),

                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                            size: 45,
                                          ),
                                        ),
                                      ),

                                    Positioned(

                                      top: 14,
                                      right: 14,

                                      child: Row(
                                        children: [


                                          GestureDetector(

                                            onTap: () {

                                              setState(() {

                                                controller.value.isPlaying

                                                    ? controller.pause()

                                                    : controller.play();
                                              });
                                            },

                                            child: Container(

                                              padding:
                                              const EdgeInsets.all(8),

                                              decoration: BoxDecoration(

                                                color: Colors.black
                                                    .withOpacity(0.55),

                                                shape: BoxShape.circle,
                                              ),

                                              child: Icon(

                                                controller.value.isPlaying

                                                    ? Icons.pause

                                                    : Icons.play_arrow,

                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 10),

                                          GestureDetector(

                                            onTap: () {

                                              setState(() {
                                                isFullScreen =
                                                !isFullScreen;
                                              });
                                            },

                                            child: Container(

                                              padding:
                                              const EdgeInsets.all(8),

                                              decoration: BoxDecoration(

                                                color: Colors.black
                                                    .withOpacity(0.55),

                                                shape: BoxShape.circle,
                                              ),

                                              child: Icon(

                                                isFullScreen

                                                    ? Icons.fullscreen_exit

                                                    : Icons.fullscreen,

                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            Row(

                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                              children: [

                                Text(
                                  _formatDuration(
                                    controller.value.position,
                                  ),

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),

                                Text(
                                  _formatDuration(
                                    controller.value.duration,
                                  ),

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 26),

                             Text(
                                AppLocalization.translate("discover_the_n") +
                                    AppLocalization.translate("ancient_egypt"),
                              style: TextStyle(
                                color: Color(0xFFC9A24D),
                                fontSize: 34,
                                height: 1.1,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 18),

                              Text(
                                AppLocalization.translate("discover_ancient_egypt_through_khemet"),
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 3,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 30),

                            Divider(
                              color: Colors.white.withOpacity(0.2),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [

                                Expanded(

                                  child: Column(

                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children: [

                                      Text(
                                        AppLocalization.translate("duration"),

                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        _formatDuration(
                                          controller.value.duration,
                                        ),

                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Expanded(

                                  child: Column(

                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                    children:  [

                                      Text(
                                        AppLocalization.translate("quality"),

                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                      ),

                                      SizedBox(height: 6),

                                      Text(
                                        AppLocalization.translate("4k_uhd"),

                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  String _formatDuration(Duration duration) {

    final minutes =
    duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds =
    duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return "$minutes:$seconds";
  }
}