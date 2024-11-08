// import 'package:datingapp/Usermanegement/newpw.dart';
// import 'package:flutter/material.dart';

// class otppage extends StatefulWidget {
//   const otppage({super.key});

//   @override
//   State<otppage> createState() => _otppageState();
// }

// class _otppageState extends State<otppage> {

//   final first=TextEditingController();
//     final second=TextEditingController();
//   final third=TextEditingController();
//   final fourth=TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final height=MediaQuery.of(context).size.height;
//     final width=MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: Container(
                
//                 decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.white,
//           border: Border.all(color: Colors.black,width: 1)
//                 ),
//                 child: IconButton(onPressed:() {
          
//                 }, icon: Icon(Icons.arrow_back,color: Colors.red,size: height/30,)),
//           ),
//         ),
//       backgroundColor: Colors.white,
//       ),
//       body: Container(
//         height: height,
//         width: width,
//         color: Colors.white,
//         child: SingleChildScrollView(
//       child: Padding(
//         padding:  EdgeInsets.only(top: height/20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//                  Text("Verification Code",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: height/30),),
//                  SizedBox(height: height/50,),
//                 Text("Please enter the code we just sent to email example@gmail.com",style: TextStyle(color: Colors.grey,fontSize: height/45,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),

// SizedBox(height: height/8,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [

// buildboxfield(height, width, first),
// buildboxfield(height, width, second),
// buildboxfield(height, width, third),
// buildboxfield(height, width, fourth)

//                   ],
//                 ),
// SizedBox(height: height/30,),
//                 Text("Didn’t received email?",style: TextStyle(color: const Color.fromARGB(255, 88, 88, 88),fontSize: height/50),),
//                 Text("Resend Code",style: TextStyle(color: Colors.black,fontSize: height/50,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),),

//                 SizedBox(height: height/15,),

//                 Padding(
//                   padding:  EdgeInsets.only(left: width/40,right: width/40),
//                   child: ElevatedButton(
                    
//                     style: ElevatedButton.styleFrom(
//                       fixedSize: Size(width, height/13),
//                       backgroundColor: const Color.fromARGB(255, 125, 5, 245),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
//                     ),
                    
                    
//                     onPressed:() {
//                         Navigator.of(context).push(MaterialPageRoute(builder:(context) {
//       return Newpw();
//     },));
//                   }, child: Text("Verify",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: height/35),)),
//                 )

//           ],
//         ),
//       ),
//         ),
//       ),
      
      
//       ),
//     );
//   }

//   Widget buildboxfield(double height,double width,TextEditingController controller,){

// return                     Container(
//                       height: height/13,
//                       width: width/7,
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
                                                      
//                             keyboardType: TextInputType.number,
//                             style: TextStyle(color: Colors.black,fontSize: height/40,),
//                             textAlign: TextAlign.center,
//                             decoration: InputDecoration(
//                               enabledBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black,width: 2)
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black,width: 2)
                          
//                               )
//                             ),
//                           ),
//                         ),
//                       ),
//   decoration: BoxDecoration(
//   color: Color.fromARGB(65, 158, 158, 158),
//     borderRadius: BorderRadius.circular(10)
//   ),                    );



//   }
// }