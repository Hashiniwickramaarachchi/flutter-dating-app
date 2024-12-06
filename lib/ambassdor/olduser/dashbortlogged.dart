import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingapp/accountdelectionpage.dart';
import 'package:datingapp/ambassdor/bottombar.dart';
import 'package:datingapp/block.dart';
import 'package:datingapp/deactivepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedPeriod = 'Monthly';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
       final User? curentuser = FirebaseAuth.instance.currentUser;
   if (curentuser == null) {
     // Handle unauthenticated user state (e.g., redirect to login page or s
     return Center(child: Text('No user is logged in.'));
   }
   return StreamBuilder<DocumentSnapshot>(
       stream: FirebaseFirestore.instance
           .collection("Ambassdor")
           .doc(curentuser.email)
           .snapshots(),
       builder: (context, snapshot) {
         if (snapshot.hasData) {
           final userdataperson =
               snapshot.data!.data() as Map<String, dynamic>?;
           if (userdataperson?['statusType'] == 'deactive') {
             WidgetsBinding.instance.addPostFrameCallback((_) async {
               if (mounted) {
                 await FirebaseAuth.instance.signOut();
                 Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context) => deactivepage()),
                   (Route<dynamic> route) => false,
                 );
               }
             });
           }
           if (userdataperson?['statusType'] == 'block') {
             WidgetsBinding.instance.addPostFrameCallback((_) async {
               if (mounted) {
                 await FirebaseAuth.instance.signOut();
                 Navigator.of(context).pushAndRemoveUntil(
                   MaterialPageRoute(builder: (context) => block()),
                   (Route<dynamic> route) => false,
                 );
               }
             });
           }
           if (userdataperson?['statusType'] == 'delete') {
             WidgetsBinding.instance.addPostFrameCallback((_) async {
               if (mounted) {
                 Navigator.of(context).pushReplacement(MaterialPageRoute(
                   builder: (context) {
                     return DeleteAccountPage(
                       initiateDelete: true,
                       who: 'Ambassdor',
                     );
                   },
                 ));
               }
             });
           }
           if (userdataperson == null) {
             return Center(
               child: Text("User data not found."),
             );
           }      
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: screenHeight / 400,
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            automaticallyImplyLeading: false,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            surfaceTintColor: const Color.fromARGB(255, 255, 255, 255),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          body: Padding(
            padding: EdgeInsets.only(
              right: screenWidth / 20,
              left: screenWidth / 20,
            ),
            child: Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("Ambassdor")
                        .doc(curentuser.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userdataperson =
                            snapshot.data!.data() as Map<String, dynamic>;
                        int addcount = userdataperson['addedusers'].length;
                        int addmatch = userdataperson['match_count'];
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.02),
                              _buildProgressSection(
                                  screenWidth, addcount, addmatch),
                              SizedBox(height: screenHeight * 0.04),
                              _buildSummarySection(screenWidth, addcount, addmatch),
                              SizedBox(height: screenHeight * 0.04),
                            ],
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                // Positioned(
                //
                //  left: 0,
                //  right: 0,
                //  bottom: screenHeight / 60,
                // child: A_BottomNavBar(
                // selectedIndex2: 1,
                // check: 'already',
                // ),
                // ),
              ],
            ),
          ),
        );
                  } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
      }
    );
  }

  Widget _buildProgressSection(double screenWidth, int addcount, int addmatch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Performance Overview',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        _buildProgressCard("Add New Couples", addcount, Colors.purple.shade50),
        _buildProgressCard("Matching Couples", addmatch, Colors.green.shade50),
      ],
    );
  }

  Widget _buildProgressCard(String title, int progress, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text('$progress'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(double screenWidth, int addcount, int addmatch) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Summary Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedPeriod,
              items: <String>['Monthly', 'Weekly', 'Daily'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedPeriod = newValue!;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 25),
        Padding(
          padding: EdgeInsets.only(left: 12, bottom: 30),
          child: Row(
            children: [
              _buildLegendItem(Color(0xff7905F5), "This Year"),
              SizedBox(width: 20),
              _buildLegendItem(Colors.red, "Last Year"),
            ],
          ),
        ),
        _buildBarChart(addcount, addmatch),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            border: Border.all(width: 4, color: color),
          ),
        ),
        SizedBox(width: 10),
        Text(label),
      ],
    );
  }

  Widget _buildBarChart(int addcount, int addmatch) {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          barGroups: _getBarGroups(addcount, addmatch),
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return _getBottomTitle(value.toInt());
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barTouchData: BarTouchData(enabled: false),
        ),
      ),
    );
  }

  Widget _getBottomTitle(int index) {
    if (selectedPeriod == 'Daily') {
      // Display days (e.g., Day 1, Day 2, etc.)
      return Text('Day ${index + 1}');
    } else if (selectedPeriod == 'Weekly') {
      // Display weeks (e.g., Week 1, Week 2, etc.)
      return Text('Week ${index + 1}');
    } else if (selectedPeriod == 'Monthly') {
      // Display months (e.g., Jan, Feb, etc.)
      const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul"];
      return Text(months[index % months.length]);
    } else {
      return Text(''); // Default empty text if no period is selected
    }
  }

  List<BarChartGroupData> _getBarGroups(int addcount, int addmatch) {
    if (addcount == 0 && addmatch == 0) {
      return [];
    }

    List<BarChartGroupData> barGroups = [];
    final data = _getDataByPeriod(addcount, addmatch);

    for (int i = 0; i < data.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data[i]['thisPeriod']!.toDouble(),
              color: Color(0xff7905F5),
              width: 8,
            ),
            BarChartRodData(
              toY: data[i]['lastPeriod']!.toDouble(),
              color: Colors.red,
              width: 8,
            ),
          ],
          showingTooltipIndicators: [],
        ),
      );
    }
    return barGroups;
  }

  List<Map<String, int>> _getDataByPeriod(int addcount, int addmatch) {
    switch (selectedPeriod) {
      case 'Weekly':
        return [
          {'thisPeriod': addcount, 'lastPeriod': addmatch},
          {'thisPeriod': addcount + 2, 'lastPeriod': addmatch - 1},
          // Add weekly data points as required
        ];
      case 'Daily':
        return [
          {'thisPeriod': addcount, 'lastPeriod': addmatch},
          {'thisPeriod': addcount + 1, 'lastPeriod': addmatch - 1},
          // Add daily data points as required
        ];
      case 'Monthly':
      default:
        return [
          {'thisPeriod': addcount, 'lastPeriod': addmatch},
          {'thisPeriod': addcount + 2, 'lastPeriod': addmatch - 1},
          {'thisPeriod': addcount - 1, 'lastPeriod': addmatch + 3},
          // Add monthly data points as required
        ];
    }
  }
}
