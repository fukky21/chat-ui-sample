import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: MaterialApp(
        title: 'Chat UI Sample',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat UI Sample'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => const ChatPage(),
            ),
          ),
          child: const Text('Go To Chat Page!'),
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController? _messageController;
  bool? _isSubmittable;
  final _messages = <String>[];
  static const _messageMaxLength = 100;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _isSubmittable = false;
  }

  @override
  void dispose() {
    super.dispose();
    _messageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Page'),
      ),
      body: Column(
        children: [
          _messageList(_messages),
          _inputBar(context),
        ],
      ),
    );
  }

  Widget _messageList(List<String> messages) {
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final reversedMessages = messages.reversed.toList();
          return _messageCell(reversedMessages[index]);
        },
        reverse: true,
      ),
    );
  }

  Widget _messageCell(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 25,
            child: Text('YT'),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '山田太郎',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Bubble(
                        nip: BubbleNip.leftTop,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '10:00',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    if (_isSubmittable ?? false) {
      final text = _messageController?.text ?? '';
      if (text.length <= _messageMaxLength) {
        setState(() {
          _messages.add(text);
          _isSubmittable = false;
          _messageController?.clear();
        });
      } else {
        showDialog<void>(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('エラー'),
              content: const Text('$_messageMaxLength文字以内で送信してください'),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Widget _inputBar(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'メッセージを入力',
                ),
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                onChanged: (text) {
                  setState(() {
                    // 空白を取り除く
                    _isSubmittable = text.trim().isNotEmpty;
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              padding: const EdgeInsets.all(0),
              color: _isSubmittable ?? false
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              onPressed: () => _sendMessage(context),
            ),
          ],
        ),
      ),
    );
  }
}
