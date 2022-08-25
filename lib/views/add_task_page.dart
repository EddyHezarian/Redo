import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:task2/controller/task_controller.dart';
import 'package:task2/models/task_model.dart';
import 'package:task2/views/homepage_screen.dart';
import 'package:time_picker_sheet/widget/sheet.dart';
import 'package:time_picker_sheet/widget/time_picker.dart';
import '../theme/theme_controller.dart';


class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //outside controllers
  final themecontroller = Get.find<ThemeServices>();
  final TaskController _taskController = Get.put(TaskController());

  List<int> reminderList = [5, 10, 15, 20];
  List<String> repeatList = ["none", "daily", "weekly", "monthly"];

  // container Controllers 
  var selectedDate = DateTime.now();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int _selectedColor = 0;
  int _selectedReminder = 5; 
  String _selectedRepeat = "none";
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime(2022, 8, 20, 9, 0, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [
          //title
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 23),
            child: CustomzeInputForm(title: "Title", controller: _titleController, hint: "enter title"),
          ),
          //note
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 23),
            child: CustomzeInputForm(title: "Note", controller: _noteController, hint: "enter Note"),
          ),
          //date
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 23),
            child: CustomzeInputForm(
              title: "date",
              controller: null,
              hint: DateFormat.yMd().format(selectedDate),
              widget: IconButton(
                icon: const Icon(CupertinoIcons.calendar),
                onPressed: () {
                  _getCalander();
                },
              ),
            ),
          ),
          //Time
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 18,
                ),
                Expanded(
                  child: CustomzeInputForm(
                    title: "Start",
                    hint: DateFormat("hh:mm a").format(_startTime).toString(),
                    widget: IconButton(
                      icon: const Icon(CupertinoIcons.clock),
                      onPressed: () {
                        _openTimePickerSheet(context, true);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: CustomzeInputForm(
                    title: "End",
                    hint: DateFormat("hh:mm a").format(_endTime).toString(),
                    widget: IconButton(
                      icon: const Icon(CupertinoIcons.clock),
                      onPressed: () {
                        _openTimePickerSheet(context, false);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          //reminder
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 10),
            child: CustomzeInputForm(
              title: "Reminder",
              hint: "$_selectedReminder minutes early ",
              widget: DropdownButton(
                underline: Container(
                  height: 0,
                ),
                iconSize: 33,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: reminderList.map<DropdownMenuItem<String>>((int value) {
                  return DropdownMenuItem<String>(
                    value: value.toString(),
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: ((value) {
                  setState(() {
                    _selectedReminder = int.parse(value!);
                  });
                }),
              ),
            ),
          ),
          //repeat
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 10),
            child: CustomzeInputForm(
              title: "Repeat",
              hint: "$_selectedRepeat  ",
              widget: DropdownButton(
                underline: Container(
                  height: 0,
                ),
                iconSize: 33,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: repeatList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: ((value) {
                  setState(() {
                    _selectedRepeat = value!;
                  });
                }),
              ),
            ),
          ),
          //color and apply
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //color selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Color",
                      style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _colorPallet()
                  ],
                ),
                //apply button
                _addTaskButton()
              ],
            ),
          )
        ]),
      ),
    );
  }

  _colorPallet() {
    return Wrap(
      children: List<Widget>.generate(
          3,
          (index) => InkWell(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    backgroundColor: index == 0
                        ? Colors.red
                        : index == 1
                            ? Colors.blue
                            : const Color.fromARGB(255, 255, 166, 0),
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 40,
                          )
                        : Container(),
                  ),
                ),
              )),
    );
  }

  _validateTaskData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      _taskController.getTask();
      Get.to(()=>const HomePage());
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Requeirs", "Title and Note must be completed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          icon: const Icon(
            Icons.warning,
            color: Colors.red,
          ));
    }
  }

  _addTaskToDB() async {
    await _taskController.addTask(
      task: TaskModel(
      title: _titleController.text, note: _noteController.text,
      date: DateFormat.yMd().format(selectedDate),
      color: _selectedColor, repeat: _selectedRepeat, 
      remind: _selectedReminder,isCompelet: 0,
      startTime: DateFormat("hh:mm a").format(_startTime).toString(),
      endTime: DateFormat("hh:mm a").format(_endTime).toString(),
    ));
  }

  _addTaskButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 13, top: 5),
      child: Container(
        width: 120,
        height: 50,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(255, 9, 157, 177)),
        child: InkWell(
          onTap: () {
            // Get.to( const AddTaskPage());
            _validateTaskData();
          },
          child: Center(
              child: Text(
            "Creat",
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )),
        ),
      ),
    );
  }

  void _openTimePickerSheet(BuildContext context, bool isStart) async {
    final result = await TimePicker.show<DateTime?>(
      context: context,
      sheet: TimePickerSheet(
        minuteInterval: 1,
        minuteTitleStyle: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 82, 158, 184)),
        hourTitleStyle: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 82, 158, 184)),
        wheelNumberSelectedStyle: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18, color: const Color.fromARGB(255, 82, 158, 184)),
        sheetTitle: 'Select Time for event',
        minuteTitle: 'Minute',
        hourTitle: 'Hour',
        sheetCloseIconColor: const Color.fromARGB(255, 14, 115, 146),
        saveButtonText: 'Save',
        saveButtonColor: const Color.fromARGB(255, 117, 180, 199),
      ),
    );
    if (result != null) {
      if (isStart == true) {
        setState(() {
          _startTime = result;
        });
      } else if (isStart == false) {
        setState(() {
          _endTime = result;
        });
      }
    }
  }

  _getCalander() async {
    DatePicker.showDatePicker(
      context,

      showTitleActions: true,
      minTime: DateTime(2022, 1, 1),
      maxTime: DateTime(2222, 6, 7),
      theme:  DatePickerTheme(
          headerColor: const Color.fromARGB(255, 1, 135, 133),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          itemStyle:  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 15, color: const Color.fromARGB(255, 0, 0, 0)),
          doneStyle:  GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
      onConfirm: (date) {
        setState(() {
          selectedDate = date;
        });
        
      },
      currentTime: DateTime.now(),
      locale: LocaleType.en,
    );
  }

  _appBar() {
    return AppBar(
        elevation: 0,
        leading: InkWell(
            child: const Icon(Icons.arrow_back_ios),
            onTap: () {
              Get.back();
            }));
  }
}



class CustomzeInputForm extends StatelessWidget {
  final Widget? widget;
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  const CustomzeInputForm({super.key, required this.title, required this.hint, this.controller, this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title!,
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 9,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Container(
              padding: const EdgeInsets.only(left: 14),
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: Color.fromARGB(255, 38, 133, 140), blurStyle: BlurStyle.outer, blurRadius: 1, spreadRadius: 1)
                ],
                //color: const Color.fromARGB(30, 237, 237, 237),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: widget == null ? false : true,
                      controller: controller,
                      autofocus: false,
                      cursorColor: const Color.fromARGB(255, 5, 104, 117),
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.none, color: Colors.black, width: 0)),
                          hintText: hint,
                          hintStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.blueGrey)),
                    ),
                  ),
                  widget == null
                      ? Container()
                      : Container(
                          child: widget,
                        )
                ],
              )),
        )
      ],
    );
  }
}
