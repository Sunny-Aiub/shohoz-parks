import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sohoz_park/app/commons/assets_const.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';
import 'package:sohoz_park/app/commons/widgets/custom_button.dart';
import 'package:sohoz_park/app/commons/home/views/left_menu.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';

import '../../../commons/widgets/custom_input_field.dart';
import '../../../utils/validator.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: controller.scaffoldKey,
          // ignore: prefer_const_constructors
          drawer: LeftMenu(),
          appBar: AppBar(
            centerTitle: false,
            elevation: 0.0,
            leading: InkWell(
              onTap: controller.openDrawer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SvgPicture.asset(AssetConstant.leftMenuIcon),
              ),
            ),
            title: Text(
              "Change Password",
              style: getSemiBoldStyle(
                  fontSize: 22, color: ColorManager.inputFieldTitleColor333333),
            ),
          ),
          body: controller.isLoading.value == true
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: Get.height - 144,
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomInputField(
                              controller: controller.passwordCtlr,
                              isEnabled: true,
                              obscureText: true,
                              hintText: 'Enter Current Password',
                              validator: (value) =>
                                  MyCustomValidator.validateEmptyField(
                                      value, context),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            CustomInputField(
                              controller: controller.newPasswordCtlr,
                              isEnabled: true,
                              obscureText: true,
                              hintText: 'Enter New Password',
                              validator: (value) =>
                                  MyCustomValidator.validateEmptyField(
                                      value, context),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            CustomInputField(
                              controller: controller.confirmPasswordCtlr,
                              isEnabled: true,
                              obscureText: true,
                              hintText: 'Confirm New Password',
                              validator: (value) =>
                                  MyCustomValidator.validateEmptyField(
                                      value, context),
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            Spacer(),
                            CustomButton(
                              buttonTitle: 'Change Password',
                              onPressed: () {

                                if (controller.formKey.currentState!.validate()) {
                                  if(controller.newPasswordCtlr.text == controller.confirmPasswordCtlr.text){
                                    controller.changePassword();
                                  }else{
                                    AppConfigs.showToast("Your new passwords doesn't match", Colors.red);
                                  }
                                } else {}
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
