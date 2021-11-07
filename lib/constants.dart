import 'package:flutter/foundation.dart';

const String domain =
    kReleaseMode ? 'https://messman.sagor.pro/' : 'http://10.0.2.2:8000/';
const String baseUrl = domain + 'api/';

class Currency {
  String name;
  String symbol;
  Currency(this.name, this.symbol);
}

List<Currency> currencies = [
  Currency('Taka', '৳'),
  Currency('Dollar', '\$'),
  Currency('Euro', '€'),
  Currency('Pound', '£'),
  Currency('Rupee', '₹'),
  Currency('Rupee', 'Rs'),
  Currency('Rupiah', 'Rp'),
  Currency('Yen', '¥'),
  Currency('Yuan', '元'),
  Currency('Dong', '₫'),
];

const PUSHER_APP_ID = '1023238';
const PUSHER_APP_KEY = '6c275fca4328cef22290';
const PUSHER_APP_SECRET = '480bc59edac47a45fed9';
const PUSHER_APP_CLUSTER = 'ap2';
