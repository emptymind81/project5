//
//  GenericTableLayout.h
//  testui
//
//  Created by Alun You on 7/13/13.
//  Copyright (c) 2013 Alun You. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableLayout : UICollectionViewLayout

@property NSArray* imageArray;
@property int spaceBetweenImage;

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
