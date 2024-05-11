import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../models/quote_model.dart';
import '../services/quotes_service.dart';

class QuotesView extends StatefulWidget {
  const QuotesView({super.key});

  @override
  State<QuotesView> createState() => _QuotesViewState();
}

class _QuotesViewState extends State<QuotesView> {
  List<QuoteModel> quotes = [];
  @override
  void initState() {
    super.initState();
    loadQuotes(); // Call your method to load quotes
    if(quotes.isNotEmpty){
      index=Random().nextInt(quotes.length);
    }
  }

  Future<void> loadQuotes() async {
    final newQuotes = await QuotesService().getQuotes();
    setState(() {
      quotes = newQuotes;
    });
  }
  late int index;
  @override
  Widget build(BuildContext context) {
    if(quotes.isNotEmpty){
      index=Random().nextInt(quotes.length);
    }
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/OIP.jpg'), // Replace with your image path
              fit: BoxFit.cover,
            )),
        child: Center(
          child: quotes.isEmpty
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromRGBO(255, 255, 255, 0.15),
                          ),
                          child: Column(
                            children: [
                              Text(
                                quotes[index].quote,
                                style: const TextStyle(
                                  fontSize: 30,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    quotes[index].author,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(onPressed: (){
                              setState(() {
                                index = Random().nextInt(quotes.length);
                              });
                            }, icon: const Icon(Icons.refresh_rounded)),
                            const SizedBox(width: 20),
                            IconButton(onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: '${quotes[index].quote} - ${quotes[index].author}'));
                            }, icon: const Icon(Icons.copy_rounded)),
                            IconButton(onPressed: (){
                              Share.share('${quotes[index].quote} - ${quotes[index].author}');
                            }, icon: const Icon(Icons.share_rounded)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
