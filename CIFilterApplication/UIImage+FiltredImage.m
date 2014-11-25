//
//  UIImage+FiltredImage.m
//  CIFilterApplication
//
//  Created by Vlad Korzun on 25.11.14.
//  Copyright (c) 2014 Vlad Korzun. All rights reserved.
//

#import "UIImage+FiltredImage.h"

@implementation UIImage (FiltredImage)

- (UIImage *)imageWithCIFilterName:(NSString *)CIFilterName
{
    if(!CIFilterName){
        return self;
    }
    UIImageOrientation orientation = self.imageOrientation;
    CIImage *inputImage = [[CIImage alloc] initWithCGImage:[self CGImage]];
    CIFilter *adjustmentFilter = [CIFilter filterWithName:CIFilterName];
    [adjustmentFilter setDefaults];
    [adjustmentFilter setValue:inputImage forKey:@"inputImage"];
    CIImage *outputImage = [adjustmentFilter outputImage];
    CIContext* context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:outputImage fromRect:outputImage.extent] ;
    UIImage* img = [[UIImage alloc] initWithCGImage:imgRef scale:1.0 orientation:orientation];
    CGImageRelease(imgRef);
    return img;
}

@end
