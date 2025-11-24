class ValidationResult {
  final bool safe;
  final List<String> warnings;
  ValidationResult({required this.safe, required this.warnings});

  Map<String, dynamic> toJson() => {'safe': safe, 'warnings': warnings};
}

ValidationResult validateOrder({
  required List<String> allergies,
  required String medication,
  double? weightKg,
  String? dose,
}) {
  final warnings = <String>[];
  if (weightKg != null && weightKg < 0.5) {
    warnings.add('weight-too-low');
  }
  for (final allergy in allergies) {
    if (medication.toLowerCase().contains(allergy.toLowerCase())) {
      warnings.add('allergy-match');
    }
  }
  if (dose != null && dose.contains('0mg')) warnings.add('zero-dose');
  return ValidationResult(safe: warnings.isEmpty, warnings: warnings);
}
