part of research_package_ui;

/// The UI representation of [RPCompletionStep]
///
/// Typically, you don’t need to instantiate a completion step widget directly. Instead, add a completion step to a task, and present the task with a task widget.
/// The task widget instantiates the step widget for the completion step.
class RPUICompletionStep extends StatefulWidget {
  final RPCompletionStep step;

  RPUICompletionStep({required this.step});

  @override
  _RPUICompletionStepState createState() => _RPUICompletionStepState();
}

class _RPUICompletionStepState extends State<RPUICompletionStep>
    with SingleTickerProviderStateMixin {
  late Animation<double> _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _scale = Tween(begin: 0.3, end: 1.1)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    RPLocalizations? locale = RPLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  locale?.translate(widget.step.title) ?? widget.step.title,
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      locale?.translate(widget.step.text!) ?? widget.step.text!,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            ScaleTransition(
              scale: _scale,
              child: Icon(
                Icons.check_circle,
                size: 120,
                color: Theme.of(context).accentColor,
              ),
            ),
            ButtonTheme(
              minWidth: 150,
              child: OutlinedButton(
                onPressed: () {
                  blocTask.sendStatus(RPStepStatus.Finished);
                },
                child: Text(
                    RPLocalizations.of(context)?.translate('DONE') ?? "Proceed"),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
