class FunctionsServices {
  String finalNumber;
  List<String> numberPart;
  String millionPart;
  String thousandPart;
  String hendred;

  String dividethousand(int number) {
    if (number < 1000) {
      finalNumber = "$number";
    } else if (number < 1000000) {
      numberPart = (number / 1000).toString().split(".");
      finalNumber = numberPart.join(",");
    } else {
      millionPart = (number / 1000000).toString().split(".").first;
      //finalNumber = numberPart.join(",");
      thousandPart =
          (int.parse((number / 1000000).toString().split(".").last.toString()) /
                  1000)
              .toString()
              .split(".")
              .first;
      hendred =
          (int.parse((number / 1000000).toString().split(".").last.toString()) /
                  1000)
              .toString()
              .split(".")
              .last;
      finalNumber = "$millionPart,$thousandPart,$hendred";
    }

    return finalNumber;
  }
}
