// const String baseUrl = 'https://messman.mhsagor.site/api/';
const String baseUrl = 'http://10.0.2.2:8000/api/';
// const String baseUrl = 'http://192.168.0.100:8000/api/';
// const String baseUrl = 'http://127.0.0.1:8000/api/';

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
