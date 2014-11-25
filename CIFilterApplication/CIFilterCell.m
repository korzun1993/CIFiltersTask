//
//  CIFilterCell.m
//  CIFilterApplication
//
//  Created by Vlad Korzun on 25.11.14.
//  Copyright (c) 2014 Vlad Korzun. All rights reserved.
//

#import "CIFilterCell.h"

@implementation CIFilterCell

- (void)setObject:(id)object
{
    [self.imageView setImage:object];
}

@end
