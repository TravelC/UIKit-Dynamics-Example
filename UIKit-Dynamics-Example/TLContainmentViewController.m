//
//  TLContainmentViewController.m
//  UIKit-Dynamics-Example
//
//  Created by Ash Furrow on 2013-07-09.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import "TLContainmentViewController.h"
#import "TLContentViewController.h"

@interface TLContainmentViewController () <TLContentViewControllerDelegate, UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UINavigationController *contentNavigationViewController;
@property (nonatomic, strong) UIViewController *menuViewController;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic) UIPushBehavior* pushBehavior;

@end

@implementation TLContainmentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"contentViewController"]) {
        self.contentNavigationViewController = segue.destinationViewController;
        TLContentViewController *contentViewController = (TLContentViewController *)[segue.destinationViewController topViewController];
        contentViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"menuViewController"]) {
        self.menuViewController = segue.destinationViewController;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Import to call this only after our view hierarchy is set up.
    [self setupContentViewControllerAnimatorProperties];
}

-(void)setupContentViewControllerAnimatorProperties {
    NSAssert(self.animator == nil, @"Animator is not nil – setupContentViewControllerAnimatorProperties likely called twice.");
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[self.contentNavigationViewController.view]];
    // Need to create a boundary that lies to the left of the left edge of the screen.
    [collisionBehaviour addBoundaryWithIdentifier:@"leftEdge" fromPoint:CGPointMake(-1, 0) toPoint:CGPointMake(-1, CGRectGetHeight(self.view.bounds))];
    [self.animator addBehavior:collisionBehaviour];
    
    self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.contentNavigationViewController.view]];
    self.gravityBehaviour.xComponent = -1.0f;
    self.gravityBehaviour.yComponent = 0.0f;
    [self.animator addBehavior:self.gravityBehaviour];
    
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.contentNavigationViewController.view] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = 0.0f;
    self.pushBehavior.angle = 0.0f;
    [self.animator addBehavior:self.pushBehavior];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contentNavigationViewController.view]];
    itemBehaviour.elasticity = 0.5f;
    [self.animator addBehavior:itemBehaviour];
}

#pragma mark - TLContentViewControllerDelegate Methods

-(void)contentViewControllerDidPressBounceButton:(TLContentViewController *)viewController {
    [self.pushBehavior setXComponent:25.0f yComponent:0.0f];
    // active is set to NO once the instantaneous force is applied. All we need to do is reactivate it on each button press.
    self.pushBehavior.active = YES;
}

#pragma mark - UIDynamicAnimatorDelegate Methods

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator*)animator {
   
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator {
    
}

@end
