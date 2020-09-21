import 'package:flutter/material.dart';

typedef void LocaleChangeCallback(Locale locale);
class LocaleUtil {

  // Support languages list
  final List<String> supportedLanguages = ['en','zh'];


  // Support Locales list
  Iterable<Locale> supportedLocales() => supportedLanguages.map<Locale>((lang) => new Locale(lang, ''));

  ///获取设备的语言设置,默认采用中文zh
  Locale localeResolutionCallback(Locale locale, Iterable<Locale> supportedLocales){
    if(locale == null || !supportedLanguages.contains(locale.languageCode)){
      _locale = new Locale("zh","");
    }else{
      _locale = locale;
    }
    return _locale;
}
  // Callback for manual locale changed
  LocaleChangeCallback onLocaleChanged;

  Locale _locale;

  static final LocaleUtil _localeUtil = new LocaleUtil._internal();
  factory LocaleUtil() {
    return _localeUtil;
  }
  LocaleUtil._internal();

}

LocaleUtil localeUtil = new LocaleUtil();