import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common_widgets/Bounce.dart';

class ResultPage extends StatefulWidget {

  Barcode result;
  ResultPage(this.result);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {

  Barcode result;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLink;

  // Text Gradient
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffFE1919), Color(0xffEC5050)],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

  @override
  void initState() {
    super.initState();
    result = widget.result;
    isLink = linkHandler(result.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("FlutterQR - Result"),
        ),
        body: Column(
          children: [
            _buildResultView(),
            _buildSheet()
          ],
        ));
  }

  Expanded _buildSheet() {
    return Expanded(
      flex: 2,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Bounce(
                  duration: Duration(milliseconds: 200),
                  onPress: () {
                    Clipboard.setData(new ClipboardData(text: "${result.code}"));
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Copied *-*',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(fontSize: 16),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      MaterialCommunityIcons.clipboard_text,
                      color: Colors.grey.shade200,
                      size: 40,
                    ),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(100)),
                  ),
                ),
                isLink
                    ?Bounce(
                  onPress: () {
                    _launchURL("${result.code}");
                  },
                  duration: Duration(milliseconds: 200),
                  child: Container(
                    width: 80,
                    height: 80,
                    child: Icon(
                      MaterialCommunityIcons.web,
                      color: Colors.grey.shade200,
                      size: 40,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(100)
                    ),
                  ),
                )
                    : Container(
                  width: 80,
                  height: 80,
                  child: Icon(
                    MaterialCommunityIcons.web,
                    color: Colors.grey.shade200,
                    size: 40,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(100)
                  ),
                )
              ],
            ),
            SizedBox(height: 40),
            Bounce(
              duration: Duration(milliseconds: 100),
              onPress: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 250,
                height: 50,
                child: Center(
                  child: Text(
                    "Try Again",
                    style: GoogleFonts.montserrat(fontSize: 30, color: Colors.grey.shade200),
                  ),
                ),
                decoration: BoxDecoration(color: Colors.grey.shade800, borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
      ),
    );
  }

  Widget _buildResultView() {
    return Expanded(
      flex: 4,
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Container(
                width: 100,
                height: 100,
                child: Lottie.asset("assets/lottie/qr_result.json"),
              ),
              SizedBox(height: 20),
              Text(
                "Successful",
                style: GoogleFonts.montserrat(
                    fontSize: 30, fontWeight: FontWeight.w500, foreground: Paint()..shader = linearGradient),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 12,
                      ),
                      child: Text(
                        "${result.code}",
                        style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(6)),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  bool linkHandler(String data){
    Pattern urlPattern =
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?";    RegExp regExp = new RegExp(
      urlPattern
    );
      return regExp.hasMatch(data);
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
