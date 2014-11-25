//
//  CIFilterCell.h
//  CIFilterApplication
//
//  Created by Vlad Korzun on 25.11.14.
//  Copyright (c) 2014 Vlad Korzun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIFilterCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

- (void)setObject:(id)object;

@end
