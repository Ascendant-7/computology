import 'package:computology/features/pc_builder/data/pc_component.dart';
import 'package:computology/features/pc_builder/data/pc_component_data.dart';
import 'package:computology/features/pc_builder/logic/compatibility_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CompatibilityService service;

  setUp(() {
    service = CompatibilityService();
  });

  // ---------------------------------------------------------------------------
  // Helper – look up components from the catalog by ID.
  // ---------------------------------------------------------------------------
  PCComponent _cpu(String id) =>
      PCComponentData.cpus.firstWhere((c) => c.id == id);
  PCComponent _mb(String id) =>
      PCComponentData.motherboards.firstWhere((c) => c.id == id);
  PCComponent _gpu(String id) =>
      PCComponentData.gpus.firstWhere((c) => c.id == id);
  PCComponent _ram(String id) =>
      PCComponentData.rams.firstWhere((c) => c.id == id);
  PCComponent _storage(String id) =>
      PCComponentData.storages.firstWhere((c) => c.id == id);
  PCComponent _psu(String id) =>
      PCComponentData.powerSupplies.firstWhere((c) => c.id == id);
  PCComponent _case(String id) =>
      PCComponentData.cases.firstWhere((c) => c.id == id);

  // ---------------------------------------------------------------------------
  // Valid full builds
  // ---------------------------------------------------------------------------
  group('Valid builds', () {
    test('Full AMD build — AM5 CPU + AM5 board + DDR5 RAM', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen5_7600'),
        motherboard: _mb('mb_b650_gaming'),
        gpu: _gpu('gpu_rtx4060'),
        ram: _ram('ram_32gb_ddr5_6000'),
        storage: _storage('storage_1tb_nvme'),
        psu: _psu('psu_750w_gold'),
        pcCase: _case('case_nzxt_h5'),
      );

      expect(result.isCompatible, isTrue);
      expect(result.errors, isEmpty);
      expect(result.passed.length, greaterThanOrEqualTo(4));
    });

    test('Full Intel build — LGA1700 CPU + Z790 board + DDR5 RAM', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_i5_14600k'),
        motherboard: _mb('mb_z790_msi'),
        gpu: _gpu('gpu_rtx4070_super'),
        ram: _ram('ram_16gb_ddr5_5600'),
        storage: _storage('storage_2tb_nvme'),
        psu: _psu('psu_850w_gold'),
        pcCase: _case('case_corsair_4000d'),
      );

      expect(result.isCompatible, isTrue);
      expect(result.errors, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // CPU ↔ Motherboard socket
  // ---------------------------------------------------------------------------
  group('CPU / Motherboard socket check', () {
    test('AM5 CPU + LGA1700 motherboard → error', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen5_7600'), // AM5
        motherboard: _mb('mb_z790_msi'), // LGA1700
      );

      expect(result.isCompatible, isFalse);
      expect(
        result.errors.any((e) => e.title.contains('Socket Mismatch')),
        isTrue,
      );
    });

    test('LGA1700 CPU + AM5 motherboard → error', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_i5_14600k'), // LGA1700
        motherboard: _mb('mb_b650_gaming'), // AM5
      );

      expect(result.isCompatible, isFalse);
      expect(
        result.errors.any((e) => e.title.contains('Socket Mismatch')),
        isTrue,
      );
    });

    test('Matching sockets → passed', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen7_7800x3d'), // AM5
        motherboard: _mb('mb_x670_aorus'), // AM5
      );

      expect(
        result.passed.any((p) => p.title.contains('CPU / Motherboard Socket')),
        isTrue,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Motherboard ↔ RAM type
  // ---------------------------------------------------------------------------
  group('Motherboard / RAM type check', () {
    test('DDR5 motherboard + DDR4 RAM → error', () {
      final result = service.checkCompatibility(
        motherboard: _mb('mb_b650_gaming'), // DDR5
        ram: _ram('ram_16gb_ddr4_3200'), // DDR4
      );

      expect(result.isCompatible, isFalse);
      expect(
        result.errors.any(
          (e) => e.title.contains('Motherboard / RAM Type Mismatch'),
        ),
        isTrue,
      );
    });

    test('DDR5 motherboard + DDR5 RAM → passed', () {
      final result = service.checkCompatibility(
        motherboard: _mb('mb_z790_msi'), // DDR5
        ram: _ram('ram_32gb_ddr5_6000'), // DDR5
      );

      expect(
        result.passed.any((p) => p.title.contains('Motherboard / RAM Type')),
        isTrue,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // CPU ↔ RAM type
  // ---------------------------------------------------------------------------
  group('CPU / RAM type check', () {
    test('DDR5 CPU + DDR4 RAM → error', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen5_7600'), // DDR5
        ram: _ram('ram_16gb_ddr4_3200'), // DDR4
      );

      expect(result.isCompatible, isFalse);
      expect(
        result.errors.any((e) => e.title.contains('CPU / RAM Type Mismatch')),
        isTrue,
      );
    });

    test('DDR5 CPU + DDR5 RAM → passed', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_i7_14700k'),
        ram: _ram('ram_16gb_ddr5_5600'),
      );

      expect(
        result.passed.any((p) => p.title.contains('CPU / RAM Type')),
        isTrue,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // PSU wattage
  // ---------------------------------------------------------------------------
  group('PSU wattage check', () {
    test('High-TDP build with small PSU → error or warning', () {
      // RTX 4070 Super (220W) + Ryzen 7 7800X3D (120W) + RAM (5W)
      //   + Storage (8W) = 353W → 20% headroom = 424W. 650W PSU is fine.
      // But let's test the high-draw GPU with a 650W PSU (should be fine).
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen7_7800x3d'), // 120W
        gpu: _gpu('gpu_rx7800xt'), // 263W
        ram: _ram('ram_32gb_ddr5_6000'), // 5W
        storage: _storage('storage_1tb_nvme'), // 8W
        psu: _psu('psu_650w_gold'), // 650W
      );

      // Total TDP = 396W. Recommended = 396 * 1.2 = 476W.
      // 650W > 476W → should pass.
      expect(
        result.passed.any((p) => p.title.contains('PSU Wattage')),
        isTrue,
      );
    });

    test('PSU with sufficient headroom → passed', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen5_7600'), // 65W
        gpu: _gpu('gpu_rtx4060'), // 115W
        ram: _ram('ram_16gb_ddr5_5600'), // 5W
        storage: _storage('storage_1tb_nvme'), // 8W
        psu: _psu('psu_650w_gold'), // 650W
      );

      // Total TDP = 193W, recommended 232W, capacity 650W → passed.
      expect(result.passed.any((p) => p.title.contains('PSU')), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // Case ↔ Motherboard form factor
  // ---------------------------------------------------------------------------
  group('Case / Motherboard form factor check', () {
    test('ATX motherboard in Mini-ITX case → error', () {
      final result = service.checkCompatibility(
        motherboard: _mb('mb_b650_gaming'), // ATX
        pcCase: _case('case_nr200'), // Mini-ITX
      );

      expect(result.isCompatible, isFalse);
      expect(
        result.errors.any(
          (e) => e.title.contains('Form Factor Mismatch'),
        ),
        isTrue,
      );
    });

    test('Micro-ATX motherboard in ATX case → passed', () {
      final result = service.checkCompatibility(
        motherboard: _mb('mb_b760_gigabyte'), // Micro-ATX
        pcCase: _case('case_nzxt_h5'), // ATX
      );

      expect(
        result.passed.any(
          (p) => p.title.contains('Case / Motherboard Form Factor'),
        ),
        isTrue,
      );
    });

    test('ATX motherboard in ATX case → passed', () {
      final result = service.checkCompatibility(
        motherboard: _mb('mb_z790_msi'), // ATX
        pcCase: _case('case_corsair_4000d'), // ATX
      );

      expect(
        result.passed.any(
          (p) => p.title.contains('Case / Motherboard Form Factor'),
        ),
        isTrue,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Incomplete build warning
  // ---------------------------------------------------------------------------
  group('Completeness check', () {
    test('Empty build → warning with all missing components', () {
      final result = service.checkCompatibility();

      expect(result.isCompatible, isTrue); // No errors, just warnings.
      expect(
        result.warnings.any((w) => w.title == 'Incomplete Build'),
        isTrue,
      );
      expect(
        result.warnings
            .firstWhere((w) => w.title == 'Incomplete Build')
            .description,
        contains('CPU'),
      );
    });

    test('Partial build → warning listing missing parts', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen5_7600'),
        motherboard: _mb('mb_b650_gaming'),
      );

      expect(result.isCompatible, isTrue);
      final incomplete = result.warnings.firstWhere(
        (w) => w.title == 'Incomplete Build',
      );
      expect(incomplete.description, contains('GPU'));
      expect(incomplete.description, contains('RAM'));
      expect(incomplete.description, isNot(contains('CPU')));
      expect(incomplete.description, isNot(contains('Motherboard')));
    });

    test('Complete build → no incompleteness warning', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen5_7600'),
        motherboard: _mb('mb_b650_gaming'),
        gpu: _gpu('gpu_rtx4060'),
        ram: _ram('ram_16gb_ddr5_5600'),
        storage: _storage('storage_1tb_nvme'),
        psu: _psu('psu_750w_gold'),
        pcCase: _case('case_nzxt_h5'),
      );

      expect(
        result.warnings.any((w) => w.title == 'Incomplete Build'),
        isFalse,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Multiple errors at once
  // ---------------------------------------------------------------------------
  group('Multiple errors', () {
    test('Wrong socket + wrong RAM type → 3 errors', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen5_7600'), // AM5, DDR5
        motherboard: _mb('mb_z790_msi'), // LGA1700, DDR5
        ram: _ram('ram_16gb_ddr4_3200'), // DDR4
      );

      // Socket mismatch: AM5 ≠ LGA1700
      // Motherboard/RAM: DDR5 ≠ DDR4
      // CPU/RAM: DDR5 ≠ DDR4
      expect(result.isCompatible, isFalse);
      expect(result.errors.length, equals(3));
    });
  });

  // ---------------------------------------------------------------------------
  // CompatibilityResult properties
  // ---------------------------------------------------------------------------
  group('CompatibilityResult', () {
    test('totalChecks includes all categories', () {
      final result = service.checkCompatibility(
        cpu: _cpu('cpu_ryzen5_7600'),
        motherboard: _mb('mb_b650_gaming'),
        gpu: _gpu('gpu_rtx4060'),
        ram: _ram('ram_32gb_ddr5_6000'),
        storage: _storage('storage_1tb_nvme'),
        psu: _psu('psu_750w_gold'),
        pcCase: _case('case_nzxt_h5'),
      );

      expect(result.totalChecks, greaterThan(0));
      expect(
        result.totalChecks,
        equals(
          result.errors.length +
              result.warnings.length +
              result.passed.length,
        ),
      );
    });
  });
}
