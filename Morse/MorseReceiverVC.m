//
//  MorseReceiverVC.m
//  Morse
//
//  Created by Taylor Potter on 4/17/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "MorseReceiverVC.h"
#import  <AVFoundation/AVFoundation.h>


@interface MorseReceiverVC ()


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
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Run session setup after subviews are laid out.
- (void)viewDidLayoutSubviews
{
  // Create AVCaptureSession and set the quality of the output
  self.session = [[AVCaptureSession alloc] init];
  self.session.sessionPreset = AVCaptureSessionPresetPhoto;
  
  // Get the Back Camera Device, init a AVCaptureDeviceInput linking the Device and add the input to the session.
  self.videoDevice = [self backCamera];
  self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
  [self.session addInput:self.videoInput];
  
  // Insert code to add still image output here
  
  // Init the AVCaptureVideoPreviewLayer with our created session. Get the UIView layer
  AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
  CALayer *viewLayer = self.previewView.layer;
  
  // Set the AVCaptureVideoPreviewLayer bounds to the main view bounds and fill it accordingly. Add as sublayer to the main UIView
  [viewLayer setMasksToBounds:YES];
  captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  captureVideoPreviewLayer.frame = [viewLayer bounds];
  [viewLayer addSublayer:captureVideoPreviewLayer];
  
  // Start Running the Session
  [self.session startRunning];
}


// Utility Function to get the back camera device
- (AVCaptureDevice *)backCamera
{
  //Get all available devices, loop through and get the back position camera
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  for (AVCaptureDevice *device in devices)
  {
    if ([device position] == AVCaptureDevicePositionBack)
    {
      return device;
    }
  }
  return nil;
}




@end
