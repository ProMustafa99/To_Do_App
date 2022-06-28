
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqllit/To_Do_cubit/cubit.dart';
import 'package:sqllit/To_Do_cubit/state.dart';
import 'package:sqllit/gloabel_var.dart';
import 'package:sqllit/modules/Done_task.dart';
import 'package:sqllit/modules/archive.dart';
import 'package:sqllit/modules/new_task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';


class Home_layout extends StatefulWidget {

  @override
  _Home_layoutState createState() => _Home_layoutState();
}

class _Home_layoutState extends State<Home_layout>
{


   var database ;

  bool isBottomSheetShown = false;

  var NameTask = TextEditingController();

  var Date_task = TextEditingController();

  var Task_time = TextEditingController();


  var scaffoldKey = GlobalKey<ScaffoldState>();

  var _forKey = GlobalKey<FormState>();


  Widget Name_task()
  {
    return Padding(
      padding:EdgeInsets.all(10) ,
      child: TextFormField(

        controller: NameTask,
        decoration: InputDecoration(
          prefixIcon:Icon(Icons.menu),
          border: OutlineInputBorder(),
          hintText: 'Enater Name Task ',
        ),
        validator: (value)
        {
          if (value == null || value.isEmpty) {
            return 'Please Enter Name Task';
          }
        },
      ),
    );

  }

  Widget Task_Date()
  {
    return Padding(
      padding:EdgeInsets.all(10) ,

      child: TextFormField(

        onTap: ()
        {
          showDatePicker
            (
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.parse('2023-01-01')
           ).then((value)
            {Date_task.text =DateFormat.yMMMd().format(value as DateTime);});
        },
        controller: Date_task,
        decoration: InputDecoration(
          prefixIcon:Icon(Icons.date_range_outlined),
          border: OutlineInputBorder(),
          hintText: 'Enater Task Date',
        ),
        validator: (value)
        {
          if (value == null || value.isEmpty)
          {
            return 'Please Enter Task Date';
          }
        },
      ),
    );

  }

  Widget Task_Time()
  {
    return Padding(
      padding:EdgeInsets.all(10) ,

      child: TextFormField(

       onTap: ()
       {
         showTimePicker
           (
             context: context,
             initialTime:TimeOfDay.now(),
           ).then((value) {
             print(value!.format(context));
             Task_time.text = value.format(context);
         });
       },
        controller: Task_time,
        decoration: InputDecoration(
          prefixIcon:Icon(Icons.watch_later_outlined),
          border: OutlineInputBorder(),
          hintText: 'Enater Task  Time',
        ),
        validator: (value)
        {
          if (value == null || value.isEmpty)
        {
            return 'Please Enter Task Time';
          }
        },
      ),
    );

  }


  @override
  Widget build(BuildContext context)
  {

    return BlocProvider(
      create: (context)=>AppCubit()..create_database(),
      
      child: BlocConsumer<AppCubit , AppState>(
        listener: (context , state){
          if(state is AppGet_DATA_FROM_Data_baseState)
            {
              print("DONR CREATE DATA BASE WITH CUBIT");
            }
        },
        builder: (context , state)
        {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: Text('${AppCubit.get(context).title_AppBar[AppCubit.get(context).selected_page]}'),),
            body: ConditionalBuilder(
              condition: state is !AppGet_DATA_Loading_FROM_Data_baseState,
              builder: (context)=>AppCubit.get(context).screen[AppCubit.get(context).selected_page],
              fallback: (context)=>Center(child: Text("No data found at the moment")),

            ),
            floatingActionButton: FloatingActionButton(
              onPressed: ()
              {
                if(isBottomSheetShown)
                {
                  Navigator.pop(context);
                  setState(() {isBottomSheetShown=false;});
                }
                else
                {
                  scaffoldKey.currentState!.showBottomSheet((context)
                  {
                    return Form
                      (
                        key: _forKey,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Container
                            (
                            width: double.infinity,
                            color: Colors.white70,
                            height: 380,
                            child: Column(
                              children:
                              [
                                Name_task(),
                                Task_Date(),
                                Task_Time(),
                                RaisedButton
                                  (
                                     onPressed: ()
                                     {
                                       AppCubit.get(context).insert_database(NameTask.text.trim(), Date_task.text.trim(),Task_time.text.trim());
                                     },
                                     child: Center(child:Text("Add Task" , style: TextStyle(color: Colors.white ),),),
                                    color: Colors.blue,

                                    )

                              ],
                            ),
                          ),
                        )
                    );
                  });
                  setState(() {isBottomSheetShown=true;});
                }


              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),

            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.blue,
              selectedFontSize: 15,
              unselectedFontSize: 10,
              unselectedItemColor: Colors.grey,
              currentIndex: AppCubit.get(context).selected_page,
              onTap:(index)
              {
                AppCubit.get(context).Chang_screen(index);
               },
              items:
              [
                BottomNavigationBarItem(icon: Icon(Icons.menu) , label: " New Task"),
                BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: " Done"),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),
          );
        },
      ),
    );
  }
}




