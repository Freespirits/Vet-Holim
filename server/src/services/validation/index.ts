import { runDartValidation, type ValidationInput } from './dartBridge.js';

const localRules = (input: ValidationInput) => {
  const warnings: string[] = [];
  if (input.weightKg && input.weightKg < 0.5) warnings.push('weight-too-low');
  if (input.allergies.some((a) => input.medication.toLowerCase().includes(a.toLowerCase()))) {
    warnings.push('allergy-match');
  }
  const zeroDosePattern = /^\s*0+(\.0+)?\s*mg\b/i;
  if (input.dose && zeroDosePattern.test(input.dose)) warnings.push('zero-dose');
  return { safe: warnings.length === 0, warnings };
};

export async function validateOrder(input: ValidationInput) {
  const local = localRules(input);
  try {
    const remote = await runDartValidation(input);
    const combinedWarnings = Array.from(new Set([...local.warnings, ...remote.warnings]));
    return { safe: remote.safe && local.safe, warnings: combinedWarnings };
  } catch (err) {
    return local;
  }
}
