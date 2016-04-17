//
//  ViewController.m
//  ScrollViews
//
//  Created by Matt Galloway on 29/02/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "ViewController.h"
#import "NoteView.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *notesList;
@property float noteSize;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notesList = [NSMutableArray new];
    
    self.scrollView.frame = self.view.frame;
    self.scrollView.contentSize = self.view.frame.size;
    self.scrollView.clipsToBounds = YES;
    self.scrollView.scrollEnabled = YES;
    
    self.viewCollector.frame = self.scrollView.frame;
    
    self.noteSize = MIN(self.viewCollector.frame.size.width,self.viewCollector.frame.size.height)*0.2f;
    
    self.scrollView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:65.0f/255.0f alpha:1.0f];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = 4.0f;
    self.scrollView.zoomScale = 1.0f;
    
    //    CGRect view = self.view.frame;
    //    CGRect collector = self.viewCollector.frame;
    //    CGRect scroll = self.scrollView.frame;
    
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    
    CGPoint pointInView = [recognizer locationInView:self.viewCollector];
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width ;
    CGFloat h = scrollViewSize.height ;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    NoteView* newNote = [[NoteView alloc] initWithFrame:CGRectMake(x, y, self.noteSize, self.noteSize)];
    newNote.center = pointInView;
    
    UIPanGestureRecognizer *dragRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragNote:)];
    [dragRecognizer setMinimumNumberOfTouches:1];
    [dragRecognizer setMaximumNumberOfTouches:1];
    [newNote addGestureRecognizer:dragRecognizer];
    
    [self.viewCollector addSubview:newNote];
    [self.notesList addObject:newNote];
}

- (void)dragNote:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.viewCollector];
    NoteView* draggedView = (NoteView*)recognizer.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began");
        [draggedView setSelected];
        [self.viewCollector bringSubviewToFront:draggedView];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended");
        [self.viewCollector bringSubviewToFront:draggedView];
    }
    
    for (NoteView* note in self.notesList) {
        
        if ([note isSelected]) {
            
            CGRect recognizerFrame = note.frame;
            recognizerFrame.origin.x += translation.x;
            recognizerFrame.origin.y += translation.y;
            if ((CGRectContainsRect(self.viewCollector.bounds, recognizerFrame))||(recognizerFrame.origin.y + recognizerFrame.size.height > self.viewCollector.bounds.size.height)||(recognizerFrame.origin.x + recognizerFrame.size.width > self.viewCollector.bounds.size.width)) {
                note.frame = recognizerFrame;
            } else {
                
                if (recognizerFrame.origin.y < self.viewCollector.bounds.origin.y) {
                    recognizerFrame.origin.y = 0;
                }
                
                if (recognizerFrame.origin.x < self.viewCollector.bounds.origin.x) {
                    recognizerFrame.origin.x = 0;
                }
            }
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.viewCollector];
        }
    }
}


- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    
    if (self.scrollView.zoomScale > 1.0f) {
        [self.scrollView setZoomScale:1.0f animated:YES];
    } else {
        [self.scrollView setZoomScale:3.0f animated:YES];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.viewCollector;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    
}

@end
