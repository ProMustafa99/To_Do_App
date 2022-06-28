import 'package:flutter/material.dart';
import 'package:sqllit/To_Do_cubit/cubit.dart';


Widget bulidTaskItem(Map data , context)
{
  return Dismissible(
    key: Key('${data['id']}'),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:
        [
          CircleAvatar(
            radius: 40.0,
            child: Text("${data['time']}" ,style: TextStyle(fontSize: 15),),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children:
              [
                Text('${data['title']}',style: TextStyle(fontSize: 20),),
                Text('${data['status']}',style: TextStyle(fontSize: 20),),
                Text('${data['date']}',style: TextStyle(fontSize: 20 ,color: Colors.grey),),
              ],
            ),
          ),
          SizedBox(height: 2,),
          IconButton(
              onPressed: ()
              {
                AppCubit.get(context).update('Done' ,data['id'] );
              },
              icon: Icon(Icons.check_box , color: Colors.green,)),
          IconButton(
              onPressed: (){ AppCubit.get(context).update('archive' ,data['id'] );},
              icon: Icon(Icons.archive_outlined , color: Colors.lightBlue,)),


        ],
      ),
    ),
    onDismissed: (directory)
    {
      AppCubit.get(context).DeletData(data['id']);

    },
  );
}

