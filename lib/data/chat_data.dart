import 'package:fixmate/model/chat_model.dart';

class ChatData {
  static final List<ConversationModel> conversations = [
    const ConversationModel(
      id: 'CONV-101',
      workerName: 'Sunil Perera',
      workerAvatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      workerTrade: 'Master Painter',
      serviceCategory: 'Painting',
      isOnline: true,
      isVerified: true,
      lastMessage: 'I am on my way to your location, ETA 15 mins.',
      time: '2:30 PM',
      unreadCount: 2,
      activeJobTitle: 'Full Room Painting',
      activeJobId: '#JOB-84920',
      activeJobStatus: 'Worker on the Way',
    ),
    const ConversationModel(
      id: 'CONV-102',
      workerName: 'Kasun Fernando',
      workerAvatar:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      workerTrade: 'Licensed Plumber',
      serviceCategory: 'Plumbing',
      isOnline: false,
      isVerified: true,
      lastMessage: 'Looking forward to our scheduled visit tomorrow at 9 AM.',
      time: '11:15 AM',
      unreadCount: 0,
      activeJobTitle: 'Pipe Leak Repair',
      activeJobId: '#JOB-84915',
      activeJobStatus: 'Booking Confirmed',
    ),
    const ConversationModel(
      id: 'CONV-103',
      workerName: 'Nimal Jayasuriya',
      workerAvatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      workerTrade: 'Electrician Pro',
      serviceCategory: 'Electrical',
      isOnline: true,
      isVerified: true,
      lastMessage: 'Thank you for the review and rating! Have a great day.',
      time: 'Yesterday',
      unreadCount: 0,
      activeJobTitle: 'Ceiling Fan Repair',
      activeJobId: '#JOB-84801',
      activeJobStatus: 'Completed',
    ),
  ];

  static List<ChatMessageModel> sampleMessages = [
    const ChatMessageModel(
      id: 'M1',
      text: 'Hi, good afternoon! I have accepted your painting request.',
      isMe: false,
      time: '2:15 PM',
    ),
    const ChatMessageModel(
      id: 'M2',
      text: 'Hello Sunil! Please let me know when you leave.',
      isMe: true,
      time: '2:20 PM',
    ),
    const ChatMessageModel(
      id: 'M3',
      text: 'I just picked up the requested Nippon paint supplies.',
      isMe: false,
      time: '2:25 PM',
    ),
    const ChatMessageModel(
      id: 'M4',
      text: 'I am on my way to your location, ETA 15 mins.',
      isMe: false,
      time: '2:30 PM',
    ),
  ];
}
