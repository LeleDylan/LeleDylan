import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:puntajepro/domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  static const _productId = 'pro_monthly';
  final InAppPurchase _iap;

  SubscriptionRepositoryImpl(this._iap);

  @override
  Future<bool> isPro() async {
    final pastPurchases = await _iap.queryPastPurchases();
    return pastPurchases.pastPurchases.any((p) => p.productID == _productId);
  }

  @override
  Future<void> purchaseMonthly() async {
    final response = await _iap.queryProductDetails({_productId});
    final detail = response.productDetails.firstWhere((p) => p.id == _productId);
    final purchaseParam = PurchaseParam(productDetails: detail);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }
}
