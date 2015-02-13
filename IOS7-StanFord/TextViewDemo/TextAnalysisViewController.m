//
//  TextAnalysisViewController.m
//  TextViewDemo
//
//  Created by Ｋ on 2015/2/12.
//
//

#import "TextAnalysisViewController.h"

@interface TextAnalysisViewController ()
@property (weak, nonatomic) IBOutlet UILabel *colorAnalyzeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outlinedAnalyzeLabel;

@end

@implementation TextAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setTextToAnalyze:(NSAttributedString *)textToAnalyze {
    _textToAnalyze = textToAnalyze;
    if (self.view.window) {
        [self updateUI];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI {
    self.colorAnalyzeLabel.text = [NSString stringWithFormat:@"%lu colorful characters", (unsigned long)[[self charactersWithAttribute:NSForegroundColorAttributeName] length]];
    
    self.outlinedAnalyzeLabel.text = [NSString stringWithFormat:@"%lu outlined characters", (unsigned long)[[self charactersWithAttribute:NSStrokeWidthAttributeName] length]];
    
}

- (NSAttributedString *)charactersWithAttribute:(NSString *)attributeName {
    NSMutableAttributedString *character = [[NSMutableAttributedString alloc]init];
    int index = 0;
    NSLog(@"%@",self.textToAnalyze);
    while (index < [self.textToAnalyze length]) {
        NSRange range ;
        id value = [self.textToAnalyze  attribute:attributeName atIndex:index effectiveRange:&range];
        if (value) {
            [character appendAttributedString:[self.textToAnalyze attributedSubstringFromRange:range]];
            index = range.location + range.length;
        } else {
            index ++;
        }
    }
    
    return character;
}
@end