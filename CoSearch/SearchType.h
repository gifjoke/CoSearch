//
//  SearchType.h
//  CoSearch
//
//  Created by Fnoz on 15/9/30.
//  Copyright (c) 2015年 Fnoz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchType : NSObject

@property (nonatomic, strong) NSString *searchTypeName;
@property (nonatomic, strong) NSString *searchTypeImageName;
@property (nonatomic, strong) NSString *searchTypeModel;
@property (nonatomic, assign) NSInteger searchTypeId;
@property (nonatomic, assign) CGFloat offsetY;

@end
