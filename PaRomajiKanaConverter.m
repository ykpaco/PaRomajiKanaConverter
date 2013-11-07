//
//  PaRomajiKanaConverter.h
//
//  Created by Yusuke Kawakami on 2013/02/27.
//  Copyright (c) 2013年 Yusuke Kawakami. All rights reserved.
//
//  This code is a objective-c version of
//  (http://d.hatena.ne.jp/mohayonao/20091129/1259505966) written by mohayonao.
//

#import "PaRomajiKanaConverter.h"

@implementation PaRomajiKanaConverter {
    NSDictionary *_kataToHiraMap;
    NSDictionary *_hiraToKataMap;

    NSDictionary *_romajiToKanaMap;
    NSDictionary *_kanaToRomajiMap;
    
    NSRegularExpression *_reHira;
    NSRegularExpression *_reKata;
    
    NSRegularExpression *_reRomajiToKana;
    NSRegularExpression *_reRomajiNn;
    NSRegularExpression *_reRomajiMba;
    NSRegularExpression *_reRomajiXtu;
    NSRegularExpression *_reRomajiA__;
    
    NSRegularExpression *_reKanaToRomaji;
    NSRegularExpression *_reKanaXtu;
    NSRegularExpression *_reKanaLtu;
    NSRegularExpression *_reKanaEr;
    NSRegularExpression *_reKanaN;
    NSRegularExpression *_reKanaOo;
}

- (id)init
{
    if (self = [super init]) {
        [self initDictionaries];
        [self initRegexp];
    }
    return self;
}

