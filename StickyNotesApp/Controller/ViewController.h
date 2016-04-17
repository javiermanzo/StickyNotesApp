//
//  ViewController.h
//  MuralNotes
//
//  Created by Javier Manzo on 1/30/16.
//  Copyright © 2016 Javier Manzo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewCollector;

@end

