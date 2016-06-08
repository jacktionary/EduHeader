//
//  JSGCommentView.m
//  blur_comment
//
//  Created by dai.fengyi on 15/5/15.
//  Copyright (c) 2015年 childrenOurFuture. All rights reserved.
//

#import "BlurCommentView.h"
#import "UIImageEffects.h"
#import "EHMacro.h"

#define ANIMATE_DURATION    0.3f
#define kMarginWH           15
#define kButtonWidth        50
#define kButtonHeight       15
#define kTextFont           [UIFont systemFontOfSize:14]
#define kTextViewHeight     100
#define kSheetViewHeight    (kMarginWH * 4 + kButtonHeight + kTextViewHeight)
@interface BlurCommentView ()
@property (strong, nonatomic) SuccessBlock success;
@property (weak, nonatomic) id<BlurCommentViewDelegate> delegate;
@property (strong, nonatomic) UIView *sheetView;
@property (strong, nonatomic) UITextView *commentTextView;
@end
@implementation BlurCommentView
+ (void)commentshowInView:(UIView *)view success:(SuccessBlock)success delegate:(id <BlurCommentViewDelegate>)delegate
{
    BlurCommentView *commentView = [[BlurCommentView alloc] initWithFrame:view.bounds];
    if (commentView) {
        //挡住响应
        commentView.userInteractionEnabled = YES;
        //增加EventResponsor
        [commentView addEventResponsors];
        //block or delegate
        commentView.success = success;
        commentView.delegate = delegate;
        
        [view addSubview:commentView];
        [view addSubview:commentView.sheetView];
        [commentView.commentTextView becomeFirstResponder];
    }
}
#pragma mark - 外部调用
+ (void)commentshowSuccess:(SuccessBlock)success
{
    [BlurCommentView commentshowInView:[UIApplication sharedApplication].keyWindow success:success delegate:nil];
}

+ (void)commentshowDelegate:(id<BlurCommentViewDelegate>)delegate
{
    [BlurCommentView commentshowInView:[UIApplication sharedApplication].keyWindow success:nil delegate:delegate];
}

+ (void)commentshowInView:(UIView *)view success:(SuccessBlock)success
{
    [BlurCommentView commentshowInView:view success:success delegate:nil];
}

+ (void)commentshowInView:(UIView *)view delegate:(id<BlurCommentViewDelegate>)delegate
{
    [BlurCommentView commentshowInView:view success:nil delegate:delegate];
}
#pragma mark - 内部调用
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.alpha = 0;
    
    CGRect rect = self.bounds;
    UIView *backgroundView = [[UIView alloc] initWithFrame:rect];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.6;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self
            action:@selector(backgroundViewTapped:)];
    
    [backgroundView addGestureRecognizer:tap];
    
    [self addSubview:backgroundView];
    
    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, rect.size.height - kSheetViewHeight, rect.size.width, kSheetViewHeight)];
    _sheetView.backgroundColor = [UIColor whiteColor];
    
    _commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(kMarginWH, _sheetView.bounds.size.height - kMarginWH * 3 - kTextViewHeight - kButtonHeight, rect.size.width - kMarginWH * 2, kTextViewHeight)];
    _commentTextView.text = nil;
    _commentTextView.layer.borderColor = UIColorFromRGB(0xcdcdcd).CGColor;
    _commentTextView.layer.borderWidth = 1;
    
    [_sheetView addSubview:_commentTextView];
    
    // gray line
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTextViewHeight + kMarginWH * 2, rect.size.width, 1)];
    
    grayLine.backgroundColor = UIColorFromRGB(0xcdcdcd);
    grayLine.alpha = 0.5;
    
    [_sheetView addSubview:grayLine];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(0, _sheetView.bounds.size.height - kMarginWH - kButtonHeight, CGRectGetWidth(rect), kButtonHeight);
    commentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [commentButton setTitle:@"完成" forState:UIControlStateNormal];
    [commentButton setTitleColor:UIColorFromRGB(0x343434) forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:commentButton];

}

- (void)backgroundViewTapped:(UIGestureRecognizer *)gesture
{
    [self dismissCommentView];
}

- (UIImage *)snapShot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)addEventResponsors
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Botton Action
- (void)cancelComment:(id)sender {
    [_sheetView endEditing:YES];
}
- (void)comment:(id)sender {
    //发送请求
    if (_success) {
        _success(_commentTextView.text);
    }
    if ([_delegate respondsToSelector:@selector(commentDidFinished:)]) {
        [_delegate commentDidFinished:_commentTextView.text];
    }
    [_sheetView endEditing:YES];
}

- (void)dismissCommentView
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeFromSuperview];
    [_sheetView removeFromSuperview];
}
#pragma mark - Keyboard Notification Action
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSLog(@"%@", aNotification);
    CGFloat keyboardHeight = [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    NSTimeInterval animationDuration = [[aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 1;
        _sheetView.frame = CGRectMake(0, self.superview.bounds.size.height - _sheetView.bounds.size.height - keyboardHeight, _sheetView.bounds.size.width, kSheetViewHeight);
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.alpha = 0;
        _sheetView.frame = CGRectMake(0, self.superview.bounds.size.height, _sheetView.bounds.size.width, kSheetViewHeight);
    } completion:^(BOOL finished){
        [self dismissCommentView];
    }];
}
@end