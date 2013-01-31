//
//  Song.h
//  Top Songs
//
//  Created by wangyongqi on 1/26/13.
//  Copyright (c) 2013 wyq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSDate *pubDate;

//@property (nonatomic, copy) NSArray *artistLinks;
@property (nonatomic, copy) NSString *artist;
//@property (nonatomic, copy) NSArray *albumLinks;

@property (nonatomic, copy) NSString *albumPrice;
//@property (nonatomic, copy) NSArray *coverArts;

@end
