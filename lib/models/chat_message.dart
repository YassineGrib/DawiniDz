// JSON serialization will be added later
class ChatConversation {
  final String uuid;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatConversation({
    required this.uuid,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  // JSON serialization methods will be added later

  factory ChatConversation.fromMap(Map<String, dynamic> map) {
    return ChatConversation(
      uuid: map['uuid'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatConversation && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

class ChatMessage {
  final String uuid;
  final String conversationId;
  final String messageText;
  final bool isUserMessage;
  final DateTime timestamp;
  final List<String>? symptoms;
  final String? preliminaryDiagnosis;
  final List<String>? recommendations;

  ChatMessage({
    required this.uuid,
    required this.conversationId,
    required this.messageText,
    required this.isUserMessage,
    required this.timestamp,
    this.symptoms,
    this.preliminaryDiagnosis,
    this.recommendations,
  });

  // JSON serialization methods will be added later

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      uuid: map['uuid'] as String,
      conversationId: map['conversation_id'] as String,
      messageText: map['message_text'] as String,
      isUserMessage: (map['is_user_message'] as int) == 1,
      timestamp: DateTime.parse(map['timestamp'] as String),
      symptoms: map['symptoms'] != null
          ? (map['symptoms'] as String)
                .split(',')
                .where((s) => s.isNotEmpty)
                .toList()
          : null,
      preliminaryDiagnosis: map['preliminary_diagnosis'] as String?,
      recommendations: map['recommendations'] != null
          ? (map['recommendations'] as String)
                .split(',')
                .where((s) => s.isNotEmpty)
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'conversation_id': conversationId,
      'message_text': messageText,
      'is_user_message': isUserMessage ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
      'symptoms': symptoms?.join(','),
      'preliminary_diagnosis': preliminaryDiagnosis,
      'recommendations': recommendations?.join(','),
    };
  }

  ChatMessage copyWith({
    String? uuid,
    String? conversationId,
    String? messageText,
    bool? isUserMessage,
    DateTime? timestamp,
    List<String>? symptoms,
    String? preliminaryDiagnosis,
    List<String>? recommendations,
  }) {
    return ChatMessage(
      uuid: uuid ?? this.uuid,
      conversationId: conversationId ?? this.conversationId,
      messageText: messageText ?? this.messageText,
      isUserMessage: isUserMessage ?? this.isUserMessage,
      timestamp: timestamp ?? this.timestamp,
      symptoms: symptoms ?? this.symptoms,
      preliminaryDiagnosis: preliminaryDiagnosis ?? this.preliminaryDiagnosis,
      recommendations: recommendations ?? this.recommendations,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() {
    return 'ChatMessage(uuid: $uuid, isUser: $isUserMessage, text: ${messageText.substring(0, messageText.length > 50 ? 50 : messageText.length)}...)';
  }
}
