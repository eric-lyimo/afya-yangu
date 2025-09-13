class ChatMessage{
  String message;
  int chatId;
  int senderId;
  String sentAt;
  ChatMessage({required this.message, required this.chatId, required this.senderId, required this.sentAt});
  
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      chatId: json['chats_id'],
      senderId: json['user_id'],
      message: json['message']??"empty",
      sentAt: json['created_at'],
    );
  }
}