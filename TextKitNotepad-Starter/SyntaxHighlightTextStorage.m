//
//  SyntaxHighlightTextStorage.m
//  TextKitNotepad
//
//  Created by Ｋ on 2015/1/8.
//  Copyright (c) 2015年 Colin Eberhardt. All rights reserved.
//

#import "SyntaxHighlightTextStorage.h"

@implementation SyntaxHighlightTextStorage
{
    NSMutableAttributedString *_backingStore;
    NSAttributedString *teststring;
}
- (id)init {
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}

- (NSString *)string {
    return [_backingStore string]; }
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    NSLog(@"replaceCharactersInRange:%@ withString:%@",
          NSStringFromRange(range), str);
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes range:range changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)processEditing {
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}

- (void)performReplacementsForRange:(NSRange)changedRange {
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string]
                                                        lineRangeForRange:NSMakeRange(changedRange.location, 0)]); extendedRange = NSUnionRange(extendedRange,
                                                                                                                                                [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
     [self applyStylesToRange:extendedRange];
}

- (void)applyStylesToRange:(NSRange)searchRange {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor *boldFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont* boldFont = [UIFont fontWithDescriptor:boldFontDescriptor size: 0.0];
    UIFont* normalFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    NSString* regexStr = @"(\\*\\w+(\\s\\w+)*\\*)\\s";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    NSDictionary *boldAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:20.0f]};
    NSDictionary* normalAttributes = @{ NSFontAttributeName : normalFont };
    [regex enumerateMatchesInString:[_backingStore string] options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        NSRange matchRange  = [result range];
        [self addAttributes:boldAttributes range:matchRange];
        if (NSMaxRange(matchRange) < self.length) {
             [self addAttributes:normalAttributes range:NSMakeRange(NSMaxRange(matchRange), 1)];
        }
    }
     ];
    
}
- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range {
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes
                                                            range:range changeInLength:0];
    [self endEditing]; }

@end
