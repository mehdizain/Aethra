# AI Image Generator App - Agent Context Documentation

## 🚀 **Project Overview**
A Flutter chat-based AI image generator application that uses Stability AI's API to generate images based on user input. Features a modern dark theme with smooth animations and conversational UI.

## 📱 **Application Features**
- **Chat Interface**: Modern messaging UI with floating input and message bubbles
- **Image Generation**: AI-powered image creation using Stability AI API
- **Multiple Generations**: Users can generate unlimited images in sequence
- **Dark Theme**: Beautiful gradient-based dark theme with purple/blue accents
- **Responsive Design**: Works on mobile and web platforms

## 🔄 **User Flow**
1. **Object Selection**: User types the name of object to generate
2. **Style Selection**: User chooses from 6 image style options via buttons
3. **Generation**: API generates image with constructed prompt
4. **Display**: Generated image appears in chat with caption
5. **Continue**: User can choose to generate another image (Yes/No buttons)

## 🎨 **UI Components & Styling**

### **Color Scheme**
- **Background**: `#0F0F23` (Deep space blue)
- **App Bar**: `#16213E` (Rich navy)
- **Chat Input**: `#161B22` with gradient `#2D2D44` → `#1F1B2E`
- **User Messages**: Gradient `#6A4CFF` → `#4F46E5`
- **Bot Messages**: Gradient `#2D2D44` → `#1F1B2E`
- **Avatars**: Bot and User have distinct gradients

### **Key Widgets**
- **ChatScreen**: Main screen with Stack layout (messages + floating input)
- **ChatMessageBubble**: Text message display with animations
- **ImageMessageBubble**: Image display with rounded corners and shadows
- **ImageTypeOptions**: Style selection buttons (6 options)
- **YesNoOptions**: Continue/End generation buttons
- **ChatInput**: Floating input field with send button

## 🛠 **Technical Architecture**

### **File Structure**
```
lib/
├── main.dart                          # App entry point
├── models/
│   └── chat_message.dart              # Message model with image support
├── screens/
│   └── chat_screen.dart               # Main chat interface
├── services/
│   └── api_service.dart               # Stability AI API integration
└── widgets/
    ├── chat_message_bubble.dart       # Text message widget
    ├── image_message_bubble.dart      # Image message widget
    ├── chat_input.dart                # Input field with animations
    ├── image_type_options.dart        # Style selection buttons
    └── yes_no_options.dart            # Continue/End buttons
```

### **State Management**
- **Local State**: Uses `setState()` for UI updates
- **Message Storage**: `List<ChatMessage>` maintains conversation history
- **API State**: Boolean flags track generation progress
- **User Input**: String variables store selections

## 🔧 **API Integration**

### **Stability AI Configuration**
- **Endpoint**: `https://api.stability.ai/v2beta/stable-image/generate/core`
- **Method**: POST (Multipart form data)
- **Authentication**: Bearer token in headers
- **Response**: Base64 encoded image data

### **Prompt Construction**
```dart
String prompt = "A $imageType illustration of a $objectName, centered in frame, high detail, studio lighting, minimal background";
```

### **Image Types Available**
- realistic
- sketch
- pixel art
- anime-style
- watercolor
- 3D render

## 📊 **Data Models**

### **ChatMessage Model**
```dart
class ChatMessage {
  final String text;
  final MessageType type;              // user, bot
  final DateTime timestamp;
  final MessageContentType contentType; // text, image
  final Uint8List? imageBytes;         // For image messages
}
```

### **State Variables**
```dart
String? objectName;                    // User's object selection
String? imageType;                     // Selected image style
bool _waitingForObjectName = true;     // Initial state
bool _waitingForImageType = false;     // After object entered
bool _isGeneratingImage = false;       // During API call
bool _waitingForAnotherImage = false;  // After generation
```

## 🎯 **User Experience Flow**

### **Conversation States**
1. **Initial**: Bot asks for object name
2. **Object Input**: User types object name
3. **Style Selection**: Bot shows 6 style buttons
4. **Generation**: API processes request (loading state)
5. **Result Display**: Image appears in chat
6. **Continue Prompt**: Yes/No buttons for next generation

### **Error Handling**
- **API Failures**: Graceful error messages
- **Invalid Inputs**: Validation with user guidance
- **Network Issues**: Try-catch blocks with user feedback

## 🔄 **Animation System**

### **Message Animations**
- **Entrance**: Scale + opacity animations for new messages
- **Typing**: Word-by-word reveal for bot responses
- **Button Interactions**: Scale animations on press

### **UI Transitions**
- **Smooth Scrolling**: Auto-scroll to latest messages
- **Loading States**: Spinner in send button during generation
- **State Changes**: Fade transitions between conversation states

## 🎨 **Design Patterns**

### **Widget Architecture**
- **Stateful Widgets**: For animated components
- **Composition**: Small, reusable widgets
- **Responsive Design**: Dynamic sizing based on content/screen
- **Theme Consistency**: Centralized color scheme

### **Code Organization**
- **Separation of Concerns**: API, UI, and business logic separated
- **Reusable Components**: Modular widget design
- **Clear Naming**: Descriptive variable and function names

## 🐛 **Known Limitations**
- **Single API Provider**: Only Stability AI currently supported
- **No Image Persistence**: Images not saved to device
- **No Conversation History**: Messages cleared on app restart
- **No User Authentication**: No user accounts or profiles

## 🚀 **Future Enhancement Ideas**
- **Multi-Provider Support**: Add OpenAI DALL-E, Midjourney
- **Image Gallery**: Save and browse generated images
- **Conversation Export**: Share or save chat history
- **Advanced Prompting**: More detailed style controls
- **User Profiles**: Save preferences and favorites

## 🔧 **Development Notes**
- **Flutter Version**: Requires Flutter 3.8.1+
- **Dependencies**: `http: ^1.1.0` for API calls
- **Platform Support**: Mobile (iOS/Android) and Web
- **Performance**: Optimized for smooth animations and image display

## 📝 **Code Quality**
- **Error Handling**: Comprehensive try-catch blocks
- **User Feedback**: Clear loading states and error messages
- **Code Comments**: Detailed documentation throughout
- **Consistent Styling**: Unified design language

This documentation provides a complete overview of the AI Image Generator app's architecture, features, and implementation details for easy understanding and future development.
