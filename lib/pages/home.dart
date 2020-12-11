import 'dart:io';
import 'package:band_names/constants.dart';
import 'package:band_names/models/models.dart';
import 'package:band_names/services/socket_server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String route = 'HomePages';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final _socketServer = Provider.of<SocketServer>(context, listen: false);

    _socketServer.socket.on('get-bands', _handlerGetBands);

    super.initState();
  }

  _handlerGetBands(dynamic payload) {
    this.bands = (payload as List).map((band) {
      return Band.fromMap(band);
    }).toList();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    final _socketServer = Provider.of<SocketServer>(context);
    _socketServer.socket.off('get-bands');
  }

  @override
  Widget build(BuildContext context) {
    final _socketServer = Provider.of<SocketServer>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BandNames',
          style: TextStyle(color: kGrey),
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: _socketServer.socket.connected
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            _showGraf(),
            Expanded(
              child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, index) => _buildBand(bands[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBand,
        child: Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

  _buildBand(Band band) {
    final _socketServer = Provider.of<SocketServer>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) =>
          _socketServer.emit('delete-band', {'id': band.id}),
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
        onTap: () => _socketServer.emit('vote-band', {'id': band.id}),
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
          content: TextField(
              controller: textController,
              textCapitalization: TextCapitalization.sentences),
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
        content: CupertinoTextField(
          controller: textController,
          textCapitalization: TextCapitalization.sentences,
        ),
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
    final _socketServer = Provider.of<SocketServer>(context, listen: false);

    if (name.length > 0) {
      _socketServer.emit('add-band', {'name': name});
    }

    Navigator.pop(context);
  }

  _showGraf() {
    Map<String, double> dataMap = {
      for (var band in this.bands) band.name: band.votes.toDouble()
    };

    return dataMap.length > 0
        ? Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: 220,
            child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
            ),
          )
        : Container(
            height: 220,
          );
  }
}
