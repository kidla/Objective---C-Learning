//
//  MarkdownParser.h
//  TextKitMagazine
//
//  Created by Ｋ on 2015/1/12.
//  Copyright (c) 2015年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkdownParser : NSObject
- (NSAttributedString *)parseMarkdownFile:(NSString*)path;
@end
