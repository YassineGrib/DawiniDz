import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/chat_message.dart';
import '../../services/chatbot_service.dart';

class HealthAssistantScreen extends StatefulWidget {
  const HealthAssistantScreen({super.key});

  @override
  State<HealthAssistantScreen> createState() => _HealthAssistantScreenState();
}

class _HealthAssistantScreenState extends State<HealthAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatbotService _chatbotService = ChatbotService();

  List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _sendWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    try {
      // TODO: Get current user ID from auth service
      const userId = 'current_user_id';
      final messages = await _chatbotService.getChatHistory(userId);

      setState(() {
        _messages = messages;
      });

      _scrollToBottom();
    } catch (e) {
      print('Error loading chat history: $e');
    }
  }

  Future<void> _sendWelcomeMessage() async {
    if (_messages.isEmpty) {
      final welcomeMessage = ChatMessage(
        uuid: 'welcome_message',
        conversationId: 'current_user_id',
        messageText:
            'مرحباً بك في المساعد الصحي الذكي! 👋\n\nيمكنني مساعدتك في:\n• تحليل الأعراض\n• تقديم نصائح صحية عامة\n• الإجابة على أسئلتك الطبية\n• تذكيرك بالأدوية والمواعيد\n\nكيف يمكنني مساعدتك اليوم؟',
        isUserMessage: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(welcomeMessage);
      });

      _scrollToBottom();
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      uuid: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: 'current_user_id',
      messageText: messageText,
      isUserMessage: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Save user message
      await _chatbotService.saveMessage(userMessage);

      // Get AI response
      final response = await _chatbotService.getAIResponse(
        messageText,
        'current_user_id',
      );

      // Add AI response
      final aiMessage = ChatMessage(
        uuid: DateTime.now().millisecondsSinceEpoch.toString() + '_ai',
        conversationId: 'current_user_id',
        messageText: response,
        isUserMessage: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(aiMessage);
      });

      // Save AI message
      await _chatbotService.saveMessage(aiMessage);

      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في إرسال الرسالة: ${e.toString()}'),
            backgroundColor: AppConstants.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'المساعد الصحي الذكي'),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Loading Indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: AppConstants.primaryColor.withValues(
                      alpha: 0.1,
                    ),
                    child: const Icon(
                      Icons.smart_toy,
                      color: AppConstants.primaryColor,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  const Text(
                    'المساعد يكتب...',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(width: AppConstants.paddingSmall),
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك هنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLarge,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: AppConstants.paddingSmall,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                FloatingActionButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUserMessage;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
              child: const Icon(
                Icons.smart_toy,
                color: AppConstants.primaryColor,
                size: 16,
              ),
            ),
            const SizedBox(width: AppConstants.paddingSmall),
          ],

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: isUser ? AppConstants.primaryColor : Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  topRight: const Radius.circular(
                    AppConstants.borderRadiusMedium,
                  ),
                  bottomLeft: Radius.circular(
                    isUser ? AppConstants.borderRadiusMedium : 4,
                  ),
                  bottomRight: Radius.circular(
                    isUser ? 4 : AppConstants.borderRadiusMedium,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.messageText,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: isUser
                          ? Colors.white
                          : AppConstants.textPrimaryColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall / 2),
                  Text(
                    '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: isUser
                          ? Colors.white.withValues(alpha: 0.7)
                          : AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: AppConstants.paddingSmall),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.1),
              child: const Icon(
                Icons.person,
                color: AppConstants.primaryColor,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
