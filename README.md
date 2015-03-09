PaRomajiKanaConverter
=====================

Kana - Romaji Converter written in Objective-C

iOS's Romaji - Kana transform (CFStringTransform) is buggy on some ios versions and is not prescise. 
The goal of this code is to become a good alternative of the iOS string transform library.


## Install
Just copy the following files into your project:
* NSString+RomajiKanaConvert.[hm]
* PaRomajiKanaConverter.[hm]
   
## Examples

```objective-c
#import "NSString+RomajiKanaConvert.h"

{
NSString *romaji = @"kyari-pamyupamyu";
NSString *kana = [romaji stringRomajiToHiragana]; // きゃりーぱみゅぱみゅ
}
{
NSString *romaji = @"hannyashinkyo";
NSString *kana = [romaji stringRomajiToHiragana]; // はんにゃしんきょう
}
{
NSString *kana = @"おくさんおげんきデスカー";
NSString *romaji = [kana stringKanaToRomaji]; // okusanogenkidesuka-
}
{
NSString *hiragana = @"ちゅーりっぷ";
NSString *katakana = [hiragana stringHiraganaToKatakana]; // チューリップ
}

```


## License

PaRomajiKanaConverter is available under the MIT license.