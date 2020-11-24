import 'dart:io';

import 'package:band_names/constants.dart';
import 'package:band_names/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final String route = 'HomePages';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Band> bands = [
    Band(id: '1', name: 'Ismael F. Santan', votes: 33),
    Band(id: '2', name: 'Samuel Diaz', votes: 19),
    Band(id: '3', name: 'Miguel de Jesus', votes: 32),
    Band(id: '4', name: 'Robinson Cano', votes: 25),
    Band(id: '5', name: 'Armando Paredes', votes: 33),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'BandNames',
          style: TextStyle(color: kGrey),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => _buildBand(bands[index]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBand,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  _buildBand(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direciton $direction');
      },
      background: Container(
        padding: EdgeInsets.only(left: 20),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'DELETE BAND',
            style: TextStyle(color: kWhite),
          ),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: kBlueL,
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () => debugPrint(band.name),
      ),
    );
  }

  _addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('New band name'),
          content: TextField(controller: textController),
          actions: [
            MaterialButton(
              onPressed: () => _addBandToList(textController.text),
              child: Text('Add'),
              textColor: kBlue,
            )
          ],
        ),
      );
    }

    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('New band name:'),
        content: CupertinoTextField(controller: textController),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Add'),
            onPressed: () => _addBandToList(textController.text),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  _addBandToList(String name) {
    if (name.length > 0) {
      print(name);
      this.bands.add(Band(id: '${bands.length}', name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