- (void)initDictionaries
{
    _kataToHiraMap = @{
        @"ア":@"あ", @"イ":@"い", @"ウ":@"う", @"エ":@"え", @"オ":@"お",
        @"カ":@"か", @"キ":@"き", @"ク":@"く", @"ケ":@"け", @"コ":@"こ",
        @"サ":@"さ", @"シ":@"し", @"ス":@"す", @"セ":@"せ", @"ソ":@"そ",
        @"タ":@"た", @"チ":@"ち", @"ツ":@"つ", @"テ":@"て", @"ト":@"と",
        @"ナ":@"な", @"ニ":@"に", @"ヌ":@"ぬ", @"ネ":@"ね", @"ノ":@"の",
        @"ハ":@"は", @"ヒ":@"ひ", @"フ":@"ふ", @"ヘ":@"へ", @"ホ":@"ほ",
        @"マ":@"ま", @"ミ":@"み", @"ム":@"む", @"メ":@"め", @"モ":@"も",
        @"ヤ":@"や", @"ユ":@"ゆ", @"ヨ":@"よ", @"ラ":@"ら", @"リ":@"り",
        @"ル":@"る", @"レ":@"れ", @"ロ":@"ろ", @"ワ":@"わ", @"ヲ":@"を",
        @"ン":@"ん",

        @"ガ":@"が", @"ギ":@"ぎ", @"グ":@"ぐ", @"ゲ":@"げ", @"ゴ":@"ご",
        @"ザ":@"ざ", @"ジ":@"じ", @"ズ":@"ず", @"ゼ":@"ぜ", @"ゾ":@"ぞ",
        @"ダ":@"だ", @"ヂ":@"ぢ", @"ヅ":@"づ", @"デ":@"で", @"ド":@"ど",
        @"バ":@"ば", @"ビ":@"び", @"ブ":@"ぶ", @"ベ":@"べ", @"ボ":@"ぼ",
        @"パ":@"ぱ", @"ピ":@"ぴ", @"プ":@"ぷ", @"ペ":@"ぺ", @"ポ":@"ぽ",

        @"ァ":@"ぁ", @"ィ":@"ぃ", @"ゥ":@"ぅ", @"ェ":@"ぇ", @"ォ":@"ぉ",
        @"ャ":@"ゃ", @"ュ":@"ゅ", @"ョ":@"ょ",
        @"ヴ":@"ゔ", @"ッ":@"っ", @"ヰ":@"ゐ", @"ヱ":@"ゑ",
    };
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in [_kataToHiraMap allKeys]) {
        [dict setObject:key forKey:[_kataToHiraMap objectForKey:key]];
    }
    _hiraToKataMap = dict;

    NSDictionary *master = @{
        @"a"  :@"ア", @"i"  :@"イ", @"u"  :@"ウ", @"e"  :@"エ", @"o"  :@"オ",
        @"ka" :@"カ", @"ki" :@"キ", @"ku" :@"ク", @"ke" :@"ケ", @"ko" :@"コ",
        @"sa" :@"サ", @"shi":@"シ", @"su" :@"ス", @"se" :@"セ", @"so" :@"ソ",
        @"ta" :@"タ", @"chi":@"チ", @"tu" :@"ツ", @"te" :@"テ", @"to" :@"ト",
        @"na" :@"ナ", @"ni" :@"ニ", @"nu" :@"ヌ", @"ne" :@"ネ", @"no" :@"ノ",
        @"ha" :@"ハ", @"hi" :@"ヒ", @"fu" :@"フ", @"he" :@"ヘ", @"ho" :@"ホ",
        @"ma" :@"マ", @"mi" :@"ミ", @"mu" :@"ム", @"me" :@"メ", @"mo" :@"モ",
        @"ya" :@"ヤ", @"yu" :@"ユ", @"yo" :@"ヨ",
        @"ra" :@"ラ", @"ri" :@"リ", @"ru" :@"ル", @"re" :@"レ", @"ro" :@"ロ",
        @"wa" :@"ワ", @"wo" :@"ヲ", @"nn"  :@"ン", @"vu" :@"ヴ",
        @"ga" :@"ガ", @"gi" :@"ギ", @"gu" :@"グ", @"ge" :@"ゲ", @"go" :@"ゴ",
        @"za" :@"ザ", @"ji" :@"ジ", @"zu" :@"ズ", @"ze" :@"ゼ", @"zo" :@"ゾ",
        @"da" :@"ダ", @"di" :@"ヂ", @"du" :@"ヅ", @"de" :@"デ", @"do" :@"ド",
        @"ba" :@"バ", @"bi" :@"ビ", @"bu" :@"ブ", @"be" :@"ベ", @"bo" :@"ボ",
        @"pa" :@"パ", @"pi" :@"ピ", @"pu" :@"プ", @"pe" :@"ペ", @"po" :@"ポ",

        @"kya":@"キャ", @"kyi":@"キィ", @"kyu":@"キュ", @"kye":@"キェ", @"kyo":@"キョ",
        @"gya":@"ギャ", @"gyi":@"ギィ", @"gyu":@"ギュ", @"gye":@"ギェ", @"gyo":@"ギョ",
        @"sha":@"シャ",                @"shu":@"シュ", @"she":@"シェ", @"sho":@"ショ",
        @"ja" :@"ジャ",                @"ju" :@"ジュ", @"je" :@"ジェ", @"jo" :@"ジョ",
        @"cha":@"チャ",                @"chu":@"チュ", @"che":@"チェ", @"cho":@"チョ",
        @"dya":@"ヂャ", @"dyi":@"ヂィ", @"dyu":@"ヂュ", @"dhe":@"デェ", @"dyo":@"ヂョ",
        @"tha":@"テャ", @"thi":@"ティ", @"thu":@"テュ", @"the":@"テェ", @"tho":@"テョ",
        @"nya":@"ニャ", @"nyi":@"ニィ", @"nyu":@"ニュ", @"nye":@"ニェ", @"nyo":@"ニョ",
        @"hya":@"ヒャ", @"hyi":@"ヒィ", @"hyu":@"ヒュ", @"hye":@"ヒェ", @"hyo":@"ヒョ",
        @"bya":@"ビャ", @"byi":@"ビィ", @"byu":@"ビュ", @"bye":@"ビェ", @"byo":@"ビョ",
        @"pya":@"ピャ", @"pyi":@"ピィ", @"pyu":@"ピュ", @"pye":@"ピェ", @"pyo":@"ピョ",
        @"mya":@"ミャ", @"myi":@"ミィ", @"myu":@"ミュ", @"mye":@"ミェ", @"myo":@"ミョ",
        @"rya":@"リャ", @"ryi":@"リィ", @"ryu":@"リュ", @"rye":@"リェ", @"ryo":@"リョ",
        @"fa" :@"ファ", @"fi" :@"フィ",               @"fe" :@"フェ", @"fo" :@"フォ",
        @"wi" :@"ウィ", @"we" :@"ウェ",
        @"va" :@"ヴァ", @"vi" :@"ヴィ", @"ve" :@"ヴェ", @"vo" :@"ヴォ",

        @"kwa":@"クァ", @"kwi":@"クィ", @"kwu":@"クゥ", @"kwe":@"クェ", @"kwo":@"クォ",
        //@"kha":@"クァ", @"khi":@"クィ", @"khu":@"クゥ", @"khe":@"クェ", @"kho":@"クォ",
        //@"gwa":@"グァ", @"gwi":@"グィ", @"gwu":@"グゥ", @"gwe":@"グェ", @"gwo":@"グォ",
        @"gwa":@"グヮ", @"gwi":@"グィ", @"gwu":@"グゥ", @"gwe":@"グェ", @"gwo":@"グォ",
        //@"gha":@"グァ", @"ghi":@"グィ", @"ghu":@"グゥ", @"ghe":@"グェ", @"gho":@"グォ",
        //@"swa":@"スァ", @"swi":@"スィ", @"swu":@"スゥ", @"swe":@"スェ", @"swo":@"スォ",
        //@"zwa":@"ズヮ", @"zwi":@"ズィ", @"zwu":@"ズゥ", @"zwe":@"ズェ", @"zwo":@"ズォ",
        //@"twa":@"トァ", @"twi":@"トィ", @"twu":@"トゥ", @"twe":@"トェ", @"two":@"トォ",
        @"twu":@"トゥ",
        //@"dwa":@"ドァ", @"dwi":@"ドィ", @"dwu":@"ドゥ", @"dwe":@"ドェ", @"dwo":@"ドォ",
        //@"mwa":@"ムヮ", @"mwi":@"ムィ", @"mwu":@"ムゥ", @"mwe":@"ムェ", @"mwo":@"ムォ",
        //@"bwa":@"ビヮ", @"bwi":@"ビィ", @"bwu":@"ビゥ", @"bwe":@"ビェ", @"bwo":@"ビォ",
        //@"pwa":@"プヮ", @"pwi":@"プィ", @"pwu":@"プゥ", @"pwe":@"プェ", @"pwo":@"プォ",
        //@"phi":@"プィ", @"phu":@"プゥ", @"phe":@"プェ", @"pho":@"フォ",
        
        @"dha":@"デャ",@"dhi":@"ディ",@"dhu":@"デュ",@"dhe":@"デェ",@"dho":@"デョ",
        
        @"-":@"ー"
    };


    NSDictionary *romajiAssist = @{
        @"si" :@"シ"  , @"ti" :@"チ"  , @"hu" :@"フ" , @"zi":@"ジ",
        @"sya":@"シャ", @"syu":@"シュ", @"syo":@"ショ",
        @"tya":@"チャ", @"tyu":@"チュ", @"tyo":@"チョ",
        @"cya":@"チャ", @"cyu":@"チュ", @"cyo":@"チョ",
        @"jya":@"ジャ", @"jyu":@"ジュ", @"jyo":@"ジョ", @"pha":@"ファ",
        @"zya":@"ジャ", @"zyi":@"ジィ", @"zyu":@"ジュ", @"zye":@"ジェ", @"zyo":@"ジョ",
        @"qa" :@"クァ", @"qi" :@"クィ", @"qu" :@"クゥ", @"qe" :@"クェ", @"qo":@"クォ",
        @"xa" :@"ァ", @"xi" :@"ィ", @"xu" :@"ゥ", @"xe" :@"ェ", @"xo":@"ォ",
        @"la" :@"ァ", @"li" :@"ィ", @"lu" :@"ゥ", @"le" :@"ェ", @"lo":@"ォ",

        @"ca" :@"カ", @"ci":@"シ", @"cu":@"ク", @"ce":@"セ", @"co":@"コ",
        @"la" :@"ラ", @"li":@"リ", @"lu":@"ル", @"le":@"レ", @"lo":@"ロ",

        @"mb" :@"ム", @"py":@"パイ", @"tho": @"ソ", @"thy":@"ティ", @"oh":@"オウ",
        @"by":@"ビィ", @"cy":@"シィ", @"dy":@"ディ", @"fy":@"フィ", @"gy":@"ジィ",
        @"hy":@"シー", @"ly":@"リィ", @"ny":@"ニィ", @"my":@"ミィ", @"ry":@"リィ",
        @"ty":@"ティ", @"vy":@"ヴィ", @"zy":@"ジィ"

        //@"b":@"ブ", @"c":@"ク", @"d":@"ド", @"f":@"フ"  , @"g":@"グ", @"h":@"フ", @"j":@"ジ",
        //@"k":@"ク", @"l":@"ル", @"m":@"ム", @"p":@"プ"  , @"q":@"ク", @"r":@"ル", @"s":@"ス",
        //@"t":@"ト", @"v":@"ヴ", @"w":@"ゥ", @"x":@"クス", @"y":@"ィ", @"z":@"ズ"
    };

    NSDictionary *kanaAssist = @{ @"a":@"ァ", @"i":@"ィ", @"u":@"ゥ", @"e":@"ェ", @"o":@"ォ" };
    
    NSMutableDictionary *romajiToKanaMap = [NSMutableDictionary dictionaryWithDictionary:master];
    [romajiToKanaMap addEntriesFromDictionary:romajiAssist];
    _romajiToKanaMap = romajiToKanaMap;
    

    NSMutableDictionary *kanaToRomajiMap = [NSMutableDictionary dictionary];
    for (NSString *key in [master allKeys]) {
        [kanaToRomajiMap setObject:key forKey:[master objectForKey:key]];
    }
    for (NSString *key in [kanaAssist allKeys]) {
        [kanaToRomajiMap setObject:key forKey:[kanaAssist objectForKey:key]];
    }
    _kanaToRomajiMap = kanaToRomajiMap;
}

