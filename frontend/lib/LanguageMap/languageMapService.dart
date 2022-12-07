

import 'package:rent_a_roo/LanguageMap/english.dart';
import 'package:rent_a_roo/LanguageMap/urdu.dart';

class LanguageMapService
{
  static String langMode='English';
  static Map languageMap=urduMap;
  static getTranslation(String word)
  {
    if (langMode == 'Urdu' && urduMap.containsKey(word))
      return languageMap[word];
    else
      return word;
  }
  static setTranslation(String mode)
  { langMode=mode;
    if(mode=='English')
    {
      languageMap=englishMap;
    }else if(mode=="Urdu")
    {
      languageMap=urduMap;
    }
  }
}