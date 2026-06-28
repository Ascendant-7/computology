import 'pc_component.dart';

/// Provides sample component data for the PC Builder feature.
///
/// Each component includes realistic technical specifications to enable
/// accurate compatibility checking between parts.
class PCComponentData {
  // ---------------------------------------------------------------------------
  // CPUs
  // ---------------------------------------------------------------------------
  static const List<PCComponent> cpus = [
    PCComponent(
      id: 'cpu_ryzen5_7600',
      name: 'AMD Ryzen 5 7600',
      price: 220,
      category: 'cpu',
      socket: 'AM5',
      ramType: 'DDR5',
      tdpWatts: 65,
    ),
    PCComponent(
      id: 'cpu_ryzen7_7800x3d',
      name: 'AMD Ryzen 7 7800X3D',
      price: 399,
      category: 'cpu',
      socket: 'AM5',
      ramType: 'DDR5',
      tdpWatts: 120,
    ),
    PCComponent(
      id: 'cpu_i5_14600k',
      name: 'Intel Core i5-14600K',
      price: 320,
      category: 'cpu',
      socket: 'LGA1700',
      ramType: 'DDR5',
      tdpWatts: 125,
    ),
    PCComponent(
      id: 'cpu_i7_14700k',
      name: 'Intel Core i7-14700K',
      price: 410,
      category: 'cpu',
      socket: 'LGA1700',
      ramType: 'DDR5',
      tdpWatts: 125,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Motherboards
  // ---------------------------------------------------------------------------
  static const List<PCComponent> motherboards = [
    PCComponent(
      id: 'mb_b650_gaming',
      name: 'MSI B650 Gaming Plus',
      price: 180,
      category: 'motherboard',
      socket: 'AM5',
      chipset: 'B650',
      ramType: 'DDR5',
      formFactor: 'ATX',
      maxRamSpeed: 6400,
    ),
    PCComponent(
      id: 'mb_x670_aorus',
      name: 'Gigabyte X670 Aorus Elite',
      price: 320,
      category: 'motherboard',
      socket: 'AM5',
      chipset: 'X670',
      ramType: 'DDR5',
      formFactor: 'ATX',
      maxRamSpeed: 6600,
    ),
    PCComponent(
      id: 'mb_z790_msi',
      name: 'MSI MAG Z790 Tomahawk',
      price: 280,
      category: 'motherboard',
      socket: 'LGA1700',
      chipset: 'Z790',
      ramType: 'DDR5',
      formFactor: 'ATX',
      maxRamSpeed: 7200,
    ),
    PCComponent(
      id: 'mb_b760_gigabyte',
      name: 'Gigabyte B760M DS3H',
      price: 130,
      category: 'motherboard',
      socket: 'LGA1700',
      chipset: 'B760',
      ramType: 'DDR5',
      formFactor: 'Micro-ATX',
      maxRamSpeed: 5600,
    ),
  ];

  // ---------------------------------------------------------------------------
  // GPUs
  // ---------------------------------------------------------------------------
  static const List<PCComponent> gpus = [
    PCComponent(
      id: 'gpu_rtx4060',
      name: 'NVIDIA RTX 4060',
      price: 299,
      category: 'gpu',
      tdpWatts: 115,
    ),
    PCComponent(
      id: 'gpu_rtx4070_super',
      name: 'NVIDIA RTX 4070 Super',
      price: 599,
      category: 'gpu',
      tdpWatts: 220,
    ),
    PCComponent(
      id: 'gpu_rx7800xt',
      name: 'AMD Radeon RX 7800 XT',
      price: 499,
      category: 'gpu',
      tdpWatts: 263,
    ),
  ];

  // ---------------------------------------------------------------------------
  // RAM
  // ---------------------------------------------------------------------------
  static const List<PCComponent> rams = [
    PCComponent(
      id: 'ram_16gb_ddr5_5600',
      name: '16GB DDR5-5600',
      price: 65,
      category: 'ram',
      ramType: 'DDR5',
      maxRamSpeed: 5600,
      tdpWatts: 5,
    ),
    PCComponent(
      id: 'ram_32gb_ddr5_6000',
      name: '32GB DDR5-6000',
      price: 120,
      category: 'ram',
      ramType: 'DDR5',
      maxRamSpeed: 6000,
      tdpWatts: 5,
    ),
    PCComponent(
      id: 'ram_16gb_ddr4_3200',
      name: '16GB DDR4-3200',
      price: 40,
      category: 'ram',
      ramType: 'DDR4',
      maxRamSpeed: 3200,
      tdpWatts: 5,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Storage
  // ---------------------------------------------------------------------------
  static const List<PCComponent> storages = [
    PCComponent(
      id: 'storage_1tb_nvme',
      name: '1TB NVMe SSD',
      price: 70,
      category: 'storage',
      tdpWatts: 8,
    ),
    PCComponent(
      id: 'storage_2tb_nvme',
      name: '2TB NVMe SSD',
      price: 130,
      category: 'storage',
      tdpWatts: 8,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Power Supplies
  // ---------------------------------------------------------------------------
  static const List<PCComponent> powerSupplies = [
    PCComponent(
      id: 'psu_650w_gold',
      name: '650W 80+ Gold',
      price: 90,
      category: 'psu',
      psuCapacityWatts: 650,
    ),
    PCComponent(
      id: 'psu_750w_gold',
      name: '750W 80+ Gold',
      price: 120,
      category: 'psu',
      psuCapacityWatts: 750,
    ),
    PCComponent(
      id: 'psu_850w_gold',
      name: '850W 80+ Gold',
      price: 150,
      category: 'psu',
      psuCapacityWatts: 850,
    ),
  ];

  // ---------------------------------------------------------------------------
  // Cases
  // ---------------------------------------------------------------------------
  static const List<PCComponent> cases = [
    PCComponent(
      id: 'case_nzxt_h5',
      name: 'NZXT H5 Flow',
      price: 90,
      category: 'case',
      formFactor: 'ATX',
    ),
    PCComponent(
      id: 'case_corsair_4000d',
      name: 'Corsair 4000D Airflow',
      price: 100,
      category: 'case',
      formFactor: 'ATX',
    ),
    PCComponent(
      id: 'case_nr200',
      name: 'Cooler Master NR200',
      price: 85,
      category: 'case',
      formFactor: 'Mini-ITX',
    ),
  ];
}
