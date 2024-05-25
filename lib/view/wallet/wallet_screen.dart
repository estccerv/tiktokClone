import 'dart:ui';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/modal/wallet/my_wallet.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/redeem/redeem_screen.dart';
import 'package:bubbly/view/wallet/dialog_coins_plan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  MyWalletData? _myWalletData;
  SessionManager sessionManager = SessionManager();
  SettingData? settingData;

  @override
  void initState() {
    prefData();
    getMyWalletData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        body: Column(
          children: [
            AppBarCustom(title: LKey.wallet.tr),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: myLoading.isDark
                                      ? ColorRes.colorPrimaryDark
                                      : ColorRes.greyShade100,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          ColorRes.colorPink.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    NumberFormat.compact(
                                      locale: 'en',
                                    ).format(_myWalletData?.myWallet ?? 0),
                                    style: TextStyle(
                                      fontFamily: FontRes.fNSfUiBold,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              left: 0,
                              bottom: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: myLoading.isDark
                                      ? ColorRes.colorPrimary
                                      : ColorRes.white.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(color: ColorRes.colorPink),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Center(
                                      child: Text(
                                        '$appName ${LKey.youHave.tr}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: FontRes.fNSfUiSemiBold,
                                            color: !myLoading.isDark
                                                ? ColorRes.colorPink
                                                : ColorRes.greyShade100),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        width: 160,
                        height: 160,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppRes.redeemTitle(
                            (settingData?.coinValue ?? 0.0).toStringAsFixed(2)),
                        style: TextStyle(
                          color: ColorRes.colorTextLight,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return DialogCoinsPlan();
                            },
                            backgroundColor: Colors.transparent,
                          ).then((value) {
                            getMyWalletData();
                          });
                        },
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: 30),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                ColorRes.colorTheme,
                                ColorRes.colorPink,
                              ],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${LKey.add.tr} $appName',
                            style: TextStyle(
                                fontFamily: FontRes.fNSfUiSemiBold,
                                color: ColorRes.white,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      Divider(
                        color: myLoading.isDark
                            ? ColorRes.colorPrimary
                            : ColorRes.greyShade100,
                        height: 1,
                        thickness: 1,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LKey.rewardingActions.tr,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 58,
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.symmetric(horizontal: 9),
                        decoration: BoxDecoration(
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: ColorRes.colorTheme,
                              radius: 22,
                              child: Text(
                                "+${NumberFormat.compact(locale: 'en').format(settingData?.rewardVideoUpload ?? 0)}",
                                style: TextStyle(
                                  color: ColorRes.white,
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: FontRes.fNSfUiMedium,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                LKey.wheneverYouUploadVideo.tr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontFamily: FontRes.fNSfUiMedium),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                          height: 1,
                          thickness: 1),
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if ((_myWalletData?.myWallet ?? 0) <=
                    (settingData?.minRedeemCoins ?? 0)) {
                  CommonUI.showToast(msg: LKey.insufficientRedeemPoints.tr);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RedeemScreen()),
                  ).then((value) {
                    getMyWalletData();
                  });
                }
              },
              child: Container(
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(
                    colors: [ColorRes.colorTheme, ColorRes.colorPink],
                  ),
                ),
                child: Center(
                  child: Text(
                    LKey.requestRedeem.tr,
                    style: TextStyle(
                        color: ColorRes.white,
                        fontSize: 19,
                        fontFamily: FontRes.fNSfUiMedium),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: AppBar().preferredSize.height / 2,
            )
          ],
        ),
      );
    });
  }

  void getMyWalletData() {
    ApiService().getMyWalletCoin().then((value) {
      _myWalletData = value.data;
      setState(() {});
    });
  }

  void prefData() async {
    await sessionManager.initPref();
    settingData = sessionManager.getSetting()?.data;
    setState(() {});
  }
}
