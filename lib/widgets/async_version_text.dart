import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AsyncVersionText extends StatelessWidget {
  const AsyncVersionText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return Text(
              "Version: ${snap.data.version} Build:${snap.data.buildNumber}");
        }
      },
    );
  }
}
