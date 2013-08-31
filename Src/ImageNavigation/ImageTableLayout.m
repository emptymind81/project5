//
//  GenericTableLayout.m
//  testui
//
//  Created by Alun You on 7/13/13.
//  Copyright (c) 2013 Alun You. All rights reserved.
//

#import "ImageTableLayout.h"

@implementation ImageTableLayout
{
    NSMutableArray* m_prepared_attrs;
}

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

-(void) prepareLayout
{
    m_prepared_attrs = [[NSMutableArray alloc] init];
    int pos = 0;
    for (int i=0; i<self.imageArray.count; i++)
    {
        NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:0];
        PSUICollectionViewLayoutAttributes* attributes = [PSUICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
        
        UIImage* image = self.imageArray[i];
        
        //CGSize size = image.size;
        
        CGRect rect1 = CGRectMake(pos, 0, image.size.width+self.spaceBetweenImage, image.size.height);
        attributes.frame = rect1;
        //NSLog(@"rect.x=%.1f, rect.y=%.1f", rect.origin.x, rect.origin.y);
        //if(CGRectIntersectsRect(rect, attributes.frame))
        {
            [m_prepared_attrs addObject:attributes];
        }
        
        pos += image.size.width + self.spaceBetweenImage;
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //PSUICollectionView* view = self.collectionView;
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (int i=0; i<m_prepared_attrs.count; i++)
    {
        PSUICollectionViewLayoutAttributes* attributes = m_prepared_attrs[i];
        CGRect frame = attributes.frame;
        //NSLog(@"frame.x=%.1f, frame.y=%.1f", frame.origin.x, frame.origin.y);
        if(CGRectIntersectsRect(rect, frame))
        {
            [array addObject:attributes];
        }
    }
    return array;
}

- (PSUICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //PSUICollectionViewLayoutAttributes* res = [super layoutAttributesForItemAtIndexPath:indexPath];
    //res.frame = CGRectMake(100, 0, res.frame.size.width/2, res.frame.size.height);
    
    PSUICollectionViewLayoutAttributes* attributes = [PSUICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /*int pos = 0;
    for (int i=0; i<indexPath.row; i++)
    {
        UIImage* image = self.imageArray[i];
        pos += image.size.width + self.spaceBetweenImage;
    }
    
    UIImage* image = self.imageArray[indexPath.row];
    //CGSize size = image.size;
    
    CGRect rect1 = CGRectMake(pos, 0, image.size.width+self.spaceBetweenImage, image.size.height);
    attributes.frame = rect1;*/
        
    return attributes;
}

@end
