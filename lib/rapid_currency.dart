import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'currency_model.dart';

class RapidCurrencyScreen extends StatefulWidget {
  const RapidCurrencyScreen({Key? key}) : super(key: key);

  @override
  State<RapidCurrencyScreen> createState() => _RapidCurrencyScreenState();
}

class _RapidCurrencyScreenState extends State<RapidCurrencyScreen> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  CurrencyModel? conversionData; // Updated: CurrencyModel instance
  double? amount;
  double? conversionRate;
  String fromCurrency = '';
  String toCurrency = '';

  Future<void> fetchConversionRate() async {
    String input = fromController.text;

    List<String> inputParts = input.split(' ');
    amount = double.tryParse(inputParts[0]) ?? 0.0;
    fromCurrency = inputParts[1].toUpperCase();
    toCurrency = toController.text.toUpperCase();

    final String apiUrl =
        'https://currency-converter241.p.rapidapi.com/conversion_rate?from=$fromCurrency&to=$toCurrency';

    final Map<String, String> headers = {
      'X-Rapidapi-Key': 'daa335f7c2mshe795d2cc15128bep1834d8jsn0e278208d758',
      'X-Rapidapi-Host': 'currency-converter241.p.rapidapi.com',
      'Host': 'currency-converter241.p.rapidapi.com',
    };

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      conversionRate = responseData['rate'];

      setState(() {
        conversionData = CurrencyModel(
          rate: conversionRate,
          from: From(rate: amount!.toInt(), currency: fromCurrency),
          to: To(
              rate: (amount! * conversionRate!).toDouble(), currency: toCurrency),
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<void> sendData() async {
    try {
      if (conversionData != null) {
        Map<String, dynamic> currencyData = conversionData!.toJson();

        String uid = DateTime.now().millisecondsSinceEpoch.toString();
        String collectionName = "currency";

        String documentPath = '$collectionName/$uid';
        await FirebaseFirestore.instance.doc(documentPath).set(currencyData);
        print("Data sent successfully");
      }
    } catch (e) {
      print("Error sending data: $e");
      throw e.toString();
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Currency Converter",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Currency Converter"),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: fromController,
                    decoration: InputDecoration(
                      hintText: "From Country Currency",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: toController,
                    decoration: InputDecoration(
                      hintText: "To Country Currency",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async{
                    fetchConversionRate();
                  await  sendData();
                  },
                  child: Text("Convert"),
                ),
                SizedBox(
                  height: 20,
                ),
                if (conversionData != null)
                  Text(
                    'Conversion Result: ${conversionData!.to!.rate}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
