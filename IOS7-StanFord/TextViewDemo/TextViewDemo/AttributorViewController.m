//
//  ViewController.m
//  TextViewDemo
//
//  Created by Ｋ on 2015/2/11.
//
//

#import "AttributorViewController.h"

@interface AttributorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *headlineLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *outlineButton;

@end

@implementation AttributorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]initWithString:self.outlineButton.currentTitle];
    [title setAttributes:@{NSStrokeWidthAttributeName : @3 , NSStrokeColorAttributeName : self.outlineButton.tintColor} range:NSMakeRange(0, [title length])];
    //[self.outlineButton.titleLabel setAttributedText:title];
    [self.outlineButton setAttributedTitle:title forState:UIControlStateNormal];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self usePreferFont];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePreferFont:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)changePreferFont:(NSNotification *)notification {
    [self usePreferFont];
}

- (void)usePreferFont {
    self.bodyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}
- (IBAction)changeBodySelectionColorToMatchBackgroundOfButton:(UIButton *)sender {
    [self.bodyTextView.textStorage addAttribute:NSForegroundColorAttributeName value:sender.backgroundColor range:self.bodyTextView.selectedRange];
}

- (IBAction)outlineBodySelection {
    [self.bodyTextView.textStorage addAttributes:@{NSStrokeColorAttributeName : [UIColor blackColor] , NSStrokeWidthAttributeName : @-3} range:self.bodyTextView.selectedRange];
}

- (IBAction)unoutlineBodySelection {
    [self.bodyTextView.textStorage removeAttribute:NSStrokeWidthAttributeName range:self.bodyTextView.selectedRange];
}


@end
