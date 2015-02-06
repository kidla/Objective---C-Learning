//
//  CENoteEditorControllerViewController.m
//  TextKitNotepad
//
//  Created by Colin Eberhardt on 19/06/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NoteEditorViewController.h"
#import "Note.h"
#import "TimeIndicatorView.h"
#import "SyntaxHighlightTextStorage.h"

@interface NoteEditorViewController () <UITextViewDelegate>



@end

@implementation NoteEditorViewController
{
    TimeIndicatorView* _timeView;
    SyntaxHighlightTextStorage* _textStorage;
    UITextView* _textView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil ];
     [self createTextView];
    _timeView = [[TimeIndicatorView alloc] init:self.note.timestamp];
    [self.view addSubview:_timeView];
    
}

- (void)createTextView {
    NSDictionary *attrs = @{NSFontAttributeName:
                                [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSAttributedString* attrString = [[NSAttributedString alloc] initWithString:_note.contents attributes:attrs];
    _textStorage = [SyntaxHighlightTextStorage new];
    [_textStorage appendAttributedString:attrString];
    CGRect newTextViewRect = self.view.bounds;
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width, CGFLOAT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
   // container.widthTracksTextView = NO;
    [layoutManager addTextContainer:container]; [_textStorage addLayoutManager:layoutManager];
    _textView = [[UITextView alloc] initWithFrame:newTextViewRect
                                    textContainer:container];
    _textView.delegate = self;
    [self.view addSubview:_textView];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _textView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 216.0f);

    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.note.contents = textView.text;
    
    _textView.frame = self.view.bounds;
}

- (void)preferredContentSizeChanged:(NSNotification *) notification {
    _textView.font =
    [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self updateTimeIndicatorFrame];
}
 

- (void)viewDidLayoutSubviews {
    [self updateTimeIndicatorFrame];
}

- (void)updateTimeIndicatorFrame {
    [_timeView updateSize];
    _timeView.frame = CGRectOffset(_timeView.frame,
                                   self.view.frame.size.width - _timeView.frame.size.width,
                                   0.0);
    UIBezierPath* exclusionPath = [_timeView curvePathWithOrigin:_timeView.center];
     _textView.textContainer.exclusionPaths = @[exclusionPath];

}
@end
