import 'package:flutter/material.dart';
import 'package:flutter_date_picker_timeline/flutter_date_picker_timeline.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import 'package:task2/controller/task_controller.dart';
import 'package:task2/models/task_model.dart';
import 'package:task2/views/add_task_page.dart';
import 'package:task2/theme/theme_controller.dart';
import 'package:task2/theme/theme_scheme.dart';


//GlobalKey<ScaffoldState> _key = GlobalKey();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: unused_field
  final Uri _url = Uri.parse("https://github.com/EddyHezarian/Redo");
  Rx<double> widthCart = 16.0.obs;
  final themecontroller = Get.find<ThemeServices>();
  var lightTXT = Themes.lightTheme.textTheme;
  var darkTXT = Themes.darkTheme.textTheme;
  var selectedDay = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    var dayinit = DateTime.now().day;
    var monthinit = DateTime.now().month;
    var yearinit = DateTime.now().year;
    return Scaffold(
      // key: _key,
      body: Column(
        children: [
          const SizedBox(height: 10),
          _topDate(),
          _datePicker(yearinit, monthinit, dayinit),
          const SizedBox(
            height: 12,
          ),
          _taskCard(),
        ],
      ),

      appBar: _appBar(),
    );
  }

  _datePicker(int yearinit, int monthinit, int dayinit) {
    return Container(
        padding: const EdgeInsets.only(top: 11, bottom: 11),
        child: FlutterDatePickerTimeline(
          calendarMode: CalendarMode.gregorian,
          initialFocusedDate: DateTime.now(),
          itemRadius: 18,
          selectedItemWidth: 160,
          itemHeight: 60,
          unselectedItemTextStyle:
              GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16, color: const Color.fromARGB(255, 133, 207, 229)),
          selectedItemTextStyle: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
          unselectedItemBackgroundColor: const Color.fromARGB(168, 218, 218, 218),
          selectedItemBackgroundColor: const Color.fromARGB(255, 117, 180, 199),
          unselectedItemWidth: 55,
          startDate: DateTime(2022, 07, 01),
          endDate: DateTime(2222, 12, 30),
          initialSelectedDate: DateTime(yearinit, monthinit, dayinit),
          onSelectedDateChange: (DateTime? dateTime) {
            setState(() {
              selectedDay = dateTime!;
            });
          },
        ));
  }

  _topDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 13, top: 15),
          child: Column(
            children: [
              Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                selectedDay.day == DateTime.now().day ? "Today" : "",
                style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        _addTaskButton()
      ],
    );
  }

  _addTaskButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 13, top: 5),
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 117, 180, 199)),
        child: InkWell(
          onTap: () async {
            Get.to(() => const AddTaskPage());
          },
          child: const Center(
              child: Text(
            "+ Add task",
            style: TextStyle(color: Pallet.white),
          )),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      actions: [
        Expanded(
          child: Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              InkWell(
                onTap: () {
                  if (Get.isDarkMode) {
                    //themecontroller.changeTheme(Themes.lightTheme);
                    themecontroller.switchTheme(ThemeMode.light);
                    themecontroller.saveThemeFromBox(false);
                  } else {
                    //themecontroller.changeTheme(Themes.lightTheme);
                    themecontroller.switchTheme(ThemeMode.dark);
                    themecontroller.saveThemeFromBox(true);
                  }
                },
                child: const Icon(
                  CupertinoIcons.color_filter,
                  size: 40,
                ),
              ),
              Text(
                "ReDo",
                style:
                    GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 117, 180, 199)),
              )
            ],
          ),
        )
      ],
    );
  }


  _taskCard() {
    return Expanded(child: Obx(
      () {
        return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              var cart = _taskController.taskList[index];

              if (cart.repeat == 'daily') {
                return cart.isCompelet == 1
                    ? Padding(
                        padding: const EdgeInsets.only(right: 30, left: 30),
                        child: TaskTile(item_: cart ,recurringMode: true,),
                      )
                    : TaskTile(item_: cart,recurringMode: true,);
              } else if (cart.date == DateFormat.yMd().format(selectedDay)) {
                return cart.isCompelet == 1
                    ? Padding(
                        padding: const EdgeInsets.only(right: 30, left: 30),
                        child: TaskTile(item_: cart ,recurringMode: false,),
                      )
                    : TaskTile(item_: cart,recurringMode: false,);
              } else {
                return Container();
              }
            });
      },
    ));
  }
}

// ignore: must_be_immutable
class TaskTile extends StatelessWidget {
  TaskModel item_;
  bool recurringMode;
  TaskTile({
    super.key,
    required this.item_,
    required this.recurringMode
  });
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return InkWell(
      //delete task
      onLongPress: () {
        _BotomSheetForDelete(context, item_);
      },

      child: Container(
        //decorating task tile
        height: 130,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: _getColor(item_.color!)),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //titel . date . note 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //title
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10),
                  child: Text(
                    item_.title!,
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                //time and date with clock icon
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 6),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.clock,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "${item_.startTime!} - ${item_.date!}",
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      //
                    ],
                  ),
                ),
                //note
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Text(item_.note!,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )),
                )
              ],
            ),
           //check box and recurring icon 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,        
              children: [
                 //check box
                InkWell(
                  onTap: () {
                    _taskController.markAsCompelet(item_.id!);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100), color: const Color.fromARGB(125, 255, 255, 255)),
                    child: item_.isCompelet == 1 ? const Icon(Icons.done) : Container(),
                  ),
                ),
               const SizedBox(height: 10,),
               //recurring icon
               recurringMode == true ? 
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.repeat,color: Colors.white,),
                ):Container() 
              ],
            )
          ],
        ),
      ),
    );
  }

  _getColor(int num) {
    switch (num) {
      case (0):
        return Colors.red;
      case (1):
        return Colors.blue;
      case (2):
        return const Color.fromARGB(255, 255, 166, 0);
    }
  }

  // ignore: non_constant_identifier_names
  _BotomSheetForDelete(BuildContext context, TaskModel item_) {
    Get.bottomSheet(Container(
      height: MediaQuery.of(context).size.height * 0.24,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 247, 245, 245),
      ),
      child: Column(
        children: [
          //grey puller line
          Container(
            width: 120,
            height: 6,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
          ),
          const SizedBox(
            height: 40,
          ),
          //delete bootom
          InkWell(
            onTap: () {
              _taskController.delete(item_);
              _taskController.getTask();
              Get.back();
            },
            child: Container(
              width: 320,
              height: 60,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.red),
              child: Center(
                  child: Text(
                "Delete Task",
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          //close button
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: 320,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(0, 255, 255, 255)),
              child: Center(
                  child: Text(
                "Close",
                style: GoogleFonts.lato(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 2, 2, 2),
                ),
              )),
            ),
          ),
        ],
      ),
    ));
  }
}
