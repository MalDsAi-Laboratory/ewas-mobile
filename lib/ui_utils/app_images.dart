import 'package:flutter/foundation.dart' show kReleaseMode;

/// Returns a URL that works in both local dev and production.
/// In local dev, falls back to Unsplash placeholder images.
/// In production, uses the real ewas media server.
class AppImages {
  static const String _prodBase = 'http://ewas.maldsai.com:8080/myapp';

  /// Banner carousel images shown on home screen
  static List<String> get homeBanner => kReleaseMode
      ? [
          '$_prodBase/home_banner/1.webp',
          '$_prodBase/home_banner/2.webp',
          '$_prodBase/home_banner/3.webp',
        ]
      : [
          'https://images.unsplash.com/photo-1518770660439-4636190af475?w=800',
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
          'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=800',
        ];

  /// Seller home — Sell E-Waste carousel
  static List<String> get sellEwaste => kReleaseMode
      ? [
          '$_prodBase/sellewaste/2.jpg',
          '$_prodBase/sellewaste/1.jpg',
        ]
      : [
          'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=800',
          'https://images.unsplash.com/photo-1605600659908-0ef719419d41?w=800',
        ];

  /// Seller home — View Orders carousel
  static List<String> get viewOrders => kReleaseMode
      ? ['$_prodBase/vieworders/1.jpg']
      : ['https://images.unsplash.com/photo-1542744094-3a31f272c490?w=800'];

  /// Seller/Recycler home — Buy Recycled Items carousel
  static List<String> get buyRecycled => kReleaseMode
      ? [
          '$_prodBase/buyrecycled/1.jpg',
          '$_prodBase/buyrecycled/2.jpg',
        ]
      : [
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
          'https://images.unsplash.com/photo-1497436072909-60f360e1d4b1?w=800',
        ];

  /// Recycler home — Find E-Waste carousel
  static List<String> get findEwaste => kReleaseMode
      ? [
          '$_prodBase/findewaste/1.jpg',
          '$_prodBase/findewaste/2.jpg',
        ]
      : [
          'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?w=800',
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=800',
        ];

  /// Recycler home — Update Price carousel
  static List<String> get updatePrice => kReleaseMode
      ? [
          '$_prodBase/updateprice/1.jpg',
          '$_prodBase/updateprice/2.jpg',
        ]
      : [
          'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=800',
          'https://images.unsplash.com/photo-1589758438368-0ad531db3366?w=800',
        ];
}
