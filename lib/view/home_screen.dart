import 'dart:math';

import 'package:facemash_clone/models/profile.dart';
import 'package:facemash_clone/util/constant.dart';
import 'package:facemash_clone/viewmodels/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomeActivity extends StatefulWidget {
  static const String id = 'home_activity';
  const HomeActivity({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> {
  int idxA = 0;
  int idxB = 1;
  int K = 32;

  @override
  Widget build(BuildContext context) {
    final double sWidth = MediaQuery.of(context).size.width;

    HomeViewModel homeViewModel = context.watch<HomeViewModel>();

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: ListView(shrinkWrap: true, children: [
          const SizedBox(height: 25),
          const Text('Programming language ranking system',
              style: TextStyle(
                  color: colorBlack,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center),
          const SizedBox(height: 15),
          const Text('Which do you prefer? Click to choose.',
              style: TextStyle(
                  color: colorBlack,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center),
          const SizedBox(height: 35),
          _loadProfiles(homeViewModel, sWidth),
          const SizedBox(height: 15),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Rankings',
                  style: TextStyle(
                      color: colorBlack,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left),
            ),
          ),
          const SizedBox(height: 7),
          _loadRatings(homeViewModel),
          const SizedBox(height: 35)
        ])));
  }

  _loadProfiles(HomeViewModel homeViewModel, double sWidth) {
    if (homeViewModel.loading) {
      return const CircularProgressIndicator();
    }

    if (homeViewModel.profileError != null) {
      return Container();
    }

    return homeViewModel.profileListModel.isNotEmpty
        ? Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                GestureDetector(
                  onTap: () async {
                    if (idxA < homeViewModel.profileListModel.length - 1) {
                      //initialize variables
                      var rA = homeViewModel.profileListModel[idxA].rUser;
                      var rB = homeViewModel.profileListModel[idxB].rUser;

                      //calculate Ea,Eb and Ra,Rb
                      var eA = 1 / (1 + pow(10, (rB - rA) / 400));
                      var eB = 1 / (1 + pow(10, (rA - rB) / 400));

                      var rAa = rA + K * (1 - eA);
                      var rBb = rA + K * (0 - eB);

                      //update values in DB
                      await homeViewModel.updateProfileRating(
                          homeViewModel.profileListModel[idxA].id,
                          idxA,
                          rAa.round(),
                          homeViewModel.profileListModel[idxB].id,
                          idxB,
                          rBb.round());

                      //update the pointers
                      adjustIndexB(homeViewModel.profileListModel);
                    } else {
                      //reset index values back to init
                      resetIndex();
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.only(left: 10, right: 5),
                      height: (sWidth / 2) + 10,
                      width: (sWidth / 2) - 30,
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (idxA <=
                                homeViewModel.profileListModel.length - 1)
                            ? Image.network(
                                homeViewModel.profileListModel[idxA].imageUrl,
                                fit: BoxFit.contain)
                            : Container(),
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text('or',
                      style: TextStyle(
                          color: colorBlack,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center),
                ),
                GestureDetector(
                  onTap: () async {
                    if (idxA < homeViewModel.profileListModel.length - 1) {
                      //initialize variables
                      var rA = homeViewModel.profileListModel[idxA].rUser;
                      var rB = homeViewModel.profileListModel[idxB].rUser;

                      //calculate Ea,Eb and Ra,Rb
                      var eA = 1 / (1 + pow(10, (rB - rA) / 400));
                      var eB = 1 / (1 + pow(10, (rA - rB) / 400));

                      var rAa = rA + K * (0 - eA);
                      var rBb = rA + K * (1 - eB);

                      //update values in DB
                      await homeViewModel.updateProfileRating(
                          homeViewModel.profileListModel[idxA].id,
                          idxA,
                          rAa.round(),
                          homeViewModel.profileListModel[idxB].id,
                          idxB,
                          rBb.round());

                      //update the pointers
                      adjustIndexA(homeViewModel.profileListModel);
                    } else {
                      //reset index values back to init
                      resetIndex();
                    }
                  },
                  child: Container(
                      margin: const EdgeInsets.only(left: 5, right: 10),
                      height: (sWidth / 2) + 10,
                      width: (sWidth / 2) - 30,
                      decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 1),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (idxB <=
                                homeViewModel.profileListModel.length - 1)
                            ? Image.network(
                                homeViewModel.profileListModel[idxB].imageUrl,
                                fit: BoxFit.contain)
                            : Container(),
                      )),
                )
              ])
        : Container();
  }

  _loadRatings(HomeViewModel homeViewModel) {
    if (homeViewModel.loading) {
      return Container();
    }

    if (homeViewModel.profileError != null) {
      return Container();
    }

    List<Profile> profileList = homeViewModel.profileListModel;
    profileList.sort((a, b) => b.rUser.compareTo(a.rUser));

    return profileList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: profileList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                        topLeft: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 1),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Image.network(profileList[index].imageUrl,
                            width: 40, height: 40),
                        const SizedBox(width: 10),
                        Text('Rating: ${profileList[index].rUser}',
                            style: const TextStyle(
                                color: colorBlack,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left)
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Container();
  }

  void adjustIndexA(List<Profile> profileList) {
    setState(() {
      if (idxA + 1 == idxB) {
        if (idxA + 2 <= profileList.length - 1) {
          idxA += 2;
        } else {
          resetIndex();
        }
      } else {
        idxA++;
      }
    });
  }

  void adjustIndexB(List<Profile> profileList) {
    setState(() {
      if (idxB + 1 == idxA) {
        if (idxB + 2 <= profileList.length - 1) {
          idxB += 2;
        }
      } else {
        idxB++;
      }
    });
  }

  void resetIndex() {
    setState(() {
      idxA = 0;
      idxB = 1;
    });
  }
}
