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
#import  <QuartzCore/QuartzCore.h>
#import "LDProgressView.h"
#import "UIColor+RGBValues.h"

@interface ViewController () <UITextFieldDelegate, TorchControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *currentLetter;
@property (strong, nonatomic)TorchController *torchController;
@property (strong, nonatomic)LDProgressView *progressView;


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
  [self showProgressBar];

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

-(void)updateProgressBarWithTotal:(CGFloat)total andProgress:(CGFloat)progress

{

  _progressView.progress = progress / total;
  NSLog(@"%f", _progressView.progress);

}

-(void)showProgressBar

{
  _progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 145, self.view.frame.size.width-40, 5)];
  _progressView.progress = 0.0;
  _progressView.borderRadius = @0;
  _progressView.type = LDProgressStripes;
  _progressView.color = [UIColor redColor];
  [self.view addSubview:_progressView];
}






@end
