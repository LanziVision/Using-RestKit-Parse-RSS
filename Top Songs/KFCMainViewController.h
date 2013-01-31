//
//  KFCMainViewController.h
//  Top Songs
//
//  Created by wangyongqi on 1/31/13.
//  Copyright (c) 2013 wyq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RKObjectLoader.h>

@interface KFCMainViewController : UITableViewController<RKObjectLoaderDelegate>

@property (nonatomic, strong) NSArray *objects;

@end
