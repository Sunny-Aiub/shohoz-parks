import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:sohoz_park/app/commons/widgets/custom_button.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';

import '../../../commons/colors.dart';
import '../../../commons/styles.dart';
import '../controllers/verified_ticket_controller.dart';

class VerifiedTicketView extends GetView<VerifiedTicketController> {
  const VerifiedTicketView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // ignore: prefer_const_constructors
        backgroundColor: ColorManager.backgroundColor,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          // leading: InkWell(
          //   onTap: controller.openDrawer,
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: SvgPicture.asset(AssetConstant.leftMenuIcon),
          //   ),
          // ),
          title: Text(
            "Zone Ticket Verified",
            style: getSemiBoldStyle(
                fontSize: 22, color: ColorManager.inputFieldTitleColor333333),
          ),
        ),
        body: Obx(() {
          return CustomScrollView(
            slivers: [
              if (controller.isLoading.value == false)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(8),
                      // ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'MOBILE: ',
                                style: getMediumStyle(
                                    fontSize: 16,
                                    color: ColorManager.yellowF2994A),
                              ),
                              TextSpan(
                                text: AppConfigs.scannedPhoneNumber,
                                style: getBoldStyle(
                                    fontSize: 16,
                                    color: ColorManager
                                        .inputFieldTitleColor333333),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (controller.rideData.isNotEmpty)
                SliverList.builder(
                  itemCount: controller.rideData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  controller.rideData[index].ticket!.name
                                      .toString(),
                                  style: getBoldStyle(
                                      fontSize: 15,
                                      color: ColorManager.black595C7D),
                                ),
                              ),
                              Text(
                                controller.rideData[index].totalTickets
                                    .toString(),
                                style: getBoldStyle(
                                    fontSize: 15,
                                    color: ColorManager.black595C7D),
                              ),
                              CustomButton(
                                buttonTitle: "Redeem",
                                color: controller.rideData[index].tickets![0]
                                            .redeem ==
                                        "0"
                                    ? Colors.blue
                                    : Colors.grey,
                                width: 100,
                                onPressed: () {
                                  if (controller
                                          .rideData[index].tickets![0].redeem ==
                                      "0") {
                                    Get.defaultDialog(
                                        title:
                                            "Are you sure about redeeming it?",
                                        backgroundColor: Colors.white,
                                        titleStyle: getSemiBoldStyle(
                                            fontSize: 20,
                                            color: ColorManager
                                                .inputFieldTitleColor333333),
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CustomButton(
                                                  width: 100,
                                                  buttonTitle: 'Yes',
                                                  onPressed: () {


                                                    controller.callRedeemAPI(index);
                                                  }),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CustomButton(
                                                  textStyle: TextStyle(
                                                      color: Colors.black),
                                                  width: 100,
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                  buttonTitle: 'Cancel',
                                                  onPressed: () {
                                                    Get.back();
                                                  }),
                                            )
                                          ],
                                        ));
                                  } else {
                                    AppConfigs.showToast(
                                        "Already Redeemed", Colors.red);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        }),
      ),
    );
  }

}
