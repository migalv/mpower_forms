import 'package:flutter/material.dart';
import 'package:loan_application_form/main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final Map urlParameters = Uri.parse(settings.name).queryParameters;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => LoanApplicationForm(
            source: urlParameters["source"],
            campaign: urlParameters["campaign"],
            startFromQuestionId: urlParameters["questionId"],
            userId: urlParameters["uid"],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => LoanApplicationForm(
            source: urlParameters["source"],
            campaign: urlParameters["campaign"],
            startFromQuestionId: urlParameters["questionId"],
            userId: urlParameters["uid"],
          ),
        );
    }
  }
}
