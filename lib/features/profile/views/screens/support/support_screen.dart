import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_app/core/constants/app_assets.dart';
import 'package:real_estate_app/core/routes/app_routes.dart';
import 'package:real_estate_app/features/profile/views/widgets/support_widgets/support_topic.dart';
import 'package:real_estate_app/features/profile/views/widgets/support_widgets/ticket_card.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  static final _topics = [
    SupportTopic(path: Assets.icons.property, title: 'Property'),
    SupportTopic(path: Assets.icons.wallet, title: 'Payments'),
    SupportTopic(path: Assets.icons.booking, title: 'Booking'),
    SupportTopic(path: Assets.icons.icon6, title: 'Document'),
  ];

  static final _tickets = [
    TicketData(
      date: "12/04/2023",
      id: "sup-234",
      status: PaymentStatus.pending,
      title: "Payment Failed",
    ),
    TicketData(
      date: "12/04/2023",
      id: "sup-234",
      status: PaymentStatus.paid,
      title: "Payment Success",
    ),
    TicketData(
      date: "12/04/2023",
      id: "sup-235",
      status: PaymentStatus.pending,
      title: "Payment Failed",
    ),
    TicketData(
      date: "12/04/2023",
      id: "sup-236",
      status: PaymentStatus.failed,
      title: "Payment Failed",
    ),
    TicketData(
      date: "12/04/2023",
      id: "sup-237",
      status: PaymentStatus.paid,
      title: "Payment Success",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'Support',
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: CustomScrollView(
          slivers: [
            /// Title
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AppText(
                  'What Can we help with?',
                  fontSize: 16,

                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            /// Topics Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => TopicCard(topic: _topics[index]),
                  childCount: _topics.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.3,
                ),
              ),
            ),

            /// Tickets Title
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: SliverToBoxAdapter(
                child: AppText(
                  'My Support Tickets',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            /// Ticket List
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: TicketCard(t: _tickets[index]),
                  );
                }, childCount: _tickets.length),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20.0,
        ).copyWith(bottom: 50),
        child: AppButton(
          text: "New Request",
          onPressed: () {
            Get.toNamed(AppRoutes.newRequest);
          },
        ),
      ),
    );
  }
}
