import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool isLoading;
  final bool enabled;

  const ChatInput({
    Key? key,
    required this.onSendMessage,
    this.isLoading = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _textController.addListener(() {
      setState(() {
        _hasText = _textController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      widget.onSendMessage(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A24), Color(0xFF0D0D12)],
        ),
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: const Color(0xFF7C3AED).withOpacity(0.4),
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withOpacity(0.3),
            blurRadius: 30.0,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20.0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A2A35), Color(0xFF1F1F2A)],
                ),
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: _focusNode.hasFocus 
                      ? const Color(0xFF06FFA5).withOpacity(0.6)
                      : const Color(0xFF7C3AED).withOpacity(0.3),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _focusNode.hasFocus
                        ? const Color(0xFF06FFA5).withOpacity(0.3)
                        : Colors.transparent,
                    blurRadius: 15.0,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                enabled: widget.enabled,
                maxLines: 3,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  if (widget.enabled) _sendMessage();
                },
                onChanged: (text) {
                  // Handle raw input to prevent Enter from creating new lines when sending
                  if (text.endsWith('\n') && !text.endsWith('\n\n')) {
                    final trimmedText = text.trimRight();
                    if (trimmedText.isNotEmpty) {
                      _textController.text = trimmedText;
                      _textController.selection = TextSelection.fromPosition(
                        TextPosition(offset: trimmedText.length),
                      );
                      _sendMessage();
                    }
                  }
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: widget.enabled ? 'Text to generate image' : 'Please select from the options above',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(widget.enabled ? 0.5 : 0.3),
                    fontSize: 15.0,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    gradient: _hasText && !widget.isLoading && widget.enabled
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF06FFA5), Color(0xFF059669)],
                          )
                        : const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF3D3D5C), Color(0xFF2A2A40)],
                          ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (_hasText && !widget.isLoading && widget.enabled)
                        BoxShadow(
                          color: const Color(0xFF06FFA5).withOpacity(0.5),
                          blurRadius: 20.0,
                          offset: const Offset(0, 6),
                        ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: (_hasText && !widget.isLoading && widget.enabled) ? _sendMessage : null,
                    icon: widget.isLoading
                        ? const SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            color: _hasText ? Colors.white : Colors.white.withOpacity(0.5),
                            size: 20.0,
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
