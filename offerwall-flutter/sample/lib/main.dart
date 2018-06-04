import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MyApp());

String country = "US";
String idfaGaid = "bar";
String language = "en";
String token = "6ce0bbf0-2dc8-4d7c-a497-e93105188ba1";
String userId = "foo";

class MyApp extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        final flutterWebviewPlugin = new FlutterWebviewPlugin();

        flutterWebviewPlugin.onUrlChanged.listen((String url) {
            if (!url.startsWith("https://offerwall.annecy.media")) {
                _launchURL(url);
            }
        });

        return new MaterialApp(
            routes: {
                "/": (_) => new WebviewScaffold(
                    url: "https://offerwall.annecy.media?country=" + country + "&language=" + language + "&idfa_gaid=" + idfaGaid + "&token=" + token + "&user_id=" + userId + "&platform=android",
                    withJavascript: true,
                    appBar: new AppBar(
                        title: new Text("Annecy Offerwall"),
                    ),
                ),
            },
        );
    }

    _launchURL(String url) async {
        if (await canLaunch(url)) {
            await launch(url, forceSafariVC: false, forceWebView: false);
        } else {
            throw 'Could not launch $url';
        }
    }
}
