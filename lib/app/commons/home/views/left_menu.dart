import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sohoz_park/app/commons/assets_const.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';

class LeftMenu extends StatelessWidget {
  const LeftMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        height: Get.height,
        child: Padding(
          padding: const EdgeInsets.only(top: 32, left: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${AppConfigs.currentUser?.firstName ?? ' ' } ${AppConfigs.currentUser?.lastName ?? ' '} ',
                  style: getBoldStyle(
                      fontSize: 22,
                      color: ColorManager.inputFieldTitleColor333333)),
              Text(AppConfigs.currentUser?.phone ?? ' ',
                  style: getSemiBoldStyle(
                      fontSize: 16,
                      color: ColorManager.inputFieldTitleColor333333)),
              const SizedBox(
                height: 40,
              ),
              ListTile(
                onTap: (){
                  Get.offAllNamed(Routes.HOME);
                },
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorManager.buttonBackgroundColor,
                  child: const Icon(Icons.home,color: Colors.white,),
                ),
                title: Text('Home',
                    style: getSemiBoldStyle(
                        fontSize: 18,
                        color: ColorManager.inputFieldTitleColor333333)),
              ),
              ListTile(
                onTap: (){
                  Get.toNamed(Routes.REPORTS);
                },
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(AssetConstant.reportsIcon),
                title: Text('Reports',
                    style: getSemiBoldStyle(
                        fontSize: 18,
                        color: ColorManager.inputFieldTitleColor333333)),
              ),
              ListTile(
                onTap: (){
                  Get.offAndToNamed(Routes.CHANGE_PASSWORD);
                },
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorManager.buttonBackgroundColor,
                  child: SvgPicture.asset('assets/icons/carbon_password.svg'),
                ),
                title: Text('Change Password',
                    style: getSemiBoldStyle(
                        fontSize: 18,
                        color: ColorManager.inputFieldTitleColor333333)),
              ),
              ListTile(
                onTap: (){
                  Get.offAllNamed(Routes.LOGIN);
                },
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.asset(AssetConstant.logoutIcon),
                title: Text('Log Out',
                    style: getSemiBoldStyle(
                        fontSize: 18,
                        color: ColorManager.inputFieldTitleColor333333)),
              ),
              const Spacer(),
              Divider(
                height: 20,
                thickness: 1,
                color: ColorManager.grayE4E4E4,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AssetConstant.callIcon),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "For any query please contact us",
                          style: getRegularStyle(
                              fontSize: 11, color: ColorManager.gray707070),
                        ),
                        Text(
                          "16374",
                          style: getBoldStyle(
                              fontSize: 22, color: ColorManager.primaryGreen),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
