import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';
import 'package:sohoz_park/app/commons/widgets/custom_button.dart';
import 'package:sohoz_park/app/routes/app_pages.dart';
import 'package:sohoz_park/app/utils/appconfigs.dart';
import 'package:sohoz_park/app/utils/roles.dart';

import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // ignore: prefer_const_constructors
        backgroundColor: ColorManager.backgroundColor,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          title: Text(
            "Your Report",
            style: getSemiBoldStyle(
                fontSize: 22, color: ColorManager.inputFieldTitleColor333333),
          ),
        ),
        body: Obx(() {
          return Screenshot(
            controller: controller.screenshotController,
            child: CustomScrollView(
              slivers: [
                if (controller.isLoading.value == false)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Select Your Role',
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorManager.primaryBlack,
                            ),
                          ),
                          Container(
                            width: Get.width - 32,
                            decoration: BoxDecoration(
                                // color: ColorManager.backBlue,
                                border:
                                    Border.all(color: ColorManager.grayE4E4E4),
                                borderRadius: BorderRadius.circular(8)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Select Your Role',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: ColorManager.primaryBlack,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: ColorManager.primaryBlack,
                                ),
                                items: AppConfigs.userRoles
                                    .map((String item) =>
                                        DropdownMenuItem<String>(
                                          value: item,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              item,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                value: controller.selectedRole.value,
                                onChanged: (String? value) {
                                  if (value != null) {
                                    controller.selectedRole.value = value!;
                                    controller.update();
                                    controller.clearData();
                                  }
                                },
                                iconStyleData: IconStyleData(
                                  openMenuIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                      color: ColorManager.primaryBlack,
                                    ),
                                  ),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: ColorManager.primaryBlack,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: controller
                                      .dateInput, //editing controller of this TextField
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons
                                          .calendar_today), //icon of text field
                                      labelText:
                                          "Enter Date" //label text of field
                                      ),
                                  readOnly:
                                      true, //set it true, so that user will not able to edit text
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(
                                            2000), //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2101));

                                    if (pickedDate != null) {
                                      print(
                                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);
                                      print(
                                          formattedDate); //formatted date output using intl package =>  2021-03-16
                                      //you can implement different kind of Date Format here according to your requirement
                                      controller.dateInput.text = formattedDate;
                                      controller.clearDataWithoutTime();

                                      // controller.getReports(withText: true);
                                      //set output date to TextField value.
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///in-time
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: Get.width / 2 - 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: controller
                                          .intTimeInput, //editing controller of this TextField
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons
                                              .watch_later_outlined), //icon of text field
                                          labelText:
                                              "In time" //label text of field
                                          ),
                                      readOnly:
                                          true, //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        final TimeOfDay? picked =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        String minuteValue = '00';
                                        String hourValue = '00';
                                        if (picked != null) {
                                          print(picked);
                                          if (picked.minute > 9) {
                                            minuteValue =
                                                picked.minute.toString();
                                            //'${picked.hour.toString()}:${picked.minute.toString()}:00';
                                          } else {
                                            minuteValue =
                                                '0${picked.minute.toString()}';

                                            // controller.inTime.value =
                                            //     '${picked.hour.toString()}:0${picked.minute.toString()}:00';
                                          }
                                          if (picked.hour > 9) {
                                            hourValue = picked.hour.toString();

                                            // controller.intTimeInput.text =
                                            // '${picked.hour.toString()}:${picked.minute.toString()}:00';
                                          } else {
                                            hourValue =
                                                '0${picked.hour.toString()}';

                                            // controller.intTimeInput.text =
                                            // '${picked.hour.toString()}:0${picked.minute.toString()}:00';
                                          }
                                          controller.intTimeInput.text =
                                              '$hourValue:$minuteValue:00';
                                          controller.clearDataWithoutTime();
                                        } else {
                                          print("TimeOfDay is not selected");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              ///out-time
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: Get.width / 2 - 24,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: controller
                                          .outTimeInput, //editing controller of this TextField
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons
                                              .watch_later_outlined), //icon of text field
                                          labelText:
                                              "Out Time" //label text of field
                                          ),
                                      readOnly:
                                          true, //set it true, so that user will not able to edit text
                                      onTap: () async {
                                        final TimeOfDay? picked =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        String minuteValue = '00';
                                        String hourValue = '00';

                                        if (picked != null) {
                                          print(
                                              picked); //pickedDate output format => 2021-03-10 00:00:00.000
                                          if (picked.minute > 9) {
                                            minuteValue =
                                                picked.minute.toString();
                                          } else {
                                            minuteValue =
                                                '0${picked.minute.toString()}';
                                          }
                                          if (picked.hour > 9) {
                                            hourValue = picked.hour.toString();
                                          } else {
                                            hourValue =
                                                '0${picked.hour.toString()}';
                                          }
                                          controller.outTimeInput.text =
                                              '$hourValue:$minuteValue:00';

                                          controller.clearDataWithoutTime();
                                          // if (picked.minute > 9) {
                                          //   controller.outTimeInput.text =
                                          //       '${picked.hour.toString()}:${picked.minute.toString()}:00';
                                          // } else {
                                          //   controller.outTimeInput.text =
                                          //       '${picked.hour.toString()}:0${picked.minute.toString()}:00';
                                          // }
                                        } else {
                                          print("TimeOfDay is not selected");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          CustomButton(
                            buttonTitle: 'Show Report',
                            onPressed: () {
                              if (controller.selectedRole.value != '' &&
                                  controller.intTimeInput.text != '' &&
                                  controller.outTimeInput.text != '') {
                                if (controller.selectedRole.value ==
                                    UserRoles.ENTRY_TICKET_SELLER.name) {
                                  controller.getReports(withText: true);

                                  ///to do
                                } else if (controller.selectedRole.value ==
                                    UserRoles.ZONE_TICKET_SELLER.name) {
                                  controller.getReports(withText: true);
                                } else if (controller.selectedRole.value ==
                                    UserRoles.TICKET_SCANNER.name) {
                                  controller.getReports(withText: true);
                                }
                              } else {
                                AppConfigs.showToast(
                                    "No Report Found! Please input your role, date and time",
                                    Colors.red);
                              }
                            },
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          if (controller.reportData.value?.parkName != null)
                            Text(
                              '${controller.reportData.value?.parkName ?? ''}- ${controller.reportData.value?.branchName ?? ''}',
                              style: getBoldStyle(
                                  fontSize: 16,
                                  color:
                                      ColorManager.inputFieldTitleColor333333),
                            ),
                          const SizedBox(
                            height: 32,
                          ),
                          if (controller.reportData.value?.sellerFirstName !=
                              null)
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'User: ',
                                    style: getMediumStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333),
                                  ),
                                  TextSpan(
                                    text:
                                        '${controller.reportData.value?.sellerFirstName ?? ''} ${controller.reportData.value?.sellerLastName ?? ''}',
                                    style: getBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 32,
                          ),
                          if (controller.reportData.value?.sellerFirstName !=
                              null)
                            Divider(
                              height: 8,
                              thickness: 1,
                              color: ColorManager.primaryBlack,
                            ),
                        ],
                      ),
                    ),
                  ),
                if (controller.isLoading.value == false &&
                    controller.weightData.isEmpty == false)
                  SliverList.builder(
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.weightData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              (controller.selectedRole.value ==
                                      UserRoles.TICKET_SCANNER.name)
                                  ? TextSpan(
                                      text:
                                          '${controller.weightData[index].name} Ticket Scanned  :',
                                      style: getMediumStyle(
                                          fontSize: 16,
                                          color: ColorManager
                                              .inputFieldTitleColor333333),
                                    )
                                  : TextSpan(
                                      text:
                                          '${controller.weightData[index].name} Ticket Sold  :',
                                      style: getMediumStyle(
                                          fontSize: 16,
                                          color: ColorManager
                                              .inputFieldTitleColor333333),
                                    ),
                              TextSpan(
                                text: (controller.weightData[index].amount ==
                                        'null')
                                    ? '0'
                                    : controller.weightData[index].amount
                                        .toString(),
                                style: getBoldStyle(
                                    fontSize: 16,
                                    color: ColorManager
                                        .inputFieldTitleColor333333),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                if (controller.isLoading.value == false &&
                    controller.weightData.isEmpty == false)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        height: 8,
                        thickness: 1,
                        color: ColorManager.primaryBlack,
                      ),
                    ),
                  ),

                ///packages data
                if (controller.isLoading.value == false &&
                    controller.packageData.isEmpty == false)
                  SliverList.builder(
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.packageData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              (controller.selectedRole.value ==
                                      UserRoles.TICKET_SCANNER.name)
                                  ? TextSpan(
                                      text:
                                          '${controller.packageData[index].name} Ticket Scanned  :',
                                      style: getMediumStyle(
                                          fontSize: 16,
                                          color: ColorManager
                                              .inputFieldTitleColor333333),
                                    )
                                  : TextSpan(
                                      text:
                                          '${controller.packageData[index].name} Ticket Sold  :',
                                      style: getMediumStyle(
                                          fontSize: 16,
                                          color: ColorManager
                                              .inputFieldTitleColor333333),
                                    ),
                              TextSpan(
                                text: (controller.packageData[index].amount ==
                                        'null')
                                    ? '0'
                                    : controller.packageData[index].amount
                                        .toString(),
                                style: getBoldStyle(
                                    fontSize: 16,
                                    color: ColorManager
                                        .inputFieldTitleColor333333),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                ///NOTE:- this view is only for Entry and Ride Ticket Seller
                if (controller.isLoading.value == false &&
                    controller.selectedRole.value !=
                        UserRoles.TICKET_SCANNER.name)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (AppConfigs.isZoneTicketSeller == true)
                          if (controller.reportData.value?.soldToday != null)
                            Divider(
                              height: 8,
                              thickness: 1,
                              color: ColorManager.primaryBlack,
                            ),
                          if (controller.reportData.value?.soldToday != null)
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Total Tickets Sold:  ',
                                    style: getMediumStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333),
                                  ),
                                  TextSpan(
                                    text:
                                        '${(controller.reportData.value?.soldToday ?? 0)}',
                                    style: getBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333),
                                  ),
                                ],
                              ),
                            ),
                          if (controller.reportData.value?.todayEarnings !=
                              null)
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Today’s Earnings: ',
                                    style: getMediumStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ৳ ${controller.reportData.value?.todayEarnings.toString() ?? ''} ',
                                    style: getBoldStyle(
                                        fontSize: 16,
                                        color: ColorManager
                                            .inputFieldTitleColor333333),
                                  ),
                                ],
                              ),
                            ),
                          if (controller.reportData.value?.soldToday != null)
                            Divider(
                              height: 16,
                              thickness: 1,
                              color: ColorManager.primaryBlack,
                            ),
                          // if (controller.reportData.value?.soldToday != null)
                          //   if (AppConfigs.isZoneTicketSeller == true)
                          //     Text(
                          //       'Total Tickets Sold: ${controller.reportData.value?.soldToday ?? ''}',
                          //       style: getBoldStyle(
                          //           fontSize: 16,
                          //           color: ColorManager
                          //               .inputFieldTitleColor333333),
                          //     ),
                          if (controller.reportData.value?.todayEarnings !=
                              null)
                            Text(
                              'Total Earnings: ৳ ${controller.reportData.value?.totalEarnings.toString() ?? ''} ',
                              style: getBoldStyle(
                                  fontSize: 16,
                                  color:
                                      ColorManager.inputFieldTitleColor333333),
                            ),
                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'powered by-',
                                style: getRegularStyle(
                                    fontSize: 14,
                                    color: ColorManager
                                        .inputFieldTitleColor333333),
                              ),
                              SvgPicture.asset(
                                  'assets/icons/sohoz_gray_icon.svg'),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          (controller.reportData.value?.branchName != null)
                              ? CustomButton(
                                  buttonTitle: 'Print',
                                  onPressed: () {
                                    if (controller.selectedRole.value != '' &&
                                        controller.intTimeInput.text != '' &&
                                        controller.outTimeInput.text != '') {
                                      if (controller.selectedRole.value ==
                                          UserRoles.ENTRY_TICKET_SELLER.name) {
                                        controller.printEntryTicketReport(
                                            controller.reportData.value!);
                                      } else if (controller
                                              .selectedRole.value ==
                                          UserRoles.ZONE_TICKET_SELLER.name) {
                                        controller.printRideTicketReport(
                                            controller.reportData.value!);
                                      } else if (controller
                                              .selectedRole.value ==
                                          UserRoles.TICKET_SCANNER.name) {
                                        ///to do
                                      } else {
                                        ///to do
                                      }
                                    } else {
                                      AppConfigs.showToast(
                                          "No Report Found! Please input your role, date and time",
                                          Colors.red);
                                    }
                                  },
                                )
                              : Container(),
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ),

                ///***************view for Entry and Ride Ticket Seller end******************

                ///NOTE:- this view is only for Ticket Scanner
                if (controller.isLoading.value == false &&
                    controller.selectedRole.value ==
                        UserRoles.TICKET_SCANNER.name)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (AppConfigs.isZoneTicketSeller == true)

                          Divider(
                            height: 8,
                            thickness: 1,
                            color: ColorManager.primaryBlack,
                          ),

                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Total Tickets Scanned:  ',
                                  style: getMediumStyle(
                                      fontSize: 16,
                                      color: ColorManager
                                          .inputFieldTitleColor333333),
                                ),
                                TextSpan(
                                  text:
                                      '${(controller.totalScannedTicket ?? 0)}',
                                  style: getBoldStyle(
                                      fontSize: 16,
                                      color: ColorManager
                                          .inputFieldTitleColor333333),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 32,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'powered by-',
                                style: getRegularStyle(
                                    fontSize: 14,
                                    color: ColorManager
                                        .inputFieldTitleColor333333),
                              ),
                              SvgPicture.asset(
                                  'assets/icons/sohoz_gray_icon.svg'),
                            ],
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          (controller.reportData.value?.branchName != null)
                              ? CustomButton(
                                  buttonTitle: 'Print',
                                  onPressed: () {
                                    if (controller.selectedRole.value != '' &&
                                        controller.intTimeInput.text != '' &&
                                        controller.outTimeInput.text != '') {
                                      if (controller.selectedRole.value ==
                                          UserRoles.ENTRY_TICKET_SELLER.name) {
                                        controller.printEntryTicketReport(
                                            controller.reportData.value!);
                                      } else if (controller
                                              .selectedRole.value ==
                                          UserRoles.ZONE_TICKET_SELLER.name) {
                                        controller.printRideTicketReport(
                                            controller.reportData.value!);
                                      } else if (controller
                                              .selectedRole.value ==
                                          UserRoles.TICKET_SCANNER.name) {
                                        controller.scannerReport(
                                            controller.reportData.value!);
                                      } else {
                                        ///to do
                                      }
                                    } else {
                                      AppConfigs.showToast(
                                          "No Report Found! Please input your role, date and time",
                                          Colors.red);
                                    }
                                  },
                                )
                              : Container(),
                          const SizedBox(
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ),

                ///***************view for Ticket Scanner end******************
              ],
            ),
          );
        }),
      ),
    );
  }
}
