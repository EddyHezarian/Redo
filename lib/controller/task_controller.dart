import 'package:get/get.dart';
import 'package:task2/db/data_base.dart';
import 'package:task2/models/task_model.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    getTask();
    super.onReady();
  }

  var taskList = <TaskModel>[].obs;

  Future<void> getTask() async {
    List<Map<String, dynamic>> task = await DbService.query();
    // ignore: unnecessary_new
    taskList.assignAll(task.map((data) => new TaskModel.fromJason(data)).toList());
  }

  void delete(TaskModel task) {
    DbService.delete(task);
  }

  Future<void> markAsCompelet(int id) async {
    await DbService.update(id);
    getTask();
  }

  Future<int> addTask({TaskModel? task}) async {
    return await DbService.insert(task);
  }
}
