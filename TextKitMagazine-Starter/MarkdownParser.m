//
//  MarkdownParser.m
//  TextKitMagazine
//
//  Created by Ｋ on 2015/1/12.
//  Copyright (c) 2015年 Colin Eberhardt. All rights reserved.
//

#import "MarkdownParser.h"

@implementation MarkdownParser
{
    NSDictionary *bodyTextAttributes;
    NSDictionary *headingOneAttributes;
    NSDictionary *headingTwoAttributes;
    NSDictionary *headingThreeAttributes;
}

- (id)init {
    if (self = [super init]) {
        [self createTextAttributes];
    }
    return self;
}

- (void)createTextAttributes {
    UIFontDescriptor *baskerville = [UIFontDescriptor fontDescriptorWithFontAttributes:@{UIFontDescriptorFamilyAttribute:@"Baskerville"}];
    UIFontDescriptor *baskervilleBold = [baskerville fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    [baskerville fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFontDescriptor *bodyFont = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber *bodyFontSize = bodyFont.fontAttributes[UIFontDescriptorSizeAttribute];
    CGFloat bodyFontSizeValue = [bodyFontSize floatValue];
    bodyTextAttributes = [self attributesWithDescriptor :baskerville size:bodyFontSizeValue];
    headingOneAttributes = [self attributesWithDescriptor :baskervilleBold size:bodyFontSizeValue * 2.0f];
    headingTwoAttributes = [self attributesWithDescriptor :baskervilleBold size:bodyFontSizeValue * 1.8f];
    headingThreeAttributes = [self attributesWithDescriptor :baskervilleBold size:bodyFontSizeValue * 1.4f];
                                                                                         
}

- (NSDictionary *)attributesWithDescriptor:(UIFontDescriptor *)descriptor size:(CGFloat)size {
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:size];
    return @{NSFontAttributeName:font};
}


- (NSAttributedString *)parseMarkdownFile:(NSString*)path {
    NSMutableAttributedString *parseOutput = [[NSMutableAttributedString alloc]init];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
 
    
    NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSUInteger lineIndex = 0; lineIndex < lines.count; lineIndex ++) {
        NSString *line = lines[lineIndex];
        
        if ([line isEqualToString:@""]) {
            continue;
        }
        NSDictionary *textAttributes = bodyTextAttributes;
        if (line.length > 3){
        if ([[line substringToIndex:3] isEqualToString:@"###"]) {
            textAttributes = headingOneAttributes;
            line = [line substringFromIndex:3];
        }
        else if ([[line substringToIndex:2] isEqualToString:@"##"]) {
            textAttributes= headingTwoAttributes;
             line = [line substringFromIndex:2];
        } else if  ([[line substringToIndex:1] isEqualToString:@"#"]) {
            textAttributes= headingThreeAttributes;
             line = [line substringFromIndex:1];
         }
        }
        
        
        
        NSAttributedString *attributedText = [[NSAttributedString alloc]initWithString:line attributes:textAttributes];
        [parseOutput appendAttributedString:attributedText];
        [parseOutput appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\!\\[.*\\]\\((.*)\\)" options:0 error:nil];
        NSArray *matches = [regex matchesInString:parseOutput.string options:0 range:NSMakeRange(0, parseOutput.length)];
        for (NSTextCheckingResult *result in  [matches reverseObjectEnumerator]) {
            NSRange matchRange = [result range];
            NSRange captureRange = [result rangeAtIndex:1];
            NSTextAttachment *textAttachment = [NSTextAttachment new];
            NSLog(@"%@",[parseOutput.string substringWithRange:captureRange]);
            textAttachment.image = [UIImage imageNamed:[parseOutput.string substringWithRange:captureRange]];
            NSAttributedString *replacementString = [NSAttributedString attributedStringWithAttachment: textAttachment];
            [parseOutput replaceCharactersInRange:matchRange withAttributedString:replacementString];
        }
    
    }
    return parseOutput;
    }

@end
