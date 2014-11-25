//
//  ViewController.m
//  CIFilterApplication
//
//  Created by Vlad Korzun on 25.11.14.
//  Copyright (c) 2014 Vlad Korzun. All rights reserved.
//

#import "ViewController.h"
#import "CIFilterCell.h"
#import "UIImage+FiltredImage.h"
#import "UIImage+Resize.h"

@interface ViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationBarDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrayOfFiltersNames;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) NSArray *cache;

@property (nonatomic, strong) NSOperationQueue *filterQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterQueue = [[NSOperationQueue alloc] init];
    [self.filterQueue setQualityOfService:NSQualityOfServiceBackground];
    [self selectPhoto];
    self.arrayOfFiltersNames = [CIFilter filterNamesInCategory:kCICategoryColorEffect];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CIFilterCell *cell = (CIFilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if(indexPath.row == 0){
        [cell setObject:self.originalImage];
    } else {
        [cell setObject:self.cache[indexPath.row - 1]];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cache.count + 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = self.collectionView.frame.size;
    size.height -= [self.topLayoutGuide length];
    return size;
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    [self applyFilters];
}

- (void)applyFilters
{
    [self.filterQueue cancelAllOperations];
    self.cache = @[];
    [self.collectionView reloadData];
    for(NSString *filterName in self.arrayOfFiltersNames){
        [self.filterQueue addOperationWithBlock:^{
            UIImage *image = [self.originalImage imageWithCIFilterName:filterName];
        if(image){
            self.cache = [self.cache arrayByAddingObject:image];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
            
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.originalImage = [self scaledImageToCellSize:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaledImageToCellSize:(UIImage *)image
{
    CGSize size = self.collectionView.frame.size;
    size.height -= [self.topLayoutGuide length];
    return [image resizedImageToFitInSize:size scaleIfSmaller:NO];
}

- (IBAction)selectPhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

@end
