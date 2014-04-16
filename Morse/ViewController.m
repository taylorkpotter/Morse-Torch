//
//  ViewController.m
//  Morse
//
//  Created by Taylor Potter on 4/14/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import "ViewController.h"
#import "NSString+morseCode.h"
#import "TorchController.h"
#import  <BKECircularProgressView/BKECircularProgressView.h>
#import  <QuartzCore/QuartzCore.h>

@interface ViewController () <UITextFieldDelegate, TorchControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *currentLetter;
@property (strong, nonatomic)TorchController *torchController;
@property (strong, nonatomic)BKECircularProgressView *progressView;


@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
  
  _torchController = [[TorchController alloc]initWithDevice];
  _torchController.delegate = self;
  
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validateTextInput) name:UITextFieldTextDidChangeNotification object:nil];
 
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self setupProgressView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)validateTextInput
{
  if (_textInput.text.length == 0) {
    _textInput.layer.borderWidth = 2;
    _textInput.layer.borderColor = [[UIColor redColor] CGColor];
  } else {
    _textInput.layer.borderWidth = 0;
  }
}



- (IBAction)sendButtonPressed:(id)sender {
  if (_textInput.text.length == 0) {
    _textInput.layer.borderWidth = 2;
    _textInput.layer.borderColor = [[UIColor redColor] CGColor];
  } else {
    
    [_torchController translatingToMorse:_textInput.text];
    _textInput.text = @"";
  }
}
- (IBAction)cancelButtonPressed:(id)sender {
  [_torchController.flashQueue cancelAllOperations];
  _sendButton.imageView.image = [UIImage imageNamed:@"customButton"];
  _textInput.text = @"";
  
}

- (void)enableUIElements:(BOOL)enabled
{
  [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    if (enabled) {
      _sendButton.imageView.image = [UIImage imageNamed:@"cancel"];
    } else {
      _sendButton.imageView.image = [UIImage imageNamed:@"customButton"];
    }
  }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.textInput resignFirstResponder];
  return YES;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  if ( [self.textInput isFirstResponder]) {
    [self.textInput resignFirstResponder];
    
  }
}
- (void)setupProgressView
{
  _progressView = [[BKECircularProgressView alloc]initWithFrame:_sendButton.bounds];
  _progressView.progressTintColor = [UIColor redColor];
  _progressView.backgroundTintColor = [UIColor lightGrayColor];
  _progressView.lineWidth = 3.0;
  [_sendButton addSubview:_progressView];
  [_progressView setUserInteractionEnabled:NO];
}

-(void)sendingLetter:(NSString *)letter withProgress:(CGFloat)progress;
{
  [[NSOperationQueue mainQueue]addOperationWithBlock:^{
    NSLog(@"%f", progress);
    [_progressView setProgress:progress];
  }];
}





@end
