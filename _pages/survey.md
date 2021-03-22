---
layout: single
title: Survey
permalink: /survey
toc: true
---

> **Note:**
> This tutorial is limited to present some of the survey types and give an introduction on how to combine them into one question (Form step).
> For all the available answer formats please see the [list of available answer formats](/answer-formats).

Creating surveys is one of the core features of ResearchPackage. This tutorial will guide you through how to create the needed domain model objects for a survey task, how to present it in the UI, how to combine different questions on one screen, and finally how to collect the results.

## Domain Model - Task, Step & Result

Overall, ResearchPackage uses a `Task` to represent the survey containing a list of `Step`s, which each returns a `Result`.
In the API, the task is an [`RPOrderedTask`](https://pub.dev/documentation/research_package/latest/research_package_model/RPOrderedTask-class.html) object and the steps are [`RPQuestionStep`](https://pub.dev/documentation/research_package/latest/research_package_model/RPQuestionStep-class.html) objects.
Results are saved as [`RPTaskResult`](https://pub.dev/documentation/research_package/latest/research_package_model/RPTaskResult-class.html) objects. ResearchPackage also support a navigable tasks with the [`RPNavigableOrderedTask`](https://pub.dev/documentation/research_package/latest/research_package_model/RPNavigableOrderedTask-class.html).

> Later, you will see that `.withParams` constructors are being used. This is needed because of the JSON serialization which requires an empty constructor for all the classes eligible for serialization.

## The Survey Steps

### Instruction Step

You can present instructions to the user, put them to context or show footnotes with the [`RPInstructionStep`](https://pub.dev/documentation/research_package/latest/research_package_model/RPInstructionStep-class.html).
An instruction step is useful any time you want to provide some instruction for the user at the beginning or during a survey.
Here's how you can create one:

```dart
RPInstructionStep instructionStep = RPInstructionStep(
    identifier: "instructionID",
    title: "Instructions",
    detailText:
        "Example: If you have felt cheerful and in good spirits more than half of the time during the last two weeks, put a tick in the box with the number 3 in the upper right corner.",
    footnote: "(1) Important footnote")
  ..text =
      "Please indicate for each of the five statements which is closest to how you have been feeling over the last two weeks. Notice that higher numbers mean better well-being.";
```

### QuestionStep

Let's create an actual question step. An [`RPQuestionStep`](https://pub.dev/documentation/research_package/latest/research_package_model/RPQuestionStep-class.html) is a generic step that needs a child of [`RPAnswerFormat`](https://pub.dev/documentation/research_package/latest/research_package_model/RPAnswerFormat-class.html) on which depends what kind of question will the step present.

You can create as many question steps as you want.

Let's have a look at the available answer formats in ResearchPackage.

#### Single Choice

In order to create the question step we have to set up the answer format first with a list of choices ([RPChoice](https://pub.dev/documentation/research_package/latest/research_package_model/RPChoice-class.html)) and the answer style. An `RPChoice` has a text which will be presented to the participant and a value which can be used for other purposes. When saving the result both of the fields will be saved.

The UI representation of this answer format looks like this:

<img src="https://raw.githubusercontent.com/cph-cachet/research.package/master/documentation/images/AnswerFormats/SingleChoiceAnswerFormat.png" width="300">

Here's how to create a single choice answer format:

```dart
// First create the list of choices
List<RPChoice> choices = [
  RPChoice.withParams("All of the time", 5),
  RPChoice.withParams("Most of the time", 4),
  RPChoice.withParams("More than half of the time", 3),
  RPChoice.withParams("Less than half of the time", 2),
  RPChoice.withParams("Some of the time", 1),
  RPChoice.withParams("At no time", 0),
];
```

After that the choices can be passed to the constructor of a choice answer format:

```dart
// Pass the list of choices to the answer format constructor
RPChoiceAnswerFormat choiceAnswerFormat = RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.SingleChoice, choices);
```

A single choice question format allows the user to pick one single element from a previously created set of options. The easiest way to create this step is by using the `.withAnswerFormat` constructor as the following:

```dart
RPQuestionStep choiceQuestionStep = RPQuestionStep.withAnswerFormat(
  "questionStep1ID",
  "I have felt cheerful and in good spirits",
  choiceAnswerFormat,
);
```

#### Multiple Choice

The multiple choice question is similar to the single choice with the difference that the participant is allowed to choose more than one option from the presented choices.

The UI representation of this answer format looks like this (see that the small hint text below the title has changed indicating that the participant is allowed to choose more options as well):

<img src="https://raw.githubusercontent.com/cph-cachet/research.package/master/documentation/images/AnswerFormats/MultipleChoiceAnswerFormat.png" width="300">

The creation of a question step like that is similar to the single choice answer format presented above. First the [`RPChoice`](https://pub.dev/documentation/research_package/latest/research_package_model/RPChoice-class.html) objects need to be created and then passed to the the constructor of the [`RPChoiceAnswerFormat`](https://pub.dev/documentation/research_package/latest/research_package_model/RPChoiceAnswerFormat-class.html) used with the multiple choice [`ChoiceAnswerStyle`](https://pub.dev/documentation/research_package/latest/research_package_model/ChoiceAnswerStyle-class.html) like this:

```dart
// Pass the list of choices to the answer format constructor
RPChoiceAnswerFormat choiceAnswerFormat = RPChoiceAnswerFormat.withParams(ChoiceAnswerStyle.MultipleChoice, choices);
```

#### Integer

Using an integer answer format, participants can enter a number within an pre-defined range. A suffix can be specified indicating for example the unit of the number (e.g. minutes, age...).

<img src="https://raw.githubusercontent.com/cph-cachet/research.package/master/documentation/images/AnswerFormats/IntegerAnswerFormat.png" width="300">

The [`RPIntegerAnswerFormat`](https://pub.dev/documentation/research_package/latest/research_package_model/RPIntegerAnswerFormat-class.html) needs to be instantiated by giving the constructor the lower limit, the upper limit and the suffix.

```dart
RPIntegerAnswerFormat weightIntegerAnswerFormat = RPIntegerAnswerFormat.withParams(0, 200, "KG");
```

Research Package will check if the input is an actual number and between the limits and lets the participant proceed only if these conditions are meet.

### Form Step

There are situation when it's beneficial to show multiple questions on the same page as one logical block.
For this, the [`RPFormStep`](https://pub.dev/documentation/research_package/latest/research_package_model/RPFormStep-class.html) can be used. A form step consists of multiple [`RPQuestionStep`](https://pub.dev/documentation/research_package/latest/research_package_model/RPQuestionStep-class.html) steps.

The form step is showing the question steps as a scrollable list. On the UI it looks like this:

<img src="https://raw.githubusercontent.com/cph-cachet/research.package/master/documentation/images/AnswerFormats/FormAnswerFormat.png" width="300">

To create a frm step works, first create the question steps to be shown on the page:

```dart
// This is a Question Step with a Multiple Choice Answer Format. See how to create it above
RPQuestionStep instrumentChoiceQuestionStep =
RPQuestionStep.withAnswerFormat("instrumentChoiceQuestionStepID", "Which instrument are you playing?", instrumentsAnswerFormat);

// This is a Question Step with Integer Answer Format. See how to create it above
RPQuestionStep minutesQuestionStep =
RPQuestionStep.withAnswerFormat("minutesQuestionStepID", "How many minutes do you spend practicing a week?", minutesIntegerAnswerFormat);
```

Then, after the question steps are created add them to the constructor of a Form Step as a list.

```dart
RPFormStep formStep = RPFormStep.withTitle("formstepID",[instrumentChoiceQuestionStep, minutesQuestionStep], "Questions about music");
```

> **What Answer Format does the Form Step has?**
> As every question step, a form step also needs an answer format. Since it has multiple questions embedded it would be difficult to figure out which answer format to use. To solve this, ResearchPackage has a special answer format; the [`RPFormAnswerFormat`](https://pub.dev/documentation/research_package/latest/research_package_model/RPFormAnswerFormat-class.html). Since a form step can only take this specific answer format you don't have to give it to it. ResearchPackage sets the corresponding value automatically as part of the constructor.

### Completion Step

Although it's not mandatory, creating a completion step and appending it to the list of steps is a good design choice because we can make sure the user did the survey and the result is saved.
Here's how to create an [`RPCompletionStep`](https://pub.dev/documentation/research_package/latest/research_package_model/RPCompletionStep-class.html):

```dart
RPCompletionStep completionStep = RPCompletionStep("completionStepID")
  ..title = "Thank You!"
  ..text = "The survey is over and we saved your result";
```

## The Survey Task

Now that you have all the needed steps, you can create the task for the survey.
This is done by creating a [`RPOrderedTask`](https://pub.dev/documentation/research_package/latest/research_package_model/RPOrderedTask-class.html) object with a unique string identifier and the list of previously created steps.

```dart
RPOrderedTask surveyTask = RPOrderedTask("surveyTaskID", [consentVisualStep, choiceQuestionStep, completionStep]);
```

## Presenting the Task

### Ordered Task

The next step is to present the survey task (e.g., `surveyTask`).
To achieve this you have to use the UI library of Research Package.

The [`RPUITask`](https://pub.dev/documentation/research_package/latest/research_package_ui/RPUITask-class.html) class will automatically present the task based on the Step objects in the Task object. It also gives you the possibility to gather the results (for the result domain model, see the next section).

This widget returns a full screen [`Scaffold`](https://docs.flutter.io/flutter/material/Scaffold-class.html) widget so the recommended usage is to create a route which returns an [`RPUITask`](https://pub.dev/documentation/research_package/latest/research_package_ui/RPUITask-class.html) and then navigate to this route. The minimum example is the following:

```dart
class SurveyTaskRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RPUITask(
      task: surveyTask,
      onSubmit: () {} // Collecting results, see next section
    );
  }
}
```

## Collecting Results

When a step is done by the user, it produces a corresponding result object. These are all [`RPStepResult`](https://pub.dev/documentation/research_package/latest/research_package_model/RPStepResult-class.html) objects.
Results from a task is stored in a [`RPTaskResult`](https://pub.dev/documentation/research_package/latest/research_package_model/RPTaskResult-class.html) object.
Both of the task and step result objects are collection results which means that they can contain other results (e.g. the task result holds the array of step results).

Every result ([`RPResult`](https://pub.dev/documentation/research_package/latest/research_package_model/RPResult-class.html)) has an identifier which connects it to the task or step which produced it. The identifier of the result is identical to the identifier of its task or step.
Each result also have a `startDate` and `endDate` property. Based on that the time spent on the given task/step/question can be calculated. Some results for example [`RPSignatureResult`](https://pub.dev/documentation/research_package/latest/research_package_model/RPSignatureResult-class.html) does not have its `startDate` filled out. In that case only the `endDate` is relevant which in this case is the exact time of the signature.

The result hierarchy corresponds closely to the hierarchy of the building model of tasks and steps.
Below is an example figure and the actual hierarchy of a result collected after a consent document task:

<img src="https://raw.githubusercontent.com/cph-cachet/research.package/master/documentation/images/signature_result_hierarchy_figure.png" height="300"> 
<img src="https://raw.githubusercontent.com/cph-cachet/research.package/master/documentation/images/signature_result_hierarchy_screenshot.png" height="600">

Gathering the results from a task can be done by passing a callback function to the [`RPUITask`](https://pub.dev/documentation/research_package/latest/research_package_ui/RPUITask-class.html) widget's `onSubmit` input parameter. The `onSubmit` event is triggered when the user has finished with the last step in the the list of steps passed to the task object.
This callback funtion takes as input parameter the [`RPTaskResult`](https://pub.dev/documentation/research_package/latest/research_package_model/RPTaskResult-class.html) object.
An example is listed below:

```dart
void resultCallback(RPTaskResult result) {
   // Do whatever you want with the result
   // In this case we are just printing the result's keys
   print(result.results.keys);
}
```

After creating the function you just have to pass it to the Task widget when creating. This changes the build function of our example above to the following:

```dart
@override
Widget build(BuildContext context) {
   return RPUIOrderedTask(
      task: task,
      onSubmit: resultCallback,
   );
}
```

### The `onCancel` function

The `RPUITask` also has the optional `onCancel` function. The function is used if the user cancels a task, in which case the current `RPTaskResult` is passed back to the supplied `onCancel` function where it can be used however one sees fit. It is important to have a function with an _optional_ argument if the user cancels before any result, as it wont have a result to return.

```dart
@override
Widget build(BuildContext context) {
   return RPUIOrderedTask(
      task: task,
      onSubmit: resultCallback,
      onCancel: ([result]) {
        print('User canceled the task');
        useTheResult(result);
      }
   );
}
```
