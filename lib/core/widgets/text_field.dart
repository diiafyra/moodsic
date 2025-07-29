import 'package:flutter/material.dart';

class CustomFigmaTextField extends StatelessWidget {
  final String hintText; // Placeholder khi chưa nhập gì
  final TextEditingController? controller; //  set giá trị cho TextField
  final TextInputType keyboardType; //  loại bàn phím cần mở ra (text, email, number,...)
  
  const CustomFigmaTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 339, 
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF4F3A1D),
          fontSize: 14,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w400,
        ),
        cursorColor: Color(0xFF4F3A1D),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF4F3A1D),
            fontSize: 14,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// USE
//    return Scaffold(
//       appBar: AppBar(title: const Text('')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             CustomFigmaTextField(
//               hintText: 'Username',
//             ),
//             SizedBox(height: 16),
//             CustomFigmaTextField(
//               hintText: 'Email',
//               keyboardType: TextInputType.emailAddress,
//             ),
//             SizedBox(height: 16),
//             CustomFigmaTextField(
//               hintText: 'Số lượng',
//               keyboardType: TextInputType.number,
//             ),
//           ],
//         ),
//       ),
//     );