import 'package:dio/dio.dart';
import 'package:qoute_generator_app/models/quote_model.dart';

class QuotesService {
  final dio = Dio();

  Future<List<QuoteModel>> getQuotes() async {
    try {
      final response = await dio.get('https://zenquotes.io/api/quotes/');
      List<dynamic> data = response.data;
      List<QuoteModel> quotes = [];
      for (var item in data) {
        QuoteModel quote = QuoteModel(
          quote: item['q'],
          author: item['a'],
        );
        quotes.add(quote);
      }
      return quotes;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
