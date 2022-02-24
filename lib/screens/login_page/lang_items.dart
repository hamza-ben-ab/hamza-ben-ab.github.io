import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uy/services/provider/LanguageChangeProvider.dart';
import 'package:provider/provider.dart';
import 'package:uy/services/responsiveLayout.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class LangItem extends StatefulWidget {
  final int index;
  final double width;
  final bool hover;
  final String title;
  const LangItem(
      {Key key, this.title, this.hover, @required this.width, this.index})
      : super(key: key);

  @override
  _LangItemState createState() => _LangItemState();
}

class _LangItemState extends State<LangItem> {
  @override
  Widget build(BuildContext context) {
    bool largeScreen = ResponsiveLayout.isLargeScreen(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (widget.title == "Arabic") {
          context.read<LanguageChangeProvider>().changeLocale("ar");
          prefs.setString("langkey", "ar");
        }
        if (widget.title == "Bengali-বাংলা") {
          context.read<LanguageChangeProvider>().changeLocale("bn");
          prefs.setString("langkey", "bn");
        }
        if (widget.title == "German-Deutsche") {
          context.read<LanguageChangeProvider>().changeLocale("de");
          prefs.setString("langkey", "de");
        }
        if (widget.title == "Greek-Ελληνικά") {
          context.read<LanguageChangeProvider>().changeLocale("el");
          prefs.setString("langkey", "el");
        }
        if (widget.title == "English") {
          context.read<LanguageChangeProvider>().changeLocale("en");
          prefs.setString("langkey", "en");
        }
        if (widget.title == "Spanish") {
          context.read<LanguageChangeProvider>().changeLocale("es");
          prefs.setString("langkey", "es");
        }
        if (widget.title == "French") {
          context.read<LanguageChangeProvider>().changeLocale("fr");
          prefs.setString("langkey", "fr");
        }
        if (widget.title == "Hindi-हिंदी") {
          context.read<LanguageChangeProvider>().changeLocale("hi");
          prefs.setString("langkey", "hi");
        }
        if (widget.title == "Indonesian-bahasa Indonesia") {
          context.read<LanguageChangeProvider>().changeLocale("id");
          prefs.setString("langkey", "id");
        }
        if (widget.title == "Italian") {
          context.read<LanguageChangeProvider>().changeLocale("it");
          prefs.setString("langkey", "it");
        }
        if (widget.title == "Japanese-日本語") {
          context.read<LanguageChangeProvider>().changeLocale("ja");
          prefs.setString("langkey", "ja");
        }
        if (widget.title == "Korean-한국어") {
          context.read<LanguageChangeProvider>().changeLocale("ko");
          prefs.setString("langkey", "ko");
        }

        if (widget.title == "Panjabi-ਪੰਜਾਬੀ") {
          context.read<LanguageChangeProvider>().changeLocale("pa");
          prefs.setString("langkey", "pa");
        }
        if (widget.title == "Portuguese") {
          context.read<LanguageChangeProvider>().changeLocale("pt");
          prefs.setString("langkey", "pt");
        }
        if (widget.title == "Russian") {
          context.read<LanguageChangeProvider>().changeLocale("ru");
          prefs.setString("langkey", "ru");
        }
        if (widget.title == "Turkish") {
          context.read<LanguageChangeProvider>().changeLocale("tr");
          prefs.setString("langkey", "tr");
        }
        if (widget.title == "Chinese-中国人") {
          context.read<LanguageChangeProvider>().changeLocale("zh");
          prefs.setString("langkey", "zh");
        }

        html.window.location.reload();
        Navigator.of(context).pop();
      },
      child: Container(
        height: h * .06,
        width: w * widget.width,
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: largeScreen ? 14.0 : 10.0,
              color: Colors.black,
            ),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: widget.hover ? Colors.grey[300] : Colors.grey[200],
        ),
      ),
    );
  }
}
