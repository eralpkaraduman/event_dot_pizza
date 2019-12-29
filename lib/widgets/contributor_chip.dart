import 'package:flutter/material.dart';
import '../models/contributor.dart';
import '../widgets/link_chip.dart';

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
