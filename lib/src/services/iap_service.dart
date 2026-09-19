import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// StoreKit products. The subscription group and every product must be
/// created in App Store Connect with exactly these IDs:
///   - Subscriptions (group "DayZero Premium"): weekly / monthly / yearly
///   - Non-consumable: lifetime
const kProductIds = {
  'dayzero_weekly',
  'dayzero_monthly',
  'dayzero_yearly',
  'dayzero_lifetime',
};

/// Thin StoreKit 2 wrapper with an injectable "is Web" flag so the Edge demo
/// runs without IAP (demo mode unlocks premium there).
class IapService {
  IapService({this.enabled = !kIsWeb});

  /// False on the web demo: purchase calls become no-ops.
  final bool enabled;

  StreamSubscription<List<PurchaseDetails>>? _sub;
  List<ProductDetails> _products = [];
  bool _initialized = false;

  final Map<String, ProductDetails> products = {};

  bool get isInitialized => _initialized;

  /// Called once after the app boots. Idempotent, safe on web.
  Future<void> init() async {
    if (!enabled || _initialized) return;
    try {
      final available = await InAppPurchase.instance.isAvailable();
      if (!available) return;
      _sub = InAppPurchase.instance.purchaseStream.listen(_onPurchases);
      final response = await InAppPurchase.instance
          .queryProductDetails(kProductIds);
      _products = response.productDetails;
      for (final p in _products) {
        products[p.id] = p;
      }
      _initialized = true;
    } catch (e) {
      debugPrint('IapService.init failed: $e');
    }
  }

  void _onPurchases(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _onGranted(purchase.productID);
          InAppPurchase.instance.completePurchase(purchase);
        case PurchaseStatus.pending:
        case PurchaseStatus.error:
        case PurchaseStatus.canceled:
          break;
      }
    }
  }

  /// Fired when a purchase or restore grants premium. Callers re-assign it to
  /// update AppState; kept as a plain callback to avoid a service->state
  /// dependency cycle.
  void Function(String productId)? onGranted;

  void _onGranted(String productId) {
    onGranted?.call(productId);
  }

  /// Buys the non-consumable lifetime unlock; returns false when unavailable
  /// (e.g. web demo).
  Future<bool> buyLifetime() async {
    if (!enabled) return false;
    final product = products['dayzero_lifetime'];
    if (product == null) return false;
    try {
      await InAppPurchase.instance
          .buyNonConsumable(purchaseParam: PurchaseParam(productDetails: product));
      return true;
    } catch (e) {
      debugPrint('IapService.buyLifetime failed: $e');
      return false;
    }
  }

  /// Buys one of the subscription tiers. in_app_purchase 3.x routes
  /// subscriptions through the same StoreKit entry point as non-consumables.
  Future<bool> buySubscription(String productId) async {
    if (!enabled) return false;
    final product = products[productId];
    if (product == null) return false;
    try {
      await InAppPurchase.instance.buyNonConsumable(
          purchaseParam: PurchaseParam(productDetails: product));
      return true;
    } catch (e) {
      debugPrint('IapService.buySubscription failed: $e');
      return false;
    }
  }

  Future<void> restore() async {
    if (!enabled) return;
    try {
      await InAppPurchase.instance.restorePurchases();
    } catch (e) {
      debugPrint('IapService.restore failed: $e');
    }
  }

  /// Localized display price for a product, or null when not loaded.
  String? priceFor(String productId) => products[productId]?.price;

  void dispose() {
    _sub?.cancel();
  }
}
