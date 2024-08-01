import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TranslationPage(),
    );
  }
}

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  TranslateLanguage _sourceLanguage = TranslateLanguage.english;
  TranslateLanguage _targetLanguage = TranslateLanguage.arabic;
  late OnDeviceTranslator _translator;
  String _translatedText = '';
  bool _isLoading = false;

  final List<TranslateLanguage> _languages = [
    TranslateLanguage.english,
    TranslateLanguage.arabic,
    TranslateLanguage.french,
    TranslateLanguage.german,
    TranslateLanguage.spanish,
    TranslateLanguage.chinese
  ];

  @override
  void initState() {
    super.initState();
    _translator = OnDeviceTranslator(
      sourceLanguage: _sourceLanguage,
      targetLanguage: _targetLanguage,
    );
  }

  @override
  void dispose() {
    _translator.close();
    super.dispose();
  }

  void _translateText(String text) async {
    setState(() {
      _isLoading = true;
    });

    final translatedText = await _translator.translateText(text);

    setState(() {
      _translatedText = translatedText;
      _isLoading = false;
    });
  }

  void _updateSourceLanguage(TranslateLanguage? language) {
    if (language != null) {
      setState(() {
        _sourceLanguage = language;
        _translator = OnDeviceTranslator(
          sourceLanguage: _sourceLanguage,
          targetLanguage: _targetLanguage,
        );
      });
    }
  }

  void _updateTargetLanguage(TranslateLanguage? language) {
    if (language != null) {
      setState(() {
        _targetLanguage = language;
        _translator = OnDeviceTranslator(
          sourceLanguage: _sourceLanguage,
          targetLanguage: _targetLanguage,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                DropdownButton<TranslateLanguage>(
                  value: _sourceLanguage,
                  items: _languages.map((TranslateLanguage language) {
                    return DropdownMenuItem<TranslateLanguage>(
                      value: language,
                      child: Text(language.name),
                    );
                  }).toList(),
                  onChanged: _updateSourceLanguage,
                  isExpanded: true,
                  hint: const Text('Select source language'),
                ),
                const SizedBox(height: 20),
                DropdownButton<TranslateLanguage>(
                  value: _targetLanguage,
                  items: _languages.map((TranslateLanguage language) {
                    return DropdownMenuItem<TranslateLanguage>(
                      value: language,
                      child: Text(language.name),
                    );
                  }).toList(),
                  onChanged: _updateTargetLanguage,
                  isExpanded: true,
                  hint: const Text('Select target language'),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Enter text to translate',
                  ),
                  onSubmitted: _translateText,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Translated Text:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(_translatedText),
              ],
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
