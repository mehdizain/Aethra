import 'package:flutter/material.dart';
import '../models/chat_message.dart';

class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;

  const ChatMessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: const EdgeInsets.only(
                left: 12.0,
                right: 12.0,
                top: 2.0,
                bottom: 6.0,
              ),
              child: Row(
                mainAxisAlignment: widget.message.isUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.message.isBot) ...[
                    _buildAvatar(isBot: true),
                    const SizedBox(width: 8.0),
                  ],
                  Flexible(
                    child: _buildMessageBubble(context),
                  ),
                  if (widget.message.isUser) ...[
                    const SizedBox(width: 8.0),
                    _buildAvatar(isBot: false),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar({required bool isBot}) {
    return Container(
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isBot 
              ? [const Color(0xFF7C3AED), const Color(0xFF9333EA)]
              : [const Color(0xFF06FFA5), const Color(0xFF059669)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (isBot ? const Color(0xFF4F46E5) : const Color(0xFF06B6D4))
                .withOpacity(0.4),
            blurRadius: 15.0,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        isBot ? Icons.psychology_rounded : Icons.person_rounded,
        color: Colors.white,
        size: 22.0,
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final textLength = widget.message.text.length;
    
    // Calculate dynamic max width based on text length and screen size
    double maxWidth;
    if (screenWidth > 1200) {
      // Desktop/Web - more conservative width for short messages
      if (textLength < 20) {
        maxWidth = screenWidth * 0.25;
      } else if (textLength < 50) {
        maxWidth = screenWidth * 0.4;
      } else {
        maxWidth = screenWidth * 0.6;
      }
    } else if (screenWidth > 600) {
      // Tablet
      if (textLength < 20) {
        maxWidth = screenWidth * 0.4;
      } else if (textLength < 50) {
        maxWidth = screenWidth * 0.6;
      } else {
        maxWidth = screenWidth * 0.75;
      }
    } else {
      // Mobile
      if (textLength < 20) {
        maxWidth = screenWidth * 0.6;
      } else {
        maxWidth = screenWidth * 0.8;
      }
    }
    
    return IntrinsicWidth(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          minWidth: 60.0, // Minimum width for very short messages
        ),
        padding: EdgeInsets.symmetric(
          horizontal: textLength < 10 ? 8.0 : 12.0,
          vertical: textLength < 10 ? 6.0 : 8.0,
        ),
        decoration: BoxDecoration(
        gradient: widget.message.isUser
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF06FFA5), Color(0xFF059669)],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1A24), Color(0xFF0D0D12)],
              ),
          borderRadius: _getBorderRadius(),
          border: Border.all(
            color: widget.message.isUser
                ? const Color(0xFF06FFA5).withOpacity(0.3)
                : const Color(0xFF7C3AED).withOpacity(0.3),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.message.isUser
                  ? const Color(0xFF06FFA5).withOpacity(0.2)
                  : const Color(0xFF7C3AED).withOpacity(0.2),
              blurRadius: 20.0,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.message.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                height: 1.3,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (widget.message.text.isNotEmpty) ...[
              const SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatTimestamp(widget.message.timestamp),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.message.isUser)
                    Icon(
                      Icons.done_all_rounded,
                      color: Colors.white.withOpacity(0.6),
                      size: 16.0,
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }


  BorderRadius _getBorderRadius() {
    const radius = Radius.circular(18.0);
    const smallRadius = Radius.circular(6.0);
    
    if (widget.message.isUser) {
      return const BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: smallRadius,
      );
    } else {
      return const BorderRadius.only(
        topLeft: radius,
        topRight: radius,
        bottomLeft: smallRadius,
        bottomRight: radius,
      );
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}
