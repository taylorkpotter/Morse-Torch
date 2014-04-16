//
//  TorchController.h
//  Morse
//
//  Created by Taylor Potter on 4/16/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TorchController : NSObject

-(instancetype)initWithDevice;

-(void)translatingToMorse:(NSString *)messageToTranslate;


@end
