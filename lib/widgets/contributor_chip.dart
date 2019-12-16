import 'package:event_dot_pizza/models/contributor.dart';
import 'package:event_dot_pizza/widgets/link_chip.dart';
import 'package:flutter/material.dart';

class ContributorChip extends StatelessWidget {
  final Contributor contributor;
  const ContributorChip(
    this.contributor, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinkChip(
      contributor.login,
      url: contributor.htmlUrl,
      image: NetworkImage(contributor.avatarUrl),
    );
  }
}
