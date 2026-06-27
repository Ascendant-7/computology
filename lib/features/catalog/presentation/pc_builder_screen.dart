import 'package:flutter/material.dart';

/// Model class for PC components
class PCComponent {
  final String id;
  final String name;
  final double price;

  PCComponent({required this.id, required this.name, required this.price});
}

/// Provides sample component data for PC Builder
class PCComponentData {
  static final List<PCComponent> cpus = [
    PCComponent(id: 'cpu1', name: 'Ryzen 5 7600', price: 220),
    PCComponent(id: 'cpu2', name: 'Ryzen 7 7800X3D', price: 399),
    PCComponent(id: 'cpu3', name: 'Intel i5-14600K', price: 320),
  ];

  static final List<PCComponent> motherboards = [
    PCComponent(id: 'mb1', name: 'B650 Gaming', price: 180),
    PCComponent(id: 'mb2', name: 'X670 Aorus', price: 320),
    PCComponent(id: 'mb3', name: 'Z790 MSI', price: 280),
  ];

  static final List<PCComponent> gpus = [
    PCComponent(id: 'gpu1', name: 'RTX 4060', price: 299),
    PCComponent(id: 'gpu2', name: 'RTX 4070 Super', price: 599),
    PCComponent(id: 'gpu3', name: 'RX 7800 XT', price: 499),
  ];

  static final List<PCComponent> rams = [
    PCComponent(id: 'ram1', name: '16GB DDR5', price: 65),
    PCComponent(id: 'ram2', name: '32GB DDR5', price: 120),
  ];

  static final List<PCComponent> storages = [
    PCComponent(id: 'storage1', name: '1TB NVMe SSD', price: 70),
    PCComponent(id: 'storage2', name: '2TB NVMe SSD', price: 130),
  ];

  static final List<PCComponent> powerSupplies = [
    PCComponent(id: 'psu1', name: '650W Gold', price: 90),
    PCComponent(id: 'psu2', name: '750W Gold', price: 120),
  ];

  static final List<PCComponent> cases = [
    PCComponent(id: 'case1', name: 'NZXT H5', price: 90),
    PCComponent(id: 'case2', name: 'Corsair 4000D', price: 100),
  ];
}

class PCBuilderScreen extends StatefulWidget {
  const PCBuilderScreen({super.key});

  @override
  State<PCBuilderScreen> createState() => _PCBuilderScreenState();
}

class _PCBuilderScreenState extends State<PCBuilderScreen> {
  // Selected components
  PCComponent? selectedCPU;
  PCComponent? selectedMotherboard;
  PCComponent? selectedGPU;
  PCComponent? selectedRAM;
  PCComponent? selectedStorage;
  PCComponent? selectedPowerSupply;
  PCComponent? selectedCase;

  /// Calculate total price of selected components
  double _calculateTotalPrice() {
    double total = 0;
    if (selectedCPU != null) total += selectedCPU!.price;
    if (selectedMotherboard != null) total += selectedMotherboard!.price;
    if (selectedGPU != null) total += selectedGPU!.price;
    if (selectedRAM != null) total += selectedRAM!.price;
    if (selectedStorage != null) total += selectedStorage!.price;
    if (selectedPowerSupply != null) total += selectedPowerSupply!.price;
    if (selectedCase != null) total += selectedCase!.price;
    return total;
  }

  /// Count number of selected components
  int _getComponentCount() {
    int count = 0;
    if (selectedCPU != null) count++;
    if (selectedMotherboard != null) count++;
    if (selectedGPU != null) count++;
    if (selectedRAM != null) count++;
    if (selectedStorage != null) count++;
    if (selectedPowerSupply != null) count++;
    if (selectedCase != null) count++;
    return count;
  }

  /// Show success snackbar when PC build is saved
  void _savePCBuild() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PC Build Saved Successfully'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Build component selector card
  Widget _buildComponentSelector(
    String label,
    IconData icon,
    List<PCComponent> components,
    PCComponent? selectedComponent,
    Function(PCComponent?) onChanged,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PCComponent>(
              initialValue: selectedComponent,
              hint: Text('Select $label'),
              items: components.map((component) {
                return DropdownMenuItem(
                  value: component,
                  child: Text('${component.name} - \$${component.price}'),
                );
              }).toList(),
              onChanged: onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build summary card showing selected components and pricing
  Widget _buildSummaryCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Build Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSummaryItem('Components', '${_getComponentCount()}/7'),
            if (selectedCPU != null)
              _buildSummaryItem('CPU', selectedCPU!.name),
            if (selectedMotherboard != null)
              _buildSummaryItem('Motherboard', selectedMotherboard!.name),
            if (selectedGPU != null)
              _buildSummaryItem('GPU', selectedGPU!.name),
            if (selectedRAM != null)
              _buildSummaryItem('RAM', selectedRAM!.name),
            if (selectedStorage != null)
              _buildSummaryItem('Storage', selectedStorage!.name),
            if (selectedPowerSupply != null)
              _buildSummaryItem('PSU', selectedPowerSupply!.name),
            if (selectedCase != null)
              _buildSummaryItem('Case', selectedCase!.name),
            const Divider(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build individual summary item row
  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PC Builder'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Build Your Perfect PC',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select components to customize your PC build',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          // CPU Selector
          _buildComponentSelector(
            'CPU',
            Icons.memory,
            PCComponentData.cpus,
            selectedCPU,
            (value) => setState(() => selectedCPU = value),
          ),
          // Motherboard Selector
          _buildComponentSelector(
            'Motherboard',
            Icons.memory,
            PCComponentData.motherboards,
            selectedMotherboard,
            (value) => setState(() => selectedMotherboard = value),
          ),
          // GPU Selector
          _buildComponentSelector(
            'GPU',
            Icons.videogame_asset,
            PCComponentData.gpus,
            selectedGPU,
            (value) => setState(() => selectedGPU = value),
          ),
          // RAM Selector
          _buildComponentSelector(
            'RAM',
            Icons.memory,
            PCComponentData.rams,
            selectedRAM,
            (value) => setState(() => selectedRAM = value),
          ),
          // Storage Selector
          _buildComponentSelector(
            'Storage',
            Icons.storage,
            PCComponentData.storages,
            selectedStorage,
            (value) => setState(() => selectedStorage = value),
          ),
          // Power Supply Selector
          _buildComponentSelector(
            'Power Supply',
            Icons.power,
            PCComponentData.powerSupplies,
            selectedPowerSupply,
            (value) => setState(() => selectedPowerSupply = value),
          ),
          // Case Selector
          _buildComponentSelector(
            'Case',
            Icons.folder,
            PCComponentData.cases,
            selectedCase,
            (value) => setState(() => selectedCase = value),
          ),
          const SizedBox(height: 24),
          // Summary Card
          _buildSummaryCard(),
          const SizedBox(height: 16),
          // Build PC Button
          ElevatedButton.icon(
            onPressed: _savePCBuild,
            icon: const Icon(Icons.check),
            label: const Text('Build PC'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
