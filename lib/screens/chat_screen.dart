import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_flutter_with_firebase/models/chat_user.dart';
import 'package:flutter/material.dart';

import '../api/apis.dart';

//ChatScreen

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";
  const ChatScreen({super.key, required this.user});
  final ChatUser user;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: APIs.getAllMessages(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // for(var i in data!){
                    //   print('data : ${jsonEncode(i.data())}');
                    // }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

               //   final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
                  final data = snapshot.data!.docs;
                  print('data ${jsonEncode(data[0].data())}');
                  // list = documents
                  //     .map((e) => ChatUser.fromJson(e.data()))
                  //     .toList() ??
                  //     [];
                    final list = ['hi','hello'];
                  if (list.isNotEmpty) {
                    return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        //  final user = documents[index].data();

                        return Text('Message : ${list[index]}');
                      },
                    );
                  }
                  return Center(
                    child: Text(
                      'Say Hii!🤝',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: (){},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),),
          ClipOval(
            child: CircleAvatar(
              radius: 20,
              child: FadeInImage.assetNetwork(
                //placeholder: 'https://i.pinimg.com/originals/80/b5/81/80b5813d8ad81a765ca47ebc59a65ac3.jpg', // replace with your placeholder image path
                image: widget.user.image, // replace with your image URL
                width: 40,
                height:40,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error); // display an error icon when image fails to load
                }, placeholder: 'images/logo.png',
              ),
            ),
          ),
           SizedBox(width: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user.name,style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),),
              Text('no active status',style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),),
            ],
          ),
        ],
      ),
    );
  }
  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // emoji button
                  IconButton(onPressed: (){},
                      icon: Icon(Icons.emoji_emotions,
                      color: Colors.blueAccent,
                      ),),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type Something',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  // gallery button
                  IconButton(onPressed: (){},
                    icon: Icon(Icons.image,
                      color: Colors.blueAccent,
                    ),),
                  // camera button
                  IconButton(onPressed: (){},
                    icon: Icon(Icons.camera_alt,
                      color: Colors.blueAccent,
                    ),),
                ],
              ),
            ),
          ),
          // send message button
          MaterialButton(onPressed: (){},
            shape: CircleBorder(),
            minWidth: 0,
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            color: Colors.lightBlue,
          child: Icon(Icons.send,color: Colors.white,),
          ),
        ],
      ),
    );
  }
}
