//
//  Common.h
//  CoSearch
//
//  Created by Fnoz on 15/10/21.
//  Copyright © 2015年 Fnoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (UIColor *)averageColorForImage:(UIImage*)image;
+ (BOOL)isDarkColor:(UIColor *)newColor;
+ (UIColor*)mostColor:(UIImage *)image;
+ (BOOL)isNearWhite:(UIColor *)color;

@end
