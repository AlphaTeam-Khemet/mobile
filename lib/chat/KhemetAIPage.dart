import 'package:flutter/material.dart';

class KhemetAIPage extends StatefulWidget {

  final String artifactTitle;

  const KhemetAIPage({
    Key? key,
    this.artifactTitle = "",
  }) : super(key: key);

  @override
  State<KhemetAIPage> createState() =>
      _KhemetAIPageState();
}

class _KhemetAIPageState
    extends State<KhemetAIPage> {

  final TextEditingController
  _messageController =
  TextEditingController();

  final ScrollController
  _scrollController =
  ScrollController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {

    super.initState();


    messages.add({

      "isUser": false,

      "message":
      widget.artifactTitle.isNotEmpty

          ? "Welcome to KHEMET AI.\nAsk me anything about ${widget.artifactTitle}."

          : "Welcome to KHEMET AI.\nAsk me anything about Ancient Egypt.",
    });
  }



  void sendMessage(String text) {

    if (text.trim().isEmpty) return;

    setState(() {

      messages.add({

        "isUser": true,
        "message": text,
      });

      messages.add({

        "isUser": false,

        "message":
        "Analyzing \"$text\"...\n\nThis artifact belongs to Ancient Egyptian civilization and contains historical importance.",
      });
    });

    _messageController.clear();

    Future.delayed(
      const Duration(milliseconds: 300),
          () {

        _scrollController.animateTo(

          _scrollController.position.maxScrollExtent,

          duration:
          const Duration(milliseconds: 300),

          curve: Curves.easeOut,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF3EBDD),

      body: SafeArea(

        child: Column(

          children: [


            Padding(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),

              child: Row(

                children: [

                  GestureDetector(

                    onTap: () {

                      Navigator.pop(context);
                    },

                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 18),

                  const Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(

                        "KHEMET AI",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                          FontWeight.w800,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(

                        "Your Smart Museum Guide",

                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),


            Expanded(

              child: ListView.builder(

                controller: _scrollController,

                padding:
                const EdgeInsets.all(18),

                itemCount: messages.length,

                itemBuilder: (context, index) {

                  final message =
                  messages[index];

                  final bool isUser =
                  message["isUser"];

                  return Align(

                    alignment:

                    isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,

                    child: Container(

                      margin:
                      const EdgeInsets.only(
                        bottom: 14,
                      ),

                      padding:
                      const EdgeInsets.all(16),

                      constraints:
                      const BoxConstraints(
                        maxWidth: 300,
                      ),

                      decoration: BoxDecoration(

                        color:

                        isUser
                            ? const Color(0xFFC9A24D)
                            : Colors.white,

                        borderRadius:
                        BorderRadius.circular(22),
                      ),

                      child: Text(

                        message["message"],

                        style: TextStyle(

                          fontSize: 16,

                          height: 1.5,

                          color:
                          isUser
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


            Container(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),

              decoration: const BoxDecoration(

                color: Colors.white,

                borderRadius:
                BorderRadius.only(

                  topLeft:
                  Radius.circular(24),

                  topRight:
                  Radius.circular(24),
                ),
              ),

              child: Row(

                children: [

                  Expanded(

                    child: TextField(

                      controller:
                      _messageController,

                      decoration:
                      InputDecoration(

                        hintText:
                        "Ask anything...",

                        filled: true,

                        fillColor:
                        const Color(
                          0xFFF5F5F5,
                        ),

                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(
                            30,
                          ),

                          borderSide:
                          BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  GestureDetector(

                    onTap: () {

                      sendMessage(
                        _messageController.text,
                      );
                    },

                    child: Container(

                      width: 54,
                      height: 54,

                      decoration:
                      const BoxDecoration(

                        color:
                        Color(0xFFC9A24D),

                        shape: BoxShape.circle,
                      ),

                      child: const Icon(

                        Icons.send,

                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}