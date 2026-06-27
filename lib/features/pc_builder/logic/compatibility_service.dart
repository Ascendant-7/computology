import 'package:computology/features/pc_builder/data/pc_component.dart';

/// Severity level for a compatibility check result.
enum CompatibilityLevel { passed, warning, error }

/// A single compatibility check outcome.
class CompatibilityIssue {
  const CompatibilityIssue({
    required this.title,
    required this.description,
    required this.level,
  });

  final String title;
  final String description;
  final CompatibilityLevel level;
}

/// Aggregated result of all compatibility checks for a PC build.
class CompatibilityResult {
  const CompatibilityResult({
    required this.isCompatible,
    required this.errors,
    required this.warnings,
    required this.passed,
  });

  /// True when there are zero [errors].
  final bool isCompatible;

  /// Fatal incompatibilities — the build will not work.
  final List<CompatibilityIssue> errors;

  /// Non-fatal concerns — the build works but could be improved.
  final List<CompatibilityIssue> warnings;

  /// Checks that passed successfully.
  final List<CompatibilityIssue> passed;

  /// Total number of checks performed.
  int get totalChecks => errors.length + warnings.length + passed.length;
}

/// Pure-logic service that validates hardware compatibility for a PC build.
///
/// This class has no Flutter dependency and is fully unit-testable.
class CompatibilityService {
  /// The recommended power headroom multiplier.
  /// A PSU should have at least 20% more capacity than total TDP.
  static const double _psuHeadroomFactor = 1.2;

  /// Form factors in order from smallest to largest.
  /// A case that supports a larger form factor also supports all smaller ones.
  static const List<String> _formFactorHierarchy = [
    'Mini-ITX',
    'Micro-ATX',
    'ATX',
  ];

  /// Run all compatibility checks on the given component selections.
  ///
  /// Any parameter may be `null` if the user hasn't selected that component
  /// yet. Missing components result in warnings, not errors.
  CompatibilityResult checkCompatibility({
    PCComponent? cpu,
    PCComponent? motherboard,
    PCComponent? gpu,
    PCComponent? ram,
    PCComponent? storage,
    PCComponent? psu,
    PCComponent? pcCase,
  }) {
    final List<CompatibilityIssue> errors = [];
    final List<CompatibilityIssue> warnings = [];
    final List<CompatibilityIssue> passed = [];

    // 1. Check completeness
    _checkCompleteness(
      cpu: cpu,
      motherboard: motherboard,
      gpu: gpu,
      ram: ram,
      storage: storage,
      psu: psu,
      pcCase: pcCase,
      warnings: warnings,
    );

    // 2. CPU ↔ Motherboard socket
    _checkCpuMotherboardSocket(
      cpu: cpu,
      motherboard: motherboard,
      errors: errors,
      passed: passed,
    );

    // 3. Motherboard ↔ RAM type
    _checkMotherboardRamType(
      motherboard: motherboard,
      ram: ram,
      errors: errors,
      passed: passed,
    );

    // 4. CPU ↔ RAM type
    _checkCpuRamType(
      cpu: cpu,
      ram: ram,
      errors: errors,
      passed: passed,
    );

    // 5. PSU wattage
    _checkPsuWattage(
      cpu: cpu,
      gpu: gpu,
      ram: ram,
      storage: storage,
      psu: psu,
      errors: errors,
      warnings: warnings,
      passed: passed,
    );

    // 6. Case ↔ Motherboard form factor
    _checkCaseFormFactor(
      motherboard: motherboard,
      pcCase: pcCase,
      errors: errors,
      passed: passed,
    );

    return CompatibilityResult(
      isCompatible: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      passed: passed,
    );
  }

  // ---------------------------------------------------------------------------
  // Individual checks
  // ---------------------------------------------------------------------------

  void _checkCompleteness({
    required PCComponent? cpu,
    required PCComponent? motherboard,
    required PCComponent? gpu,
    required PCComponent? ram,
    required PCComponent? storage,
    required PCComponent? psu,
    required PCComponent? pcCase,
    required List<CompatibilityIssue> warnings,
  }) {
    final missing = <String>[];
    if (cpu == null) missing.add('CPU');
    if (motherboard == null) missing.add('Motherboard');
    if (gpu == null) missing.add('GPU');
    if (ram == null) missing.add('RAM');
    if (storage == null) missing.add('Storage');
    if (psu == null) missing.add('Power Supply');
    if (pcCase == null) missing.add('Case');

    if (missing.isNotEmpty) {
      warnings.add(CompatibilityIssue(
        title: 'Incomplete Build',
        description: 'Missing components: ${missing.join(', ')}.',
        level: CompatibilityLevel.warning,
      ));
    }
  }

  void _checkCpuMotherboardSocket({
    required PCComponent? cpu,
    required PCComponent? motherboard,
    required List<CompatibilityIssue> errors,
    required List<CompatibilityIssue> passed,
  }) {
    if (cpu == null || motherboard == null) return;
    if (cpu.socket == null || motherboard.socket == null) return;

    if (cpu.socket != motherboard.socket) {
      errors.add(CompatibilityIssue(
        title: 'CPU / Motherboard Socket Mismatch',
        description:
            '${cpu.name} uses socket ${cpu.socket} but '
            '${motherboard.name} uses socket ${motherboard.socket}. '
            'They are physically incompatible.',
        level: CompatibilityLevel.error,
      ));
    } else {
      passed.add(CompatibilityIssue(
        title: 'CPU / Motherboard Socket',
        description:
            '${cpu.name} and ${motherboard.name} both use '
            'socket ${cpu.socket}.',
        level: CompatibilityLevel.passed,
      ));
    }
  }

