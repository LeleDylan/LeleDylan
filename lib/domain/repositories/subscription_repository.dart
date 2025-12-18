abstract class SubscriptionRepository {
  Future<bool> isPro();
  Future<void> purchaseMonthly();
}
