import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/mock/mock_data.dart';
import '../../../providers/marketplace_provider.dart';

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});
  @override
  State<ProductManagementPage> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementPage> {
  String _search = '';

  List<MockPlant> _getFiltered(BuildContext context) {
    final all = context.watch<MarketplaceProvider>().allPlants;
    return all.where((p) =>
      p.nameBn.contains(_search) || p.name.toLowerCase().contains(_search.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFiltered(context);

    return Scaffold(
      appBar: AppBar(title: const Text('প্রোডাক্ট ম্যানেজমেন্ট')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('গাছ যোগ করুন'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'প্রোডাক্ট খুঁজুন...',
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.primaryGreen),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${filtered.length}টি প্রোডাক্ট', style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _ProductListItem(
                plant: filtered[index],
                onEdit: () => _showAddProductSheet(context, plant: filtered[index]),
                onDelete: () {
                  context.read<MarketplaceProvider>().deleteProduct(filtered[index].id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('প্রোডাক্ট মোছা হয়েছে')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductSheet(BuildContext context, {MockPlant? plant}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _AddProductSheet(plant: plant),
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final MockPlant plant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ProductListItem({required this.plant, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(imageUrl: plant.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plant.nameBn, style: AppTextStyles.h3(context).copyWith(fontSize: 14)),
                const SizedBox(height: 3),
                Row(children: [
                  Text('৳${plant.price.toInt()}', style: AppTextStyles.price(context).copyWith(fontSize: 14)),
                  if (plant.originalPrice != null) ...[
                    const SizedBox(width: 6),
                    Text('৳${plant.originalPrice!.toInt()}', style: AppTextStyles.priceStrikethrough(context)),
                  ],
                ]),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('স্টক: ২৫টি', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'edit', child: Text('সম্পাদনা')),
              PopupMenuItem(
                value: 'delete',
                child: Text('মুছুন', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddProductSheet extends StatefulWidget {
  final MockPlant? plant;
  const _AddProductSheet({this.plant});

  @override
  State<_AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<_AddProductSheet> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant?.nameBn ?? '');
    _priceController = TextEditingController(text: widget.plant != null ? widget.plant!.price.toInt().toString() : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 500.0;
    if (name.isEmpty) return;

    if (widget.plant == null) {
      final newPlant = MockPlant(
        id: 'p_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        nameBn: name,
        imageUrl: 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=400&q=80',
        price: price,
        nurseryName: 'Green Valley Nursery',
        nurseryVerified: true,
        nurseryPremium: true,
        rating: 4.8,
        reviewCount: 1,
        sold: 0,
        category: 'ইনডোর',
        careLevel: 'সহজ',
        sunlight: 'পরোক্ষ আলো',
        water: 'সপ্তাহে একবার',
      );
      context.read<MarketplaceProvider>().addProduct(newPlant);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('নতুন গাছ যোগ করা হয়েছে')),
      );
    } else {
      final updated = MockPlant(
        id: widget.plant!.id,
        name: widget.plant!.name,
        nameBn: name,
        imageUrl: widget.plant!.imageUrl,
        price: price,
        originalPrice: widget.plant!.originalPrice,
        nurseryName: widget.plant!.nurseryName,
        nurseryVerified: widget.plant!.nurseryVerified,
        nurseryPremium: widget.plant!.nurseryPremium,
        rating: widget.plant!.rating,
        reviewCount: widget.plant!.reviewCount,
        sold: widget.plant!.sold,
        category: widget.plant!.category,
        inWishlist: widget.plant!.inWishlist,
        careLevel: widget.plant!.careLevel,
        sunlight: widget.plant!.sunlight,
        water: widget.plant!.water,
      );
      context.read<MarketplaceProvider>().updateProduct(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('গাছের তথ্য আপডেট করা হয়েছে')),
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.plant == null ? 'নতুন গাছ যোগ করুন' : 'গাছ সম্পাদনা করুন',
                style: AppTextStyles.h2(context),
              ),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'গাছের নাম (বাংলা)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'মূল্য (৳)'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _save,
            child: Text(widget.plant == null ? 'যোগ করুন' : 'আপডেট করুন'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}


/// Compatibility typedef
typedef ProductManagementScreen = ProductManagementPage;
