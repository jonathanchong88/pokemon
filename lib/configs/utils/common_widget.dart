import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/data.dart';

class CommonWidget {
  static AppBar appBar(
    BuildContext context,
    String title,
    IconData? backIcon,
    Color color, {
    Widget? actonWidget,
    IconData? actionIcon,
    Color backgroundColor = Colors.transparent,
    void Function()? callback,
    void Function()? actionCallback,
  }) {
    return AppBar(
      leading: backIcon == null
          ? null
          : IconButton(
              icon: Icon(backIcon, color: color),
              onPressed: () {
                if (callback != null) {
                  callback();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(color: color, fontFamily: 'Rubik'),
      ),
      backgroundColor: backgroundColor,
      elevation: 0.0,
      actions: [actonWidget ?? Container()],
    );
  }

  static SizedBox rowHeight({double height = 30}) {
    return SizedBox(height: height);
  }

  static SizedBox rowWidth({double width = 30}) {
    return SizedBox(width: width);
  }

  static errorPrompt(String msg) {
    Get.showSnackbar(
      GetSnackBar(
        message: msg,
        isDismissible: true,
        duration: const Duration(milliseconds: 1600),
        // dismissDirection: SnackDismissDirection.HORIZONTAL,
        snackStyle: SnackStyle.GROUNDED,
      ),
    );
  }

  static String convertDateFormat(String format, DateTime _date) {
    // return DateFormat().format(_date);
    final dtFormat = DateFormat(format);
    var str = dtFormat.format(_date);
    return str;
  }

  static showLoading() {
    Get.defaultDialog(
        title: "Loading...",
        content: const CircularProgressIndicator(),
        barrierDismissible: false);
  }

  static dismissLoadingWidget() {
    Get.back();
  }

  List<Pokemon> getPokemonInOrder(List<Pokemon> items, bool isAscending) {
    items.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });

    if (isAscending) {
      return items.toList();
    } else {
      return items.reversed.toList();
    }
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
