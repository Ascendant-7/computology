import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:computology/features/cart/logic/cart_provider.dart';
import 'package:computology/features/catalog/data/product.dart';
import 'package:computology/features/pc_builder/data/pc_component.dart';
import 'package:computology/features/pc_builder/data/pc_component_data.dart';
import 'package:computology/features/pc_builder/logic/compatibility_service.dart';
import 'package:computology/features/pc_builder/presentation/compatibility_result_sheet.dart';

class PCBuilderScreen extends StatefulWidget {
  const PCBuilderScreen({super.key});

  @override
  State<PCBuilderScreen> createState() => _PCBuilderScreenState();
}

class _PCBuilderScreenState extends State<PCBuilderScreen> with SingleTickerProviderStateMixin {
  // Selected components
  PCComponent? selectedCPU;
  PCComponent? selectedMotherboard;
  PCComponent? selectedGPU;
  PCComponent? selectedRAM;
  PCComponent? selectedStorage;
  PCComponent? selectedPowerSupply;
  PCComponent? selectedCase;

  CompatibilityResult? _lastResult;
  final CompatibilityService _compatibilityService = CompatibilityService();

  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

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

  bool get _hasAnySelection => _getComponentCount() > 0;

  void _checkCompatibility() {
    final result = _compatibilityService.checkCompatibility(
      cpu: selectedCPU,
      motherboard: selectedMotherboard,
      gpu: selectedGPU,
      ram: selectedRAM,
      storage: selectedStorage,
      psu: selectedPowerSupply,
      pcCase: selectedCase,
    );

    setState(() => _lastResult = result);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CompatibilityResultSheet(result: result),
    );
  }

  List<PCComponent> _getSelectedComponents() {
    return [
      ?selectedCPU,
      ?selectedMotherboard,
      ?selectedGPU,
      ?selectedRAM,
      ?selectedStorage,
      ?selectedPowerSupply,
      ?selectedCase,
    ];
  }

  String _buildName() {
    if (selectedCPU != null) {
      return '${selectedCPU!.name} PC Build';
    }
    return 'Custom PC Build';
  }

  String _buildImageUrl() {
    return 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=400&q=80';
  }

  Product _buildPCProduct() {
    final components = _getSelectedComponents();
    final double total = _calculateTotalPrice();

    return Product(
      id: 'pc_build_${DateTime.now().millisecondsSinceEpoch}',
      name: _buildName(),
      imageUrl: _buildImageUrl(),
      price: total,
      rating: 0.0,
      category: 'PC Builder',
      description: components.map((c) => '• ${c.name} — \$${c.price.toStringAsFixed(2)}').join('\n'),
      specs: {
        for (final c in components)
          c.category[0].toUpperCase() + c.category.substring(1): c.name,
      },
      tags: ['PC_BUILDER'],
    );
  }

  void _savePCBuild() {
    final components = _getSelectedComponents();
    if (components.isEmpty) return;

    final cart = context.read<CartProvider>();
    cart.addProduct(_buildPCProduct());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('PC Build added to cart!'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () => context.push('/cart'),
        ),
      ),
    );
  }

  void _onSelectionChanged() {
    setState(() => _lastResult = null);
  }

  void _openComponentPicker(String label, List<PCComponent> components, PCComponent? currentSelection, ValueChanged<PCComponent?> onSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ComponentPickerSheet(
        label: label,
        components: components,
        currentSelection: currentSelection,
        onSelected: (comp) {
          onSelected(comp);
          _onSelectionChanged();
        },
      ),
    );
  }

  Widget _buildAnimatedSlot(int index, Widget child) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
          ),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canSave = _lastResult != null && _lastResult!.isCompatible;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PC Builder'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 200), // padding for bottom panel
            children: [
              Text(
                'Build Your Perfect PC',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Select components to customize your PC build',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              _buildAnimatedSlot(0, _ComponentSlot(
                label: 'CPU',
                icon: Icons.memory,
                selectedComponent: selectedCPU,
                onTap: () => _openComponentPicker('CPU', PCComponentData.cpus, selectedCPU, (v) => setState(() => selectedCPU = v)),
              )),
              _buildAnimatedSlot(1, _ComponentSlot(
                label: 'Motherboard',
                icon: Icons.developer_board,
                selectedComponent: selectedMotherboard,
                onTap: () => _openComponentPicker('Motherboard', PCComponentData.motherboards, selectedMotherboard, (v) => setState(() => selectedMotherboard = v)),
              )),
              _buildAnimatedSlot(2, _ComponentSlot(
                label: 'GPU',
                icon: Icons.videogame_asset,
                selectedComponent: selectedGPU,
                onTap: () => _openComponentPicker('GPU', PCComponentData.gpus, selectedGPU, (v) => setState(() => selectedGPU = v)),
              )),
              _buildAnimatedSlot(3, _ComponentSlot(
                label: 'RAM',
                icon: Icons.sd_storage,
                selectedComponent: selectedRAM,
                onTap: () => _openComponentPicker('RAM', PCComponentData.rams, selectedRAM, (v) => setState(() => selectedRAM = v)),
              )),
              _buildAnimatedSlot(4, _ComponentSlot(
                label: 'Storage',
                icon: Icons.storage,
                selectedComponent: selectedStorage,
                onTap: () => _openComponentPicker('Storage', PCComponentData.storages, selectedStorage, (v) => setState(() => selectedStorage = v)),
              )),
              _buildAnimatedSlot(5, _ComponentSlot(
                label: 'Power Supply',
                icon: Icons.power,
                selectedComponent: selectedPowerSupply,
                onTap: () => _openComponentPicker('Power Supply', PCComponentData.powerSupplies, selectedPowerSupply, (v) => setState(() => selectedPowerSupply = v)),
              )),
              _buildAnimatedSlot(6, _ComponentSlot(
                label: 'Case',
                icon: Icons.computer,
                selectedComponent: selectedCase,
                onTap: () => _openComponentPicker('Case', PCComponentData.cases, selectedCase, (v) => setState(() => selectedCase = v)),
              )),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BuildSummaryPanel(
              totalPrice: _calculateTotalPrice(),
              componentCount: _getComponentCount(),
              canSave: canSave,
              hasAnySelection: _hasAnySelection,
              lastResult: _lastResult,
              onCheckCompatibility: _checkCompatibility,
              onSavePCBuild: _savePCBuild,
              cpu: selectedCPU,
              gpu: selectedGPU,
              ram: selectedRAM,
              storage: selectedStorage,
              psu: selectedPowerSupply,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentSlot extends StatelessWidget {
  const _ComponentSlot({
    required this.label,
    required this.icon,
    required this.selectedComponent,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final PCComponent? selectedComponent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = selectedComponent != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? colorScheme.primary.withValues(alpha: 0.3) : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: isSelected ? colorScheme.primaryContainer : colorScheme.surfaceContainerHighest,
                child: Icon(
                  icon,
                  color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                  child: isSelected
                      ? Column(
                          key: const ValueKey('selected'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 2),
                            Text(selectedComponent!.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('\$${selectedComponent!.price.toStringAsFixed(2)}', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600)),
                          ],
                        )
                      : Column(
                          key: const ValueKey('empty'),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text('Tap to select', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                          ],
                        ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: isSelected
                    ? const Icon(Icons.check_circle, color: Colors.green, key: ValueKey('check'))
                    : Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant, key: const ValueKey('chevron')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ComponentPickerSheet extends StatefulWidget {
  const _ComponentPickerSheet({
    required this.label,
    required this.components,
    required this.currentSelection,
    required this.onSelected,
  });

  final String label;
  final List<PCComponent> components;
  final PCComponent? currentSelection;
  final ValueChanged<PCComponent?> onSelected;

  @override
  State<_ComponentPickerSheet> createState() => _ComponentPickerSheetState();
}

class _ComponentPickerSheetState extends State<_ComponentPickerSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredComponents = widget.components.where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Select ${widget.label}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search components...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredComponents.isEmpty
                    ? Center(child: Text('No components found.', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant)))
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredComponents.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final comp = filteredComponents[index];
                          final isSelected = widget.currentSelection?.id == comp.id;

                          return Card(
                            elevation: isSelected ? 2 : 0,
                            color: isSelected ? colorScheme.primaryContainer.withValues(alpha: 0.3) : colorScheme.surfaceContainerLow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? colorScheme.primary : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                widget.onSelected(comp);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(comp.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                                        ),
                                        Text('\$${comp.price.toStringAsFixed(2)}', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        if (comp.socket != null) _SpecChip(label: comp.socket!),
                                        if (comp.formFactor != null) _SpecChip(label: comp.formFactor!),
                                        if (comp.ramType != null) _SpecChip(label: comp.ramType!),
                                        if (comp.tdpWatts != null) _SpecChip(label: '${comp.tdpWatts}W TDP'),
                                        if (comp.psuCapacityWatts != null) _SpecChip(label: '${comp.psuCapacityWatts}W'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

class _BuildSummaryPanel extends StatelessWidget {
  const _BuildSummaryPanel({
    required this.totalPrice,
    required this.componentCount,
    required this.canSave,
    required this.hasAnySelection,
    required this.lastResult,
    required this.onCheckCompatibility,
    required this.onSavePCBuild,
    this.cpu,
    this.gpu,
    this.ram,
    this.storage,
    this.psu,
  });

  final double totalPrice;
  final int componentCount;
  final bool canSave;
  final bool hasAnySelection;
  final CompatibilityResult? lastResult;
  final VoidCallback onCheckCompatibility;
  final VoidCallback onSavePCBuild;
  
  final PCComponent? cpu;
  final PCComponent? gpu;
  final PCComponent? ram;
  final PCComponent? storage;
  final PCComponent? psu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Bottom padding for safe area
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Price', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: totalPrice),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Text('\$${value.toStringAsFixed(2)}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary));
                      },
                    ),
                  ],
                ),
                if (lastResult != null) _CompatibilityBadge(result: lastResult!),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Components', style: theme.textTheme.bodySmall),
                          Text('$componentCount/7', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: componentCount / 7.0,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _PowerBar(cpu: cpu, gpu: gpu, ram: ram, storage: storage, psu: psu),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: hasAnySelection ? onCheckCompatibility : null,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Check Compatibility'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: canSave ? onSavePCBuild : null,
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text('Build PC'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PowerBar extends StatelessWidget {
  const _PowerBar({this.cpu, this.gpu, this.ram, this.storage, this.psu});
  
  final PCComponent? cpu;
  final PCComponent? gpu;
  final PCComponent? ram;
  final PCComponent? storage;
  final PCComponent? psu;

  @override
  Widget build(BuildContext context) {
    int totalTdp = 0;
    if (cpu?.tdpWatts != null) totalTdp += cpu!.tdpWatts!;
    if (gpu?.tdpWatts != null) totalTdp += gpu!.tdpWatts!;
    if (ram?.tdpWatts != null) totalTdp += ram!.tdpWatts!;
    if (storage?.tdpWatts != null) totalTdp += storage!.tdpWatts!;
    
    final int psuCapacity = psu?.psuCapacityWatts ?? 0;
    
    double ratio = 0;
    if (psuCapacity > 0) {
      ratio = (totalTdp / psuCapacity).clamp(0.0, 1.0);
    }
    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    Color barColor = colorScheme.primary;
    if (psuCapacity > 0) {
      if (ratio > 0.9) {
        barColor = colorScheme.error;
      } else if (ratio > 0.8) {
        barColor = Colors.orange;
      } else {
        barColor = Colors.green;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Power', style: theme.textTheme.bodySmall),
            Text('${totalTdp}W${psuCapacity > 0 ? ' / ${psuCapacity}W' : ''}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: psuCapacity > 0 ? ratio : (totalTdp > 0 ? 1.0 : 0.0),
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(psuCapacity == 0 && totalTdp > 0 ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5) : barColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _CompatibilityBadge extends StatelessWidget {
  const _CompatibilityBadge({required this.result});

  final CompatibilityResult result;

  @override
  Widget build(BuildContext context) {
    final bool ok = result.isCompatible;
    final Color color = ok ? Colors.green : Theme.of(context).colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.error,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            ok ? 'Compatible' : 'Incompatible',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
