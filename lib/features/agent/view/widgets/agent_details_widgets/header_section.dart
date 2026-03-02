import 'package:flutter/material.dart';
import 'package:real_estate_app/features/agent/models/agent_details_response_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_image.dart';

class HeaderSection extends StatelessWidget {
  final AgentDetailModel agent;

  const HeaderSection({super.key, required this.agent});
  @override
  Widget build(BuildContext context) {
    return  FlexibleSpaceBar(
                background: Stack(
                  clipBehavior: Clip.antiAlias,
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Cover Image
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 170,
                      child: AppImage(path: agent.image, fit: BoxFit.cover),
                    ),

                    // Dark overlay for readability
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 170,
                      child: Container(color: Colors.black.withValues(alpha: 0.18)),
                    ),

                    // Circular avatar overlapping content
                    Positioned(
                      bottom: 100,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 72,
                          backgroundImage:
                              agent.image != null && agent.image!.isNotEmpty
                              ? NetworkImage(agent.image!)
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              agent.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              agent.roleType,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if ((agent.agencyName).isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'At ${agent.agencyName}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ;
  }
}