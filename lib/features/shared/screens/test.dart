import 'package:flutter/material.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            snap: true,
            floating: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: AppContainer(
                // padding: EdgeInsets.all(0),
                // borderRadius: BorderRadius.all(Radius.circular(29)),
                // color: Colors.red,
                child: AppTextFormField(),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                AppText("dfg"),
                AppText.large("sdfs"),
                AppText.small("sdf"),
                // Te,
                AppTextFormField(
                  labelText: 'Username',
                  showContainerBorder: true,
                  containerBorderRadius: BorderRadius.circular(8),
                ),

                AppTextFormField(
                  labelText: 'Email',
                  isPassword: false,
                  containerGradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.white],
                  ),

                  showContainerBorder: true,
                  containerBorderRadius: BorderRadius.zero,
                  containerBorderSideType: BorderSideType.bottom,
                  containerBorderColor: Colors.blue,
                  containerBorderWidth: 2,
                  containerElevation: 4,
                  containerMargin: EdgeInsets.all(8),
                  containerPadding: EdgeInsets.symmetric(horizontal: 12),
                ),

                AppTextFormField(
                  labelText: 'Password',
                  isPassword: true,
                  containerDecoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red, width: 3),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black26),
                    ],
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
