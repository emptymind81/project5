//
//  DoorsViewController.m
//  Dulux
//
//  Created by You Alun on 8/7/13.
//  Copyright (c) 2013 dangdang. All rights reserved.
//

#import "WinesViewController.h"
#import "AutoLayoutHelper.h"
#import "WineBigViewController.h"
#import "UIImage+Tint.h"
#import "ImageTableLayout.h"
#import "ImageCell.h"

NSString *kDetailedViewControllerID = @"DetailView";    // view controller storyboard id
NSString *kCellID = @"cellID";        // UICollectionViewCell storyboard id

NSString *CollectionViewCellIdentifier = @"ImageCollectionViewCellIdentifier";

@interface WinesViewController ()

@end

@implementation WinesViewController
{
   NSMutableArray* m_image_views;
   UIImageView* m_image_view1;
   UIImageView* m_image_view2;
   UIImageView* m_image_view3;
   
   UIImageView* m_icon_image_view;
    
    int m_x_margin;
    
    int m_current_x;
    bool first_init;
    
    int m_space_between;
    
    int m_wines_num;
    
    UICollectionView* m_collection_view;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_x_margin = 10;
        m_current_x = 0;
        first_init = true;
        m_wines_num = 24;
        m_space_between = 55;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* back_pic = @"wines-back.jpg";
    UIImage* image = [UIImage imageNamed:back_pic];
    UIImageView* back_image_view = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:back_image_view];
    
    /*m_image_views = [[NSMutableArray alloc] init];
     if (first_init) {
     m_current_x = m_x_margin;
     }
     first_init = false;
     int pos = m_current_x;
     for (int i=0; i<m_wines_num; i++)
     {
     NSString* image_name = [NSString stringWithFormat:@"wine%d", i+1];
     UIImage* image = [UIImage imageNamed:image_name];
     UIImageView* image_view = [[UIImageView alloc] initWithImage:image];
     image_view.frame = CGRectMake(pos, 768-83-image_view.frame.size.height, image_view.frame.size.width, image_view.frame.size.height);
     
     //image_view.translatesAutoresizingMaskIntoConstraints = false;
     image_view.contentMode = UIViewContentModeScaleToFill;
     image_view.userInteractionEnabled = true;
     
     [self.view addSubview:image_view];
     [m_image_views addObject:image_view];
     pos += image.size.width + m_space_between;
     }*/
    
    NSMutableArray* image_array = [[NSMutableArray alloc] init];
    for (int i=0; i<m_wines_num; i++)
    {
        NSString* image_name = [NSString stringWithFormat:@"wine%d", i+1];
        UIImage* image = [UIImage imageNamed:image_name];
        [image_array addObject:image];
    }
    
    ImageTableLayout *layout = [[ImageTableLayout alloc] init];
    layout.imageArray = image_array;
    layout.spaceBetweenImage = m_space_between;
    
    int max_height = [self GetMaxHeight:m_wines_num];
    CGRect frame = CGRectMake(0, 768-83-max_height, 1024, max_height);
    m_collection_view = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    m_collection_view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    m_collection_view.delegate = self;
    m_collection_view.dataSource = self;
    m_collection_view.backgroundColor = [UIColor clearColor];
    [m_collection_view registerClass:[ImageCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    m_collection_view.allowsMultipleSelection = false;
    
    [self.view addSubview:m_collection_view];
    
    //m_collection_view.layer.borderColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.5 alpha:1].CGColor;
    //m_collection_view.layer.borderWidth = 2.0f;
    
    NSString* back_button_pic = @"wines-back-button.png";
    UIImage* back_button_image = [UIImage imageNamed:back_button_pic];
    UIButton* back_button = [[UIButton alloc] init];
    back_button.frame = CGRectMake(470, 280, 82, 45);
    [back_button setImage:back_button_image forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(navigateBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back_button];
    
    //[self initSwipeRecognizers];
    
    //[self addRecognizers];
}

-(int) GetMaxHeight:(int)imageNum
{
    int max_height = 0;
    for (int i=0; i<imageNum; i++)
    {
        NSString* image_name = [NSString stringWithFormat:@"wine%d", i+1];
        UIImage* image = [UIImage imageNamed:image_name];
        if (image.size.height > max_height)
        {
            max_height = image.size.height;
        }
    }
    return max_height;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) wineClicked:(id)sender
{
    int index = -1;
    for (int i=0; i<m_image_views.count; i++)
    {
        if (m_image_views[i] == sender)
        {
            index = i;
            break;
        }
    }
    
    [self switchToWine:index];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Began");
    [self logTouches: event];
    
    [super touchesEnded: touches withEvent: event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Moved");
    [self logTouches: event];
    
    [super touchesEnded: touches withEvent: event];
    
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.view];
    CGPoint previousLocation = [aTouch previousLocationInView:self.view];
    
    int offset = (location.x-previousLocation.x)*1;
    
    UIImageView* view0 = m_image_views[0];
    int view0_new_left = view0.frame.origin.x + offset;
    int view0_new_right = view0.frame.origin.x + view0.frame.size.width + offset;
    if (view0_new_left >= m_x_margin)
    {
        return;
    }
    
    UIImageView* viewlast = m_image_views[m_image_views.count-1];
    int viewlast_new_left = viewlast.frame.origin.x + offset;
    int viewlast_new_right = viewlast.frame.origin.x + viewlast.frame.size.width + offset;
    if (viewlast_new_right <= 1024-m_x_margin)
    {
        return;
    }
    
    
    m_current_x += offset;
    for (int i=0; i<m_image_views.count; i++)
    {
        UIImageView* view = m_image_views[i];
        view.frame = CGRectOffset(view.frame, offset, 0);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches Ended");
    [self logTouches: event];
    
    [super touchesEnded: touches withEvent: event];
}

-(void)logTouches: (UIEvent*)event
{
    int count = 1;
    
    for (UITouch* touch in event.allTouches)
    {
        CGPoint location = [touch locationInView: self.view];
        
        NSLog(@"%d: (%.0f, %.0f)", count, location.x, location.y);
        count++;
    }
}

- (void) initSwipeRecognizers
{
    UISwipeGestureRecognizer* swipe_left_recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipe_left_recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer* swipe_right_recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipe_right_recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe_left_recognizer];
    [self.view addGestureRecognizer:swipe_right_recognizer];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)swipeRecognizer
{
    
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)swipeRecognizer
{
    
}


-(void) switchToWine:(int)wineIndex
{
    [UIView animateWithDuration:0.1
                     animations:^{
                         self.view.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                         WineBigViewController* view_controller = [[WineBigViewController alloc] initWithNibName:@"WineBigViewController" bundle:nil];
                         view_controller.wineIndex = wineIndex;
                         [self.navigationController pushViewController:view_controller animated:false];
                     }];

}

- (void) addRecognizers
{
    for (int i=0; i<m_image_views.count; i++)
    {
        UIImageView* view = m_image_views[i];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [view addGestureRecognizer:singleTap];
    }
}

- (void) clearRecognizers
{
    for (int i=0; i<m_image_views.count; i++)
    {
        UIImageView* view = m_image_views[i];
        for (int i=0; i<view.gestureRecognizers.count; i++)
        {
            UIGestureRecognizer* recognizer = view.gestureRecognizers[i];
            [view removeGestureRecognizer:recognizer];
        }
    }
}

- (void) disableRecognizers
{
    for (int i=0; i<m_image_views.count; i++)
    {
        UIImageView* view = m_image_views[i];
        for (int i=0; i<view.gestureRecognizers.count; i++)
        {
            UIGestureRecognizer* recognizer = view.gestureRecognizers[i];
            recognizer.enabled = false;
        }
    }
}

- (void) enableRecognizers
{
    for (int i=0; i<m_image_views.count; i++)
    {
        UIImageView* view = m_image_views[i];
        for (int i=0; i<view.gestureRecognizers.count; i++)
        {
            UIGestureRecognizer* recognizer = view.gestureRecognizers[i];
            recognizer.enabled = false;
        }
    }
}

- (void) handleImageClick:(int)imageIndex
{
    int detail_wine_index = imageIndex;
    if (imageIndex == 10 || imageIndex == 12 || imageIndex == 13 || imageIndex == 16  ||
        imageIndex == 18 || imageIndex == 20 || imageIndex == 22 || imageIndex == 23)
    {
        return;
    }
    if (imageIndex == 11) {
        detail_wine_index = imageIndex - 1;
    }
    if (imageIndex >= 14) {
        detail_wine_index = imageIndex - 3;
    }
    if (imageIndex >= 17) {
        detail_wine_index = imageIndex - 4;
    }
    if (imageIndex >= 19) {
        detail_wine_index = imageIndex - 5;
    }
    if (imageIndex >= 21) {
        detail_wine_index = imageIndex - 6;
    }
    if (imageIndex >= 24) {
        detail_wine_index = imageIndex - 8;
    }
    
    //[self clearRecognizers];
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         //m_image_view2.alpha = 0.2;
                         //view.image = [UIImage imageNamed:@"door102open.png"];
                     }
                     completion:^(BOOL finished){
                         //sleep(1);
                         
                         [self switchToWine:detail_wine_index];
                     }];
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    
    for (int i=0; i<m_image_views.count; i++)
    {
        UIImageView* view = m_image_views[i];
        if (view == tapRecognizer.view)
        {
            [self handleImageClick:i];
        }
    }
}

