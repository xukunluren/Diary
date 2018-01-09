//
//  UISearchBar+Additions.m
//  WeiKe
//
//  Created by js on 15/7/29.
//  Copyright (c) 2015年 jing. All rights reserved.
//

#import "UISearchBar+Additions.h"

@implementation UISearchBar (Additions)

- (UIButton *)cancelButton{
    for(id control in [[self.subviews firstObject] subviews])
    {
        if ([control isKindOfClass:[UIButton class]])
        {
            UIButton * btn =(UIButton *)control;
            return btn;
        }
    }
    return nil;
}

@end