- (void)initRegexp
{
    {
        NSError *error = nil;
        NSArray *hiraList = [_hiraToKataMap allKeys];
        NSString *hiraPattern = [NSString stringWithFormat:@"(%@|.)", [hiraList componentsJoinedByString:@"|"]];
        _reHira = [NSRegularExpression regularExpressionWithPattern:hiraPattern options:0 error:&error];
        if (error) {
            NSLog(@"hira regex error:%@", error);
        }
    }
    {
        NSError *error = nil;
        NSArray *kataList = [_kataToHiraMap allKeys];
        NSString *kataPattern = [NSString stringWithFormat:@"(%@|.)", [kataList componentsJoinedByString:@"|"]];
        _reKata = [NSRegularExpression regularExpressionWithPattern:kataPattern options:0 error:&error];
        if (error) {
            NSLog(@"kata regex error:%@", error);
        }
    }
    {
        NSError *error = nil;
        NSMutableArray *romajiKeys = [NSMutableArray arrayWithArray:[_romajiToKanaMap allKeys]];
        [self sortStringArrayByLength:romajiKeys ascending:NO];
        NSString *romajiPattern = [NSString stringWithFormat:@"(%@|.)", [romajiKeys componentsJoinedByString:@"|"]];
        _reRomajiToKana = [NSRegularExpression regularExpressionWithPattern:romajiPattern options:0 error:&error];
        if (error) {
            NSLog(@"romajiToKana regex error:%@", error);
        }
    }
    { //nnの後に母音またはyが続かない場合は 1 個の n に変換
        NSError *error = nil;
        _reRomajiNn = [NSRegularExpression regularExpressionWithPattern:@"nn([^aiueoy]|$)" options:0 error:&error];
        if (error) {
            NSLog(@"romajiMba regex error:%@", error);
        }
    }
    { //m の後ろにバ行、パ行のときは "ン" と変換
        NSError *error = nil;
        _reRomajiMba = [NSRegularExpression regularExpressionWithPattern:@"m(b|p)([aiueo])" options:0 error:&error];
        if (error) {
            NSLog(@"romajiMba regex error:%@", error);
        }
    }
    { //子音が続く時は "ッ" と変換
        NSError *error = nil;
        _reRomajiXtu = [NSRegularExpression regularExpressionWithPattern:@"([bcdfghjklmpqrstvwxyz])\\1" options:0 error:&error];
        if (error) {
            NSLog(@"romajiXtu regex error:%@", error);
        }
    }
    { //母音が続く時は "ー" と変換
        NSError *error = nil;
        _reRomajiA__ = [NSRegularExpression regularExpressionWithPattern:@"([aiueo])\\1" options:0 error:&error];
        if (error) {
            NSLog(@"romajiA__ regex error:%@", error);
        }
    }
    {
        NSError *error = nil;
        NSMutableArray *kanaKeys = [NSMutableArray arrayWithArray:[_kanaToRomajiMap allKeys]];
        [self sortStringArrayByLength:kanaKeys ascending:NO];
        NSString *romajiPattern = [NSString stringWithFormat:@"(%@|.)", [kanaKeys componentsJoinedByString:@"|"]];
        _reKanaToRomaji = [NSRegularExpression regularExpressionWithPattern:romajiPattern options:0 error:&error];
        if (error) {
            NSLog(@"kanaToRomaji regex error:%@", error);
        }
    }
    { //小さい "ッ" は直後の文字を２回に変換
        NSError *error = nil;
        _reKanaXtu = [NSRegularExpression regularExpressionWithPattern:@"ッ(.)" options:0 error:&error];
        if (error) {
            NSLog(@"kanaXtu regex error:%@", error);
        }
    }
    { //最後の小さい "ッ" は消去
        NSError *error = nil;
        _reKanaLtu = [NSRegularExpression regularExpressionWithPattern:@"ッ$" options:0 error:&error];
        if (error) {
            NSLog(@"kanaXtu regex error:%@", error);
        }
    }
    { //"ー"は直前の文字を２回に変換
        NSError *error = nil;
        _reKanaEr = [NSRegularExpression regularExpressionWithPattern:@"(.)ー" options:0 error:&error];
        if (error) {
            NSLog(@"kanaEr regex error:%@", error);
        }
    }
    { //n の後ろが バ行、パ行 なら m に修正
        NSError *error = nil;
        _reKanaN = [NSRegularExpression regularExpressionWithPattern:@"n(b|p)([aiueo])" options:0 error:&error];
        if (error) {
            NSLog(@"kanaN regex error:%@", error);
        }
    }
    /*
    { //oosaka → osaka
        NSError *error = nil;
        _reKanaOo = [NSRegularExpression regularExpressionWithPattern:@"([aiueo])\\1" options:0 error:&error];
        if (error) {
            NSLog(@"kanaOo regex error:%@", error);
        }
    }
     */

}

