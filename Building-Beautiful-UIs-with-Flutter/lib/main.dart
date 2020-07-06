// -. Column : 자식을 세로로 배치합니다. 열은 여러 하위 위젯을 취할 수 있으며 스크롤 위 목록과 입력 필드의 행이됩니다.

// - .Flexible : ListView의 부모 노드. 받은 메시지가 Colum을 채우도록합니다.

// -. Divider : 메시지표시부분과 텍스트 입력 부분을 구분하는 수평선을 그어줍니다.

// -. Container : 텍스트 컴포저의 부모 노드입니다. 배경이미지, 패딩, 마진등 레이아웃을 위해 사용됩니다.  decoration으로 BoxDecoration 객체을 사용합니다. 이 예제의 경우에 ThemeData 객체의 cardColor를 사용하는데. 이렇게하면 메시지 작성 UI가 메시지 목록과 다른 배경이됩니다.

//출처: https://paulaner80.tistory.com/entry/플러터로-예쁜-UI-만들기 [paulaner80]

// transition 종류들.
//
// SizeTransition
//
// AlignTransition
//
// DecoratedBoxTransition
//
// FadeTransition
//
// PositionedTransition
//
// RelativePositionedTransition
//
// RotationTransition
//
// ScaleTransition
//
// SlideTransition
//
//
//
//출처: https://paulaner80.tistory.com/entry/플러터로-예쁜-UI-만들기 [paulaner80]

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(FriendlyChat());
}
// root stateless
class FriendlyChat extends StatelessWidget {

  final ThemeData kIOSTheme = ThemeData(
      primarySwatch: Colors.orange,
      primaryColor: Colors.grey[100],
      primaryColorBrightness: Brightness.light);

  final ThemeData kDefaultTheme = ThemeData(
      primarySwatch: Colors.purple,
      accentColor: Colors.orangeAccent[400]);


 // 출처: https://paulaner80.tistory.com/entry/플러터로-예쁜-UI-만들기 [paulaner80]
  @override
  Widget build(BuildContext context) {
    // MaterialApp : 자식 위젯들에 material theme가 적용되게 한다.
    return MaterialApp(title: 'FriendlyChat', home: ChatScreen());
  }
}
// child stateful
class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin { // vsync를 사용하기 위해 클래스 정의에 TickerProviderStateMixin 포함
  // state 객체를 구현하는 새로운 class
  final _messages = <ChatMessage>[];
  final _textController = TextEditingController();
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    // Scaffold : 머터리얼 디자인에서 기본 화면요소로 쓰이는 위젯
    return Scaffold(
        appBar: AppBar(title: Text('FriendlyChat')),
        body: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ));
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row( // 입력 필드 옆에 버튼을 표시
          children: <Widget>[
            Flexible( // 버튼이 사용하지 않는 나머지 공간을 사용하도록 텍스트 필드의 크기를 자동 조정해줌.
              child: TextField(
                controller: _textController,
                onChanged: (text) => setState(() => _isComposing = text.length > 0),
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            CupertinoButton(
              child: new Text("Send"),
              onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null, // _isComposing이 false이면 onPressed 인수를 null로 변경
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() => _isComposing = false);
    ChatMessage message = ChatMessage(
      text: text,
      animationController: AnimationController(
        duration: Duration(milliseconds: 700),
        vsync: this, // VSync란 안드로이드 기기에 표출되는 화면의 정보가 변경되었을 때 이를 호출하는 신호
      ),
    );
    setState(() => _messages.insert(0, message));
    message.animationController.forward();
  }

  @override // 애니메이션이 필요 없어지면 리소스를 확보하기 위해 dispose해주는 것이 좋다.
  void dispose() { // 다른 화면으로 넘어가면 이전 화면의 애니메이션을 제거함으로써 리소스 확보
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});

  final String text;
  final AnimationController animationController;
  final _name = "YonghunPark";

  @override
  Widget build(BuildContext context) {
    return SizeTransition( // child의 넓이 또는 높이에 주어진 값을 곱하는 애니메이션 효과를 제공
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut), // 애니메이션의 시작 부분에서 빠르게 슬라이드 되게하고 정지할 때까지 느려지게 함.
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                child: Text(_name[0]),
              ),
            ),
            Expanded( // 줄바꿈
              child: Column( // 보낸 사람 이름이 들어감
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_name, style: Theme.of(context).textTheme.subhead), // 메시지 텍스트
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}