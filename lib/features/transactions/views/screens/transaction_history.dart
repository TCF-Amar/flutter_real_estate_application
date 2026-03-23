import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final fakeData = [
      {
        "image":
            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
        "title": "Skyline Luxury",
        "transaction_id": "7458-AdV4758",
        "amount": "\$70,000",
        "date": "2/12 Installment",
        "status": "Successful",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
        "title": "Skyline Luxury",
        "transaction_id": "7458-AdV4758",
        "amount": "\$70,000",
        "date": "2/12 Installment",
        "status": "Successful",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1170&q=80",
        "title": "Skyline Luxury",
        "transaction_id": "7458-AdV4758",
        "amount": "\$70,000",
        "date": "2/12 Installment",
        "status": "Successful",
      },
    ];

    return Scaffold(
      appBar: const DefaultAppBar(title: "Transaction History"),
      body: Column(
        children: [
          // Filter Section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _FilterChip(label: "All", isSelected: true),
                const SizedBox(width: 12),
                _FilterChip(
                  label: "Status",
                  hasDropdown: true,
                  dropDown: DropdownFlutter<String>(
                    hintText: "Status",
                    items: const ["All", "Successful", "Pending", "Failed"],
                    onChanged: (value) {},
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Colors.white,
                      closedBorder: Border.all(color: Colors.grey.shade300),
                      closedBorderRadius: BorderRadius.circular(12),
                      closedSuffixIcon: const Icon(Icons.expand_more, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _FilterChip(
                  label: "Payment Type",
                  hasDropdown: true,
                  dropDown: DropdownFlutter<String>(
                    hintText: "Payment Type",
                    items: const ["All", "Fill Payment", "Installment"],
                    onChanged: (value) {},
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Colors.white,
                      closedBorder: Border.all(color: Colors.grey.shade300),
                      closedBorderRadius: BorderRadius.circular(12),
                      closedSuffixIcon: const Icon(Icons.expand_more, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Transaction List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: fakeData.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = fakeData[index];
                return _TransactionCard(data: item);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool hasDropdown;
  final Widget? dropDown;

  const _FilterChip({
    required this.label,
    this.isSelected = false,
    this.hasDropdown = false,
    this.dropDown,
  });

  @override
  Widget build(BuildContext context) {
    if (dropDown != null) {
      return SizedBox(
        width: 130,
        height: 48,
        child: dropDown,
      );
    }
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 1),
      borderRadius: BorderRadius.circular(12),
      showBorder: true,
      borderColor: isSelected ? AppColors.primary : Colors.grey.shade300,
      color: Colors.white,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              label,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : Colors.grey.shade600,
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.expand_more,
                size: 20,
                color: isSelected ? AppColors.primary : Colors.grey.shade600,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _TransactionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      // showBorder: true,
      // borderColor: Colors.blue.shade400, // Matching the blue highlight in screenshot
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade400, width: 1),
      showShadow: true,
      shadowColor: Colors.grey.shade400,
      color: Colors.white,
      child: Row(
        children: [
          // Circular Image
          AppImage(
            path: data["image"],
            width: 50,
            height: 50,
            radius: BorderRadius.circular(30),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  data["title"],
                  fontSize: 15,
                  // fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 4),
                AppText(
                  "Trans. ID : ${data["transaction_id"]}",
                  fontSize: 10,
                  color: Colors.blue.shade300,
                ),
                const SizedBox(height: 4),
                AppText(
                  data["date"],
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),

          // Amount & Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                data["amount"],
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
              _StatusBadge(status: data["status"]),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(6),
      color: Colors.green.shade50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: Colors.green.shade400,
          ),
          const SizedBox(width: 4),
          AppText(
            status,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.green.shade400,
          ),
        ],
      ),
    );
  }
}
