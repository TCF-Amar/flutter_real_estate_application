import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate_app/features/shared/widgets/back_button.dart';
import 'package:real_estate_app/features/shared/widgets/header_text.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? surfaceTintColor;
  final double? toolbarHeight;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const DefaultAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.surfaceTintColor,
    this.toolbarHeight,
    this.systemOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: leading ?? const AppBackButton(),
      ),
      centerTitle: centerTitle,
      title: titleWidget ?? (title != null ? HeaderText(text: title!) : null),
      actions: actions,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      toolbarHeight: toolbarHeight,
      systemOverlayStyle: systemOverlayStyle,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? kToolbarHeight);
}
