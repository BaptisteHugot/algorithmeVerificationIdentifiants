/**
 * @file algorithmes.dart
 * @brief Implémentation de différents algorithmes utilisés pour valider la véracité d'identifiants
 */

/**
 * Implémentation de l'algorithme de Luhn
 * @param nombre Le nombre que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeLuhn(String nombre){
  int somme = 0;
  bool alternance = false;

  for(int i = nombre.length-1;i>=0;i--){
    int n = int.parse(nombre.substring(i,i+1));
    if(alternance){
      n = 2*n;
      if(n>9){
        n = (n%10)+1;
      }
    }
    somme = somme + n;
    alternance = !alternance;
  }
  int codeCorrecteur = somme % 10;

  return (codeCorrecteur == 0);
}

/**
 * Implémentation de l'algorithme de vérification du SIRET dans le cas particulier de La Poste
 * @param SIRET Le SIRET de La Poste que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeSiretLaPoste(String SIRET){
  int somme = 0;
  int cleControle = 0;

  for(int i = 0;i<SIRET.length;i++) {
    int n = int.parse(SIRET.substring(i,i+1));
    somme = somme + n;
  }

  cleControle = somme % 5;

  return (cleControle == 0);
}

/**
 * Implémentation de l'algorithme EAN8
 * @param EAN L'EAN (code barres) que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeEAN8(String EAN){
  int cle = int.parse(EAN.substring(EAN.length-1,EAN.length));
  int sommeControle = 0;

  for(int i = 0;i<EAN.length-1;i++) {
    int n = int.parse(EAN.substring(i,i+1));
    if(i%2 == 0){
      sommeControle = sommeControle + (3 * n);
    }else if(i % 2 == 1){
      sommeControle = sommeControle + n;
    }
  }

  int cleCalculee = 10 - (sommeControle % 10);

  return(cleCalculee == cle);
}

/**
 * Implémentation de l'algorithme EAN13
 * @param EAN L'EAN (code barres) que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeEAN13(String EAN){
  int alpha = 0;
  int beta = 0;
  int codeCorrecteur = 0;
  int cle = int.parse(EAN.substring(EAN.length-1,EAN.length));

  for(int i = 0;i<EAN.length-1;i++) {
    int n = int.parse(EAN.substring(i,i+1));
    if(i%2 == 0){
      beta = beta + n;
    }else if(i%2 == 1){
      alpha = alpha + n;
    }
  }
  codeCorrecteur = 10-((3*alpha+beta)%10);

  return(codeCorrecteur == cle);
}

/**
 * Implémentation de vérification d'un ISBN
 * @param ISBN L'ISBN que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeISBN(String ISBN){
  String cle = ISBN.substring(ISBN.length-1,ISBN.length);
  int sommeControle = 0;
  String codeCorrecteur = "";

  for(int i = 0 ; i < ISBN.length-1 ; i++){
    int n = int.parse(ISBN.substring(i,i+1));
    int temp = 10-i;
    sommeControle = sommeControle + n*temp;
  }

  int codeCorrecteurTemporaire = sommeControle % 11;

  if(codeCorrecteurTemporaire < 10){
    codeCorrecteur = codeCorrecteur.toString();
  }else if(codeCorrecteurTemporaire == 10){
    codeCorrecteur = "X";
  }

  return (cle == codeCorrecteur);
}

/**
 * Implémentation de l'algorithme de vérification de la clé d'un identifiant INSEE
 * @param NIR L'identifiant NIR que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeNIR(String NIR){
  int identifiant = int.parse(NIR.substring(0,13));
  int cle = int.parse(NIR.substring(13,15));

  int cleCalculee = 97 - (identifiant % 97);

  return(cle == cleCalculee);
}

/**
 * Implémentation de l'algorithme de vérificafion d'un RIB
 * @param RIB Le RIB que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeRIB(String RIB){
  int codeBanque = int.parse(RIB.substring(0,5));
  int codeGuichet = int.parse(RIB.substring(5,10));
  String numeroCompte = RIB.substring(10,21);
  String cle = RIB.substring(21,23);
  String numeroCompteConvertiTemp = "";
  int numeroCompteConverti = 0;
  String cleControle = "";

  for(int i = 0 ; i < numeroCompte.length ; i++){
    String c = numeroCompte.substring(i,i+1);
    int letterValue = 0;
    if(c == "A" || c == "J"){
      letterValue = 1;
    }else if(c == "B" || c == "K" || c == "S"){
      letterValue = 2;
    }else if(c == "C" || c == "L" || c == "T"){
      letterValue = 3;
    }else if(c == "D" || c == "M" || c == "U"){
      letterValue = 4;
    }else if(c == "E" || c == "N" || c == "V"){
      letterValue = 5;
    }else if(c == "F" || c == "O" || c == "W"){
      letterValue = 6;
    }else if(c == "G" || c == "P" || c == "X"){
      letterValue = 7;
    }else if(c == "H" || c == "Q" || c == "Y"){
      letterValue = 9;
    }else if(c == "I" || c == "R" || c == "Z"){
      letterValue = 9;
    }else{
      letterValue = int.parse(c);
    }
    numeroCompteConvertiTemp = numeroCompteConvertiTemp + letterValue.toString();
  }
  numeroCompteConverti = int.parse(numeroCompteConvertiTemp);

  int calculCleControle = 97 - (((89 * codeBanque) + (15 * codeGuichet) + (3 * numeroCompteConverti)) % 97);
  if(calculCleControle < 10){
    cleControle = "0" + calculCleControle.toString();
  }else{
    cleControle = calculCleControle.toString();
  }
    return (cle == cleControle);
}

/**
 * Implémentation de l'algorithme de vérification d'un IBAN
 * @param IBAN L'IBAN que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeIBAN(String IBAN){
  String codePays = IBAN.substring(0,1);
  int cle = int.parse(IBAN.substring(2,3));
  String codePaysValue = "";

  for(int i = 0 ; i < codePays.length ; i++) {
    int value = (codePays.codeUnitAt(0)-65); // On récupère la position dans l'alphabet
    value = value + 10; // On ajoute 10 à la position dans l'alphabet
    codePaysValue = codePaysValue + value.toString();
  }
  codePaysValue = codePaysValue + "00";
  int codePaysCalculCle = int.parse(codePaysValue);
  int codeControle = 98 - (codePaysCalculCle % 97);

  return (cle == codeControle);
}

/**
 * Implémentation de l'algorithme de vérification du numéro de TVA intracommunautaire français
 * @param numeroTVA Le numéro de TVA intracommunautaire français
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeTVAIntraCommunautaire(String numeroTVA){
  int cle = int.parse(numeroTVA.substring(2,4));
  int Siren = int.parse(numeroTVA.substring(4,13));

  int codeControle = (12 + 3 * (Siren % 97)) % 97;

  return (cle == codeControle);
}

/**
 * Implémentation de vérification d'un ISSN
 * @param ISSN L'ISSN que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeISSN(String ISSN){
  int cle = int.parse(ISSN.substring(ISSN.length-1,ISSN.length));
  int sommeControle = 0;

  for(int i = 0 ; i < ISSN.length-1 ; i++){
    int n = int.parse(ISSN.substring(i,i+1));
    int temp = 8-i;
    sommeControle = sommeControle + n*temp;
  }

  int codeCorrecteur = 11 - (sommeControle % 11);
  return (cle == codeCorrecteur);
}

/**
 * Implémentation de vérification d'un ISWC
 * @param ISWC L'ISWC que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeISWC(String ISWC){
  int cle = int.parse(ISWC.substring(ISWC.length-1,ISWC.length));
  int sommeControle = 1;

  for(int i = 1 ; i < ISWC.length-1 ; i++){
    int n = int.parse(ISWC.substring(i,i+1));
    sommeControle = sommeControle + n * i;
  }

  int cleCalculee = (10 - (sommeControle % 10)) % 10;

  return (cle == cleCalculee);
}

/**
 * Implémentation de vérification d'un eID (identifiant eSIM)
 * @param eID L'eID que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeEID(String eID){
  String eIDToCheck = eID.substring(0,eID.length-2) + "00";
  String cle = eID.substring(eID.length-2,eID.length);
  String cleCalculee = "";

  BigInt eIDToCheckConvert = BigInt.parse(eIDToCheck);
  BigInt cleCalcul = BigInt.from(98) - (eIDToCheckConvert % BigInt.from(97));

  if(cleCalcul < BigInt.from(10)){
    cleCalculee = "0" + cleCalcul.toString();
  }else {
    cleCalculee = cleCalcul.toString();
  }

  return (cle == cleCalculee);
}

/**
 * Implémentation de vérification d'un ISMN (avant 2009)
 * @param ISMN L'ISMN que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeISMN_pre2009(String ISMN){
  int cle = int.parse(ISMN.substring(ISMN.length-1,ISMN.length));
  int sommeControle = 9;

  for(int i = 1;i<ISMN.length-1;i++) {
    int n = int.parse(ISMN.substring(i,i+1));
    if(i%2 == 0){
      sommeControle = sommeControle + (3 * n);
    }else if(i % 2 == 1){
      sommeControle = sommeControle + n;
    }
  }

  int cleCalculee = 10 - (sommeControle % 10);

  return(cleCalculee == cle);
}

/**
 * Implémentation de vérification d'un ISMN (après 2009)
 * @param ISMN L'ISMN que l'on souhaite tester
 * @return true si la somme de contrôle est correcte, false sinon
 */
bool algorithmeISMN_post2009(String ISMN){
  int cle = int.parse(ISMN.substring(ISMN.length-1,ISMN.length));
  int sommeControle = 0;

  for(int i = 0;i<ISMN.length-1;i++) {
    int n = int.parse(ISMN.substring(i,i+1));
    if(i%2 == 1){
      sommeControle = sommeControle + (3 * n);
    }else if(i % 2 == 0){
      sommeControle = sommeControle + n;
    }
  }

  int cleCalculee = 10 - (sommeControle % 10);

  return(cleCalculee == cle);
}