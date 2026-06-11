import 'package:flutter/material.dart';

import '../localization/app_localization.dart';

class ChatItem {
  String title;

  List<Map<String, dynamic>> messages;

  ChatItem({required this.title, required this.messages});
}

class ChatBotPage extends StatefulWidget {
  final String? artifactName;

  const ChatBotPage({Key? key, this.artifactName}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  List<ChatItem> recentChats = [];

  List<Map<String, dynamic>> messages = [
    {
      "isUser": false,
      "message": AppLocalization.translate("welcome_to_khemet_ai_chat_intro"),
    },
  ];

  bool isFirstMessage = true;

  int? currentChatIndex;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (widget.artifactName != null && widget.artifactName!.isNotEmpty) {
        askAboutArtifact(widget.artifactName!);
      }
    });
  }

  void askAboutArtifact(String artifactName) async {
    if (isFirstMessage) {
      recentChats.insert(0, ChatItem(title: artifactName, messages: []));

      currentChatIndex = 0;

      isFirstMessage = false;
    }

    setState(() {
      messages.add({"isUser": true, "message": artifactName});

      recentChats[currentChatIndex!].messages = List.from(messages);
    });

    scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() {
      messages.add({
        "isUser": false,
        "messageKey": "searching_artifact_info",
        "artifactName": artifactName,
      });

      recentChats[currentChatIndex!].messages = List.from(messages);
    });

    scrollToBottom();
  }

  void sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    String userMessage = messageController.text.trim();

    if (isFirstMessage) {
      recentChats.insert(0, ChatItem(title: userMessage, messages: []));

      currentChatIndex = 0;

      isFirstMessage = false;
    }

    setState(() {
      messages.add({"isUser": true, "message": userMessage});

      recentChats[currentChatIndex!].messages = List.from(messages);
    });

    messageController.clear();

    scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() {
      messages.add({
        "isUser": false,

        "message":
            "Tutankhamun was an ancient Egyptian pharaoh of the 18th dynasty. He became king at age 9 and is famous for his nearly intact golden tomb discovered in 1922.",
      });

      recentChats[currentChatIndex!].messages = List.from(messages);
    });

    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,

        duration: const Duration(milliseconds: 400),

        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,

      backgroundColor: const Color(0xFFF2E8D5),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,

                      decoration: const BoxDecoration(
                        color: Color(0xFFC9A24D),

                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.smart_toy_outlined,

                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      AppLocalization.translate("khemet"),

                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(Icons.add_comment_outlined),

                title: Text(AppLocalization.translate("new_chat")),
                onTap: () {
                  Navigator.pop(context);

                  setState(() {
                    messages = [
                      {
                        "isUser": false,
                        "message":
                            "Welcome to KHEMET AI.\nAsk me anything about ancient Egypt, artifacts, museums, kings, or history.",
                      },
                    ];

                    isFirstMessage = true;

                    currentChatIndex = null;
                  });
                },
              ),

              const Divider(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                child: Text(
                  AppLocalization.translate("recent_chat"),

                  style: TextStyle(color: Color(0xFFC9A24D), fontSize: 18),
                ),
              ),

              Expanded(
                child: recentChats.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalization.translate("no_chats_yet"),

                          style: TextStyle(color: Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: recentChats.length,

                        itemBuilder: (context, index) {
                          final chat = recentChats[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),

                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(14),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),

                                    blurRadius: 4,

                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),

                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    messages = List.from(chat.messages);

                                    currentChatIndex = index;

                                    isFirstMessage = false;
                                  });

                                  Navigator.pop(context);

                                  scrollToBottom();
                                },

                                leading: Container(
                                  width: 34,
                                  height: 34,

                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF3E2B8),

                                    shape: BoxShape.circle,
                                  ),

                                  child: const Icon(
                                    Icons.chat_bubble_outline,

                                    size: 18,

                                    color: Color(0xFFC9A24D),
                                  ),
                                ),

                                title: Text(
                                  chat.title,

                                  maxLines: 1,

                                  overflow: TextOverflow.ellipsis,

                                  style: const TextStyle(
                                    fontSize: 13,

                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        TextEditingController editController =
                                            TextEditingController(
                                              text: chat.title,
                                            );

                                        showDialog(
                                          context: context,

                                          builder: (_) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),

                                              title: Text(
                                                AppLocalization.translate(
                                                  "rename_chat",
                                                ),
                                              ),

                                              content: TextField(
                                                controller: editController,

                                                decoration: InputDecoration(
                                                  hintText:
                                                      AppLocalization.translate(
                                                        "enter_new_name",
                                                      ),
                                                ),
                                              ),

                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },

                                                  child: Text(
                                                    AppLocalization.translate(
                                                      "cancel",
                                                    ),
                                                  ),
                                                ),

                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            const Color(
                                                              0xFFC9A24D,
                                                            ),
                                                      ),

                                                  onPressed: () {
                                                    setState(() {
                                                      chat.title =
                                                          editController.text;
                                                    });

                                                    Navigator.pop(context);
                                                  },

                                                  child: Text(
                                                    AppLocalization.translate(
                                                      "save",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },

                                      child: const Padding(
                                        padding: EdgeInsets.all(6),

                                        child: Icon(
                                          Icons.edit_outlined,

                                          size: 20,

                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          recentChats.removeAt(index);

                                          if (recentChats.isEmpty) {
                                            messages = [
                                              {
                                                "isUser": false,

                                                "message":
                                                    "Welcome to KHEMET AI.\nAsk me anything about ancient Egypt.",
                                              },
                                            ];

                                            isFirstMessage = true;
                                          }
                                        });
                                      },

                                      child: const Padding(
                                        padding: EdgeInsets.all(6),

                                        child: Icon(
                                          Icons.delete_outline,

                                          size: 22,

                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
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
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Opacity(
                    opacity: 0.18,

                    child: Image.asset(
                      "assets/image/A.png",

                      width: screenWidth * 0.70,

                      height: screenWidth * 0.70,

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

                        child: const Icon(Icons.arrow_back, size: 28),
                      ),

                      SizedBox(width: screenWidth * 0.04),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              AppLocalization.translate("khemet_ai"),

                              style: TextStyle(
                                fontSize: 26,

                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            SizedBox(height: 2),

                            Text(
                              AppLocalization.translate(
                                "ask_anything_about_ancient_egypt",
                              ),

                              style: TextStyle(
                                fontSize: 12,

                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState?.openDrawer();
                        },

                        child: Container(
                          width: 42,
                          height: 42,

                          decoration: const BoxDecoration(
                            color: Color(0xFFC9A24D),

                            shape: BoxShape.circle,
                          ),

                          child: const Icon(Icons.tune, color: Colors.black87),
                        ),
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

                      final bool isUser = message["isUser"];

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),

                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),

                          constraints: BoxConstraints(
                            maxWidth: screenWidth * 0.78,
                          ),

                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFFC9A24D)
                                : Colors.white,

                            borderRadius: BorderRadius.circular(22),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),

                                blurRadius: 6,

                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),

                          child: Text(
                            message["message"],

                            style: TextStyle(
                              fontSize: screenWidth < 400 ? 14 : 16,

                              height: 1.5,

                              color: isUser ? Colors.black : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

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
                          padding: const EdgeInsets.symmetric(horizontal: 18),

                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: TextField(
                            controller: messageController,

                            decoration:  InputDecoration(
                              border: InputBorder.none,

                              hintText: AppLocalization.translate("ask_your_museum_guide"),                            ),

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
                          width: screenWidth * 0.14,

                          height: screenWidth * 0.14,

                          constraints: const BoxConstraints(
                            minWidth: 54,
                            minHeight: 54,
                          ),

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
}
