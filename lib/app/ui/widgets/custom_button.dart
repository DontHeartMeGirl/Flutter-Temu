// import 'package:flutter/material.dart';

// class CategoryButton extends StatelessWidget {
//   final String label; // 按钮上的文字
//   final bool isSelected; // 当前按钮是否被选中
//   final VoidCallback onTap; // 按钮点击时的回调函数

//   const CategoryButton({
//     Key? key,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // 按钮文字
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                 color: isSelected ? Colors.black : Colors.grey,
//               ),
//             ),
//             // 选中时的下划线
//             if (isSelected)
//               Container(
//                 margin: const EdgeInsets.only(top: 4),
//                 height: 2,
//                 width: 20,
//                 color: Colors.black,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
