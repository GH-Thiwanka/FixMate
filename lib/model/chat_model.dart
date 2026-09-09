class ChatMessageModel {
  final String id;
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;
  final String? imageUrl;

  const ChatMessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = true,
    this.imageUrl,
  });
}

class ConversationModel {
  final String id;
  final String workerName;
  final String workerAvatar;
  final String workerTrade;
  final String serviceCategory;
  final bool isOnline;
  final bool isVerified;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? activeJobTitle;
  final String? activeJobId;
  final String? activeJobStatus;

  const ConversationModel({
    required this.id,
    required this.workerName,
    required this.workerAvatar,
    required this.workerTrade,
    required this.serviceCategory,
    this.isOnline = true,
    this.isVerified = true,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.activeJobTitle,
    this.activeJobId,
    this.activeJobStatus,
  });
}
