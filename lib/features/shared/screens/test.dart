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
                  showBorder: true,
                  borderRadius: BorderRadius.circular(8),
                ),

                AppTextFormField(
                  labelText: 'Email',
                  isPassword: false,

                  showBorder: true,
                  borderRadius: BorderRadius.zero,
                  borderSideType: BorderSideType.bottom,
                  borderColor: Colors.blue,
                  borderWidth: 2,

                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                ),

                AppTextFormField(
                  labelText: 'Password',
                  isPassword: true,
                  borderSideType: BorderSideType.bottom,
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
