// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final double? height;
  final Color? backgroundColor;
  final BoxBorder? border;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextAlign? textAlign;
  final bool? obscureText;
  void Function(String)? onChanged;
  final FocusNode? focusNode;
  BorderRadiusGeometry? borderRadius;
  final InputBorder? focusedBorder;
final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  final int? maxLines;
  final int? maxLength;

  final String? Function(String?)? validator;

  CustomInputField(
      {Key? key,
      required this.controller,
      required this.isEnabled,
      this.backgroundColor,
      this.focusNode,
      this.maxLength,
      this.border,
      this.prefixIcon,
      this.hintText,
      this.onChanged,
      this.suffixIcon,
      this.obscureText,
      this.focusedBorder,
      this.borderRadius,
      this.keyboardType,
      this.maxLines,
      this.validator,
      this.height,
      this.textAlign, this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      height: height ?? 56,
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorManager.inputFieldBackgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: (focusNode?.hasFocus == true)
            ? [
                // BoxShadow(
                //   color: ColorManager.primary500.withOpacity(0.18),
                //   offset: Offset(0, 6),
                //   blurRadius: 20,
                //   spreadRadius: 0,
                // )
              ]
            : null,
        border: (focusedBorder != null) ? null : border,
      ),
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatters ?? [
          LengthLimitingTextInputFormatter(11),
        ],
        onChanged: onChanged,
        validator: validator,
        enabled: isEnabled,
        keyboardType: keyboardType ?? TextInputType.text,
        focusNode: focusNode,
        obscureText: obscureText ?? false,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        textAlign: textAlign ?? TextAlign.left,
        style: getSemiBoldStyle(
            fontSize: 14, color: ColorManager.inputFieldTextColor),
        decoration: InputDecoration(
          border: InputBorder.none,
          // OutlineInputBorder(
          //     borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          //     borderSide: BorderSide(color: ColorManager.inputFieldBackgroundColor)
          //     ),
          focusedBorder: focusedBorder,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,

          contentPadding: const EdgeInsets.all(12.0),

          hintStyle: getRegularStyle(
              fontSize: 14, color: ColorManager.inputFieldTextColor),
          hintText: hintText ?? "Search here",

          // hintStyle: getRegularStyle(
          //     fontSize: 14,color: ColorManager.gray400
          // )
        ),
      ),
    );
  }
}
