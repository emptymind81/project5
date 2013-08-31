//
//  ImageNavigationViewController.m
//  Wine
//
//  Created by Emptymind on 8/31/13.
//  Copyright (c) 2013 dangdang. All rights reserved.
//

#import "ImageNavigationViewController.h"


@interface ImageNavigationViewController ()

@end

@implementation ImageNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.spaceBetweenImage = 0;
        self.showScrollBar = true;
        self.enableScroll = true;
        self.allowsMultipleSelection = false;
        self.cellIdentifier = @"ImageNavigationViewControllerIdentifier";
    }
    return self;
}

-(void) doInit
{
    ImageTableLayout *layout = [[ImageTableLayout alloc] init];
    layout.imageArray = self.imageArray;
    layout.spaceBetweenImage = self.spaceBetweenImage;
    
    CGRect frame = self.view.frame;
    self.collectionView = [[PSUICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:self.cellIdentifier];
    self.collectionView.allowsMultipleSelection = false;
    [self.collectionView setScrollEnabled:self.enableScroll];
    self.collectionView.showsHorizontalScrollIndicator = self.showScrollBar;
    self.collectionView.showsVerticalScrollIndicator = self.showScrollBar;
    self.collectionView.allowsMultipleSelection = self.allowsMultipleSelection;
    
    [self.view addSubview:self.collectionView];
    
    //self.collectionView.layer.borderColor = [UIColor yellowColor].CGColor;
    //self.collectionView.layer.borderWidth = 2.0f;
    
    //self.collectionView.contentOffset = CGPointMake(1024*self.wineIndex, 0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self doInit];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark Collection View Data Source

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    UIImage* image = self.imageArray[indexPath.row];
    cell.image = image;
    
    return cell;
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView layout:(PSUICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage* image = self.imageArray[indexPath.row];
    CGSize size = {image.size.width, image.size.height};
    
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(PSUICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(PSUICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

#pragma mark -
#pragma mark Collection View Delegate

- (void)collectionView:(PSUICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(PSUICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(PSUICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate)
    {
        [self.delegate imageNavigationViewController:self didSelectItem:indexPath.row image:self.imageArray[indexPath.row]];
    }
}

- (void)collectionView:(PSUICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate)
    {
        [self.delegate imageNavigationViewController:self didUnSelectItem:indexPath.row image:self.imageArray[indexPath.row]];
    }
}

- (BOOL)collectionView:(PSUICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(PSUICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(PSUICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
