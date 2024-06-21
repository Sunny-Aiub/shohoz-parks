import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../../../commons/assets_const.dart';
import '../../../commons/colors.dart';
import '../../../commons/home/views/left_menu.dart';
import '../../../commons/styles.dart';
import '../../../commons/widgets/custom_button.dart';
import '../../../commons/widgets/custom_input_field.dart';
import '../../../utils/appconfigs.dart';
import '../../../utils/validator.dart';
import '../controllers/package_controller.dart';

class PackageView extends GetView<PackageController> {
  const PackageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
            backgroundColor: ColorManager.backgroundColor,
            key: controller.scaffoldKey,
            drawer: const LeftMenu(),
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
                "Sell Package Ticket",
                style: getSemiBoldStyle(
                    fontSize: 22,
                    color: ColorManager.inputFieldTitleColor333333),
              ),
            ),
            body: Obx(() => CustomScrollView(
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.all(16),
                    ),
                    if (controller.sellTicketItems.isNotEmpty == true)
                      SliverList.builder(
                        itemCount: controller.sellTicketItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Container(
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 1, color: Color(0xFF079D49)),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: Get.width / 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller
                                                .sellTicketItems[index].name
                                                .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: getSemiBoldStyle(
                                                fontSize: 16,
                                                color: ColorManager
                                                    .inputFieldTitleColor333333),
                                          ),
                                          Text(
                                            '(${controller.sellTicketItems[index].description ?? ""})',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                            style: getSemiBoldStyle(
                                                fontSize: 16,
                                                color: ColorManager
                                                    .inputFieldTitleColor333333),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 4,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.decrementValue(index);

                                            controller.getTotalTicketCounts();
                                            controller.getTotalPrice();
                                          },
                                          child: Container(
                                              height: 24,
                                              width: 24,
                                              decoration: const BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4))),
                                              child: const Icon(
                                                Icons.remove,
                                                color: Colors.white,
                                              )),
                                        ),
                                        SizedBox(
                                          width: 64,
                                          child: CustomInputField(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              hintText: '0',
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                decimal: false,
                                              ),
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    2),
                                              ],
                                              textAlign: TextAlign.center,
                                              height: 40,
                                              controller: controller
                                                  .inputControllers[index],
                                              onChanged: (value) {
                                                if (value != null) {
                                                  controller
                                                      .sellTicketItems[index]
                                                      .ticketCount = int
                                                          .tryParse(value) ??
                                                      0;
                                                  controller.sellTicketItems
                                                      .refresh();

                                                  controller
                                                      .getTotalTicketCounts();
                                                  controller.getTotalPrice();
                                                }
                                              },
                                              isEnabled: true),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            controller.incrementValue(index);

                                            controller.getTotalTicketCounts();
                                            controller.getTotalPrice();
                                          },
                                          child: Container(
                                              height: 24,
                                              width: 24,
                                              decoration: const BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4))),
                                              child: const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    SliverPadding(
                      padding:
                          const EdgeInsets.only(top: 32, left: 16, right: 16),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          height: (controller.sellTicketItems.isNotEmpty ==
                                  true)
                              ? ((controller.sellTicketItems.length * 80 + 60) >
                                      Get.height)
                                  ? Get.height
                                  : controller.sellTicketItems.length * 80 + 60
                              : Get.height,
                          decoration: BoxDecoration(
                              color: ColorManager.primaryWhite,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ticket Type',
                                      style: getRegularStyle(
                                          fontSize: 12,
                                          color: ColorManager.textColor999999),
                                    ),
                                    Text(
                                      'Money',
                                      style: getRegularStyle(
                                          fontSize: 12,
                                          color: ColorManager.textColor999999),
                                    ),
                                  ],
                                ),
                              ),
                              if (controller.sellTicketItems.isNotEmpty == true)
                                Expanded(
                                  child: ListView.builder(
                                    itemCount:
                                        controller.sellTicketItems.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return (controller.sellTicketItems[index]
                                                  .ticketCount ==
                                              0)
                                          ? const SizedBox()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: Get.width / 2,
                                                    child: Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                              text: controller
                                                                  .sellTicketItems[
                                                                      index]
                                                                  .name,
                                                              style: getSemiBoldStyle(
                                                                  fontSize: 18,
                                                                  color: ColorManager
                                                                      .inputFieldTitleColor333333)),
                                                          TextSpan(
                                                              text: ' x ',
                                                              style: getSemiBoldStyle(
                                                                  fontSize: 18,
                                                                  color: ColorManager
                                                                      .inputFieldTitleColor333333)),
                                                          TextSpan(
                                                              text: controller
                                                                  .sellTicketItems[
                                                                      index]
                                                                  .ticketCount
                                                                  .toString(),
                                                              style: getSemiBoldStyle(
                                                                  fontSize: 18,
                                                                  color: ColorManager
                                                                      .inputFieldTitleColor333333)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    '৳ ${controller.sellTicketItems[index].ticketCount * double.parse(controller.sellTicketItems[index].price.toString()!)}',
                                                    textAlign: TextAlign.right,
                                                    style: getSemiBoldStyle(
                                                        fontSize: 18,
                                                        color: ColorManager
                                                            .inputFieldTitleColor333333),
                                                  ),
                                                ],
                                              ),
                                            );
                                    },
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Total   x ${controller.totalTicketCounter.value}',
                                        style: getSemiBoldStyle(
                                            fontSize: 18,
                                            color: ColorManager
                                                .inputFieldTitleColor333333)),
                                    Text('৳ ${controller.totalPrice.value}',
                                        style: getSemiBoldStyle(
                                            fontSize: 18,
                                            color: ColorManager
                                                .inputFieldTitleColor333333)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 16),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mobile Number',
                                  style: getMediumStyle(
                                      fontSize: 16,
                                      color: ColorManager
                                          .inputFieldTitleColor333333)),
                              CustomInputField(
                                controller: controller.mobileNumberCtlr,
                                isEnabled: true,
                                hintText: 'Enter Mobile Number',
                                validator: (value) =>
                                    MyCustomValidator.validateMobileNumber(
                                        value, context),
                                keyboardType: TextInputType.number,
                                backgroundColor: ColorManager.primaryWhite,
                              ),
                              const SizedBox(
                                height: 70,
                              ),
                              CustomButton(
                                  buttonTitle: 'Confirm Tickets',
                                  onPressed: () {
                                    if (controller.totalPrice.value == 0) {
                                      AppConfigs.showToast(
                                          'You have not added any ticket. You have to input at least one ticket to proceed.',
                                          Colors.red);
                                    } else if (controller
                                            .totalTicketCounter.value >
                                        10) {
                                      AppConfigs.showToast(
                                          'You can buy maximum 10 tickets at a time!',
                                          Colors.red);
                                    } else {
                                      if (controller
                                          .mobileNumberCtlr.text.isEmpty ==
                                          true) {
                                        showConfirmationPopUp();
                                      } else {
                                        if (controller
                                            .mobileNumberCtlr.text.length ==
                                            11) {
                                          showConfirmationPopUp();
                                        } else {
                                          AppConfigs.showToast(
                                              'Enter a valid mobile number!',
                                              Colors.red);
                                        }
                                      }
                                    }
                                  })
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ))),
      ),
    );
  }

  void showConfirmationPopUp() {
    Get.defaultDialog(
        title: "Are you sure about selling it?",
        backgroundColor: ColorManager.primaryWhite,
        titleStyle: getSemiBoldStyle(
            fontSize: 22, color: ColorManager.inputFieldTitleColor333333),
        content: Container(
          decoration: BoxDecoration(
              color: ColorManager.primaryWhite,
              borderRadius: BorderRadius.circular(8)),
          height: (controller.sellTicketItems.isNotEmpty == true)
              ? Get.height - 190
              : Get.height / 2.5,
          width: Get.width - 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    // color: ColorManager.grayE4E4E4,
                    // borderRadius:
                    // BorderRadius.circular(8),
                    ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 8, right: 8, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ticket Type',
                        style: getRegularStyle(
                            fontSize: 12, color: ColorManager.textColor999999),
                      ),
                      Text(
                        'Money',
                        style: getRegularStyle(
                            fontSize: 12, color: ColorManager.textColor999999),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  // physics:
                  //     const NeverScrollableScrollPhysics(),
                  itemCount: controller.sellTicketItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return (controller.sellTicketItems[index].ticketCount == 0)
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width / 2 - 24,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: controller
                                                    .sellTicketItems[index]
                                                    .name,
                                                style: getSemiBoldStyle(
                                                    fontSize: 16,
                                                    color: ColorManager
                                                        .inputFieldTitleColor333333)),
                                            TextSpan(
                                                text: ' x ',
                                                style: getSemiBoldStyle(
                                                    fontSize: 18,
                                                    color: ColorManager
                                                        .inputFieldTitleColor333333)),
                                            TextSpan(
                                                text: controller
                                                    .sellTicketItems[index]
                                                    .ticketCount
                                                    .toString(),
                                                style: getSemiBoldStyle(
                                                    fontSize: 16,
                                                    color: ColorManager
                                                        .inputFieldTitleColor333333)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                    '৳  ${controller.sellTicketItems[index].ticketCount * double.parse(controller.sellTicketItems[index].price.toString()!)}',
                                    textAlign: TextAlign.right,
                                    style: getSemiBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333)),
                              ],
                            ),
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8, right: 8, top: 0.0, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total   x ${controller.totalTicketCounter.value}',
                        style: getSemiBoldStyle(
                            fontSize: 16,
                            color: ColorManager.inputFieldTitleColor333333)),
                    Text('৳ ${controller.totalPrice.value}',
                        style: getSemiBoldStyle(
                            fontSize: 16,
                            color: ColorManager.inputFieldTitleColor333333)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                        buttonTitle: 'Yes',
                        width: 110,
                        onPressed: () {
                          if (controller.totalTicketCounter.value > 0) {
                            controller.buyPackageTicket();
                          }
                        }),
                    CustomButton(
                        buttonTitle: 'Cancel',
                        border: Border.all(color: ColorManager.gray707070),
                        width: 110,
                        color: Colors.white,
                        textStyle: TextStyle(color: ColorManager.gray707070),
                        onPressed: () {
                          Get.back();
                        })
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
