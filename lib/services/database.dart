import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  Future<void> addData(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
      print(e);
    });
  }

  getData() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future<void> addQuizData(Map quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .set(quizData)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> addQuestionData(quizData, String quizId) async {
    await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .add(quizData)
        .catchError((e) {
      print(e);
    });
  }

  getQuizData() async {
    return await FirebaseFirestore.instance.collection("Quiz").snapshots();
  }

  getQuestionData(String quizId) async {
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }

  getPronounceData() async {
    return await FirebaseFirestore.instance.collection("Pronounce").snapshots();
  }

  getFlashcards() async {
    return await FirebaseFirestore.instance.collection("Pronounce").get();
  }

  getGrammar() async {
    return await FirebaseFirestore.instance.collection("Verbs").get();
  }

  getCategoryData() async {
    return await FirebaseFirestore.instance
        .collection("Categories")
        .snapshots();
  }

  getProfileData(String uid) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .snapshots();
  }
}
