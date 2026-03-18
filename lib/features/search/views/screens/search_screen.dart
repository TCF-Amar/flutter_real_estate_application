import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/search/controllers/search_controller.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SearchScreen extends GetView<AppSearchController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Search"),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                // leading: const Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: AppBackButton(),
                // ),
                toolbarHeight: 80,
                flexibleSpace: FlexibleSpaceBar(
                  background: SafeArea(
                    child: AppContainer(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: AppTextFormField(
                        controller: controller.searchController,
                        hintText: "Search properties by name, location...",
                        onFieldSubmitted: (value) => controller.search(),
                        prefixIcon: AppSvg(path: Assets.icons.search),
                        showContainerBorder: true,
                        containerBorderRadius: BorderRadius.circular(12),
                        // containerBorderSideType: BorderSideType.bottom,
                        containerBorderWidth: 1,
                        // containerBorderColor: AppColors.grey.withValues(alpha: 0.2),
                        suffixIcon: IconButton(
                          onPressed: () => controller.setQuery(""),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                        onChanged: (value) => controller.setQuery(value),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AppContainer(
                  height: 5,
                  color: AppColors.grey.withValues(alpha: 0.2),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),

              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.recentSearchesRx.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: const AppText(
                          "Recent Searches",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.recentSearchesRx.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final recent = controller.recentSearchesRx[index];
                          return ListTile(
                            onTap: () {
                              controller.setQuery(recent.query);
                              controller.search();
                            },
                            leading: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: AppImage(path: recent.image),
                            ),
                            title: AppText(
                              recent.title,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: AppText(
                              recent.location,
                              fontSize: 12,
                              color: AppColors.grey,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),

          // DraggableScrollableSheet(
          //   initialChildSize: 0.5,
          //   minChildSize: 0.5,
          //   maxChildSize: 0.9,
          //   snap: true,
          //   builder: (context, scrollController) {
          //     return Container(
          //       decoration: BoxDecoration(
          //         color: AppColors.white,
          //         borderRadius: const BorderRadius.vertical(
          //           top: Radius.circular(20),
          //         ),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.black.withValues(alpha: 0.1),
          //             blurRadius: 10,
          //             spreadRadius: 5,
          //           ),
          //         ],
          //       ),
          //       child: Column(
          //         children: [
          //           const SizedBox(height: 12),
          //           Container(
          //             width: 40,
          //             height: 5,
          //             decoration: BoxDecoration(
          //               color: AppColors.grey.withValues(alpha: 0.3),
          //               borderRadius: BorderRadius.circular(10),
          //             ),
          //           ),
          //           const SizedBox(height: 12),
          //           Expanded(
          //             child: ListView.builder(
          //               controller: scrollController,
          //               itemCount: 20,
          //               itemBuilder: (context, index) {
          //                 return ListTile(
          //                   title: AppText("Recent Search Item $index"),
          //                   leading: const Icon(Icons.history),
          //                   onTap: () {},
          //                 );
          //               },
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
