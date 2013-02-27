//
//  NSString+Henkan.h
//
//  Created by Yusuke Kawakami on 2013/02/27.
//  Copyright (c) 2012年 Yusuke Kawakami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RomajiKanaConvert)

- (NSString *)stringRomajiToHiragana;
- (NSString *)stringRomajiToKatakana;
- (NSString *)stringKanaToRomaji;
- (NSString *)stringHiraganaToKatakana;
- (NSString *)stringKatakanaToHiragana;

@end
