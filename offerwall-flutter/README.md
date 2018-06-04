# Annecy Media Offerwall (Flutter)

Use our [API docs](https://admin.annecy.media/docs) for an awesome integration experience!

## Sample

Check out our [Sample Project](https://github.com/gdmobile/annecy-media-docs/tree/master/offerwall-flutter/sample/index.html)!

## Example

Add **flutter_webview_plugin** and **url_launcher** to your package's **pubspec.yaml** file.

``` yaml
dependencies:
  flutter_webview_plugin: "^0.1.6"
  url_launcher: "^3.0.2"
```

install packages from the command line.

``` bash
$ flutter packages get
```

You can get your custom web offerwall URL [here](https://admin.annecy.media/offerwall). Create a **WebviewScaffold** and set the correct parameters!

``` dart
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
```
