//
//  ImageNavigationViewController.h
//  Wine
//
//  Created by Emptymind on 8/31/13.
//  Copyright (c) 2013 dangdang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCell.h"
#import "ImageTableLayout.h"

@class ImageNavigationViewController;

@protocol ImageNavigationViewControllerDelegate
@required

- (void)imageNavigationViewController:(ImageNavigationViewController *)imageNavigationViewController didSelectItem:(int)rowIndex image:(UIImage*)image;
- (void)imageNavigationViewController:(ImageNavigationViewController *)imageNavigationViewController didUnSelectItem:(int)rowIndex image:(UIImage*)image;
@end

/////////////////////////////////

@interface ImageNavigationViewController : UIViewController<PSUICollectionViewDataSource, PSUICollectionViewDelegate>

//required
@property NSMutableArray* imageArray;

//option
@property int spaceBetweenImage;
@property bool showScrollBar;
@property bool enableScroll;
@property bool allowsMultipleSelection;

@property NSString* cellIdentifier;

@property id<ImageNavigationViewControllerDelegate> delegate;


//for get or internal use
@property PSUICollectionView* collectionView;

@end
