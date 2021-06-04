import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}
class _FAQScreenState extends State<FAQScreen> {
  List questions;
  List isVisible = [];
  @override
  void initState() {
    super.initState();
    questions = [
      {
        "id": "1",
        "question": "Sign In Options",
        "answer":
        "We support the following SIgn In options:\n1.Google Sign In\n2.Sign up with an Eiga Account"
      },
      {
        "id": "2",
        "question": "What does the app do?",
        "answer":
        "Eiga is a movie recommendation and streaming application."
      },
      {
        "id": "3",
        "question": "How to select the best torrent link from the list?",
        "answer":
        "\nLook for the number of seeders.\nThe one with most seeders will give you the fastest speed."
      },
      {
        "id": "4",
        "question": "Where does the movies gets downloaded ?",
        "answer":
        "The movie gets downloaded in the local storage of your phone."
      },
      {
        "id": "5",
        "question": "",
        "answer":
        ""
      },
      {
        "id": "6",
        "question": "Security and privacy policy",
        "answer":
        "All the messages and media are end to end encrypted and stored in the server. Cypher cannot access the actual message.\nThe keys used for decrypted only on client side and Cypher doesn't have access information to decrypt the messages and files and hence the messages of users are safe."
      },
      {
        "id": "7",
        "question": "",
        "answer":
        ""
      },
      {
        "id": "8",
        "question": "",
        "answer":
        "."
      },
      {
        "id": "9",
        "question": "Contact us",
        "answer": "If you have any query, mail us at eiga.ty@gmail.com"
      }
    ];
  }

  _questionContainer(question) {
    return Container(
      // width: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // onPressed: () {},
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(Icons.face),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      Text(
                        question['question'],
                        style: TextStyle(fontSize: 20),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isVisible.contains(question['id'])) {
                            isVisible.removeWhere(
                                    (element) => element == question['id']);
                          } else {
                            isVisible.add(question['id']);
                          }
                          setState(() {});
                        },
                        child: Icon(
                          isVisible.contains(question['id'])
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                      )
                    ],
                  ),
                  isVisible.contains(question['id'])
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(Icons.face),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          question['answer'],
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )
                      : Container(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeIcon = IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        onPressed: () => Navigator.pop(context));
    return SafeArea(
      child: Scaffold(
        appBar: getAppBarWithBackBtn(
            ctx: context,
            title: 'FAQs',
            bgColor: Colors.white,
            //titleTag: 'About Us',
            icon: homeIcon),
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return _questionContainer(questions[index]);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}