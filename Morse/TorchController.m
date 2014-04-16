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
@property (strong, nonatomic) NSOperationQueue *flashQueue;
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
  NSArray *translatedArray = [NSString translateMessageToMorse:messageToTranslate];
  
  for (_morseLetter in translatedArray) {
  
    for(int i=0; i<_morseLetter.length; i++) {
      NSString *letter = [_morseLetter substringWithRange:NSMakeRange(i, 1)];
      
      if ([letter isEqualToString:@"."]) {
        [self.flashQueue addOperationWithBlock:^{
//          [self.sendButton setEnabled:NO];
          [self flashDot];
        }];
      } else if ([letter isEqualToString:@"-"]) {
//        [self.sendButton setEnabled:NO];
        [self.flashQueue addOperationWithBlock:^{
          [self flashDash];
        }];
      } else if ([letter isEqualToString:@" "]) {
//        [self.sendButton setEnabled:NO];
        [self.flashQueue addOperationWithBlock:^{
          [self flashLetterSpace];
        }];
        [self.flashQueue addOperationWithBlock:^{
//          [self.sendButton setEnabled:NO];
          [self flashLetterSpace];
        }];
        
      }
    }
    
  }
  
}

@end
