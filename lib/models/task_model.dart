
// ignore_for_file: unnecessary_this

class TaskModel {
  int? id;
  String? title;
  String? note;
  String? startTime;
  String? endTime;
  String? date;
  int? color;
  int? isCompelet;
  String? repeat;
  int? remind;

  TaskModel({
    this.id,
    this.title,
    this.note,
    this.isCompelet,
    this.color,
    this.endTime,
    this.startTime,
    this.remind,
    this.repeat,
    this.date,
  });

  TaskModel.fromJason(Map<String, dynamic> url) {
    id = url['id'];
    title = url['title'];
    note = url['note'];
    date = url['date'];
    isCompelet = url['isCompelet'];
    color = url['color'];
    startTime = url['startTime'];
    endTime = url['endTime'];
    repeat = url['repeat'];
    remind = url['remind'];
  }
  
  Map<String, dynamic> toJason() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['note'] = this.note;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['isCompelet'] = this.isCompelet;
    data['date'] = this.date;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;
    return data;
  }
}
