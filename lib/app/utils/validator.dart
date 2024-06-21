class MyCustomValidator {
  static String? validateEmptyField(value, context) {
    if (value.isEmpty) {
      return 'this field is required '; //getTranslatedValue(context, "empty_validation");
    }

    return null;
  }

  static String? validateEmail(value, context){
    bool valid = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
    if(!valid==true){
      return   'invalid email!';
    }
    return null;
  }


  static String? validateMobileNumber(value, context){
    if (value.toString().length != 11) {
      return 'mobile number is not valid'; //getTranslatedValue(context, "empty_validation");
    }
    return null;
  }
}
