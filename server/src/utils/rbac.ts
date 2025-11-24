import type { Role } from '../entities/User.js';

export type Permission =
  | 'encounter.create'
  | 'encounter.close'
  | 'order.create'
  | 'order.approve'
  | 'mar.record'
  | 'patient.read'
  | 'patient.write'
  | 'audit.view';

const rolePermissions: Record<Role, Permission[]> = {
  vet: ['encounter.create', 'encounter.close', 'order.create', 'order.approve', 'mar.record', 'patient.read', 'patient.write'],
  technician: ['encounter.create', 'order.create', 'mar.record', 'patient.read'],
  pharmacist: ['order.approve', 'patient.read', 'audit.view'],
  reception: ['patient.read', 'patient.write'],
  admin: ['encounter.create', 'encounter.close', 'order.create', 'order.approve', 'mar.record', 'patient.read', 'patient.write', 'audit.view'],
  auditor: ['audit.view', 'patient.read']
};

export const hasPermission = (roles: Role[], permission: Permission) =>
  roles.some((role) => rolePermissions[role]?.includes(permission));
