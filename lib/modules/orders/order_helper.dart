enum OrderStatus {
  orderPlaced('Order placed'),
  biddingStarted('Bidding Started'),
  biddingInProgress('Bidding In Progress'),
  biddingCompleted('Bidding Completed'),
  awaitingForPick('Awaiting for pick'),
  orderCollected('Order Collected'),
  deliveredToWarehouse('Delivered to warehouse'),
  deliveredForRecycle('Delivered for Recycle'),
  biddingRejected('Bidding Rejected'),
  completed('Completed');

  final String value;
  const OrderStatus(this.value);

  /// Safely parse a backend string to an [OrderStatus].
  /// Returns null for unknown / null strings instead of throwing.
  static OrderStatus? fromString(String? s) {
    if (s == null) return null;
    for (final status in OrderStatus.values) {
      if (status.value == s) return status;
    }
    return null;
  }
}
