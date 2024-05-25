import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/plan/coin_plans.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DialogCoinsPlan extends StatefulWidget {
  @override
  State<DialogCoinsPlan> createState() => _DialogCoinsPlanState();
}

class _DialogCoinsPlanState extends State<DialogCoinsPlan> {
  List<CoinPlanData> plans = [];
  int coinAmount = 0;
  SessionManager sessionManager = SessionManager();
  SettingData? settingData;

  @override
  void initState() {
    prefData();
    ApiService().getCoinPlanList().then((value) {
      plans = value.data ?? [];
      setState(() {});
    });
    MethodChannel(ConstRes.bubblyCamera).setMethodCallHandler((payload) async {
      print(payload.arguments);
      if (payload.method == 'is_success_purchase' &&
          (payload.arguments as bool)) {
        print(coinAmount);
        ApiService().purchaseCoin(coinAmount.toString()).then(
          (value) {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      } else {
        Navigator.pop(context);
      }
      return;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Container(
        height: 450,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorRes.colorTheme, ColorRes.colorPink],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(icStore),
                    color: ColorRes.white,
                    height: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${LKey.shop.tr} $appName',
                    style: TextStyle(
                      fontFamily: FontRes.fNSfUiMedium,
                      color: ColorRes.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color:
                    myLoading.isDark ? ColorRes.colorPrimary : ColorRes.white,
                child: ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            children: [
                              Image(
                                  height: 30,
                                  image: AssetImage(
                                      myLoading.isDark ? icLogo : icLogoLight)),
                              SizedBox(width: 25),
                              Expanded(
                                child: Text(
                                  '${plans[index].coinAmount} $appName',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  CommonUI.showLoader(context);
                                  this.coinAmount =
                                      plans[index].coinAmount ?? 0;
                                  await BubblyCamera.inAppPurchase(Platform
                                          .isAndroid
                                      ? '${plans[index].playstoreProductId}'
                                      : '${plans[index].appstoreProductId}');
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      ColorRes.colorTheme),
                                ),
                                child: Text(
                                  '${settingData?.currency}${NumberFormat.compact(locale: 'en').format(double.parse(plans[index].coinPlanPrice ?? '0'))}',
                                  style: TextStyle(
                                      fontFamily: FontRes.fNSfUiSemiBold,
                                      color: ColorRes.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 0.1,
                          color: !myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.white,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void prefData() async {
    await sessionManager.initPref();
    settingData = sessionManager.getSetting()?.data;
    setState(() {});
  }
}
