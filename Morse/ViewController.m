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

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textInput;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *currentLetter;
@property (strong, nonatomic)TorchController *torchController;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  _torchController = [[TorchController alloc]initWithDevice];
  
  
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
    
    [_torchController translatingToMorse:_textInput.text];
  }
}


@end
