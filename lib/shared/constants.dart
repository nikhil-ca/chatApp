import 'package:flutter/material.dart';


const textInputDecoration = InputDecoration(
    hintText: '',
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.deepPurple,
            width: 1.0
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.deepPurple,
            width:1.0
        )
    )
);

const inputTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
);

const outputTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.bold
);

final buttonStyle = BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xFFD1C4E9),
Color(0xFF7E57C2)
]
),
borderRadius: BorderRadius.circular(40)
);



class AppBarMain extends StatelessWidget implements PreferredSizeWidget{
  const AppBarMain({Key? key}) : super(key: key);
  @override
  Size get preferredSize =>const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
      return AppBar(
          backgroundColor: Colors.amber[600],
          title: const Text('Hola',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),),
      );
  }
}
