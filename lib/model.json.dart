// GENERATED CODE - DO NOT MODIFY BY HAND

part of research_package_model;

bool _fromJsonFunctionsRegistrered = false;

/// Register all the fromJson functions for the deployment domain classes.
void _registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistrered) return;
  _fromJsonFunctionsRegistrered = true;

  // AnswerFormat classes
  FromJsonFactory().register(RPAnswerFormat());
  FromJsonFactory().register(RPBooleanAnswerFormat(falseText: '', trueText: ''));
  FromJsonFactory().register(RPChoiceAnswerFormat(answerStyle: RPChoiceAnswerStyle.SingleChoice, choices: []));
  FromJsonFactory().register(RPChoice(text: '',value: 1));
  FromJsonFactory().register(RPDateTimeAnswerFormat(dateTimeAnswerStyle: RPDateTimeAnswerStyle.Date));
  FromJsonFactory().register(RPFormAnswerFormat());
  FromJsonFactory().register(RPImageChoiceAnswerFormat(choices: []));
  FromJsonFactory().register(RPImageChoice(description: '', imageUrl: ''));
  FromJsonFactory().register(RPIntegerAnswerFormat(maxValue: 1, minValue: 1));
  FromJsonFactory().register(RPSliderAnswerFormat(divisions: 1, maxValue: 1, minValue: 1));
  FromJsonFactory().register(RPTextAnswerFormat());

  // Steps classes
  FromJsonFactory().register(RPStep(identifier: '', title: ''));
  FromJsonFactory().register(RPQuestionStep(identifier: '', title: '', answerFormat: RPAnswerFormat()));
  FromJsonFactory().register(RPInstructionStep(identifier: '', title: ''));
  FromJsonFactory().register(RPFormStep(identifier: '', title: '', steps: []));
  FromJsonFactory().register(RPCompletionStep(identifier: '', title: ''));

  // Consent Document classes
  FromJsonFactory().register(RPConsentReviewStep(identifier: '', consentDocument: RPConsentDocument(sections: [], title: '')));
  FromJsonFactory().register(RPVisualConsentStep(identifier: '', consentDocument: RPConsentDocument(sections: [], title: '')));
  FromJsonFactory().register(RPConsentDocument(title: '', sections: []));
  FromJsonFactory().register(RPConsentSection(type: RPConsentSectionType.AboutUs));
  FromJsonFactory().register(RPConsentSignature(identifier: ''));

  // Tasks classes
  FromJsonFactory().register(RPOrderedTask(identifier: '', steps: []));
  FromJsonFactory().register(RPNavigableOrderedTask(identifier: '', steps: []));
  FromJsonFactory().register(RPDataTypeSection(dataName: '', dataInformation: '',));
}

// auto generate json code (.g files) with:
//   flutter pub run build_runner build --delete-conflicting-outputs
