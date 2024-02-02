import 'package:flutter/material.dart';
import 'package:text_editors/save_file_service.dart';

void main() {
  runApp(const MyApp());
}

class TextEditor extends StatelessWidget {
  const TextEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Editor',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final SaveFileService _saveFileService = MethodChannelService();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editor"),
      ),
      body: Column(
        children: [
          _buildTextField(hint: "File name", controller: _fileNameController),
          _buildTextField(
            hint: "Write text...",
            maxLines: null,
            minLines: 7,
            controller: _textController,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_fileNameController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Please enter a file name."),
              ),
            );
            return;
          }

          final messenger = ScaffoldMessenger.of(context);
          final successful = await _saveFileService.saveFile(
            fileName: _fileNameController.text,
            text: _textController.text,
          );

          messenger.showSnackBar(
            SnackBar(
              content: Text(
                successful ? "File saved successfully" : "Failed to save file",
              ),
            ),
          );
        },
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int? maxLines = 1,
    int? minLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
        maxLines: maxLines,
        minLines: minLines,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }
}
