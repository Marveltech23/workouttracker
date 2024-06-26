import 'package:flutter/material.dart';
import 'package:workout_tracker/data/hive_database.dart';
import 'package:workout_tracker/date_time/date_time.dart';
import 'package:workout_tracker/models/exercises.dart';
import 'package:workout_tracker/models/workout.dart';

class WorkOutData extends ChangeNotifier {
  final db = HiveDatabase();

  /*
  wORKOUT DATA STRUCTURE 
  
  - This overall list contains the difference workouts 
  - Each workout has a name,and List of exercise 

  _*/

  List<Workout> workoutList = [
    //default workout
    Workout(name: 'Upper Body', exercises: [
      Exercise(name: 'Bicep Curls', weight: '10', reps: '10', sets: '3')
    ]),

    Workout(name: 'Lower Body ', exercises: [
      Exercise(name: 'S Curls', weight: '10', reps: '10', sets: '3')
    ])
  ];
  //if  there are Workout already in database, then get that workout list, otherwise  use default
  // void initialization() {
  //   // Check if previous data exists in the database
  //   if (db.previousDataExists()) {
  //     // If data exists, read it from the database and assign it to workoutList
  //     workoutList = db.readFromDataBase();
  //   } else {
  //     // If no previous data exists, save the current workoutList to the database
  //     db.saveToDatabase(workoutList);
  //   }

  //   // At this point, workoutList has been either loaded from the database or saved to it.
  //   // You can proceed with further initialization steps, like loading a heatmap.
  //   loadHeatMap();
  // }

  void initialization() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } else {
      db.saveToDatabase(workoutList);
    }
  }

  // void initialization() {
  //   List<Workout>? dataFromDatabase = db.readFromDataBase();

  //   if (dataFromDatabase != null) {
  //     workoutList = dataFromDatabase;
  //   } else {
  //     // Handle the case where data from the database is null
  //     workoutList = [];
  //   }

  //   // You can add additional logic if needed

  //   loadHeatMap();
  // }

// get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout
  int numberofExercisesInWork(String workoutName) {
    Workout relevantWorkOut = getRelevantwork(workoutName);
    return relevantWorkOut.exercises.length;
  }

// add a workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
    db.saveToDatabase(workoutList);
  }

// add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    //find the relevant workout

    Workout relevantWorkout = getRelevantwork(workoutName);

    relevantWorkout.exercises.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));

    notifyListeners();
    db.saveToDatabase(workoutList);
  }

// check off exercise
  void checkoffExercise(String workoutName, String exerciseName) {
    // Find the relevant workout and relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    db.saveToDatabase(workoutList);
    loadHeatMap();
  }

//returs relevant workout object, given a workout name
  Workout getRelevantwork(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

//return relevant exercise object,given a workout name + exercise name

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantwork(workoutName);

    //then find the relevant exercise in that workout

    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }

  // get start date

  String getStartDate() {
    return db.getStartDate();
  }

  Map<DateTime, int> heatMapDataset = {};

  // void loadHeatMap() {
  //   DateTime startDate = CreateDateTimeOblect(getStartDate());

  //   int daysInBetween = DateTime.now().difference(startDate).inDays;

  //   // go from start date to today, and add each completion staus to the dataset
  //   // "COMPLETION_STATUS_yyymmdd"

  //   for (int i = 0; i < daysInBetween + 1; i++) {
  //     String yyyymmdd =
  //         convertDateTimeYYYYMMDD(startDate.add(Duration(days: i)));
  //   }

  //   int completionStatus = db.getCompletionStatus(yyyymmdd);

  //   int year = startDate.add(Duration(days: i)).year;

  //   int month = startDate.add(Duration(days: i)).month;

  //   int day = startDate.add(Duration(days: i)).month;

  //   final percentForEachDay = <DateTime, int>{
  //     DateTime(year, month, day): completionStatus
  //   };

  //   heatMapDataset.addEntries(percentForEachDay.entries);
  // }
  void loadHeatMap() {
    DateTime startDate = CreateDateTimeOblect(getStartDate());
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeYYYYMMDD(startDate.add(Duration(days: i)));

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day =
          startDate.add(Duration(days: i)).day; // Corrected from month to day

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): completionStatus
      };

      heatMapDataset.addEntries(percentForEachDay.entries);
    }
  }
}
