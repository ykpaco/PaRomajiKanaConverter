//
//  PaRomajiKanaConverter.h
//
//  Created by Yusuke Kawakami on 2013/02/27.
//  Copyright (c) 2012年 Yusuke Kawakami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaRomajiKanaConverter : NSObject

- (NSString* )convertToHiraganaFromKatakana:(NSString *)katakana;
- (NSString* )convertToKatakanaFromHiragana:(NSString *)hiragana;
- (NSString* )convertToKatakanaFromRomaji:(NSString *)romaji;
- (NSString* )convertToHiraganaFromRomaji:(NSString *)romaji;
- (NSString* )convertToRomajiFromKana:(NSString *)kana;

@end
