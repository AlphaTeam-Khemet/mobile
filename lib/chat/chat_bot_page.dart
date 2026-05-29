import 'package:flutter/material.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {


  final TextEditingController messageController =
  TextEditingController();

  final ScrollController scrollController =
  ScrollController();


  List<Map<String, dynamic>> messages = [

    {
      "isUser": false,
      "message":
      "Welcome to KHEMET AI.\nAsk me anything about ancient Egypt, artifacts, museums, kings, or history.",
    },
  ];


  void sendMessage() async {

    if (messageController.text.trim().isEmpty) return;

    String userMessage = messageController.text;


    setState(() {

      messages.add({

        "isUser": true,
        "message": userMessage,
      });
    });

    messageController.clear();

    scrollToBottom();


    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    setState(() {

      messages.add({

        "isUser": false,

        "message":
        "Tutankhamun was an ancient Egyptian pharaoh of the 18th dynasty. He became king at age 9 and is famous for his nearly intact golden tomb discovered in 1922.",
      });
    });

    scrollToBottom();
  }


  void scrollToBottom() {

    Future.delayed(
      const Duration(milliseconds: 300),
          () {

        scrollController.animateTo(

          scrollController.position.maxScrollExtent,

          duration:
          const Duration(milliseconds: 400),

          curve: Curves.easeOut,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF2E8D5),

      body: SafeArea(

        child: Stack(

          children: [


            Positioned.fill(

              child: IgnorePointer(

                child: Center(

                  child: Opacity(

                    opacity: 0.25,

                    child: Image.asset(

                      "assets/image/A.png",

                      width: 360,
                      height: 360,

                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),


            Column(

              children: [



                Padding(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
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
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(width: 18),

                      Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: const [

                          Text(
                            "KHEMET AI",

                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Ask anything about Ancient Egypt",

                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


                Expanded(

                  child: ListView.builder(

                    controller: scrollController,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),

                    itemCount: messages.length,

                    itemBuilder: (context, index) {

                      final message = messages[index];

                      final bool isUser =
                      message['isUser'];

                      return Align(

                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,

                        child: Container(

                          margin: const EdgeInsets.only(
                            bottom: 14,
                          ),

                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),

                          constraints: BoxConstraints(
                            maxWidth:
                            MediaQuery.of(context)
                                .size
                                .width * 0.78,
                          ),

                          decoration: BoxDecoration(

                            color: isUser
                                ? const Color(0xFFC9A24D)
                                : Colors.white,

                            borderRadius:
                            BorderRadius.circular(22),

                            boxShadow: [

                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.05),

                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: Text(

                            message['message'],

                            style: TextStyle(

                              fontSize: 16,

                              height: 1.5,

                              color: isUser
                                  ? Colors.black
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),


                SizedBox(

                  height: 45,

                  child: ListView(

                    scrollDirection: Axis.horizontal,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                    ),

                    children: [

                      quickQuestion(
                        "Who was Tutankhamun?",
                      ),

                      quickQuestion(
                        "Who is Ramses?",
                      ),

                      quickQuestion(
                        "Tell me about pyramids",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),



                Padding(

                  padding: const EdgeInsets.only(
                    left: 14,
                    right: 14,
                    bottom: 16,
                  ),

                  child: Row(

                    children: [


                      Expanded(

                        child: Container(

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 18,
                          ),

                          decoration: BoxDecoration(

                            color: Colors.white,

                            borderRadius:
                            BorderRadius.circular(30),
                          ),

                          child: TextField(

                            controller: messageController,

                            decoration: const InputDecoration(

                              border: InputBorder.none,

                              hintText:
                              "Ask your museum guide...",
                            ),

                            onSubmitted: (value) {
                              sendMessage();
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),


                      GestureDetector(

                        onTap: sendMessage,

                        child: Container(

                          width: 58,
                          height: 58,

                          decoration: const BoxDecoration(

                            color: Color(0xFFC9A24D),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget quickQuestion(String text) {

    return GestureDetector(

      onTap: () {

        messageController.text = text;

        sendMessage();
      },

      child: Container(

        margin: const EdgeInsets.only(right: 10),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius:
          BorderRadius.circular(30),

          border: Border.all(
            color: const Color(0xFFE0C98F),
          ),
        ),

        child: Center(

          child: Text(

            text,

            style: const TextStyle(
              color: Color(0xFF7A5B2E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}