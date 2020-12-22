import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cons_calc_lib/cons_calc_lib.dart';
import 'package:meta/meta.dart';

class LoanApplicationRepository extends DynamicFormsRepository {
  LoanApplicationRepository(
      {@required String codeVersion,
      bool isDebugging,
      String source,
      String campaign})
      : super(codeVersion,
            isDebugging: isDebugging, source: source, campaign: campaign);

  @override
  Future<DynamicForm> getFormWithId(String formId) async {
    // Fetch the DynamicForm from Firestore
    DocumentSnapshot formDoc = await Firestore.instance
        .collection('dynamic_forms')
        .document(formId)
        .get();

    if (formDoc == null) return null;

    // Fetch the Questions of the DynamicForm from Firestore
    List<DocumentSnapshot> documents =
        (await formDoc.reference.collection('questions').getDocuments())
            .documents;

    if (documents == null) return null;

    // Transform the Firestore docs to Question models
    List<Question> questions = documents
        .map((questionDoc) => Question.fromJson(questionDoc.data))
        .toList();

    return DynamicForm(
      formDoc.documentID,
      questions: questions,
      title: formDoc.data["title"],
      emailList: formDoc.data["email_list"] != null &&
              formDoc.data["email_list"].isNotEmpty
          ? List<String>.from(formDoc.data["email_list"])
          : null,
      greetingTitle: formDoc["greeting_title"],
      greetingSubtitle: formDoc["greeting_subtitle"],
    );
  }
}
