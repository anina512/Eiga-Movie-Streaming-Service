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
        "question": "What is Eiga?",
        "answer":
        "\nEiga is a recommendation cum streaming service that offers a wide variety of movies across various genres. It also offers personalised recommendations based on your search history.\n\nYou can watch as much as you want, just click on the link and your movie will get downloaded.There is always something new to discover,new movies are added every week!"
      },
      {
        "id": "2",
        "question": "Sign In Options",
        "answer":
        "\nWe support the following Sign In options:\n\n1.Google Sign In\n2.Sign up with an Eiga Account using either Email id or Mobile Number"
      },
      {
        "id": "3",
        "question": "How to select the best torrent link from the list?",
        "answer":
        "\nLook for the number of seeders.\nThe one with most seeders will give you the fastest speed."
      },
      {
        "id": "4",
        "question": "Where does the movies get downloaded ?",
        "answer":
        "\nThe movie gets downloaded in the local storage of your phone."
      },
      {
        "id": "5",
        "question": "Can I get the movie using my own downloader?",
        "answer":
        "\nYes. You can long press any link tab after tapping on the 'Get Links' button to copy the link directly on to their clipboard. Then simply paste the link in your torrent downloader to get your movie."
      },
      {
        "id": "6",
        "question": "What can I watch on Eiga?",
        "answer":
        "\nEiga has an extensive library of feature films, documentaries, anime, thrillers, top rated movies and more. Watch as much as you want, anytime you want."
      },
      {
        "id": "7",
        "question": "What if I forget my password?",
        "answer": "\nFret not. If you have used your Email for signing up and you forget your password then just click on the 'Forgot password' button. You will receive an OTP in your mail, which upon verification will give you the link to change your password. "
      },


      {
        "id": "8",
        "question": "Contact us",
        "answer": "\nIf you have any query, mail us at eiga.ty@gmail.com"
      },

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