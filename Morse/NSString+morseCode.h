//
//  NSString+morseCode.h
//  Morse
//
//  Created by Taylor Potter on 4/15/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (morseCode)



+ (NSMutableArray *)translateMessageToMorse:(NSString *)inputText;

//+ (NSString *)morseSymbolFromCharacter:(NSString *)character;

+ (NSDictionary *)dictionaryOfMorseSymbols:(NSString *)letterToTranslate;




@end
