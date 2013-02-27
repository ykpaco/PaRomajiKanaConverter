//
//  NSString+Henkan.m
//

#import "NSString+RomajiKanaConvert.h"
#import "PaRomajiKanaConverter.h"

@implementation NSString (RomajiKanaConvert)

static PaRomajiKanaConverter *converter;

+ (void)initClassIfNeeded
{
    if (!converter) {
        converter = [PaRomajiKanaConverter new];
    }
}

- (NSString *)stringRomajiToHiragana
{
    [NSString initClassIfNeeded];
    return [converter convertToHiraganaFromRomaji:self];
}

- (NSString *)stringRomajiToKatakana
{
    [NSString initClassIfNeeded];
    return [converter convertToKatakanaFromRomaji:self];
}

- (NSString *)stringKanaToRomaji
{
    [NSString initClassIfNeeded];
    return [converter convertToRomajiFromKana:self];
}

- (NSString *)stringHiraganaToKatakana
{
    [NSString initClassIfNeeded];
    return [converter convertToKatakanaFromHiragana:self];
}

- (NSString *)stringKatakanaToHiragana
{
    [NSString initClassIfNeeded];
    return [converter convertToHiraganaFromKatakana:self];
}

@end
