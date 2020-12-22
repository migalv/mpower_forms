import 'package:cons_calc_lib/cons_calc_lib.dart';
import 'package:flutter/material.dart';
import 'package:loan_application_form/loan_application_repository.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:loan_application_form/route_generator.dart';

const String codeVersion = 'v1.2.0';
const String APP_TITLE = 'Loan appliation MPower';
const String INITIAL_FORM_ID = "TABLE_Civil_Servants_ZM";
const bool debugMode = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_TITLE,
      theme: buildMPowerTheme(),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class LoanApplicationForm extends StatefulWidget {
  final String source;
  final String campaign;
  final String userId;
  final String startFromQuestionId;

  const LoanApplicationForm({
    Key key,
    this.source = "organic",
    this.campaign = "none",
    this.userId,
    this.startFromQuestionId,
  }) : super(key: key);
  @override
  _LoanApplicationFormState createState() => _LoanApplicationFormState();
}

class _LoanApplicationFormState extends State<LoanApplicationForm> {
  LoanApplicationRepository repository;

  @override
  void initState() {
    repository = LoanApplicationRepository(
      codeVersion: codeVersion,
      isDebugging: debugMode,
      source: widget.source,
      campaign: widget.campaign,
    );

    repository.formResultsStream.listen((Map<String, List<Map>> formResults) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ThankYouPage(),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocProvider<DynamicFormBloc>(
        initBloc: (_, b) =>
            b ??
            DynamicFormBloc(
              initialFormId: INITIAL_FORM_ID,
              repository: repository,
              userId: widget.userId,
              startFromQuestionId: widget.startFromQuestionId,
            ),
        onDispose: (_, b) => b.dispose(),
        child: DynamicFormPage(),
      );
}

class ThankYouPage extends StatelessWidget {
  final AutoSizeGroup group = AutoSizeGroup();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryMain,
      body: Column(
        children: [
          _buildMpowerLogo(context),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 128.0,
                  ),
                  AutoSizeText(
                    "Thank you so much for your time!",
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    group: group,
                  ),
                  AutoSizeText(
                    "An MPower employee will get in touch very soon.",
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    group: group,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMpowerLogo(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Image.network(
          "https://firebasestorage.googleapis.com/v0/b/mpower-dashboard-components.appspot.com/o/assets%2Fmpower_logos%2Flogo-con-text.svg?alt=media&token=3d4fd611-cff2-4a2a-b752-64d935902b29",
          width: MediaQuery.of(context).size.height <= 768
              ? MediaQuery.of(context).size.height / 10
              : MediaQuery.of(context).size.height / 8,
          color: Color.fromRGBO(0, 54, 103, 1),
        ),
      );
}
