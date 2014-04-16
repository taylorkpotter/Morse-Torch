//
//  TorchController.h
//  Morse
//
//  Created by Taylor Potter on 4/16/14.
//  Copyright (c) 2014 potter.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TorchControllerDelegate <NSObject>

-(void)sendingLetter:(NSString *)letter withProgress:(CGFloat)progress;
-(void)enableUIElements:(BOOL)enabled;


@end

@interface TorchController : NSObject
@property(unsafe_unretained, nonatomic)id<TorchControllerDelegate> delegate;
@property (strong, nonatomic) NSOperationQueue *flashQueue;


-(instancetype)initWithDevice;

-(void)translatingToMorse:(NSString *)messageToTranslate;


@end
