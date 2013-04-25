//
//  LoadFullView.m
//  ArtChina
//
//  Created by 王 军 on 13-1-31.
//  Copyright (c) 2013年 王 军. All rights reserved.
//

#import "LoadFullView.h"

@implementation LoadFullView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView:) name:@"remove.load.view" object:nil];
    }
    return self;
}
-(void)removeView:(NSNotification *)notification
{
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
