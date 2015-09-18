//
//  Singleton.m
//  InstagramApp
//
//  Created by Webinfoways on 15/02/13.
//  Copyright (c) 2013 WebPlanex. All rights reserved.
//

#import "Singleton.h"
#import "AppDelegate.h"
@implementation Singleton
static Singleton *singletonObj = NULL;
@synthesize currentSelectedTab,myPlaylist,items;

+ (Singleton *)sharedSingleton {
    @synchronized(self) {
        if (singletonObj == NULL)
        singletonObj = [[self alloc] init];
    }
    return(singletonObj);
}

-(void)setcurrentSelectedTab:(int)myString{
    self.currentSelectedTab=myString;
}
-(int)getcurrentSelectedTab{
    return self.currentSelectedTab;
    
}
-(NSString *)getUserDefault:(NSString *)pref{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *val = @"";
    
    if (standardUserDefaults)
        val = [standardUserDefaults objectForKey: pref];
    
    return val;
}

-(void)setUserDefault:(NSString *)myString :(NSString *)pref  {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if (standardUserDefaults) {
        [standardUserDefaults setObject:myString forKey:pref];
        [standardUserDefaults synchronize];
    }
}
-(void)AjNotificationView :(NSString *)title :(int)AJNotificationType{
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [AJNotificationView showNoticeInView:appDel.window type:AJNotificationType title:title linedBackground:AJLinedBackgroundTypeAnimated hideAfter:1.5 offset:0 delay:0 detailDisclosure:YES response:^{
    }];
}

-(NSMutableAttributedString *)CreateAttributeStringStartEnd :(int)FontSize :(NSString *)text :(int)startString :(int)endString :(UIColor *)color anothercolor:(UIColor *)othercolor{
   // UIFont *boldFont = CustomFontDemiWithSize(FontSize);
    UIFont *regularFont = CustomFontMediumWithSize (FontSize);
    UIColor *foregroundColor = color;

    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           othercolor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName,foregroundColor, NSForegroundColorAttributeName, nil];
    const NSRange range = NSMakeRange(startString,endString); // range of " 2012/10/14 ". Ideally this should not be hardcoded
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:subAttrs];
    [attributedText setAttributes:attrs range:range];
    return attributedText;
}




//chat

- (CGSize)getSizeFromString :(NSString *)message width:(float)width fontName:(UIFont *)fontName
{
    CGRect labelBounds = [message boundingRectWithSize:CGSizeMake(width, 100000)
                                               options:NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName: fontName}
                                               context:nil];
    
    return CGSizeMake(ceilf(labelBounds.size.width), ceilf(labelBounds.size.height));
}

- (NSString *)removeNull:(NSString *)str
{
    str = [NSString stringWithFormat:@"%@",str];
    if (!str)
        return @"";
    else if([str isEqualToString:@"<null>"])
        return @"";
    else if([str isEqualToString:@"(null)"])
        return @"";
    else if([str isEqualToString:@"N/A"])
        return @"";
    else if([str isEqualToString:@"n/a"])
        return @"";
    else
        return str;
}
- (UIColor *) colorFromHexString:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
