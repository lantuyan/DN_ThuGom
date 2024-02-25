import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:thu_gom/shared/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:thu_gom/shared/themes/style/app_text_styles.dart';

class HomeScreenCollector extends StatefulWidget {
  @override
  State<HomeScreenCollector> createState() => _HomeScreenCollectorState();
}

class _HomeScreenCollectorState extends State<HomeScreenCollector> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsConstants.kBackgroundColor,
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  color: ColorsConstants.kBGCardColor,
                  child: _userName(),
                ),
                SizedBox(
                  height: 8.h,
                ),
                // DANH SACH YÊU CẦU
                Padding(
                  padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                  child: Column(
                    children: [
                      Container(
                        height: 300.h,
                        child: DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              Container(
                                height: 50.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsConstants.kBGCardColor,
                                ),
                                child: TabBar(
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BoxDecoration(
                                    color: ColorsConstants.kActiveColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  labelColor: ColorsConstants.kBGCardColor,
                                  dividerColor: ColorsConstants.kActiveColor,
                                  tabs: [
                                    Tab(
                                      child: Container(
                                        width: 250.w,
                                        child: Text(
                                          "Yêu Cầu (3)",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Container(
                                        width: 250.w,
                                        child: Text(
                                          "Đã Xử Lý (1)",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TabBarView(children: [
                                  listRequest(),
                                  listComfirmed(),
                                ]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _userName() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 12.sp),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
          ),
          GestureDetector(
            onTap: () {
              print("CLICK SANG PAGE PROFILE NÈ!!!!");
            },
            child: Image.asset(
              'assets/images/user-avatar.png',
              height: 40.h,
              width: 40.w,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            "URENCO 15:".tr + "Nhân viên 1",
            style: AppTextStyles.headline1,
          )
        ],
      ),
    );
  }
}

class listRequest extends StatelessWidget {
  const listRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsConstants.kBGCardColor,
      child: Center(
          child: Text(
        "Danh sách yêu cầu",
        style: TextStyle(fontSize: 20),
      )),
    );
  }
}

class listComfirmed extends StatelessWidget {
  const listComfirmed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsConstants.kBGCardColor,
      child: Center(
          child: Text(
        "Danh sách Lịch sử",
        style: TextStyle(fontSize: 20),
      )),
    );
  }
}
