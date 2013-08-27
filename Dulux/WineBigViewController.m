//
//  DoorsViewController.m
//  Dulux
//
//  Created by You Alun on 8/7/13.
//  Copyright (c) 2013 dangdang. All rights reserved.
//

#import "WineBigViewController.h"
#import "AutoLayoutHelper.h"
#import "QuartzCore/QuartzCore.h"

@interface WineBigViewController ()

@end

typedef enum
{
    InitReason_GoLeft=0,
    InitReason_GoRight=1,
    InitReason_ViewAppear=2
} InitReason;

@implementation WineBigViewController
{
   
   UIImageView* m_back_image_view;
    UIImageView* m_wine_image_view;
    
    UIButton* m_left_button;
    UIButton* m_right_button;
    
    int m_total_wine_num;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        m_total_wine_num = 16;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self reInitSubViews:InitReason_ViewAppear];
}

-(void) updateButtonStatus
{
    if (self.wineIndex == 0)
    {
        m_left_button.enabled = false;
    }
    else
    {
        m_right_button.enabled = true;
    }
    
    if (self.wineIndex == m_total_wine_num-1)
    {
        m_right_button.enabled = false;
    }
    else
    {
        m_right_button.enabled = true;
    }
}

- (void) reInitSubViews:(InitReason)initReason
{
    [self clearView];
    
    NSString* back_pic = @"single-back.jpg";
    m_back_image_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:back_pic]];
    [self.view addSubview:m_back_image_view];
    
    //add animation
    [self addSwitchViewAnimation:initReason];
    
    NSString* wine_pic = [NSString stringWithFormat:@"single-%d.png", self.wineIndex+1];
    m_wine_image_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:wine_pic]];
    [self.view addSubview:m_wine_image_view];
    
    
    
    NSString* left_button_pic = @"leftbutton.png";
    UIImage* left_button_image = [UIImage imageNamed:left_button_pic];
    m_left_button = [[UIButton alloc] init];
    m_left_button.frame = CGRectMake(496, 327, left_button_image.size.width, left_button_image.size.height);
    [m_left_button setImage:left_button_image forState:UIControlStateNormal];
    [m_left_button addTarget:self action:@selector(goLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_left_button];
    
    NSString* right_button_pic = @"rightbutton.png";
    UIImage* right_button_image = [UIImage imageNamed:right_button_pic];
    m_right_button = [[UIButton alloc] init];
    m_right_button.frame = CGRectMake(841, 327, right_button_image.size.width, right_button_image.size.height);
    [m_right_button setImage:right_button_image forState:UIControlStateNormal];
    [m_right_button addTarget:self action:@selector(goRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_right_button];
    
    NSString* back_button_pic = @"wines-back-button.png";
    UIImage* back_button_image = [UIImage imageNamed:back_button_pic];
    UIButton* back_button = [[UIButton alloc] init];
    int back_button_x = 650;
    int back_button_y = 472;
    if (self.wineIndex == 11) {
        back_button_y = 557;
    }
    else if (self.wineIndex == 12) {
        back_button_y = 480;
    }
    else if (self.wineIndex == 13) {
        back_button_y = 495;
    }
    else if (self.wineIndex == 14) {
        back_button_y = 460;
    }
    else if (self.wineIndex == 15) {
        back_button_y = 441;
    }
    back_button.frame = CGRectMake(back_button_x, back_button_y, back_button_image.size.width, back_button_image.size.height);
    [back_button setImage:back_button_image forState:UIControlStateNormal];
    [back_button addTarget:self action:@selector(navigateBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back_button];
    
    NSArray* sub_views = self.view.subviews;
    for (int i=0; i<sub_views.count; i++)
    {
        UIView* view = sub_views[i];
        view.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    //[self initNavigateButtons];
    
    [self initSwipeRecognizers];
    [self updateButtonStatus];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) switchToRoom
{
    /*[UIView animateWithDuration:0.3
                     animations:^{
                         self.view.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                         RoomViewController* view_controller = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:nil];
                         view_controller.seriIndex = self.seriIndex;
                         view_controller.roomIndex = self.roomIndex;
                         [self.navigationController pushViewController:view_controller animated:false];
                     }];
     */

}

- (void) startDetail:(id)sender
{
    [self switchToRoom];
}

- (void) clearView
{
    NSArray* sub_views = self.view.subviews;
    for (int i=0; i<sub_views.count; i++)
    {
        UIView* view = sub_views[i];
        [view removeFromSuperview];
    }
    for (int i=0; i<self.view.gestureRecognizers.count; i++)
    {
        UIGestureRecognizer* recognizer = self.view.gestureRecognizers[i];
        [self.view removeGestureRecognizer:recognizer];
    }
}

- (void) addSwitchViewAnimation:(InitReason)initReason
{
    if (initReason == InitReason_GoLeft || initReason == InitReason_GoRight)
    {
        [UIView animateWithDuration:0.5
                         animations:^{
                             m_wine_image_view.alpha = 0;
                             m_wine_image_view.frame = CGRectOffset(m_wine_image_view.frame, -1024, 0);
                         }
                         completion:^(BOOL finished){
                             //sleep(1);
                             
                             //NSString* kv_image_name = [NSString stringWithFormat:@"%@%d-kv.jpg", @"seri", seriIndex+1];
                             //[self switchToDoorsViewController:seriIndex kvImageName:kv_image_name];
                             
                             //[image_view removeFromSuperview];
                         }];
        
        /*// set up an animation for the transition between the views
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType:kCATransitionPush];
        if (initReason == InitReason_GoLeft)
        {
            [animation setSubtype:kCATransitionFromRight];
        }
        else
        {
            [animation setSubtype:kCATransitionFromLeft];
        }
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [[self.view layer] addAnimation:animation forKey:@"SwitchToView"];*/
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
    if (self.wineIndex == 0)
    {
        return;
    }
    
    self.wineIndex = (self.wineIndex-1+m_total_wine_num) % m_total_wine_num;
    [self reInitSubViews:InitReason_GoLeft];
    [self updateButtonStatus];
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)swipeRecognizer
{
    if (self.wineIndex == m_total_wine_num-1)
    {
        return;
    }
    
    self.wineIndex = (self.wineIndex+1+m_total_wine_num) % m_total_wine_num;
    [self reInitSubViews:InitReason_GoRight];
    [self updateButtonStatus];
}

- (void) goLeft:(id)sender
{
    self.wineIndex = (self.wineIndex-1+m_total_wine_num) % m_total_wine_num;
    [self reInitSubViews:InitReason_GoLeft];
    [self updateButtonStatus];
}

- (void) goRight:(id)sender
{
    self.wineIndex = (self.wineIndex+1+m_total_wine_num) % m_total_wine_num;
    [self reInitSubViews:InitReason_GoRight];
    [self updateButtonStatus];
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
    home_button.frame = CGRectMake(x, y, button_width, button_height);
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
    /*[UIView animateWithDuration:1
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         //sleep(1);
                         
                         [self.navigationController popViewControllerAnimated:TRUE];
                     }];*/
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:1];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view layer] addAnimation:animation forKey:@"SwitchToView"];

    
    [self.navigationController popViewControllerAnimated:FALSE];
}

@end
