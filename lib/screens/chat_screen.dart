import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/image_message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/image_type_options.dart';
import '../widgets/aspect_ratio_options.dart';
import '../services/api_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();
  String? objectName;
  String? imageType;
  String? aspectRatio;
  bool _waitingForObjectName = true;
  bool _waitingForImageType = false;
  bool _waitingForAspectRatio = false;
  bool _isGeneratingImage = false;
  int _retryCount = 0;
  final int _maxRetries = 2;
  
  final List<String> _imageTypes = [
    'realistic',
    'sketch',
    'pixel art',
    'anime-style',
    'watercolor',
    '3D render',
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }
  
  void _addWelcomeMessage() {
    setState(() {
      _messages.add(
        ChatMessage(
          text: 'Please select your style and aspect ratio, then enter the object name.',
          type: MessageType.bot,
        ),
      );
      // Show options immediately
      _waitingForImageType = true;
      _waitingForAspectRatio = true;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _handleSendMessage(String text) {
    // Only allow input for object name when both style and aspect ratio are selected
    if (_waitingForObjectName && imageType != null && aspectRatio != null) {
      final userMessage = ChatMessage(
        text: text,
        type: MessageType.user,
      );

      setState(() {
        _messages.add(userMessage);
      });

      // Capture the object name
      objectName = text.trim();
      _waitingForObjectName = false;
      _waitingForImageType = false;
      _waitingForAspectRatio = false;

      // Add generation message and start generating
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Generating Image...',
            type: MessageType.bot,
          ),
        );
        _isGeneratingImage = true;
      });

      // Debug: Print the captured values
      print('Object name: $objectName');
      print('Image type: $imageType');
      print('Aspect ratio: $aspectRatio');

      _scrollToBottom();

      // Generate the image
      _generateImage();
    } else if (imageType == null || aspectRatio == null) {
      // Show message if selections are missing
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Please select style and aspect ratio first.',
            type: MessageType.bot,
          ),
        );
      });
    }

    _scrollToBottom();
  }
  
  void _handleImageTypeSelection(String selectedType) {
    // Capture the image type (don't add user message)
    setState(() {
      imageType = selectedType;
    });
    
    // Debug: Print the captured values
    print('Image type selected: $imageType');
    
    _scrollToBottom();
  }
  
  void _handleAspectRatioSelection(String selectedRatio) {
    print('Aspect ratio selected: $selectedRatio');
    // Capture the aspect ratio (don't add user message)
    setState(() {
      aspectRatio = selectedRatio;
    });
    
    // Debug: Print the captured values
    print('Aspect ratio: $aspectRatio');
    
    _scrollToBottom();
  }


  void _startNewImageGeneration() {
    setState(() {
      // Reset states
      objectName = null;
      imageType = null;
      aspectRatio = null;
      _waitingForObjectName = true;
      _waitingForImageType = true;  // Show style options
      _waitingForAspectRatio = true; // Show aspect ratio options
      _retryCount = 0; // Reset retry count
      
      // Ask for new object name
      _messages.add(
        ChatMessage(
          text: 'Select your style and aspect ratio, then enter the object name.',
          type: MessageType.bot,
        ),
      );
    });
    _scrollToBottom();
  }

  Future<void> _generateImage() async {
    if (objectName == null || imageType == null || aspectRatio == null) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Error: Missing object name, image type, or aspect ratio.',
            type: MessageType.bot,
          ),
        );
        _isGeneratingImage = false;
      });
      return;
    }
    
    // Create the prompt
    String prompt = "A $imageType illustration of a $objectName, centered in frame, high detail, studio lighting, minimal background";
    
    print('Generating image with prompt: $prompt');
    print('Using aspect ratio: $aspectRatio');
    
    try {
      // Call the API service
      final result = await _apiService.generateImage(
        prompt: prompt,
        aspectRatio: aspectRatio!,
      );
      
      if (result['success']) {
        // Success - image generated
        final Uint8List imageBytes = result['data'];
        setState(() {
          _messages.add(
            ChatMessage(
              text: 'Here\'s your $imageType image of "$objectName"!',
              type: MessageType.bot,
              contentType: MessageContentType.image,
              imageBytes: imageBytes,
            ),
          );
          _isGeneratingImage = false;
        });
        
        // Automatically start new image generation
        Future.delayed(const Duration(milliseconds: 1000), () {
          _startNewImageGeneration();
        });
        
        print('Image generated successfully! Size: ${imageBytes.length} bytes');
        
      } else {
        // API returned error
        _retryCount++;
        if (_retryCount <= _maxRetries) {
          setState(() {
            _messages.add(
              ChatMessage(
                text: '⚠️ ${result['message']}\n\nRetrying... (Attempt $_retryCount/$_maxRetries)',
                type: MessageType.bot,
              ),
            );
          });
          
          // Retry after delay
          Future.delayed(const Duration(seconds: 2), () {
            _generateImage();
          });
        } else {
          setState(() {
            _messages.add(
              ChatMessage(
                text: '❌ ${result['message']}\n\nMax retries reached. Starting over.',
                type: MessageType.bot,
              ),
            );
            _isGeneratingImage = false;
          });
          
          // Reset everything and start over
          Future.delayed(const Duration(milliseconds: 3000), () {
            _startNewImageGeneration();
          });
        }
      }
    } catch (e) {
      // Exception occurred
      setState(() {
        _messages.add(
          ChatMessage(
            text: '💥 Unexpected error: ${e.toString()}\n\nPlease try again.',
            type: MessageType.bot,
          ),
        );
        _isGeneratingImage = false;
      });
      
      // Reset to allow trying again
      Future.delayed(const Duration(milliseconds: 2000), () {
        _startNewImageGeneration();
      });
    }
    
    _scrollToBottom();
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
      appBar: AppBar(
        title: const Text(
          'Aethra AI Image Generator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.75,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 3.0,
        shadowColor: const Color(0xFF7C3AED).withOpacity(0.25),
        toolbarHeight: 70.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildMessageList(),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
            child: ChatInput(
              onSendMessage: _handleSendMessage,
              isLoading: _isGeneratingImage,
              enabled: _waitingForObjectName && imageType != null && aspectRatio != null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(
        top: 4.0,
        bottom: 100.0, // Space for floating input
      ),
      itemCount: _messages.length + (_waitingForImageType ? 1 : 0) + (_waitingForAspectRatio ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _waitingForImageType) {
          return ImageTypeOptions(
            options: _imageTypes,
            onOptionSelected: _handleImageTypeSelection,
          );
        }
        if (index == _messages.length + (_waitingForImageType ? 1 : 0) && _waitingForAspectRatio) {
          return AspectRatioOptions(
            onOptionSelected: _handleAspectRatioSelection,
          );
        }
        
        final message = _messages[index];
        
        // Check if this is an image message
        if (message.isImage) {
          return ImageMessageBubble(
            message: message,
          );
        }
        
        // Regular text message
        return ChatMessageBubble(
          message: message,
        );
      },
    );
  }
}
