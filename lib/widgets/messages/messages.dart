import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../messages/chat_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('time', descending: true)
                .snapshots(), //to sort before fetching
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final chatDocs = snapShot.data.documents;

              return ListView.builder(
                reverse: true,
                itemBuilder: (ctx, i) => ChatBubble(
                    chatDocs[i]['text'],
                    chatDocs[i]['userId'] == snap.data.uid,
                    
                    chatDocs[i]['userName'],
                    chatDocs[i]['userImage'],
                    key: ValueKey(chatDocs[i].documentID)),
                itemCount: chatDocs.length,
              );
            });
      },
    );
  }
}