  void _checkMotherboardRamType({
    required PCComponent? motherboard,
    required PCComponent? ram,
    required List<CompatibilityIssue> errors,
    required List<CompatibilityIssue> passed,
  }) {
    if (motherboard == null || ram == null) return;
    if (motherboard.ramType == null || ram.ramType == null) return;

    if (motherboard.ramType != ram.ramType) {
      errors.add(CompatibilityIssue(
        title: 'Motherboard / RAM Type Mismatch',
        description:
            '${motherboard.name} supports ${motherboard.ramType} but '
            '${ram.name} is ${ram.ramType}. '
            'The RAM slots are physically different.',
        level: CompatibilityLevel.error,
      ));
    } else {
      passed.add(CompatibilityIssue(
        title: 'Motherboard / RAM Type',
        description:
            '${motherboard.name} and ${ram.name} both use '
            '${ram.ramType}.',
        level: CompatibilityLevel.passed,
      ));
    }
  }

  void _checkCpuRamType({
    required PCComponent? cpu,
    required PCComponent? ram,
    required List<CompatibilityIssue> errors,
    required List<CompatibilityIssue> passed,
  }) {
    if (cpu == null || ram == null) return;
    if (cpu.ramType == null || ram.ramType == null) return;

    if (cpu.ramType != ram.ramType) {
      errors.add(CompatibilityIssue(
        title: 'CPU / RAM Type Mismatch',
        description:
            '${cpu.name} supports ${cpu.ramType} but '
            '${ram.name} is ${ram.ramType}.',
        level: CompatibilityLevel.error,
      ));
    } else {
      passed.add(CompatibilityIssue(
        title: 'CPU / RAM Type',
        description:
            '${cpu.name} and ${ram.name} both use ${ram.ramType}.',
        level: CompatibilityLevel.passed,
      ));
    }
  }

  void _checkPsuWattage({
    required PCComponent? cpu,
    required PCComponent? gpu,
    required PCComponent? ram,
    required PCComponent? storage,
    required PCComponent? psu,
    required List<CompatibilityIssue> errors,
    required List<CompatibilityIssue> warnings,
    required List<CompatibilityIssue> passed,
  }) {
    if (psu == null || psu.psuCapacityWatts == null) return;

    // Sum TDP from all selected components
    int totalTdp = 0;
    for (final component in [cpu, gpu, ram, storage]) {
      if (component?.tdpWatts != null) {
        totalTdp += component!.tdpWatts!;
      }
    }

    if (totalTdp == 0) return; // Nothing to check yet

    final int psuCapacity = psu.psuCapacityWatts!;
    final int recommendedWatts = (totalTdp * _psuHeadroomFactor).ceil();

    if (totalTdp > psuCapacity) {
      errors.add(CompatibilityIssue(
        title: 'PSU Insufficient',
        description:
            'Total estimated power draw is ${totalTdp}W but '
            '${psu.name} provides only ${psuCapacity}W. '
            'The system may shut down under load.',
        level: CompatibilityLevel.error,
      ));
    } else if (recommendedWatts > psuCapacity) {
      warnings.add(CompatibilityIssue(
        title: 'PSU Has Minimal Headroom',
        description:
            'Total estimated power draw is ${totalTdp}W. '
            'Recommended PSU capacity is at least ${recommendedWatts}W '
            '(20% headroom) but ${psu.name} provides ${psuCapacity}W.',
        level: CompatibilityLevel.warning,
      ));
    } else {
      passed.add(CompatibilityIssue(
        title: 'PSU Wattage',
        description:
            'Total estimated power draw is ${totalTdp}W. '
            '${psu.name} provides ${psuCapacity}W '
            '(recommended: ${recommendedWatts}W). Sufficient headroom.',
        level: CompatibilityLevel.passed,
      ));
    }
  }

  void _checkCaseFormFactor({
    required PCComponent? motherboard,
    required PCComponent? pcCase,
    required List<CompatibilityIssue> errors,
    required List<CompatibilityIssue> passed,
  }) {
    if (motherboard == null || pcCase == null) return;
    if (motherboard.formFactor == null || pcCase.formFactor == null) return;

    final int mbIndex = _formFactorHierarchy.indexOf(motherboard.formFactor!);
    final int caseIndex = _formFactorHierarchy.indexOf(pcCase.formFactor!);

    // If either form factor is unknown, skip the check
    if (mbIndex == -1 || caseIndex == -1) return;

    if (mbIndex > caseIndex) {
      errors.add(CompatibilityIssue(
        title: 'Case / Motherboard Form Factor Mismatch',
        description:
            '${motherboard.name} is ${motherboard.formFactor} but '
            '${pcCase.name} only supports up to ${pcCase.formFactor}. '
            'The motherboard will not physically fit.',
        level: CompatibilityLevel.error,
      ));
    } else {
      passed.add(CompatibilityIssue(
        title: 'Case / Motherboard Form Factor',
        description:
            '${motherboard.name} (${motherboard.formFactor}) fits in '
            '${pcCase.name} (${pcCase.formFactor}).',
        level: CompatibilityLevel.passed,
      ));
    }
  }
}
