import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sohoz_park/app/commons/colors.dart';
import 'package:sohoz_park/app/commons/styles.dart';


class CustomButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final BoxBorder? border;
  final double? width;
  final double? height;
  final Widget? leading;
  final Widget? trailing;

  const CustomButton(
      {super.key,
      this.onPressed,
      required this.buttonTitle,
      this.gradient,
      this.textAlign,
      this.textStyle,
      this.margin,
      this.border,
      this.leading,
      this.trailing,
      this.color,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 52,
      margin: margin,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: color ?? ColorManager.buttonBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: border,
      ),
      child: ListTile(
        onTap: onPressed,
        leading: leading, trailing: trailing, dense: true,
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        title: Center(
          child: Text(
            buttonTitle,
            textAlign: TextAlign.center,
            style: textStyle ??
                getBoldStyle(color: ColorManager.primaryWhite, fontSize: 14),
          ),
        ),
        // textColor: Colors.white,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(25),
        // ),
      ),
    );
  }
}
