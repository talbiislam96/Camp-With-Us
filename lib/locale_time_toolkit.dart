import 'package:flutter/material.dart';

String getLocaleDateFormatter(Locale myLocale){
  if(myLocale.toString() == 'fr')
    return 'fr-FR';
  else if(myLocale.toString() == 'en')
    return 'en-US';
  else
    return 'es';
}