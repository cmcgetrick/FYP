import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter3/models/question_model.dart';
import 'package:flutter3/services/database.dart';
import 'package:flutter3/widget/widget.dart';
import 'package:flutter3/widgets/quiz_play_widgets.dart';
import 'package:flutter3/views/results.dart';

class LessonFeature extends StatefulWidget {
  final String lessonId;
  LessonFeature(this.lessonId);

  @override
  _LessonFeatureState createState() => _LessonFeatureState();
}

int _correct = 0;
int _incorrect = 0;
int total = 0;

/// Stream
Stream dataStream;

class _LessonFeatureState extends State<LessonFeature> {
  QuerySnapshot questions;
  DatabaseService databaseService = new DatabaseService();

  bool buffer = true;

  @override
  void initState() {
    databaseService.getQuestionData(widget.lessonId).then((value) {
      questions = value;
      _correct = 0;
      _incorrect = 0;
      buffer = false;
      total = questions.docs.length;
      setState(() {});
      print("init don $total ${widget.lessonId} ");
    });

    if (dataStream == null) {
      dataStream = Stream<List<int>>.periodic(Duration(milliseconds: 100), (x) {
        return [_correct, _incorrect];
      });
    }

    super.initState();
  }

  QuestionModel getQuestionModelFromDatasnapshot(DocumentSnapshot snap) {
    QuestionModel questionModel = new QuestionModel();

    questionModel.question = snap.data()["question"];

    /// shuffling the options
    List<String> choices = [
      snap.data()["option1"],
      snap.data()["option2"],
      snap.data()["option3"],
      snap.data()["option4"]
    ];
    choices.shuffle();

    questionModel.option1 = choices[0];
    questionModel.option2 = choices[1];
    questionModel.option3 = choices[2];
    questionModel.option4 = choices[3];
    questionModel.correctOption = snap.data()["option1"];
    questionModel.selected = false;

    print(questionModel.correctOption.toLowerCase());

    return questionModel;
  }

  @override
  void dispose() {
    dataStream = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LogoWidget(),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0.0,
      ),
      body: buffer
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Score(
                      length: questions.docs.length,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    questions.docs == null
                        ? Container(
                            child: Center(
                              child: Text("No data stream"),
                            ),
                          )
                        : ListView.builder(
                            itemCount: questions.docs.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return LessonTile(
                                modl: getQuestionModelFromDatasnapshot(
                                    questions.docs[index]),
                                index: index,
                              );
                            })
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Results(
                        incorrect: _incorrect,
                        total: total,
                        correct: _correct,
                      )));
        },
      ),
    );
  }
}

class Score extends StatefulWidget {
  final int length;

  Score({@required this.length});

  @override
  _ScoreState createState() => _ScoreState();
}

class _ScoreState extends State<Score> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dataStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: 40,
                  margin: EdgeInsets.only(left: 14),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: <Widget>[
                      NoOfQuestionTile(
                        text: "Total",
                        number: widget.length,
                      ),
                      NoOfQuestionTile(
                        text: "Correct",
                        number: _correct,
                      ),
                      NoOfQuestionTile(
                        text: "Incorrect",
                        number: _incorrect,
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }
}

class LessonTile extends StatefulWidget {
  final QuestionModel modl;
  final int index;

  LessonTile({@required this.modl, @required this.index});

  @override
  _LessonTileState createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Q${widget.index + 1} ${widget.modl.question}",
              style:
                  TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.modl.selected) {
                ///correct
                if (widget.modl.option1 == widget.modl.correctOption) {
                  setState(() {
                    optionSelected = widget.modl.option1;
                    widget.modl.selected = true;
                    _correct = _correct + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.modl.option1;
                    widget.modl.selected = true;
                    _incorrect = _incorrect + 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "A",
              description: "${widget.modl.option1}",
              correctAnswer: widget.modl.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.modl.selected) {
                ///correct
                if (widget.modl.option2 == widget.modl.correctOption) {
                  setState(() {
                    optionSelected = widget.modl.option2;
                    widget.modl.selected = true;
                    _correct = _correct + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.modl.option2;
                    widget.modl.selected = true;
                    _incorrect = _incorrect + 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "B",
              description: "${widget.modl.option2}",
              correctAnswer: widget.modl.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.modl.selected) {
                ///correct
                if (widget.modl.option3 == widget.modl.correctOption) {
                  setState(() {
                    optionSelected = widget.modl.option3;
                    widget.modl.selected = true;
                    _correct = _correct + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.modl.option3;
                    widget.modl.selected = true;
                    _incorrect = _incorrect + 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "C",
              description: "${widget.modl.option3}",
              correctAnswer: widget.modl.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.modl.selected) {
                ///correct
                if (widget.modl.option4 == widget.modl.correctOption) {
                  setState(() {
                    optionSelected = widget.modl.option4;
                    widget.modl.selected = true;
                    _correct = _correct + 1;
                  });
                } else {
                  setState(() {
                    optionSelected = widget.modl.option4;
                    widget.modl.selected = true;
                    _incorrect = _incorrect + 1;
                  });
                }
              }
            },
            child: OptionTile(
              option: "D",
              description: "${widget.modl.option4}",
              correctAnswer: widget.modl.correctOption,
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
