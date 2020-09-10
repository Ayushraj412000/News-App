import 'package:flutter/material.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'loading_container.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  Widget build(context){
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot){
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;

        final children = <Widget>[
            ListTile(
              title: buildText(item),
              subtitle: item.by == "" ? Text("Deleted") : Text(item.by),
              contentPadding: EdgeInsets.only(
                right: 16.0,
                left: depth * 16.0,
              ),
            ),
            Divider(),
        ];
        item.kids.forEach((kidId) {
          children.add(
            Comment(
              itemId: kidId,
              itemMap: itemMap,
              depth: depth + 1,
            ),
          );
        });

        return Column(
          children: children,
        );
      },
    );
  }

  buildText(ItemModel item){
    return Text(item.text
      .replaceAll('&#x27;', "'")
      .replaceAll('<p>', '\n\n')
      .replaceAll('</p>', "")
    );
  }
}