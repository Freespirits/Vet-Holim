import { env } from './env.js';

type FeatureFlagKey = 'enableOfflineSync' | 'enableAuditTrail' | 'enableClinicaIntegration';

export type FeatureFlags = Record<FeatureFlagKey, boolean>;

const defaults: FeatureFlags = {
  enableOfflineSync: true,
  enableAuditTrail: true,
  enableClinicaIntegration: false
};

export function getFeatureFlags(): FeatureFlags {
  return { ...defaults, ...(env.featureFlags as FeatureFlags) };
}
