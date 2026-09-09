import 'package:fixmate/data/chat_data.dart';
import 'package:fixmate/model/chat_model.dart';
import 'package:fixmate/pages/workerchat.dart';
import 'package:fixmate/theme/colors.dart';
import 'package:fixmate/theme/textstyle.dart';
import 'package:fixmate/widget/bottumnavbar.dart';
import 'package:fixmate/widget/message/conversationtile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final int _selectedBottomNavIndex = 2; // Messages is index 2 in 4-tab bar
  final TextEditingController _searchController = TextEditingController();
  List<ConversationModel> _filteredConversations = [];

  @override
  void initState() {
    super.initState();
    _filteredConversations = List.from(ChatData.conversations);
  }

  void _filterChats(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = List.from(ChatData.conversations);
      } else {
        _filteredConversations = ChatData.conversations
            .where(
              (c) =>
                  c.workerName.toLowerCase().contains(query.toLowerCase()) ||
                  c.serviceCategory.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 8.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterChats,
                  decoration: const InputDecoration(
                    hintText: 'Search chats or professionals...',
                    hintStyle: AppTextStyles.inputHint,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // 2. Safety Reminder Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.shield_rounded,
                    color: Color(0xFFD97706),
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Keep communication and payments inside FixMate for 100% protection guarantee.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 3. Conversations List
            Expanded(
              child: _filteredConversations.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _filteredConversations.length,
                      itemBuilder: (context, index) {
                        final conv = _filteredConversations[index];
                        return ConversationTile(
                          conversation: conv,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WorkerChatScreen(conversation: conv),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // 4. Persistent 4-Tab Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedBottomNavIndex,
        onTap: (index) {
          if (index == _selectedBottomNavIndex) return;
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/my-jobs');
              break;
            case 2:
              // Already on Messages
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text('No Conversations Yet', style: AppTextStyles.h2),
            const SizedBox(height: 8),
            const Text(
              'Start a conversation by requesting a quote or messaging a verified professional.',
              textAlign: TextAlign.center,
              style: AppTextStyles.subtitleSmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Explore Services',
                style: AppTextStyles.buttonPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
