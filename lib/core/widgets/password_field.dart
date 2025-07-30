import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({super.key});

  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}

class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 339,
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          hintText: "Password",
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(_obscureText ? 0 : 3.1416),// lật dọc nếu hiện mật khẩu
              child: SvgPicture.asset(
                'assets/icons/Vector.svg',
                width: 12,
                height: 12,
                colorFilter: const ColorFilter.mode(
                  Color(0xFF9D7539),
                  BlendMode.srcIn,
                ),
              ),
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
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
//             SizedBox(height: 16),
//             CustomPasswordField(
//               hintText: 'Mật khẩu',
//             ),
//           ],
//         ),
//       ),
//     );
