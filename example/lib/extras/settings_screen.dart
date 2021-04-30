import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_torrent_streamer_example/constant/api_constant.dart';
import 'package:flutter_torrent_streamer_example/constant/string_constant.dart';
import 'package:flutter_torrent_streamer_example/utils/sp/sp_manager.dart';
import 'package:flutter_torrent_streamer_example/utils/widgethelper/widget_helper.dart';
import 'package:flutter_torrent_streamer_example/screens/home/new_home.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var pushNoti = false;
  var emailNoti = true;
  var darkMode = false;

  BuildContext ctx;

  @override
  void initState() {
    super.initState();
    darkMode = isDarkMode(context);
  }

  @override
  Widget build(BuildContext context) {
    var homeIcon = IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black54,
        ),
        onPressed: () => Navigator.pop(context));
    return Scaffold(
        appBar: getAppBarWithBackBtn(
            ctx: context,
            title: StringConst.SETTING_TITLE,
            bgColor: Colors.white,
            icon: homeIcon),
        body: Builder(builder: (_context) {
          return _createUi(_context);
        }));
  }

  Widget _createUi(BuildContext context) {
    ctx = context;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: <Widget>[
          InkWell(

            child: Row(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(ApiConstant.DEMO_IMG),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      getTxtBlackColor(

                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      getTxtColor(
                          fontSize: 17,

                          )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          getDivider(),
          ListTile(
            title: getTxtBlackColor(
                msg: "Language", fontSize: 16, fontWeight: FontWeight.bold),
            subtitle: getTxtColor(
                msg: "English US",
                fontSize: 15,
                txtColor: Colors.blueGrey),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey.shade400,
            ),
            onTap: () {},
          ),
          getDivider(),

          ListTile(
            title: getTxtBlackColor(
                msg: "Clear Data", fontSize: 16, fontWeight: FontWeight.bold),
            subtitle: getTxtColor(
                msg: "Start app from introduction screen",
                fontSize: 15,
                txtColor: Colors.blue),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey.shade400,
            ),
            onTap: () {
              SPManager.setOnboarding(false);
              showSnackBar(ctx, 'Data clear successfully !!');
            },
          ),
          getDivider(),

          getDivider(),
          SwitchListTile(
            title: getTxtBlackColor(
                msg: "Push Notifications",
                fontSize: 16,
                fontWeight: FontWeight.bold),
            subtitle: getTxtColor(
                msg: 'Off', fontSize: 15, txtColor: Colors.black54),
            value: pushNoti,
            onChanged: (val) {
              pushNoti = !pushNoti;
              changeData();
            },
          ),
          getDivider(),
          SwitchListTile(
            title: getTxtBlackColor(
                msg: "Dark Mode", fontSize: 16, fontWeight: FontWeight.bold),
            subtitle: getTxtColor(
                msg: 'Turn dark mode on/off',
                fontSize: 15,
                txtColor: Colors.blue),
            value: darkMode,
            onChanged: (val) {
              darkMode = !darkMode;
              // ScopedModel.of<ThemeModel>(context).setTheme(darkMode);
              changeData();
            },
          ),
          getDivider(),
          ListTile(
            title: getTxtBlackColor(
                msg: "Exit", fontSize: 16, fontWeight: FontWeight.bold),
            onTap: () => onWillPop(context),
          ),
          getDivider()
        ],
      ),
    );
  }

  void changeData() {
    setState(() {});
  }

// void getThemeData()async {
//   darkMode = ScopedModel.of<ThemeModel>(context).getTheme;
//   changeData();
// }
}