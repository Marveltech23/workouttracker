import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/components/heat_map.dart';
import 'package:workout_tracker/data/workout_data.dart';
import 'package:workout_tracker/pages/workoutpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}
//text controller

final newWorkoutNameController = TextEditingController();

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    // Perform one-time initialization tasks here

    Provider.of<WorkOutData>(context, listen: false).initialization();
  }

  void createNewWorkout() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Create new workout'),
            content: TextField(
              controller: newWorkoutNameController,
            ),
            actions: [
              MaterialButton(
                onPressed: save,
                child: Text('save'),
              ),
              MaterialButton(
                onPressed: cancel,
                child: Text('cancel'),
              ),
            ],
          );
        });
  }

  void save() {
    // get workout name from text controller
    String newWorkName = newWorkoutNameController.text;

    // add workout to workoutData List
    Provider.of<WorkOutData>(context, listen: false).addWorkout(newWorkName);

    Navigator.pop(context);
    newWorkoutNameController.clear();
  }

  void cancel() {
    Navigator.pop(context);
  }

  void getToWorkOutPage(String workoutName) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WorkoutPage(
        workoutName: workoutName,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkOutData>(builder: (context, value, child) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: createNewWorkout,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text(
              'WorkOut Tracker',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              MyheatMap(
                startDateYYYYMMDD: value.getStartDate(),
                datasets: value.heatMapDataset,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getWorkoutList().length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(16)),
                        child: ListTile(
                          title: Text(
                            value.getWorkoutList()[index].name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 19),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => getToWorkOutPage(
                                value.getWorkoutList()[index].name),
                          ),
                        ),
                      ),
                    );
                  }),
            ],
          ));
    });
  }
}
