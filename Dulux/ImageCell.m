//
//  ImageGridCell.m
//  SelectionDelegateExample
//
//  Created by orta therox on 06/11/2012.
//  Copyright (c) 2012 orta therox. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell
{
    UIImageView* m_image_view;
    UIImage* m_image;
}

-(UIImage*) image
{
    return m_image;
}

-(void) setImage:(UIImage*)image
{
    m_image = image;
    m_image_view.image = self.image;
}


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /*UIView *background = [[UIView alloc] init];
        background.backgroundColor = [UIColor colorWithRed:1.000 green:0.000 blue:0.000 alpha:1.000];
        self.selectedBackgroundView = background;
        self.backgroundColor = [UIColor colorWithRed:0.509 green:0.519 blue:0.500 alpha:1.000];*/
        
        self.backgroundColor = [UIColor clearColor];
        
        m_image_view = [[UIImageView alloc] init];
        m_image_view.image = self.image;
        CGRect rect = self.frame;
        rect = m_image_view.frame;
        m_image_view.frame = self.bounds;
        m_image_view.contentMode = UIViewContentModeTopLeft;
        //m_image_view.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:m_image_view];
         
    }
    return self;
}

- (void)layoutSubviews {
    m_image_view.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    CGRect rect = self.bounds;
    rect = self.frame;
}

- (void)setHighlighted:(BOOL)highlighted {
    /*NSLog(@"Cell %@ highlight: %@", _label.text, highlighted ? @"ON" : @"OFF");
    if (highlighted) {
        _label.backgroundColor = [UIColor yellowColor];
    }
    else {
        _label.backgroundColor = [UIColor underPageBackgroundColor];
    }*/
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    //NSLog(@"Cell select: %@", selected ? @"ON" : @"OFF");
}

@end