- (NSString* )convertToHiraganaFromKatakana:(NSString *)katakana
{
    return [self replaceString:katakana withRegex:_reKata replaceMap:_kataToHiraMap];
}

- (NSString* )convertToKatakanaFromHiragana:(NSString *)hiragana
{
    return [self replaceString:hiragana withRegex:_reHira replaceMap:_hiraToKataMap];
}

- (NSString* )convertToKatakanaFromRomaji:(NSString *)romaji
{
    romaji = [romaji lowercaseString];
    NSMutableString *convertedStr = [NSMutableString stringWithString:romaji];
    //[self replaceString:convertedStr withRegex:_reRomajiNn template:@"n$1"];     //nnの後に母音またはyが続かない場合は 1 個の n に変換
    //[self replaceString:convertedStr withRegex:_reRomajiMba template:@"ン$1$2"]; //m の後ろにバ行、パ行のときは "ン" と変換
    [self replaceString:convertedStr withRegex:_reRomajiXtu template:@"ッ$1"];   //子音が続く時は "ッ" と変換
    //[self replaceString:convertedStr withRegex:_reRomajiA__ template:@"$1ー"];   //母音が続く時は "ー" と変換
    return [self replaceString:convertedStr withRegex:_reRomajiToKana replaceMap:_romajiToKanaMap];
}

