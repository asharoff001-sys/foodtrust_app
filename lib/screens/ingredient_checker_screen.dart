import 'package:flutter/material.dart';

class IngredientCheckerScreen extends StatefulWidget {
  const IngredientCheckerScreen({super.key});

  @override
  State<IngredientCheckerScreen> createState() =>
      _IngredientCheckerScreenState();
}

class _IngredientCheckerScreenState extends State<IngredientCheckerScreen> {
  final TextEditingController controller = TextEditingController();

  final List<String> riskyIngredients = [
    'gelatin',
    'alcohol',
    'pork',
    'lard',
    'enzyme',
    'wine',
    'beer',
    'rum',
  ];

  List<String> detectedRisks = [];

  bool checked = false;

  void analyzeIngredients() {
    final text = controller.text.toLowerCase();

    detectedRisks.clear();

    for (final ingredient in riskyIngredients) {
      if (text.contains(ingredient)) {
        detectedRisks.add(ingredient);
      }
    }

    setState(() {
      checked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text('AI Ingredient Checker'),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF2A1F3D), const Color(0xFF1A1A24)]
                      : [Colors.green.shade100, Colors.green.shade50],
                ),

                borderRadius: BorderRadius.circular(24),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.auto_awesome,

                        color: isDark
                            ? Colors.purpleAccent
                            : Colors.green.shade800,

                        size: 32,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Smart Ingredient Analysis',

                          style: TextStyle(
                            fontSize: 22,

                            fontWeight: FontWeight.bold,

                            color: isDark
                                ? Colors.white
                                : Colors.green.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Paste ingredients to detect risky or non-halal components.',

                    style: TextStyle(
                      fontSize: 16,

                      color: isDark ? Colors.white70 : Colors.grey.shade700,

                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            TextField(
              controller: controller,

              maxLines: 8,

              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),

              decoration: InputDecoration(
                hintText: 'Example:\nWater, Sugar, Gelatin, Natural Flavors...',

                hintStyle: TextStyle(
                  color: isDark ? Colors.white38 : Colors.grey,
                ),

                filled: true,

                fillColor: isDark
                    ? const Color(0xFF1A1A24)
                    : Colors.grey.shade100,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),

                  borderSide: BorderSide.none,
                ),

                contentPadding: const EdgeInsets.all(20),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.purpleAccent : Colors.green,

                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                onPressed: analyzeIngredients,

                icon: const Icon(Icons.search),

                label: const Text(
                  'Analyze Ingredients',

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 34),

            if (checked)
              detectedRisks.isEmpty ? buildSafeResult() : buildRiskResult(),
          ],
        ),
      ),
    );
  }

  Widget buildSafeResult() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A24) : Colors.green.shade50,

        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        children: [
          Icon(
            Icons.verified,

            size: 80,

            color: isDark ? Colors.purpleAccent : Colors.green.shade700,
          ),

          const SizedBox(height: 18),

          Text(
            'No Risky Ingredients Detected',

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 22,

              fontWeight: FontWeight.bold,

              color: isDark ? Colors.white : Colors.green.shade800,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            'This ingredient list appears safe based on current analysis.',

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 16,

              color: isDark ? Colors.white70 : Colors.grey.shade700,

              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRiskResult() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A1A1A) : Colors.red.shade50,

        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, size: 34, color: Colors.red.shade700),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Risky Ingredients Found',

                  style: TextStyle(
                    fontSize: 22,

                    fontWeight: FontWeight.bold,

                    color: isDark ? Colors.white : Colors.red.shade800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          ...detectedRisks.map((ingredient) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),

              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A24) : Colors.white,

                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      ingredient,

                      style: TextStyle(
                        fontSize: 16,

                        fontWeight: FontWeight.bold,

                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 10),

          Text(
            'These ingredients may not be halal or may require further verification.',

            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.grey.shade700,

              height: 1.5,

              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
