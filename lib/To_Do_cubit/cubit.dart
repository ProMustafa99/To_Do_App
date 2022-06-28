import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqllit/To_Do_cubit/state.dart';
import 'package:sqllit/gloabel_var.dart';
import 'package:sqllit/modules/Done_task.dart';
import 'package:sqllit/modules/archive.dart';
import 'package:sqllit/modules/new_task.dart';

class AppCubit extends Cubit<AppState>
{

   AppCubit() :super(AppInitiolState());

   static AppCubit get(context) =>BlocProvider.of(context);

   var selected_page = 0;


   var database ;


   List<Widget> screen =
   [
      New_task(),
      Done_task(),
      archive_task()
   ];


   List<String> title_AppBar =
   [
      'New Task' ,
      'Done Task' ,
      'Archive Task'
   ];

   void Chang_screen(int index)
   {
      selected_page = index;
      emit(AppChangeBottomNavbBarState());
   }

   void getData_from_database(database)

   {
     tasks_new =[];tasks_Done =[];tasks_archeve=[];
     emit(AppGet_DATA_Loading_FROM_Data_baseState());
      database.rawQuery('SELECT * FROM tasks').then((value)
      {
       
        value.forEach((element) 
        {
            print(element['status']);

            if(element['status'] == 'incomplete')
              {tasks_new.add(element);}

            else if(element['status'] == 'archive')
            {tasks_archeve.add(element);}

            else
              {tasks_Done.add(element);}

        });
        emit(AppGet_DATA_FROM_Data_baseState());
      });
   }

   void create_database() async

   {

      database =  openDatabase(
          'todo.db',
          version: 1,
          onCreate: (database,version)
          {

             database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY , title  TEXT , date TEXT , time TEXT ,status TEXT )')
                 .then((value) {print(" Done create table");})
                 .catchError((e)
             {
                print("Error Creata data base ${e.toString()}");

             });
               emit(AppCreate_Data_baseState());
          },
          onOpen: (database)
          {
             print("data base Done open");
           getData_from_database(database);

          }
      ).then((value)
      {
        database = value;
        emit(AppOpen_Data_baseState());
      });
   }

   void insert_database(String name_task ,String date_Time , String Task_Time ) async

   {

    await database.transaction((txn) async
    {
     await txn.rawInsert(
         'INSERT INTO tasks(title ,date ,time,status) VALUES("${name_task.trim()}" ,"${date_Time.trim()}" ,"${Task_Time.trim()}","incomplete")'
     )
          .then((value)
          {
            print("${value} insert successfully ");
            emit(App_Insert_Data_baseState());

            getData_from_database(database);


          }).catchError((e)
            {
             print("**********");
             print("Error insert ${e.toString()}");
             print("**********");

            });


    }).then((value) => null).catchError((e){});
  }

  void update(String status , int id )async
  {

     await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['${status}', id, ]).then((value)
     {

       emit(AppUpdatae_Data_baseState());
       getData_from_database(database);
     });


  }

  void DeletData(int id) async{
     database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
         .then((value)
           {
             emit(AppDelete_Data_baseState());
             getData_from_database(database);
           });
  }

}