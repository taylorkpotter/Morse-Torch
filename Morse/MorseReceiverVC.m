//
//  MorseReceiverVC.m
//  Morse
//
//  Created by Taylor Potter on 4/17/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "MorseReceiverVC.h"
#import  <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImage.h>
#import <SFGaugeView/SFGaugeView.h>




@interface MorseReceiverVC () <SFGaugeViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *luminLabel;
@property (strong, nonatomic)GPUImageVideoCamera *videoCamera;
@property (strong, nonatomic)NSString *luminValue;
@property (weak, nonatomic) IBOutlet SFGaugeView *gaugeView;

@property (nonatomic) BOOL flag;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@end

@implementation MorseReceiverVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  self.gaugeView.maxlevel = 100;
}


-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  _videoCamera = [GPUImageVideoCamera new];
  _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
  
  
  
  GPUImageLuminosity*lumin = [[GPUImageLuminosity alloc] init];
  [_videoCamera addTarget:lumin];
  
  [(GPUImageLuminosity *)lumin setLuminosityProcessingFinishedBlock:^(CGFloat luminosity, CMTime frameTime) {
   // Do something with the luminosity here
   //  _luminValue = [NSString stringWithFormat:@"%f", luminosity];
    
//    if ([[NSThread currentThread]isMainThread]) {
//      NSLog(@"Main thread...");
//    } else {
//      NSLog(@"Not main thread...");
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
      _luminLabel.text = [NSString stringWithFormat:@"%f", luminosity];
      // NSLog(@"%f", luminosity * 100);
      
      int intLevel = luminosity * 100;
      self.gaugeView.currentLevel = luminosity * 100;
      NSLog(@"%li", self.gaugeView.currentLevel);

      
      if (intLevel > 80) {
      
      NSLog(@"%i", intLevel);
  
        if (!self.flag) {
      
         // Find out the start date...
          self.startDate = [NSDate date];
          
          self.flag = YES;
        }
        
      } else if (intLevel < 28) {
        
        
          
          // End date...
          
          NSTimeInterval timeSince = [[NSDate date]timeIntervalSinceDate:self.startDate];
          
        if (timeSince >= 2.5 && timeSince <= 3.3) {
          NSLog(@"Its a freaking dash...");
          timeSince = 0.0;
        }
          
          self.flag = NO;
        
        
      }
      
    });
    
  }];

  [_videoCamera startCameraCapture];
  
  NSLog(@"Testing is %@", _luminValue);
  

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sfGaugeView:(SFGaugeView*) gaugeView didChangeLevel:(NSInteger) level
{
  // NSLog(@"%li", self.gaugeView.currentLevel);
}

@end