- (NSString* )convertToHiraganaFromRomaji:(NSString *)romaji
{
    NSString *katakana = [self convertToKatakanaFromRomaji:romaji];
    return [self convertToHiraganaFromKatakana:katakana];
}

- (NSString* )convertToRomajiFromKana:(NSString *)kana
{
    NSString *katakana = [self convertToKatakanaFromHiragana:kana];
    NSMutableString *romaji = [self replaceString:katakana withRegex:_reKanaToRomaji replaceMap:_kanaToRomajiMap];
    [self replaceString:romaji withRegex:_reKanaXtu template:@"$1$1"]; //小さい "ッ" は直後の文字を２回に変換
    [self replaceString:romaji withRegex:_reKanaLtu template:@""];     //最後の小さい "ッ" は消去 //"ー"は直前の文字を２回に変換
    [self replaceString:romaji withRegex:_reKanaEr template:@"$1$1"];  //"ー"は直前の文字を２回に変換
    //[self replaceString:romaji withRegex:_reKanaN template:@"m$1$2"];  //n の後ろが バ行、パ行 なら m に修正
    [self replaceString:romaji withRegex:_reKanaOo template:@"$1"];    //oosaka → osaka
    return romaji;
}

- (void)replaceString:(NSMutableString *)str withRegex:(NSRegularExpression *)regex template:(NSString *)template
{
    [regex replaceMatchesInString:str options:0 range:NSMakeRange(0, str.length) withTemplate:template];
}

- (NSMutableString *)replaceString:(NSString *)str withRegex:(NSRegularExpression *)regex replaceMap:(NSDictionary *)replaceMap
{
    NSMutableString *ret = [NSMutableString string];
    [regex enumerateMatchesInString:str
                                options:0
                              range:NSMakeRange(0, str.length)
                                   usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                       NSString *matchedStr = [str substringWithRange:result.range];
                                       NSString *replacedStr = [replaceMap objectForKey:matchedStr];
                                       if (replacedStr) {
                                           [ret appendString:replacedStr];
                                       }
                                       else {
                                           [ret appendString:matchedStr];
                                       }
                                   }];
    return ret;
}

- (void)sortStringArrayByLength:(NSMutableArray *)array ascending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"length"
                                                                   ascending:ascending];
    [array sortUsingDescriptors:@[sortDescriptor]];
}


@end
