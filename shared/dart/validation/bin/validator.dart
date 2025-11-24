import 'dart:convert';
import '../lib/validation.dart';

void main() async {
  final input = await utf8.decoder.bind(stdin).join();
  final Map<String, dynamic> payload = json.decode(input);
  final result = validateOrder(
    allergies: List<String>.from(payload['allergies'] ?? const []),
    medication: payload['medication'] ?? '',
    weightKg: payload['weightKg']?.toDouble(),
    dose: payload['dose'],
  );
  stdout.write(json.encode(result.toJson()));
}
