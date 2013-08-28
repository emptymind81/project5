//
//  ViewController.m
//  Dulux
//
//  Created by Alun You on 8/6/13.
//  Copyright (c) 2013 dangdang. All rights reserved.
//

#import "ViewController.h"
#import "WinesViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MediaPlayer/MPMoviePlayerViewController.h"
#import "MediaPlayer/MPMoviePlayerController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray* m_image_views;
    
    UIView* m_flash_view;
    UIView* m_kv_view;
    
    NSMutableArray* m_buttons;
    
    MPMoviePlayerController* m_movie_player;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   
   /*CGRect bounds = self.view.bounds;
   CGRect button_rect = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
   UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
   button.frame = button_rect;
   [button setTitle:@"Add" forState:UIControlStateNormal];
   //[m_add_relation_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   button.autoresizingMask = UIViewAutoresizingNone;
   [button addTarget:self action:@selector(add_relation:) forControlEvents:UIControlEventTouchUpInside];
   button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   [self.view addSubview:button];
   
   [UIView animateWithDuration:3.5 animations:^{
      button.alpha = 0.0;
      button.frame = CGRectMake(0, 0,100, 20);
   }];*/
    
    NSString* back_pic = @"home-background.jpg";
    UIImage* image = [UIImage imageNamed:back_pic];
    /*NSString* back_pic = @"whitewall.png";
     image = [image imageWithGradientTintColor:[UIColor orangeColor]];*/
    UIImageView* back_image_view = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:back_image_view];
    
    int first_button_x = 285;
    int first_button_y = 546;
    m_buttons = [[NSMutableArray alloc] init];
    for(int i=0; i<4; i++)
    {
        int x = first_button_x + i * 124;
        NSString* button_pic = @"home-button1.png";
        if (i != 0)
        {
            button_pic = @"home-button2.png";
        }
        
        UIImage* button_image = [UIImage imageNamed:button_pic];
        UIButton* button = [[UIButton alloc] init];
        button.frame = CGRectMake(x, first_button_y, 85, 85);
        [button setImage:button_image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

        
        [self.view addSubview:button];
        [m_buttons addObject:button];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//for ios6
- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft  ||orientation ==  UIInterfaceOrientationLandscapeRight )
    {
        return YES;
    }
    return NO;
}

//for ios5

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft  ||
        interfaceOrientation ==  UIInterfaceOrientationLandscapeRight )
    {
        return YES;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
}


-(void) buttonClicked:(id)sender
{
    int index = -1;
    for (int i=0; i<m_buttons.count; i++)
    {
        if (m_buttons[i] == sender)
        {
            index = i;
            break;
        }
    }
    
    if (index == 0)
    {
        WinesViewController* view_controller = [[WinesViewController alloc] initWithNibName:@"WinesViewController" bundle:nil];
        [self.navigationController pushViewController:view_controller animated:false];
    }
    else
    {
        NSURL *url = nil;
        if (index-1 == 0)
        {
            url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ALCHEMY_EDIT_006-H264_720P" ofType:@"mov"]];
        }
        else if (index-1 == 1)
        {
            url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"RGS+video+final" ofType:@"mov"]];
        }
        else if (index-1 == 2)
        {
            url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"movie1" ofType:@"m4v"]];
        }
        MPMoviePlayerViewController * playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerWillExitFullscreen:)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:[playerController moviePlayer]];
        
        playerController.moviePlayer.controlStyle = MPMovieControlModeVolumeOnly;
        [playerController.moviePlayer setFullscreen:YES];
        
        playerController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        //playerController.moviePlayer.fullscreen = true;
        playerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        
        [self presentMoviePlayerViewControllerAnimated:(MPMoviePlayerViewController *)playerController];
        
        
        [playerController.moviePlayer play];
        
        /*m_movie_player  = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerWillExitFullscreen:)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:m_movie_player];
        
        m_movie_player.controlStyle = MPMovieControlStyleDefault;
        //m_movie_player.fullscreen = true;
        
        m_movie_player.scalingMode = MPMovieScalingModeAspectFill;
        [m_movie_player.view setFrame:self.view.bounds];
        [m_movie_player.view setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:m_movie_player.view];
        //[m_movie_player play];
        
        m_movie_player.shouldAutoplay=YES;
        
        [m_movie_player setControlStyle:MPMovieControlStyleDefault];
        
        [m_movie_player setFullscreen:YES animated:YES]; 
        
        [m_movie_player.view setFrame:self.view.bounds];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.view addGestureRecognizer:singleTap];*/
    }
}

- (void)moviePlayerWillExitFullscreen:(NSNotification *)theNotification
{
    
    MPMoviePlayerController *playerController = [theNotification object];
    
    [playerController stop];
    //[self dismissMoviePlayerViewControllerAnimated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:nil];
    [m_movie_player.view removeFromSuperview];
    
}

- (void) movieFinishedCallback:(NSNotification*) aNotification
{
    MPMoviePlayerController *playerController = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:playerController];
    [playerController stop];
    
    [m_movie_player.view removeFromSuperview];
}

- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    
    [m_movie_player setControlStyle:MPMovieControlStyleEmbedded];
}

- (void) switchToFlash:(int)seriIndex flashImageName:(NSString*)flashImageName
{
    CGRect bounds = self.view.bounds;
    CGRect image_view_rect = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    UIImageView* image_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:flashImageName]];
    image_view.frame = image_view_rect;
    image_view.alpha = 0.0;
    [self.view addSubview:image_view];
    
    m_flash_view = image_view;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         image_view.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         sleep(1);
                                                  
                         NSString* kv_image_name = [NSString stringWithFormat:@"%@%d-kv.jpg", @"seri", seriIndex+1];
                         [self switchToDoorsViewController:seriIndex kvImageName:kv_image_name];
                         
                         //[image_view removeFromSuperview];
                     }];
}

- (void) switchToDoorsViewController:(int)seriIndex kvImageName:(NSString*)kvImageName
{
    CGRect bounds = self.view.bounds;
    CGRect image_view_rect = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    UIImageView* image_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kvImageName]];
    image_view.frame = image_view_rect;
    image_view.alpha = 0.0;
    [self.view addSubview:image_view];
    
    m_kv_view = image_view;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         image_view.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         sleep(1);
                         
                         //[image_view removeFromSuperview];
                         
                         WinesViewController* view_controller = [[WinesViewController alloc] initWithNibName:@"WinesViewController" bundle:nil];
                         [self.navigationController pushViewController:view_controller animated:false];
                     }];
}


@end
