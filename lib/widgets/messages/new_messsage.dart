import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  var _controller = TextEditingController();
  void _sendMessage() async {

    FocusScope.of(context).unfocus();
    _controller.clear();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    
    Firestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'time': Timestamp.now(),
      'userId': user.uid,
      'userName': userData['username'],
      'userImage': userData['image_url']
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send Message...'),
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              onChanged: (val) {
                setState(() {
                  _enteredMessage = val;
                });
              },
            )),
            IconButton(
                icon: Icon(Icons.send),
                color: Theme.of(context).primaryColor,
                onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage)
          ],
        ));
  }
}
