import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'algorithmes.dart';

// Fonction servant à connaître la couleur à afficher en fonction du résultat
Color getColor(bool isValid){
  if(isValid == false){
    return Colors.red;
  }else return Colors.green;
}

// Fonction servant à afficher le bon texte en fonction du résultat
String validite(bool isValid){
  if(isValid == false){
    return "Invalide";
  }else return "Valide";
}

// Fonction principale du programme
void main() => runApp(MyApp());

// Classe de départ pour afficher l'application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = "Validité d'un identifiant";

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget{
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /// On définit les contrôleurs de texte et de formulaire
  final inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// On définit les expressions régulières pour chaque type d'identifiants
  static Pattern patternIMEI = r"^[0-9]{15}$";
  static RegExp regexIMEI = new RegExp(patternIMEI.toString());
  static Pattern patternBankCard = r"^[0-9]{16}$";
  static RegExp regexBankCard = new RegExp(patternBankCard.toString());
  static Pattern patternSiren = r"^[0-9]{9}$";
  static RegExp regexSiren = new RegExp(patternSiren.toString());
  static Pattern patternSiret = r"^[0-9]{14}$";
  static RegExp regexSiret = new RegExp(patternSiret.toString());
  static Pattern patternEAN8 = r"^[0-9]{8}$";
  static RegExp regexEAN8 = new RegExp(patternEAN8.toString());
  static Pattern patternEAN13 = r"^[0-9]{13}$";
  static RegExp regexEAN13 = new RegExp(patternEAN13.toString());
  static Pattern patternISBN = r"^[0-9]{9}[0-9X]$";
  static RegExp regexISBN = new RegExp(patternISBN.toString());
  static Pattern patternNIR = r"^[0-9]{15}$";
  static RegExp regexNIR = new RegExp(patternNIR.toString());
  static Pattern patternRIB = r"^[0-9]{10}[0-9A-Z]{11}[0-9]{2}";
  static RegExp regexRIB = new RegExp(patternRIB.toString());
  static Pattern patternIBAN = r"[A-Z]{2}[0-9]{2}[0-9A-Z]{0,30}";
  static RegExp regexIBAN = new RegExp(patternIBAN.toString());
  static Pattern patternTVAIntraCommunautaire = r"FR[0-9]{11}";
  static RegExp regexTVAIntraCommunautaire = new RegExp(patternTVAIntraCommunautaire.toString());
  static Pattern patternISSN = r"[0-9]{8}";
  static RegExp regexISSN = new RegExp(patternISSN.toString());
  static Pattern patternISWC = r"T[0-9]{10}";
  static RegExp regexISWC = new RegExp(patternISWC.toString());
  static Pattern patternICCID = r"89[0-9]{17,18}";
  static RegExp regexICCID = new RegExp(patternICCID.toString());
  static Pattern patterneID = r"89[0-9]{30}";
  static RegExp regexeID = new RegExp(patterneID.toString());
  static Pattern patternISMNPre2009 = r"M[0-9]{9}";
  static RegExp regexISMNPre2009 = new RegExp(patternISMNPre2009.toString());
  static Pattern patternISMNPost2009 = r"9790[0-9]{9}";
  static RegExp regexISMNPost2009 = new RegExp(patternISMNPost2009.toString());

  bool showResult = false; /// Booléen pour afficher le résultat ou non
  String inputNumber = ""; /// Numéro entré
  bool isValid = false; /// Booléen pour savoir si le numéro entré est valide ou non

  /// Variables d'affichage de l'application
  String? _radioValue = "";
  String _displayStartText = "";
  String _displayInputText = "";
  String _displayErrorText = "";

  /// On initialise l'état de l'application
  void initState(){
    _handleRadioValueChange(_radioValue);
    super.initState();
  }

  /// Lorsqu'on clique sur le bouton effacer
  void _erase(){
    setState((){
      showResult = false;
      inputController.text = "";
    });
  }

  /// Lorsqu'on clique sur le bouton valider
  void _validate(){
    if(_formKey.currentState!.validate()){
      setState(() {
        inputNumber = inputController.text;
        switch(_radioValue){
          case "IMEI":
            isValid = algorithmeLuhn(inputNumber);
            break;
          case "ICCID":
            if(inputNumber.length == 20){ // On supprime l'éventuel caractère de bourrage mis par les opérateurs
              isValid = algorithmeLuhn(inputNumber.substring(0,inputNumber.length-1));
            }else if(inputNumber.length == 19){
              isValid = algorithmeLuhn(inputNumber);
            }
            break;
          case "carteBancaire":
            isValid = algorithmeLuhn(inputNumber);
            break;
          case "SIREN":
            isValid = algorithmeLuhn(inputNumber);
            break;
          case "SIRET":
            if(inputNumber.startsWith("356000000")){
              isValid = algorithmeSiretLaPoste(inputNumber);
            }else{
              isValid = algorithmeLuhn(inputNumber);
            }
            break;
          case "NIR":
            isValid = algorithmeNIR(inputNumber);
            break;
          case "RIB":
            isValid = algorithmeRIB(inputNumber);
            break;
          case "IBAN":
            isValid = algorithmeIBAN(inputNumber);
            break;
          case "EAN8":
            isValid = algorithmeEAN8(inputNumber);
            break;
          case "EAN13":
            isValid = algorithmeEAN13(inputNumber);
            break;
          case "ISBN":
            isValid = algorithmeISBN(inputNumber);
            break;
          case "ISSN":
            isValid = algorithmeISSN(inputNumber);
            break;
          case "TVAIntra":
            isValid = algorithmeTVAIntraCommunautaire(inputNumber);
            break;
          case "ISWC":
            isValid = algorithmeISWC(inputNumber);
            break;
          case "eID":
            isValid = algorithmeEID(inputNumber);
            break;
          case "ISMN_pre_2009":
            isValid = algorithmeISMN_pre2009(inputNumber);
            break;
          case "ISMN_post_2009":
            isValid = algorithmeISMN_post2009(inputNumber);
            break;
        }
        showResult = true;
      });
    }else{
      setState((){
        showResult = false;
      });
    }
  }

  /// Lorsqu'un bouton radio est modifié
  void _handleRadioValueChange(String? value){
    setState((){
      _radioValue = value;
      showResult = false;

      switch(_radioValue){
        case "IMEI":
          _displayStartText = "Entrez un numéro IMEI";
          _displayInputText = "Numéro IMEI";
          _displayErrorText = "Entrez un numéro IMEI au format valide";
          break;
        case "ICCID":
          _displayStartText = "Entrez un numéro de carte SIM";
          _displayInputText = "Numéro ICCID";
          _displayErrorText = "Entrez un numéro de carte SIM (ICCID) au format valide";
          break;
        case "carteBancaire":
          _displayStartText = "Entrez un numéro de carte bancaire";
          _displayInputText = "Numéro de carte bancaire";
          _displayErrorText = "Entrez un numéro de carte bancaire au format valide";
          break;
        case "SIREN":
          _displayStartText = "Entrez un numéro SIREN";
          _displayInputText = "Numéro SIREN";
          _displayErrorText = "Entrez un numéro SIREN au format valide";
          break;
        case "SIRET":
          _displayStartText = "Entrez un numéro SIRET";
          _displayInputText = "Numéro SIRET";
          _displayErrorText = "Entrez un numéro SIRET au format valide";
          break;
        case "EAN8":
          _displayStartText = "Entrez un numéro EAN";
          _displayInputText = "Numéro EAN";
          _displayErrorText = "Entrez un numéro EAN au format valide";
          break;
        case "EAN13":
          _displayStartText = "Entrez un numéro EAN";
          _displayInputText = "Numéro EAN";
          _displayErrorText = "Entrez un numéro EAN au format valide";
          break;
        case "ISBN":
          _displayStartText = "Entrez un numéro ISBN";
          _displayInputText = "Numéro ISBN";
          _displayErrorText = "Entrez un numéro ISBN au format valide";
          break;
        case "NIR":
          _displayStartText = "Entrez un numéro NIR";
          _displayInputText = "Numéro NIR";
          _displayErrorText = "Entrez un numéro NIR au format valide";
          break;
        case "RIB":
          _displayStartText = "Entrez un RIB";
          _displayInputText = "RIB";
          _displayErrorText = "Entrez un RIB au format valide";
          break;
        case "IBAN":
          _displayStartText = "Entrez un IBAN";
          _displayInputText = "IBAN";
          _displayErrorText = "Entrez un IBAN au format valide";
          break;
        case "ISSN":
          _displayStartText = "Entrez un ISSN";
          _displayInputText = "ISSN";
          _displayErrorText = "Entrez un ISSN au format valide";
          break;
        case "TVAIntra":
          _displayStartText = "Entrez un numéro de TVA intracommunautaire français";
          _displayInputText = "Numéro TVA intracommunautaire";
          _displayErrorText = "Entrez un numéro TVA intracommunautaire français au format valide";
          break;
        case "ISWC":
          _displayStartText = "Entrez un ISWC";
          _displayInputText = "ISWC";
          _displayErrorText = "Entrez un ISWC au format valide";
          break;
        case "eID":
          _displayStartText = "Entrez un eID";
          _displayInputText = "eID";
          _displayErrorText = "Entrez un eID au format valide";
          break;
        case "ISMN_pre_2009":
          _displayStartText = "Entrez un ISMN";
          _displayInputText = "ISMN";
          _displayErrorText = "Entrez un ISMN au format valide";
          break;
        case "ISMN_post_2009":
          _displayStartText = "Entrez un ISMN";
          _displayInputText = "ISMN";
          _displayErrorText = "Entrez un ISMN au format valide";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Identifiants bancaires",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(
                    value: "carteBancaire",
                    groupValue: _radioValue,
                    activeColor: Colors.blue,
                    onChanged: (String? value) {
                      _handleRadioValueChange(value);
                    }
                  ),
                  Text("Carte bancaire"),
                  Radio(
                      value: "RIB",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("RIB"),
                  Radio(
                      value: "IBAN",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("IBAN"),
                  Radio(
                      value: "TVAIntra",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("TVA Intracommunautaire"),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Idenfiants INSEE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(
                      value: "SIREN",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("SIREN"),
                  Radio(
                      value: "SIRET",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("SIRET"),
                  Radio(
                      value: "NIR",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("NIR"),
                ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Identifiants d'objets",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Radio(
                      value: "IMEI",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("IMEI"),
                  Radio(
                      value: "ICCID",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("ICCID"),
                  Radio(
                      value: "eID",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("eID"),
                  Radio(
                      value: "EAN8",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("EAN8"),
                  Radio(
                      value: "EAN13",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("EAN13"),
                  Radio(
                      value: "ISBN",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("ISBN"),
                  Radio(
                      value: "ISSN",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("ISSN"),
                  Radio(
                      value: "ISWC",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("ISWC"),
                  Radio(
                      value: "ISMN_pre_2009",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("ISMN (avant 2009)"),
                  Radio(
                      value: "ISMN_post_2009",
                      groupValue: _radioValue,
                      activeColor: Colors.blue,
                      onChanged: (String? value) {
                        _handleRadioValueChange(value);
                      }
                  ),
                  Text("ISMN (après 2009)"),
                ]),
            Text(_displayStartText),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: inputController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9A-Z]'))],
                    decoration: InputDecoration(
                        labelText: _displayInputText
                    ),
                    validator: (value){
                      if(value != null) {
                        if (value.isEmpty) {
                          return _displayStartText;
                        } else if (_radioValue == "IMEI" && !regexIMEI.hasMatch(value)) {
                          return _displayErrorText;
                        } else if (_radioValue == "ICCID" && !regexICCID.hasMatch(value)) {
                          return _displayErrorText;
                        } else if (_radioValue == "eID" && !regexeID.hasMatch(value)) {
                          return _displayErrorText;
                        } else if (_radioValue == "carteBancaire" && !regexBankCard.hasMatch(value)) {
                          return _displayErrorText;
                        } else if (_radioValue == "SIREN" && !regexSiren.hasMatch(value)) {
                          return _displayErrorText;
                        } else if (_radioValue == "SIRET" && !regexSiret.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "IBAN" && !regexIBAN.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "RIB" && !regexRIB.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "EAN8" && !regexEAN8.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "EAN13" && !regexEAN13.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "ISBN" && !regexISBN.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "NIR" && !regexNIR.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "ISSN" && !regexISSN.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "TVAIntra" && !regexTVAIntraCommunautaire.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "ISWC" && !regexISWC.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "ISMN_pre_2009" && !regexISMNPre2009.hasMatch(value)) {
                          return _displayErrorText;
                        }else if (_radioValue == "ISMN_post_2009" && !regexISMNPost2009.hasMatch(value)) {
                          return _displayErrorText;
                        }
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 5), /// On ajoute un espacement en hauteur
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: (){
                          _validate();
                        },
                        child: Text("Valider"),
                      ),
                      SizedBox(width: 5), /// On ajoute un espacement entre les 2 boutons
                      ElevatedButton(
                        onPressed: (){
                          _erase();
                        },
                        child: Text("Effacer"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            showResult ? DataTable( /// Si un résultat doit être affiché
              columns: <DataColumn>[
                DataColumn(
                  label: Text(
                      _displayInputText
                  ),
                ),
                DataColumn(
                  label: Text(
                      "Validité"
                  ),
                ),
              ],
              rows: <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text(inputNumber, style: TextStyle(color: getColor(isValid)))),
                    DataCell(Text(validite(isValid), style: TextStyle(color: getColor(isValid)))),
                  ],
                ),
              ],
            ) : SizedBox(), /// Si aucun résultat ne doit être affiché
          ],
        ),// This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}