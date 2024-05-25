import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:bubbly/view/setting/widget/setting_center_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [AppBarCustom(title: LKey.settings.tr), SettingCenterArea()],
      ),
    );
  }
}
