import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqllit/Contents/Contents.dart';
import 'package:sqllit/To_Do_cubit/state.dart';
import 'package:sqllit/gloabel_var.dart';

import '../To_Do_cubit/cubit.dart';

class Done_task extends StatefulWidget {
  @override
  _Done_taskState createState() => _Done_taskState();
}

class _Done_taskState extends State<Done_task> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit , AppState>
      (
      listener: (context , state){},
      builder: (context , state)
      {
        return ConditionalBuilder(
          condition: tasks_Done.length >0,
          builder: (context)
          {return  ListView.separated(
                itemBuilder: (context,index)=>bulidTaskItem(tasks_Done[index],context),
                separatorBuilder: (context , index)=>Container(
                  width: double.infinity,
                  height: 1.0,
                  color: Colors.grey,
                ),
                itemCount: tasks_Done.length
            );},
          fallback:(context)=>Center(child: Text('There is no data at the moment',style: TextStyle(fontSize: 20),),),

        );

      },
    );
  }
}
