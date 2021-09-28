import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String msg;
  final bool isMe;
  final String userImage;
  final Key key;
  final String userName;
  ChatBubble(this.msg, this.isMe, this.userName, this.userImage, {this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color:
                        isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft:
                            !isMe ? Radius.circular(0) : Radius.circular(12),
                        bottomRight:
                            isMe ? Radius.circular(0) : Radius.circular(12))),
                width:
                    140, //this will not be considered as it is in a ListView but after row it will work
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userName, //didnt used data.documnt bcause using data of only one doc
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isMe
                                ? Colors.black
                                : Theme.of(context)
                                    .accentTextTheme
                                    .headline1
                                    .color),
                      ),
                      Text(
                        msg,
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                        style: TextStyle(
                            color: isMe
                                ? Colors.black
                                : Theme.of(context)
                                    .accentTextTheme
                                    .headline1
                                    .color),
                      ),
                    ]),
              ),
            ]),
        Positioned(
            top: 0,
            left: isMe ? null : 120,
            right: isMe ? 120 : null,
            child: CircleAvatar(
              
             backgroundImage: NetworkImage(userImage),
              // backgroundColor: Colors.black,
            ))
      ],
      overflow: Overflow.visible,
    );
  }
}
