String normalizeRole(String role) {
  return role.trim().toLowerCase().replaceAll(' ', '');
}

bool hasFullMenuAccess(String role) {
  final normalized = normalizeRole(role);
  return normalized == 'pengawas' ||
      normalized == 'owner' ||
      normalized == 'superadmin' ||
      normalized == 'supervisor';
}

bool canViewReportKeuangan(String role) {
  final normalized = normalizeRole(role);
  return normalized == 'owner' || normalized == 'superadmin';
}
