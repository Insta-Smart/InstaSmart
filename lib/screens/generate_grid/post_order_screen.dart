import 'package:flutter/material.dart';
import 'package:instasmart/screens/frames_screen/frames_screen.dart';
import 'package:instasmart/utils/size_config.dart';
import './components/order_element.dart';

class PostOrderScreen extends StatelessWidget {
  PostOrderScreen(this.filePaths);
  final List<String> filePaths;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(
                'Post your images to instagram in the following order by tapping on the number!',
                style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Open Sans',
                    fontSize: 30),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical*5,),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(
                  filePaths.length,
                  (index) => OrderElement(
                    filePaths: filePaths,
                    index: index,
                  ),
                ),
              ),
            ),
            RaisedButton(child: Text('Done'), onPressed: (){
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FramesScreen()));

            },)
          ],
        ),
      ),
    );
  }
}

