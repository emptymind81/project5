//
//  GenericTableLayout.m
//  testui
//
//  Created by Alun You on 7/13/13.
//  Copyright (c) 2013 Alun You. All rights reserved.
//

#import "ImageTableLayout.h"

@implementation ImageTableLayout

-(int) GetMaxHeight
{
    int max_height = 0;
    for (int i=0; i<self.imageArray.count; i++)
    {
        //NSString* image_name = [NSString stringWithFormat:@"wine%d", i+1];
        //UIImage* image = [UIImage imageNamed:image_name];
        UIImage* image = self.imageArray[i];
        if (image.size.height > max_height)
        {
            max_height = image.size.height;
        }
    }
    return max_height;
}

-(int) GetTotalWidth
{
    int total_width = 0;
    for (int i=0; i<self.imageArray.count; i++)
    {
        //NSString* image_name = [NSString stringWithFormat:@"wine%d", i+1];
        //UIImage* image = [UIImage imageNamed:image_name];
        UIImage* image = self.imageArray[i];
        total_width += image.size.width + self.spaceBetweenImage;
    }
    total_width -= self.spaceBetweenImage;
    return total_width;
}

-(CGSize)collectionViewContentSize
{
    int max_height = [self GetMaxHeight];
    int total_width = [self GetTotalWidth];
    CGSize size = {total_width, max_height};
    return size;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //UICollectionView* view = self.collectionView;
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    int pos = 0;
    for (int i=0; i<self.imageArray.count; i++)
    {
        NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
        
        UIImage* image = self.imageArray[i];
        
        //CGSize size = image.size;
        
        CGRect rect1 = CGRectMake(pos, 0, image.size.width+self.spaceBetweenImage, image.size.height);
        attributes.frame = rect1;
        //NSLog(@"rect.x=%.1f, rect.y=%.1f", rect.origin.x, rect.origin.y);
        if(CGRectIntersectsRect(rect, attributes.frame))
        {
            [array addObject:attributes];
        }
        
        pos += image.size.width + self.spaceBetweenImage;
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewLayoutAttributes* res = [super layoutAttributesForItemAtIndexPath:indexPath];
    //res.frame = CGRectMake(100, 0, res.frame.size.width/2, res.frame.size.height);
    
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    int pos = 0;
    for (int i=0; i<indexPath.row; i++)
    {
        UIImage* image = self.imageArray[i];
        pos += image.size.width + self.spaceBetweenImage;
    }
    
    UIImage* image = self.imageArray[indexPath.row];
    //CGSize size = image.size;
    
    CGRect rect1 = CGRectMake(pos, 0, image.size.width+self.spaceBetweenImage, image.size.height);
    attributes.frame = rect1;
        
    return attributes;
}

@end
