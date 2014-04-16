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

@end
@implementation TorchController

-(instancetype)initWithDevice
{
  self = [super init];
  self.myDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  self.flashQueue = [NSOperationQueue new];
  self.flashQueue.maxConcurrentOperationCount = 1;
  
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
    [self.flashQueue addOperationWithBlock:^{
      
      CGFloat progress = (CGFloat)[translatedArray indexOfObject:symbolLetter] / (CGFloat)translatedArray.count;
      
      [self.delegate sendingLetter:symbolLetter withProgress:progress];
    }];
    for(int i=0; i<_morseLetter.length; i++) {
      NSString *letter = [_morseLetter substringWithRange:NSMakeRange(i, 1)];
      if ([letter isEqualToString:@"."]) {
        [self.flashQueue addOperationWithBlock:^{
          [self flashDot];
        }];
      } else if ([letter isEqualToString:@"-"]) {
        [self.flashQueue addOperationWithBlock:^{
          [self flashDash];
        }];
      } else if ([letter isEqualToString:@" "]) {
        [self.flashQueue addOperationWithBlock:^{
          [self flashLetterSpace];
        }];
        [self.flashQueue addOperationWithBlock:^{
          [self flashLetterSpace];
        }];
        
      }
    }
    
  }
  [self.flashQueue addOperationWithBlock:^{
    [self.delegate enableUIElements:NO];
  }];

}

@end
