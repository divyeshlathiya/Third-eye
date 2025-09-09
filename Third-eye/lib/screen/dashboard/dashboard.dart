// import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// import 'package:thirdeye/Menu/menu.dart';
// import 'package:thirdeye/screen/play_quiz_screen.dart';
// import 'package:thirdeye/utils/storage_helper.dart';
// // import 'package:thirdeye/screen/about_yourself.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   String? firstName;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadFirstName();
//   }

//   Future<void> _loadFirstName() async {
//     setState(() => isLoading = true);
//     final name = await StorageHelper.getToken('first_name');
//     await Future.delayed(
//         const Duration(milliseconds: 500)); // simulate load delay
//     setState(() {
//       firstName = name ?? "User";
//       isLoading = false;
//     });
//   }

//   String _getGreeting() {
//     final hour = DateTime.now().hour;
//     if (hour < 12) return "Good morning";
//     if (hour < 17) return "Good afternoon";
//     return "Good evening";
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Builder(
//           builder: (context) {
//             double width = MediaQuery.of(context).size.width;
//             return Text(
//               "Dashboard",
//               style: TextStyle(
//                 fontSize: width * 0.045, // responsive scaling
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           },
//         ),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         automaticallyImplyLeading: false,
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadFirstName,
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Padding(
//             padding: EdgeInsets.all(width * 0.04),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     // Profile Image
//                     Container(
//                       width: width * 0.12, // responsive
//                       height: width * 0.12,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white,
//                       ),
//                       child: ClipOval(
//                         // child: Image.asset(
//                         //   'icons/profile.png',
//                         //   fit: BoxFit.cover,
//                         // ),
//                         child: Icon(Icons.person, size: width * 0.07),
//                       ),
//                     ),

//                     SizedBox(width: width * 0.03),

//                     // Greeting and Name
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _getGreeting(),
//                           style: TextStyle(
//                             fontSize: width * 0.03,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         Text(
//                           firstName ?? "Loading",
//                           style: TextStyle(
//                             fontSize: width * 0.04,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const Spacer(),

//                     // Menu Icon
//                     IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const MenuDrawer(),
//                             ));
//                       },
//                       icon: Icon(
//                         Icons.menu,
//                         size: width * 0.07,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: height * 0.02),
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: const BoxDecoration(
//                       color: Color(0xFF4B1FA1), // Deep purple shade
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(32),
//                         topRight: Radius.circular(32),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(width * 0.05),
//                       child: Column(
//                         children: [
//                           SizedBox(height: height * 0.02),
//                           Builder(
//                             builder: (context) {
//                               double width = MediaQuery.of(context).size.width;
//                               return Text(
//                                 "Start Your 21-Days journey to\nBoost mental clarity & Emotional wellness.",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: width * 0.045, // responsive font size
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               );
//                             },
//                           ),
//                           SizedBox(height: height * 0.015),
//                           GestureDetector(
//                             onTap: () {
//                               // Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //       builder: (context) => DashboardScreen(),
//                               //     ));
//                             },
//                             child: Image.asset(
//                               'assets/agna.png',
//                               width: width * 0.65,
//                               height: height * 0.3,
//                             ),
//                           ),
//                           const Spacer(),

//                           Container(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     padding: EdgeInsets.symmetric(
//                                         vertical: height * 0.018),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(24),
//                                     )),
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => WellnessScreen(),
//                                       ));
//                                 },
//                                 child: Text(
//                                   "Start Quiz",
//                                   style: TextStyle(
//                                     color: const Color(0xFF4B1FA1),
//                                     fontSize: width * 0.045,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 )),
//                           ),
//                           SizedBox(height: height * 0.025),
//                           // Updated Score and Past Score section with icons
//                           SizedBox(height: height * 0.025),

//                           // Score & Past Score Section
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               Expanded(
//                                 child: _buildScoreCard(
//                                   context,
//                                   title: "Score",
//                                   value: "36",
//                                   icon: Icons.emoji_events,
//                                 ),
//                               ),
//                               Expanded(
//                                 child: _buildScoreCard(
//                                   context,
//                                   title: "View Past Score",
//                                   value: "109",
//                                   icon: Icons.history,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildScoreCard(BuildContext context,
//       {required String title, required String value, required IconData icon}) {
//     final width = MediaQuery.of(context).size.width;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       padding: EdgeInsets.all(width * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontSize: width * 0.08,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF4B1FA1),
//                 ),
//               ),
//               SizedBox(width: width * 0.02),
//               Icon(icon, color: const Color(0xFF4B1FA1), size: width * 0.09),
//             ],
//           ),
//           SizedBox(height: 8),
//           FittedBox(
//             // ✅ ensures text resizes and stays in one line
//             child: Text(
//               title,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: width * 0.045,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF4B1FA1).withOpacity(0.7),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:thirdeye/Menu/menu.dart';
import 'package:thirdeye/screen/play_quiz_screen.dart';
import 'package:thirdeye/utils/storage_helper.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? firstName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFirstName();
  }

  Future<void> _loadFirstName() async {
    setState(() => isLoading = true);
    final name = await StorageHelper.getToken('first_name');
    await Future.delayed(const Duration(milliseconds: 500)); // simulate load
    setState(() {
      firstName = name;
      isLoading = false;
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good morning";
    if (hour < 17) return "Good afternoon";
    return "Good evening";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: width * 0.045,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _loadFirstName,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(width * 0.04),
            child: Column(
              children: [
                Row(
                  children: [
                    // Profile Image
                    Container(
                      width: width * 0.12,
                      height: width * 0.12,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: Icon(Icons.person, size: width * 0.07),
                      ),
                    ),
                    SizedBox(width: width * 0.03),

                    // Greeting and Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: TextStyle(
                            fontSize: width * 0.03,
                            color: Colors.grey,
                          ),
                        ),
                        isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                firstName ?? "User",
                                style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MenuDrawer(),
                          ),
                        );
                      },
                      icon: Icon(Icons.menu, size: width * 0.07),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),

                // Main Purple Container
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4B1FA1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.05),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.02),
                        Text(
                          "Start Your 21-Days journey to\nBoost mental clarity & Emotional wellness.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.045,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.015),
                        Image.asset(
                          'assets/agna.png',
                          width: width * 0.65,
                          height: height * 0.3,
                        ),
                        SizedBox(height: height * 0.03),

                        // Start Quiz Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.018,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WellnessScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Start Quiz",
                              style: TextStyle(
                                color: const Color(0xFF4B1FA1),
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.025),

                        // Score & Past Score
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _buildScoreCard(
                                context,
                                title: "Score",
                                value: "36",
                                icon: Icons.emoji_events,
                              ),
                            ),
                            Expanded(
                              child: _buildScoreCard(
                                context,
                                title: "View Past Score",
                                value: "109",
                                icon: Icons.history,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context,
      {required String title, required String value, required IconData icon}) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: width * 0.08,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4B1FA1),
                ),
              ),
              SizedBox(width: width * 0.02),
              Icon(icon, color: const Color(0xFF4B1FA1), size: width * 0.09),
            ],
          ),
          SizedBox(height: 8),
          FittedBox(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF4B1FA1).withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
