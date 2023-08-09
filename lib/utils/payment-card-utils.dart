import 'package:flutter/material.dart';

/// Enum variable of available card types
enum MyCardType {
  Master,
  Visa,
  Verve,
  Others,
  Invalid
}

/// Class holding the card utilities while validating
class CardUtils {

  /// Method for validating the card CVV
  /// It returns a string value
  static String? validateCVV(String? value) {
    if (value!.isEmpty) {
      return 'Enter CVV';
    }

    if (value.length < 3 || value.length > 4) {
      return "CVV is invalid";
    }
    return null;
  }

  /// Method for validating the card DATE
  /// It returns a string value
  static String? validateDate(String? value) {
    if (value!.isEmpty) {
      return 'Enter Expiry Date';
    }

    /// Integer variable holding the card year
    int year;

    /// Integer variable holding the card month
    int month;
    // The value contains a forward slash if the month and year has been
    // entered.
    if (value.contains(RegExp(r'(\/)'))) {
      var split = value.split(RegExp(r'(\/)'));
      // The value before the slash is the month while the value to right of
      // it is the year.
      month = int.parse(split[0]);
      year = int.parse(split[1]);

    } else { // Only the month was entered
      month = int.parse(value.substring(0, (value.length)));
      year = -1; // Lets use an invalid year intentionally
    }

    if ((month < 1) || (month > 12)) {
      // A valid month is between 1 (January) and 12 (December)
      return 'Expiry month is invalid';
    }

    /// Variable holding the converted year in 4 digits
    var fourDigitsYear = convertYearTo4Digits(year);
    if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
      // We are assuming a valid should be between 1 and 2099.
      // Note that, it's valid doesn't mean that it has not expired.
      return 'Expiry year is invalid';
    }

    if (!hasDateExpired(month, year)) {
      return "Card has expired";
    }
    return null;
  }

  /// Convert the two-digit year to four-digit year if necessary
  /// It returns an integer value
  static int convertYearTo4Digits(int year) {
    if (year < 100 && year >= 0) {
      var now = DateTime.now();
      String currentYear = now.year.toString();
      String prefix = currentYear.substring(0, currentYear.length - 2);
      year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
    }
    return year;
  }


  /// Method for validating the card DATE if it has expired
  /// It returns a boolean value
  static bool hasDateExpired(int month, int year) {
    return !(month == null || year == null) && isNotExpired(year, month);
  }

  /// Method for validating the card DATE if it has not expired
  /// It returns a boolean value
  static bool isNotExpired(int year, int month) {
    // It has not expired if both the year and date has not passed
    return !hasYearPassed(year) && !hasMonthPassed(year, month);
  }

  /// Method for get Expiry Date
  /// It returns a List of Integer
  static List<int> getExpiryDate(String value) {
    var split = value.split(RegExp(r'(\/)'));
    return [int.parse(split[0]), int.parse(split[1])];
  }

  /// Method to check if month has passed from today's month by comparing
  /// today's month to [month]
  /// It returns a boolean value
  static bool hasMonthPassed(int year, int month) {
    var now = DateTime.now();
    // The month has passed if:
    // 1. The year is in the past. In that case, we just assume that the month
    // has passed
    // 2. Card's month (plus another month) is more than current month.
    return hasYearPassed(year) ||
        convertYearTo4Digits(year) == now.year && (month < now.month + 1);
  }

  /// Method to check if year has passed from today's year by comparing
  /// today's year to [year]
  /// It returns a boolean value
  static bool hasYearPassed(int year) {
    int fourDigitsYear = convertYearTo4Digits(year);
    var now = DateTime.now();
    // The year has passed if the year we are currently is more than card's
    // year
    return fourDigitsYear < now.year;
  }

  /// Method to get cleaned number of a card number by cleaning all the spaces
  /// It returns a string
  static String getCleanedNumber(String text) {
    RegExp regExp = new RegExp(r"[^0-9]");
    return text.replaceAll(regExp, '');
  }

  /// Method to get card Icon depending on the [cardType], It returns a widget
  static Widget? getCardIcon(MyCardType cardType) {
    String img = "";
    Icon? icon;
    switch (cardType) {
      case MyCardType.Master:
        img = 'mastercard.png';
        break;
      case MyCardType.Visa:
        img = 'visa_card.png';
        break;
      case MyCardType.Verve:
        img = 'verve.png';
        break;
      case MyCardType.Others:
        icon = new Icon(
            Icons.credit_card,
            size: 30.0,
            color: Colors.black
        );
        break;
      case MyCardType.Invalid:
        icon = new Icon(
            Icons.warning,
            size: 30.0,
            color: Colors.amber[700]
        );
        break;
    }
    Widget? widget;
    if (img.isNotEmpty) {
      widget = Padding(
        padding: EdgeInsets.only(right: 5.0),
        child: Image.asset(
         'assets/images/$img',
          width: 30.0,
          fit: BoxFit.contain,
        ),
      );
    } else {
      widget = icon;
    }
    return widget;
  }


  /// Validating the card number with Luhn Algorithm
  /// https://en.wikipedia.org/wiki/Luhn_algorithm
  /// It returns a string
  static String? validateCardNum(String? input) {
    if (input!.isEmpty) {
      return 'Enter Card Number';
    }

    input = getCleanedNumber(input);

    if (input.length < 8) {
      return 'Invalid Card';
    }

    int sum = 0;

    int length = input.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(input[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    if (sum % 10 == 0) {
      return null;
    }

    return 'Invalid Card';
  }

  /// Method to get card type from card number
  /// It returns an enum value from [MyCardType]
  static MyCardType getCardTypeFrmNumber(String input) {
    MyCardType cardType;
    if (input.startsWith(RegExp(
        r'((5[1-5])|(222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720))'))) {
      cardType = MyCardType.Master;
    } else if (input.startsWith(RegExp(r'[4]'))) {
      cardType = MyCardType.Visa;
    } else if (input.startsWith(RegExp(r'((506(0|1))|(507(8|9))|(6500))'))) {
      cardType = MyCardType.Verve;
    } else if (input.length <= 8) {
      cardType = MyCardType.Others;
    } else {
      cardType = MyCardType.Invalid;
    }
    return cardType;
  }

}