//
//  MorseReceiverVC.h
//  Morse
//
//  Created by Taylor Potter on 4/17/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface MorseReceiverVC : UIViewController

@property (strong, nonatomic) IBOutlet UIView *previewView;

@property (strong, nonatomic) AVCaptureSession *session;
@property (strong) AVCaptureDevice *videoDevice;
@property (strong) AVCaptureDeviceInput *videoInput;
@property (strong) AVCaptureStillImageOutput *stillImageOutput;

@end
