import 'package:flutter/material.dart';

class BmiCalculator extends StatefulWidget {
  @override
  _BmiCalculatorState createState() => _BmiCalculatorState();
}

class _BmiCalculatorState extends State<BmiCalculator> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _feetController = TextEditingController();
  final _inchesController = TextEditingController();
  final _weightController = TextEditingController();

  double? _bmiResult;
  String _status = "";

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      double feet = double.parse(_feetController.text);
      double inches = double.parse(_inchesController.text);
      double weight = double.parse(_weightController.text);

      // 1. Convert height to total inches, then to meters
      double totalInches = (feet * 12) + inches;
      double heightInMeters = totalInches * 0.0254;

      // 2. BMI Formula: weight (kg) / (height (m) * height (m))
      setState(() {
        _bmiResult = weight / (heightInMeters * heightInMeters);

        if (_bmiResult! < 18.5) {
          _status = "Underweight";
        } else if (_bmiResult! < 25) {
          _status = "Normal Weight";
        } else if (_bmiResult! < 30) {
          _status = "Overweight";
        } else {
          _status = "Obese";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Assign the key here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Your Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 20),

              // Height Row: Feet and Inches
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: _buildTextField(_feetController, "Feet", "ft"),
                  ),
                  Expanded(
                    child: _buildTextField(_inchesController, "Inches", "in"),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Weight Field
              _buildTextField(_weightController, "Weight", "kg"),

              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                  ),
                  child: const Text(
                    "Calculate BMI",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              if (_bmiResult != null) _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  // Result UI
  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple),
      ),
      child: Column(
        children: [
          const Text(
            "Your BMI",
            style: TextStyle(fontSize: 18, color: Colors.purple),
          ),
          Text(
            _bmiResult!.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          Text(
            _status,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  // Helper for TextFormFields with Validation
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String suffix,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        labelStyle: const TextStyle(color: Colors.purple),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.purple, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return "Enter $label";
        if (double.tryParse(value) == null) return "Invalid";
        return null;
      },
    );
  }
}
