import 'package:flutter/material.dart';
import 'package:loyalbee/models/ThemeChanger.dart';
import 'package:loyalbee/models/notifications.dart';
import 'package:provider/provider.dart';
import '../widgets/setting_icons.dart';
import '../Providers/auth.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 5,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 15.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Setting",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Montserrat-Bold",
                          fontSize: 30,
                          color: Theme.of(context).textTheme.headline2.color),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 10,
              right: 10,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 80),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Customize your experience",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat-Bold",
                              fontSize: 18,
                              color:
                                  Theme.of(context).textTheme.headline2.color),
                        ),
                      ),
                    ),
                    Consumer<ThemeNotifier>(
                      builder: (context, ThemeNotifier notifier, child) =>
                          SwitchListTile(
                              activeColor: Color(0xFFFFCB5F),
                              contentPadding:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Icon(
                                      Icons.wb_sunny_outlined,
                                      color: Theme.of(context)
                                          .textTheme
                                          .headline2
                                          .color,
                                      size: 25,
                                    ),
                                  ),
                                  Text(
                                    "Dark Mode",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat-Light",
                                        color: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            .color,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                "Note : the app will restart after changing the theme directly",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Montserrat-Light",
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .color,
                                    fontSize: 8),
                              ),
                              value: notifier.darkTheme,
                              onChanged: (val) async {
                                await notifier.toggleTheme();
                              }),
                    ),
                    Divider(
                      thickness: 1.0,
                      height: 8,
                    ),
                    Consumer<Notifications>(
                      builder: (context, Notifications notifier, child) =>
                          SwitchListTile(
                        activeColor: Color(0xFFFFCB5F),
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 10, ),
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(
                                Icons.notifications_off_outlined,
                                color:
                                    Theme.of(context).textTheme.headline2.color,
                                size: 25,
                              ),
                            ),
                            Text(
                              "Mute Notifications",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Montserrat-Light",
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        subtitle:  Text(
                          "Disable notification and keep stop the bee sound",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat-Light",
                              color: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .color,
                              fontSize: 8)
                        ),
                        value: notifier.muteNotification,
                        onChanged: (val) async {
                          await notifier.toggleNotifications();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 30),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "More",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Montserrat-Bold",
                              fontSize: 18,
                              color:
                                  Theme.of(context).textTheme.headline2.color),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Setting.rateus,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                          title: Text("Rate us",
                              style: TextStyle(
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color)),
                          trailing: Icon(
                            Icons.chevron_right,
                            color:
                                Theme.of(context).textTheme.headline2.color,
                            size: 25,
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          height: 8,
                        ),
                        ListTile(
                          leading: Icon(
                            Setting.socialize,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                          title: Text("Contact us",
                              style: TextStyle(
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color)),
                          trailing: Icon(
                            Icons.chevron_right,
                            color:
                                Theme.of(context).textTheme.headline2.color,
                            size: 25,
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          height: 8,
                        ),
                        ListTile(
                          leading: Icon(
                            Setting.licence,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                          title: Text("License",
                              style: TextStyle(
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color)),
                          trailing: Icon(
                            Icons.chevron_right,
                            color:
                                Theme.of(context).textTheme.headline2.color,
                            size: 25,
                          ),
                        ),
                        Divider(
                          thickness: 1.0,
                          height: 8,
                        ),
                        ListTile(
                          onTap: () {
                            Provider.of<Auth>(context, listen: false)
                                .logout();
                          },
                          leading: Icon(
                            Setting.logout,
                            color: Theme.of(context).iconTheme.color,
                            size: 30,
                          ),
                          title: Text("Logout",
                              style: TextStyle(
                                  fontFamily: "Montserrat-Light",
                                  fontSize: 25,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .color)),
                          trailing: Icon(
                            Icons.chevron_right,
                            color:
                                Theme.of(context).textTheme.headline2.color,
                            size: 25,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
