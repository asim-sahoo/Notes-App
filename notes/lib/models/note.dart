class Note {
  String? id;
  String? userid;
  String? title;
  String? content;
  DateTime? date;

  Note({ this.id, this.userid, this.title, this.content, this.date});

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"],
      userid: map["userid"],
      title: map["title"],
      content: map["content"],
      date: DateTime.tryParse(map["date"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userid": userid,
      "title": title,
      "content": content,
      "date": date!.toIso8601String()
    };
  }
}