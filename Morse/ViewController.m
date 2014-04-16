//
//  ViewController.m
//  Morse
//
//  Created by Taylor Potter on 4/14/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "ViewController.h"
#import "NSString+morseCode.h"
#import  <AVFoundation/AVFoundation.h>
#import  <QuartzCore/QuartzCore.h>

@interface ViewController () <UITextFieldDelegate>
@property (strong, nonatomic) NSOperationQueue *flashQueue;
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *currentLetter;
@property (strong, nonatomic) AVCaptureDevice *myDevice;
@property (strong, nonatomic) NSString *morseLetter;
//@property (weak, nonatomic) NSInteger *sleepDuration;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.myDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.flashQueue = [NSOperationQueue new];
    self.flashQueue.maxConcurrentOperationCount = 1;
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableOrDisableButton) name:UITextFieldTextDidChangeNotification object:nil];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if ( [self.textInput isFirstResponder]) {
    [self.textInput resignFirstResponder];
    
  }
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


-(void)translatingToMorse

{
NSArray *translatedArray = [NSString translateMessageToMorse:self.textInput.text];

  for (_morseLetter in translatedArray) {

    for(int i=0; i<_morseLetter.length; i++) {
      NSString *letter = [_morseLetter substringWithRange:NSMakeRange(i, 1)];
      
      if ([letter isEqualToString:@"."]) {
        [self.flashQueue addOperationWithBlock:^{
        [self.sendButton setEnabled:NO];
        [self flashDot];
        }];
      } else if ([letter isEqualToString:@"-"]) {
        [self.sendButton setEnabled:NO];
        [self.flashQueue addOperationWithBlock:^{
        [self flashDash];
        }];
      } else if ([letter isEqualToString:@" "]) {
        [self.sendButton setEnabled:NO];
        [self.flashQueue addOperationWithBlock:^{
        [self flashLetterSpace];
        }];
        [self.flashQueue addOperationWithBlock:^{
        [self.sendButton setEnabled:NO];
        [self flashLetterSpace];
        }];
        
      }
    }
    
  }
 
}

-(void)enableOrDisableButton
{
  if (_textInput.text.length == 0) {
    _textInput.layer.borderWidth = 2;
    _textInput.layer.borderColor = [[UIColor redColor] CGColor];
  } else {
    _textInput.layer.borderWidth = 0;
  }
}



- (IBAction)buttonPressed:(id)sender {
  if (_textInput.text.length == 0) {
    _textInput.layer.borderWidth = 2;
    _textInput.layer.borderColor = [[UIColor redColor] CGColor];
  } else {
    
  [self translatingToMorse];
  }
}


@end
