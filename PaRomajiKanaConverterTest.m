//
//  PaRomajiKanaConverterTest.h
//
//  Created by Yusuke Kawakami on 2013/02/28.
//  Copyright (c) 2013年 Yusuke Kawakami. All rights reserved.
//

#import "PaRomajiKanaConverterTest.h"
#import "PaRomajiKanaConverter.h"

@implementation PaRomajiKanaConverterTest

+ (void)test
{
    PaRomajiKanaConverter* converter = [PaRomajiKanaConverter new];

    NSArray *testRomajiList =
        @[@"mohayonao",
           @"intaanetto",
           @"inntaanetto",
           @"amanattou",
           @"keitaidennwa",
           @"kurossii",
           @"akebono",
           @"ippannjin",
           @"vaiorin",
           @"vuxaiorin",
           @"twitter",
           @"ukulele",
           @"monthy python",
           @"spam!",
           @"lambda",
           @"nambda",
           @"maitta",
           @"ping pong",
           @"mohayonao",
           @"dendenmushi",
           @"namba",
           @"Dan Kogai"];
    NSArray *testHiraganaList =
        @[@"ぎょぎょっ",
           @"こまったな",
           @"おおさか",
           @"にっぽん",
           @"ゔぁいおりん",
           @"なんば",
           @"こんにちは",
           @"とうばんじゃん"];
    NSArray *testKatakanaList =
        @[@"インターネット",
           @"ハンバーグ",
           @"チューリップ",
           @"ポパイ",
           @"ヒンドゥーキョウ",
           @"モハヨナオ",
           @"マイッタ"];


    for (NSString *romaji in testRomajiList) {
        NSLog(@"[romaji to hiragana] %@ -> %@", romaji, [converter convertToHiraganaFromRomaji:romaji]);
    }
    for (NSString *romaji in testRomajiList) {
        NSLog(@"[romaji to katakana] %@ -> %@", romaji, [converter convertToKatakanaFromRomaji:romaji]);
    }

    for (NSString *hiragana in testHiraganaList) {
        NSLog(@"[hiragana to romaji] %@ -> %@", hiragana, [converter convertToRomajiFromKana:hiragana]);
    }
    for (NSString *hiragana in testHiraganaList) {
        NSLog(@"[hiragana to katakana] %@ -> %@", hiragana, [converter convertToKatakanaFromHiragana:hiragana]);
    }

    for (NSString *katakana in testKatakanaList) {
        NSLog(@"[katakana to romaji] %@ -> %@", katakana, [converter convertToRomajiFromKana:katakana]);
    }
    for (NSString *katakana in testKatakanaList) {
        NSLog(@"[katakana to katakana] %@ -> %@", katakana, [converter convertToHiraganaFromKatakana:katakana]);
    }
}

@end
