//
//  NSArray+Category.m
//  CityCascade
//
//  Created by fuzhaurui on 16/10/17.
//  Copyright © 2016年 IOS-开发机. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)

-(id)returnTerm:(NSInteger)integer
{
    if (integer<self.count) {
        return self[integer];
    }
    return nil;
}
@end
