//
//  NoteView.m
//  MuralNotes
//
//  Created by Javier Manzo on 2/1/16.
//  Copyright © 2016 Javier Manzo. All rights reserved.
//

#import "NoteView.h"
@interface NoteView ()
@property BOOL selected;
@property float lastScale;
@end

@implementation NoteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.lastScale = 1.0f;
        
        self.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
        self.layer.borderWidth = 1.5f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
    
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longpressGesture:)];
        [self addGestureRecognizer:longPress];
        
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleFingerTap];
        
        UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
        twoFingerPinch.cancelsTouchesInView = FALSE;
        twoFingerPinch.delaysTouchesEnded = TRUE; // <---- this line is essential
        [self addGestureRecognizer:twoFingerPinch];
    }
    return self;
}

-(void) setSelected{
    self.layer.borderWidth = 5.0f;
    self.layer.borderColor = [UIColor blueColor].CGColor;
    self.selected = YES;
}

-(void) setUnselected{
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.selected = NO;
}

-(BOOL)isSelected{
    return self.selected;
}

- (void)longpressGesture:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self toggleSelection];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if ([self selected]) {
        [self setUnselected];
        
    }
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)  {
        self.lastScale = 1.0f;
        return;
    }
    
    CGFloat scale = 1.0f - (_lastScale - recognizer.scale);
    CGAffineTransform transform = CGAffineTransformScale(self.transform, scale, scale);
    self.transform = transform;
    
    self.lastScale = recognizer.scale;
}

-(void) toggleSelection{
    if ([self selected]) {
        [self setUnselected];
        
    } else {
        [self setSelected];
    }
}
@end
