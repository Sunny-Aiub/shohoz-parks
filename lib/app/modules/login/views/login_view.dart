// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sohoz_park/app/commons/assets_const.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';
import 'package:sohoz_park/app/commons/widgets/custom_button.dart';
import 'package:sohoz_park/app/commons/widgets/custom_input_field.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';
import 'package:sohoz_park/app/utils/validator.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: controller.isLoading.value == true
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                            child: SvgPicture.asset(
                          AssetConstant.sohozLogoIcon,
                          width: 240,
                        )),
                        Center(
                          child: Text(
                            ' Tix Expansion',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.barlow(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Text(
                                'Enter your number & password to continue',
                                textAlign: TextAlign.center,
                                style: getMediumStyle(
                                    fontSize: 16,
                                    color: ColorManager.primaryBlack)),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text('Mobile Number',
                            style: getMediumStyle(
                                fontSize: 15,
                                color:
                                    ColorManager.inputFieldTitleColor333333)),
                        CustomInputField(
                          controller: controller.mobileNumberCtlr,keyboardType: TextInputType.number,
                          validator: (value) =>
                              MyCustomValidator.validateMobileNumber(
                                  value, context),
                          isEnabled: true,inputFormatters:[
                          LengthLimitingTextInputFormatter(11),
                        ],
                          hintText: 'Enter Mobile Number',
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text('Password',
                            style: getMediumStyle(
                                fontSize: 15,
                                color:
                                    ColorManager.inputFieldTitleColor333333)),
                        CustomInputField(
                          controller: controller.passwordCtlr,
                          obscureText: true,
                          validator: (value) =>
                              MyCustomValidator.validateEmptyField(
                                  value, context),
                          isEnabled: true,
                          hintText: 'Enter Password',
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        CustomButton(
                          buttonTitle: 'LOGIN',
                          onPressed: () {
                            if (controller.formKey.currentState!.validate()) {
                              controller.getLogin(
                                  controller.mobileNumberCtlr.text,
                                  controller.passwordCtlr.text);
                            } else {}
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
