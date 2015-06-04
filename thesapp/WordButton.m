//
//  WordButton.m
//  MLPAutoCompleteDemoStoryboard
//
//  Created by Paolo Burzacca on 27/04/15.
//
//

#import "WordButton.h"

@implementation WordButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];    
    NSLog(@"initWithFrame");
    //self.contentEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    //self.titleLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor blueColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self) {
    
    }
    
    return self;
}

@end
