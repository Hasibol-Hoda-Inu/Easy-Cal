import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_cal/application/app_colors.dart';
import 'package:easy_cal/application/const/api_key.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../../../data_models/nutrition_data_model.dart';

class Homescreen extends StatefulWidget {
  final Function(FoodNutrition)? onNutritionAnalyzed;
  final VoidCallback? onTakePhoto;

  const Homescreen({super.key, this.onNutritionAnalyzed, this.onTakePhoto});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  FoodNutrition? _nutritionData;

  Uint8List? _selectedImageBytes;
  String _analysisResult = "Snap a photo to start analyzing your meal.";
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Easy Cal"),
        centerTitle: true,
        backgroundColor: AppColors.themeColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ClipOval(
                            child: Image(
                              image: _selectedImageBytes != null
                                  ? MemoryImage(_selectedImageBytes!)
                                        as ImageProvider
                                  : const AssetImage(
                                      'assets/images/placeholder.png',
                                    ),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                if (_nutritionData != null) ...[
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    padding: const EdgeInsets.all(30.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green[50],
                      border: Border.all(color: AppColors.themeColor, width: 8.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${_nutritionData!.calories}",
                          style: const TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "kcal",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _nutritionData!.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "You have to walk: ${_nutritionData!.calories / 4} minutes to burn this meal",
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _macroTile(
                          "Protein",
                          _nutritionData!.protein,
                          Colors.blue,
                        ),
                        _macroTile("Carbs", _nutritionData!.carbs, Colors.green),
                        _macroTile("Fat", _nutritionData!.fat, Colors.red),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePhoto,
        child: const Icon(
          Icons.camera_alt,
        ),
      ),
    );
  }

  Widget _macroTile(String label, String value, Color color) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: color.withAlpha(77),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      // Compress the image to improve performance
      final bytes = await photo.readAsBytes();
      final originalImage = img.decodeImage(bytes);
      if (originalImage != null) {
        // Resize to max 400x400 to reduce memory usage
        final resizedImage = img.copyResize(
          originalImage,
          width: 400,
          height: 400,
          maintainAspect: true,
        );
        final compressedBytes = Uint8List.fromList(
          img.encodeJpg(resizedImage, quality: 80),
        );

        setState(() {
          _selectedImageBytes = compressedBytes;
          _isLoading = true;
        });
        _analyzeWithGemini(photo);
      } else {
        // If compression fails, use original bytes
        final originalBytes = await photo.readAsBytes();
        setState(() {
          _selectedImageBytes = originalBytes;
          _isLoading = true;
        });
        _analyzeWithGemini(photo);
      }
    }
  }

  Future<void> _analyzeWithGemini(XFile photo) async {
    final model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: ApiKey.geminiApiKey,
    );

    final imageBytes = await photo.readAsBytes();
    final promt = TextPart("""
    Analyze this food image. and calories will be in kCal. Return ONLY a JSON object with these keys: 
    "food_name", "calories" (as integer), "protein", "carbs", "fat".
    Example: {"food_name": "Chicken Salad", "calories": 350, "protein": "30g", "carbs": "10g", "fat": "15g"}
  """);

    final content = [
      Content.multi([promt, DataPart('image/jpeg', imageBytes)]),
    ];

    try {
      final response = await model.generateContent(content);
      final responseText = response.text ?? "";

      setState(() {
        _analysisResult = responseText;
      });

      // Try to parse the JSON response
      try {
        String jsonString = responseText.trim();
        // Remove markdown code blocks if present
        if (jsonString.startsWith('```json')) {
          jsonString = jsonString.substring(7);
        }
        if (jsonString.endsWith('```')) {
          jsonString = jsonString.substring(0, jsonString.length - 3);
        }
        jsonString = jsonString.trim();

        final jsonData = jsonDecode(jsonString);
        if (jsonData is Map<String, dynamic>) {
          final nutrition = FoodNutrition.fromJson(jsonData);
          setState(() {
            _nutritionData = nutrition;
          });
          widget.onNutritionAnalyzed?.call(nutrition);
        } else {
          setState(() {
            _analysisResult = "Invalid response format from AI.";
          });
        }
      } catch (parseError) {
        setState(() {
          _analysisResult = "Failed to parse nutrition data.";
        });
        debugPrint("JSON parse error: $parseError");
        debugPrint("Response was: $responseText");
      }
    } catch (e) {
      setState(() {
        debugPrint("❌ $e");
        _analysisResult = "Error analyzing image";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
