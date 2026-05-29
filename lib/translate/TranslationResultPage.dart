import 'package:flutter/material.dart';

class TranslationResultPage extends StatelessWidget {
  const TranslationResultPage({super.key});

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

                  const Text(

                    "Translation Result",

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

                borderRadius:
                BorderRadius.circular(24),

                child: Image.asset(

                  "assets/image/artifact.png",

                  width: double.infinity,

                  height: 240,

                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

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

                            "DETECTED\nMEANING",

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

                      const Text(

                        "\"The King, Lord of the\n"
                            "Two Lands, giving life\n"
                            "like Re forever.\"",

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

                      const Text(

                        "He creates the dawn and establishes\n"
                            "the laws of Maat across the kingdom.\n"
                            "This inscription likely dates back to\n"
                            "the\n"
                            "New Kingdom period, signifying royal\n"
                            "authority and divine favor.",

                        style: TextStyle(

                          fontSize: 17,

                          color: Colors.black54,

                          height: 1.7,

                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),


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

                      child: const Row(

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

                            "Retry",

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

                          const SnackBar(

                            backgroundColor:
                            Color(0xFFC9A24D),

                            content: Text(

                              "Saved to Collection",

                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },

                      child: const Row(

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

                            "Save to\nCollection",

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