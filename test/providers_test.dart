import 'package:flutter_test/flutter_test.dart';
import 'package:planthub/features/auth/provider/auth_provider.dart';
import 'package:planthub/features/cart/provider/cart_provider.dart';
import 'package:planthub/features/marketplace/provider/marketplace_provider.dart';
import 'package:planthub/features/marketplace/provider/wishlist_provider.dart';
import 'package:planthub/features/nursery/provider/nursery_provider.dart';

import 'package:planthub/data/mock/mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthProvider Tests', () {
    test('Default role is customer and can switch roles', () {
      final auth = AuthProvider();
      expect(auth.isCustomer, isTrue);
      expect(auth.activeRole, UserRole.customer);

      auth.switchRole(UserRole.nurseryOwner);
      expect(auth.isNurseryOwner, isTrue);
      expect(auth.activeRole, UserRole.nurseryOwner);

      auth.switchRole(UserRole.expert);
      expect(auth.isExpert, isTrue);
    });
  });

  group('CartProvider Tests', () {
    test('Can calculate subtotal, apply coupon, and update quantity', () {
      final cart = CartProvider();
      cart.clearCart();
      expect(cart.isEmpty, isTrue);
      expect(cart.totalItemCount, 0);

      final plant = MockData.plants.first;
      cart.addItem(plant, quantity: 2);
      expect(cart.totalItemCount, 2);
      expect(cart.subtotal, plant.price * 2);

      // Apply coupon GREEN20 (20% off)
      final couponApplied = cart.applyCoupon('GREEN20');
      expect(couponApplied, isTrue);
      expect(cart.discountAmount, cart.subtotal * 0.20);
      expect(cart.grandTotal, (cart.subtotal * 0.80) + cart.deliveryCharge);

      // Remove item
      cart.removeItem(plant.id);
      expect(cart.isEmpty, isTrue);
    });
  });

  group('WishlistProvider Tests', () {
    test('Can toggle plant wishlist status', () {
      final wishlist = WishlistProvider();
      wishlist.clearWishlist();
      expect(wishlist.isEmpty, isTrue);

      final plant = MockData.plants.first;
      wishlist.toggleWishlist(plant);
      expect(wishlist.isWishlisted(plant.id), isTrue);
      expect(wishlist.count, 1);

      wishlist.toggleWishlist(plant);
      expect(wishlist.isWishlisted(plant.id), isFalse);
      expect(wishlist.count, 0);
    });
  });

  group('MarketplaceProvider Tests', () {
    test('Filters by category and sorting', () {
      final mp = MarketplaceProvider();
      expect(mp.allPlants.isNotEmpty, isTrue);

      mp.setCategory('ইনডোর');
      expect(mp.selectedCategory, 'ইনডোর');
      for (final p in mp.filteredPlants) {
        expect(p.category.contains('ইনডোর'), isTrue);
      }

      mp.setSortBy(PlantSortBy.priceLowToHigh);
      final sorted = mp.filteredPlants;
      for (int i = 0; i < sorted.length - 1; i++) {
        expect(sorted[i].price <= sorted[i + 1].price, isTrue);
      }
    });
  });

  group('NurseryProvider Tests', () {
    test('Stock adjustments update inventory reactively', () {
      final nursery = NurseryProvider();
      final firstItem = nursery.inventory.first;
      final initialStock = firstItem.stock;

      nursery.updateStock(firstItem.plant.id, 5);
      expect(nursery.inventory.first.stock, initialStock + 5);

      nursery.updateStock(firstItem.plant.id, -2);
      expect(nursery.inventory.first.stock, initialStock + 3);
    });
  });
}
