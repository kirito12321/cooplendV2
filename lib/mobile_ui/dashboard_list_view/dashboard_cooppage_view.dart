import 'package:ascoop/services/database/data_coop.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/coop_profile_page.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class DashboardCoop extends StatefulWidget {
  const DashboardCoop({super.key});

  @override
  State<DashboardCoop> createState() => _DashboardCoopState();
}

class _DashboardCoopState extends State<DashboardCoop> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
                child: StreamBuilder<List<CoopInfo>>(
              stream: DataService.database().readCoopsData(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final coops = snapshot.data!;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: coops.length,
                      itemBuilder: (context, index) => buildCoop(coops[index]));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )),
          ),
        ),
      ],
    );
  }

  Widget buildCoop(CoopInfo coopInfo) => Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: grey4,
                      spreadRadius: 0.2,
                      blurStyle: BlurStyle.normal,
                      blurRadius: 1.6),
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ListTile(
              leading: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: coopInfo.profilePic,
                  width: 60.0,
                  height: 60.0,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              title: Text(
                coopInfo.coopName,
                style: h4,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  coopInfo.coopAddress,
                  style: TextStyle(
                    fontFamily: FontNamedDef,
                    fontSize: 11,
                    color: grey4,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CoopProfile(coopID: coopInfo.coopID)));
              },
            ),
          ),
        ],
      );
}
