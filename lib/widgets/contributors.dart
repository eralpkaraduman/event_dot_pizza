import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/contributor_chip.dart';
import '../models/contributor.dart';

enum _Status { Pending, Failed, Loaded }

class Contributors extends StatefulWidget {
  const Contributors({
    Key key,
  }) : super(key: key);

  @override
  _ContributorsState createState() => _ContributorsState();
}

class _ContributorsState extends State<Contributors> {
  List<Contributor> _contributors = [];
  _Status _status = _Status.Pending;

  @override
  void initState() {
    fetchContributors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String statusMessage;
    switch (_status) {
      case _Status.Pending:
        statusMessage = 'Loading...';
        break;
      case _Status.Failed:
        statusMessage = 'Failed.';
        break;
      default:
        statusMessage = '';
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('Contributors: $statusMessage'),
        Wrap(
            spacing: 4.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: _contributors
                .map((contributor) => ContributorChip(contributor))
                .toList()),
      ],
    );
  }

  void fetchContributors() async {
    this.setState(() => _status = _Status.Pending);
    http.Response response = await http.get(
      'https://api.github.com/repos/eralpkaraduman/event_dot_pizza/contributors',
    );
    if (response.statusCode == 200) {
      List<dynamic> decodedResponse = jsonDecode(response.body);
      this.setState(() {
        _contributors = decodedResponse
            .map(
              (c) => Contributor.fromJson(c),
            )
            .toList();
        this.setState(() => _status = _Status.Loaded);
      });
    } else {
      this.setState(() => _status = _Status.Failed);
    }
  }
}
