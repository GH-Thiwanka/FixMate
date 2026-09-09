import 'package:fixmate/model/chat_model.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:flutter/material.dart';

class ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasUnread = conversation.unreadCount > 0;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primarySoft,
            backgroundImage: NetworkImage(conversation.workerAvatar),
          ),
          // Online Indicator Dot
          if (conversation.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 13,
                height: 13,
                decoration: BoxDecoration(
                  color: const Color(0xFF168A55), // Green
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            conversation.workerName,
            style: AppTextStyles.h3.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            conversation.time,
            style: TextStyle(
              fontSize: 11,
              color: hasUnread
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
              fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                conversation.lastMessage,
                style: TextStyle(
                  fontSize: 12.5,
                  color: hasUnread
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasUnread)
              Container(
                margin: const EdgeInsets.only(left: 6),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${conversation.unreadCount}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      // trailing: Column(
      //   children: [
      //     Text(
      //       conversation.time,
      //       style: TextStyle(
      //         fontSize: 11,
      //         color: hasUnread
      //             ? AppColors.textPrimary
      //             : AppColors.textSecondary,
      //         fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
      //       ),
      //     ),
      //     if (hasUnread)
      //       Container(
      //         width: 20,
      //         height: 20,
      //         decoration: BoxDecoration(
      //           color: AppColors.primary,
      //           shape: BoxShape.circle,
      //         ),
      //         child: Center(
      //           child: Text(
      //             '${conversation.unreadCount}',
      //             style: const TextStyle(
      //               fontSize: 11,
      //               color: Colors.white,
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //         ),
      //       ),
      //   ],
      // ),
    );
  }
}
