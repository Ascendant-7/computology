/// Model class for a PC component with technical specifications
/// used for compatibility checking.
class PCComponent {
  const PCComponent({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.socket,
    this.chipset,
    this.ramType,
    this.tdpWatts,
    this.formFactor,
    this.maxRamSpeed,
    this.psuCapacityWatts,
  });

  final String id;
  final String name;
  final double price;

  /// Component category: 'cpu', 'motherboard', 'gpu', 'ram',
  /// 'storage', 'psu', 'case'.
  final String category;

  /// CPU socket type, e.g. 'AM5', 'LGA1700'.
  /// Applies to CPUs and motherboards.
  final String? socket;

  /// Motherboard chipset, e.g. 'B650', 'Z790'.
  final String? chipset;

  /// Supported RAM type, e.g. 'DDR5', 'DDR4'.
  /// Applies to CPUs, motherboards, and RAM sticks.
  final String? ramType;

  /// Thermal Design Power in watts.
  /// Used to estimate total system power draw.
  final int? tdpWatts;

  /// Physical form factor, e.g. 'ATX', 'Micro-ATX', 'Mini-ITX'.
  /// Applies to motherboards and cases.
  final String? formFactor;

  /// Maximum supported RAM speed in MHz.
  final int? maxRamSpeed;

  /// PSU total capacity in watts. Only applies to PSU components.
  final int? psuCapacityWatts;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PCComponent &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PCComponent($id, $name)';
}