- (void) initNavigateButtons
{
    CGRect bounds = self.view.bounds;
    int button_width  = 52;
    int button_height = 48;
    int x = 20;
    int y = bounds.size.height - 14 - button_height;
    
    NSString* home_pic = @"homebutton.png";
    UIImage* home_image = [UIImage imageNamed:home_pic];
    UIButton* home_button = [[UIButton alloc] init];
    home_button.frame = CGRectMake(470, 280, 82, 45);
    [home_button setImage:home_image forState:UIControlStateNormal];
    [home_button addTarget:self action:@selector(navigateHome:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:home_button];
    
    NSString* back_pic = @"backbutton.png";
    UIImage* back_image = [UIImage imageNamed:back_pic];
    UIButton* back_button = [[UIButton alloc] init];
    back_button.frame = CGRectMake(x+button_width+20, y, button_width, button_height);
    [back_button setImage:back_image forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(navigateBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back_button];
}

- (void) navigateHome:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

- (void) navigateBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:TRUE];
}


#pragma mark -
#pragma mark Collection View Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSString* image_name = [NSString stringWithFormat:@"wine%d", indexPath.row+1];
    cell.image = [UIImage imageNamed:image_name];
    cell.frame = CGRectMake(0, 0, cell.image.size.width, cell.image.size.height);
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* image_name = [NSString stringWithFormat:@"wine%d", indexPath.row+1];
    UIImage* image = [UIImage imageNamed:image_name];
    CGSize size = {image.size.width, image.size.height};
    
    return size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return m_wines_num;
}

#pragma mark -
#pragma mark Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self handleImageClick:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


@end
