// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PhoneAuthScreen extends StatefulWidget {
//   const PhoneAuthScreen({super.key});

//   @override
//   State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
// }

// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   final _phoneController = TextEditingController();
//   final _codeController = TextEditingController();
//   bool _codeSent = false;
//   String? _verificationId;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _codeController.dispose();
//     super.dispose();
//   }

//   void _sendCode() async {
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: '+82${_phoneController.text.replaceAll('-', '')}',
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await _auth.signInWithCredential(credential);
//           if (mounted) {
//             Navigator.pushReplacementNamed(context, '/chat');
//           }
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('인증 실패: ${e.message}')),
//           );
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           setState(() {
//             _verificationId = verificationId;
//             _codeSent = true;
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('인증번호를 전송했습니다.')),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId;
//         },
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('오류가 발생했습니다: $e')),
//       );
//     }
//   }

//   void _verifyCode() async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: _codeController.text,
//       );

//       await _auth.signInWithCredential(credential);
//       if (mounted) {
//         Navigator.pushReplacementNamed(context, '/chat');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('인증번호가 올바르지 않습니다.')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('전화번호 인증'),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: _phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: const InputDecoration(
//                 labelText: '전화번호 입력',
//                 hintText: '010-1234-5678',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             if (_codeSent)
//               TextField(
//                 controller: _codeController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: '인증번호 입력',
//                   hintText: '6자리 숫자',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _codeSent ? _verifyCode : _sendCode,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//               ),
//               child: Text(_codeSent ? '인증번호 확인' : '인증번호 요청'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
