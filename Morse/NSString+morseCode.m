//
//  NSString+morseCode.m
//  Morse
//
//  Created by Taylor Potter on 4/15/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "NSString+morseCode.h"

@implementation NSString (morseCode)


+ (NSMutableArray *)translateMessageToMorse:(NSString *)inputText
{
  NSMutableArray *symbols = [NSMutableArray new];
  
  inputText = [inputText uppercaseString];
  
  for(int i=0; i<inputText.length; i++) {
    NSString *letter = [inputText substringWithRange:NSMakeRange(i, 1)];
    [symbols addObject:[NSString dictionaryOfMorseSymbols:letter]];
  }
  return symbols;
}



+ (NSString *)dictionaryOfMorseSymbols:(NSString *)letterToTranslate
{
  NSDictionary *morseDictionary = @{@"A":@".-",
                                    @"B":@"-...",
                                    @"C":@"-.-.",
                                    @"D":@"-..",
                                    @"E":@".",
                                    @"F":@"..-.",
                                    @"G":@"--.",
                                    @"H":@"....",
                                    @"I":@"..",
                                    @"J":@".---",
                                    @"K":@"-.-",
                                    @"L":@".-..",
                                    @"M":@"--",
                                    @"N":@"-.",
                                    @"O":@"---",
                                    @"P":@".--.",
                                    @"Q":@"--.-",
                                    @"R":@".-.",
                                    @"S":@"...",
                                    @"T":@"-",
                                    @"U":@"..-",
                                    @"V":@"...-",
                                    @"W":@".--",
                                    @"X":@"-..-",
                                    @"Y":@"-.--",
                                    @"Z":@"--..",
                                    @"0":@"-----",
                                    @"1":@".----",
                                    @"2":@"..---",
                                    @"3":@"...--",
                                    @"4":@"....-",
                                    @"5":@".....",
                                    @"6":@"-....",
                                    @"7":@"--...",
                                    @"8":@"---..",
                                    @"9":@"----.",
                                    @" ":@" "};
  
  return [morseDictionary objectForKey:letterToTranslate];
}

+(NSString *)symbolForLetter:(NSString *)letter
{
  NSDictionary *morseDict = @{@"A": @".-",
                              @"B": @"-...",
                              @"C":@"-.-.",
                              @"D":@"-..",
                              @"E":@".",
                              @"F":@"..-.",
                              @"G":@"--.",
                              @"H":@"....",
                              @"I":@"..",
                              @"J":@".---",
                              @"K":@"-.-",
                              @"L":@".-..",
                              @"M":@"--",
                              @"N":@"-.",
                              @"O":@"---",
                              @"P":@".--.",
                              @"Q":@"--.-",
                              @"R":@".-.",
                              @"S":@"...",
                              @"T":@"-",
                              @"U":@"..-",
                              @"V":@"...-",
                              @"W":@".--",
                              @"X":@"-..-",
                              @"Y":@"-.--",
                              @"Z":@"--..",
                              @" ":@" "
                              };
  
  return [morseDict objectForKey:letter];
}





@end
