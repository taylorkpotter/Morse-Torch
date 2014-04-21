//
//  TorchController.m
//  Morse
//
//  Created by Taylor Potter on 4/16/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "TorchController.h"
#import  <AVFoundation/AVFoundation.h>
#import "NSString+morseCode.h"

@interface TorchController ()

@property (strong, nonatomic) AVCaptureDevice *myDevice;
@property (strong, nonatomic) NSString *morseLetter;
@property (nonatomic) CGFloat totalSymbol;
@property (nonatomic) CGFloat symbolIndex;

@end
@implementation TorchController

-(instancetype)initWithDevice
{
  self = [super init];
  self.myDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  self.flashQueue = [NSOperationQueue new];
  self.flashQueue.maxConcurrentOperationCount = 1;
  self.totalSymbol = 0;
  self.symbolIndex = 0;
  
  return self;
}

-(void)flashDot
{
  [self.myDevice lockForConfiguration:nil];
  [self.myDevice setTorchMode:AVCaptureTorchModeOn];
  [self.myDevice unlockForConfiguration];
  usleep(100000);
  [self.myDevice lockForConfiguration:nil];
  [self.myDevice setTorchMode:AVCaptureTorchModeOff];
  [self.myDevice unlockForConfiguration];
  usleep(100000);
}

-(void)flashDash
{
  
  [self.myDevice lockForConfiguration:nil];
  [self.myDevice setTorchMode:AVCaptureTorchModeOn];
  [self.myDevice unlockForConfiguration];
  usleep(300000);
  [self.myDevice lockForConfiguration:nil];
  [self.myDevice setTorchMode:AVCaptureTorchModeOff];
  [self.myDevice unlockForConfiguration];
  usleep(300000);
}

-(void)flashWordSpace
{
  usleep(400000);
}

-(void)flashLetterSpace
{
  usleep(200000);
}

-(void)translatingToMorse:(NSString *)messageToTranslate
{
  [self.flashQueue addOperationWithBlock:^{
      [self.delegate enableUIElements:YES];
  }];
  
  NSArray *translatedArray = [NSString translateMessageToMorse:messageToTranslate];
  
  for (NSString *symbolLetter in translatedArray) {
    _morseLetter = symbolLetter;
    for(int i=0; i<_morseLetter.length; i++) {
      NSString *letter = [_morseLetter substringWithRange:NSMakeRange(i, 1)];
      if ([letter isEqualToString:@"."]) {
        _totalSymbol++;
        [self.flashQueue addOperationWithBlock:^{
          _symbolIndex++;
          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.delegate updateProgressBarWithTotal:_totalSymbol andProgress:_symbolIndex];
          }];
          [self flashDot];
        }];
      } else if ([letter isEqualToString:@"-"]) {
        _totalSymbol++;
        [self.flashQueue addOperationWithBlock:^{
          _symbolIndex++;
          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.delegate updateProgressBarWithTotal:_totalSymbol andProgress:_symbolIndex];
          }];
          [self flashDash];
        }];
      } else if ([letter isEqualToString:@" "]) {
        _totalSymbol++;
        
        [self.flashQueue addOperationWithBlock:^{
          _symbolIndex++;
          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            [self.delegate updateProgressBarWithTotal:_totalSymbol andProgress:_symbolIndex];
          }];
          [self flashLetterSpace];
        }];
        [self.flashQueue addOperationWithBlock:^{

          
          [self flashLetterSpace];
        }];
        
      }
    }
    
  }
  
  [self.flashQueue addOperationWithBlock:^{
    _symbolIndex = 0;
    [self.delegate enableUIElements:NO];
  }];
}

//-(void)cancelSending
//{
//  [self.flashQueue cancelAllOperations];
//}



@end
