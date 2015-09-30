//
//  SearchTypeCollectionCell.m
//  CoSearch
//
//  Created by Fnoz on 15/9/30.
//  Copyright (c) 2015年 Fnoz. All rights reserved.
//

#import "SearchTypeCollectionCell.h"

@implementation SearchTypeCollectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _searchTypeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _searchTypeLabel.textAlignment = NSTextAlignmentCenter;
        _searchTypeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_searchTypeLabel];
        
        _searchTypeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _searchTypeImageView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_searchTypeImageView];
    }
    return self;
}

-(void)layoutSubviews{
    self.searchTypeLabel.frame = CGRectMake(0, self.frame.size.height*0.72, self.frame.size.width, self.frame.size.height*0.2);
    self.searchTypeImageView.frame = CGRectMake(self.frame.size.height*0.25, self.frame.size.height*0.2, self.frame.size.width*0.5, self.frame.size.height*0.5);
}

@end
