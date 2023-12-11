// TODO Implement this library.import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:http/http.dart' as http;
import 'package:iyzico/pages/webview_page.dart';
import 'package:iyzico/const.dart';

class CreditCardPage extends StatefulWidget {
  const CreditCardPage({super.key});

  @override
  State<CreditCardPage> createState() => _CreditCardPageState();
}

class _CreditCardPageState extends State<CreditCardPage> {
  var cardNumber2 = '';
  var expiryDate = '';
  var cardHolderName = '';
  var cvvCode = '';
  var isCvvFocused = false;
  final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
          padding: EdgeInsets.only(top: size.height*0.07),
          child: Column(
            children: [
              buildCreditCardWidget(),
              buildCreditCardForm(),
              buildPayButton(size)
            ],
          ),
        )

      ),
    );
  }

  Padding buildPayButton(Size size) {
    return Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onTap: () async {
                  if (cardNumber2.length == 19 &&
                      cvvCode.length <= 4 &&
                      cardHolderName !='' &&
                      expiryDate.length == 5){
                    cardNumber2 = cardNumber2.replaceAll(' ', '');
                    var expireMonth = expiryDate.split('/')[0];
                    var expireYear =  '20'+ expiryDate.split('/')[1];
                    var body = {
                      'cardHolderName':cardHolderName,
                      'cardNumber':cardNumber,
                      'expireMonth':expireMonth,
                      'expireYear':expireYear,
                      'cvc': cvvCode,

                    };
                    var res = await http.post(Uri.parse('http://10.0.2.2:3000/api/iyzico/pay'),
                        body: json.encode(body),
                        headers: {'Content-Type': 'application/json'});
                    var data = json.decode(res.body);
                    if(res.statusCode == 200){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>WebViewPage(htmlCode:data['page'])));
                      //print('Ýþlem baþarýlý');

                    }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(data),
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.red,
                            ));

                      //print('iþlem baþarýsýz');

                    }
                    //fonksiyon(cardNumber,cvvCode,cardHolderName,expireMonth,expireYear)
                    // print('Basarili $(cardNumber.length)';
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lütfen tüm degerleri doldurunuz'),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.red,));
                  }

                  //print(cardNumber);
                  //print(cardHolderName);
                  //print(cvvCode);
                  //print(expireYear);
                  //print(expireMonth);
                },
                child: Container(
                  width: size.width,
                  height: size.height * 0.06,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.shade900,
                  ),
                  child:const Text('Odeme Yap',style: TextStyle(fontSize: 16, color:Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            );
  }

  CreditCardForm buildCreditCardForm() {
    return CreditCardForm(
              cardNumber: cardNumber2,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              formKey: formKey, // Required
              onCreditCardModelChange: (CreditCardModel data) {
                setState(() {
                  cardHolderName = data.cardHolderName;
                  cardNumber2 = data.cardNumber;
                  expiryDate = data.expiryDate;
                  isCvvFocused = data.isCvvFocused;
                  if(data.cvvCode.length <= 3){
                    cvvCode = data.cvvCode;

                  }
                });


              }, // Required
              obscureCvv: true,
              obscureNumber: true,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              enableCvv: true,
              cvvValidationMessage: 'Please input a valid CVV',
              dateValidationMessage: 'Please input a valid date',
              numberValidationMessage: 'Please input a valid number',
              cardNumberValidator: (String? cardNumber){},
              expiryDateValidator: (String? expiryDate){},
              cvvValidator: (String? cvv){},
              cardHolderValidator: (String? cardHolderName){},
              onFormComplete: () {
                // callback to execute at the end of filling card data
              },
              autovalidateMode: AutovalidateMode.always,
              disableCardNumberAutoFillHints: false,
              inputConfiguration: const InputConfiguration(
                cardNumberDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                ),
                cardNumberTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
                cardHolderTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
                expiryDateTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
                cvvCodeTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
            );
  }

  CreditCardWidget buildCreditCardWidget() {
    return CreditCardWidget(
              cardNumber: cardNumber2,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              isHolderNameVisible: true,
              showBackView: isCvvFocused, //true when you want to show cvv(back) view
              onCreditCardWidgetChange: (CreditCardBrand brand) {}, // Callback for anytime credit card brand is changed
            );
  }
}
