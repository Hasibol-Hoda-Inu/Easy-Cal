import 'package:flutter/material.dart';

import '../../../../application/app_colors.dart';

class BmrCalculator extends StatefulWidget {
  @override
  _BmrCalculatorState createState() => _BmrCalculatorState();
}

class _BmrCalculatorState extends State<BmrCalculator> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _feetController = TextEditingController();
  final _inchesController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

  bool isMale = true;
  double? _bmrResult;

  void _calculateBMR() {
    double weight = double.tryParse(_weightController.text) ?? 0;
    double feet = double.tryParse(_feetController.text) ?? 0;
    double inches = double.tryParse(_inchesController.text) ?? 0;
    int age = int.tryParse(_ageController.text) ?? 0;

    double totalInches = (feet * 12) + inches;
    double height = totalInches * 0.0254;

    if (weight > 0 && height > 0 && age > 0) {
      setState(() {
        // Mifflin-St Jeor Equation
        if (isMale) {
          _bmrResult = (10 * weight) + (6.25 * height) - (5 * age) + 5;
        } else {
          _bmrResult = (10 * weight) + (6.25 * height) - (5 * age) - 161;
        }
      });
    }

    /// TODO: Have to add activity level.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMR Calculator"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _genderTile(
                  "Male",
                  Icons.male,
                  isMale,
                  () => setState(() => isMale = true),
                ),
                const SizedBox(width: 20),
                _genderTile(
                  "Female",
                  Icons.female,
                  !isMale,
                  () => setState(() => isMale = false),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildInput(_ageController, "Age", "years"),
                  Row(
                    spacing: 14,
                    children: [
                      Expanded(child: _buildInput(_feetController, "Feet", "feet"),),
                      Expanded(child: _buildInput(_inchesController, "Inches", "inches"),),
                    ],
                  ),
                  _buildInput(_weightController, "Weight", "kg"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _calculateBMR,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.orange,
              ),
              child: const Text(
                "Calculate BMR",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            if (_bmrResult != null) ...[
              const SizedBox(height: 40),
              const Text(
                "Your Daily BMR:",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Text(
                "${_bmrResult!.toStringAsFixed(0)} kcal",
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const Text(
                "This is the energy your body needs at rest.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String label,
    String unit,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "Enter $label";
          if (double.tryParse(value) == null) return "Invalid";
          return null;
        },
      ),
    );
  }

  Widget _genderTile(
    String title,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected ? Colors.orange.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: selected ? Colors.orange : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.orange : Colors.grey, size: 30),
            Text(
              title,
              style: TextStyle(color: selected ? Colors.orange : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
