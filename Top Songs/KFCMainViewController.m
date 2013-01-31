//
//  KFCMainViewController.m
//  Top Songs
//
//  Created by wangyongqi on 1/31/13.
//  Copyright (c) 2013 wyq. All rights reserved.
//

#define kBASE_URL @"http://ax.phobos.apple.com.edgesuite.net"
#define kRESOURCE_PATH @"/WebObjects/MZStore.woa/wpa/MRSS/newreleases/limit=100/rss.xml"

#import "KFCMainViewController.h"
#import <RestKit/RestKit.h>
//#import <RestKit/RKXMLParserXMLReader.h>

#import "Song.h"

@interface KFCMainViewController ()

@end

@implementation KFCMainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RKURL *baseUrl = [RKURL URLWithBaseURLString:kBASE_URL];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseUrl];
    
    RKObjectMapping *songMapping = [RKObjectMapping mappingForClass:[Song class]];
    [songMapping mapKeyPath:@"title" toAttribute:@"title"];
    [songMapping mapKeyPath:@"link" toAttribute:@"link"];
    [songMapping mapKeyPath:@"description" toAttribute:@"description"];
    
    [manager.mappingProvider setMapping:songMapping forKeyPath:@"rss.channel.item"];
    
    Class class = NSClassFromString(@"RKXMLParserXMLReader");
    [[RKParserRegistry sharedRegistry] setParserClass:class forMIMEType:@"application/rss+xml"];
    
    [manager loadObjectsAtResourcePath:kRESOURCE_PATH delegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_objects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SongCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Song *song = _objects[indexPath.row];
    cell.textLabel.text = song.title;
    
    return cell;
}

#pragma mark - RKObjectLoaderDelegate

/**
 * Sent when an object loaded failed to load the collection due to an error
 */
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"load objects failed: %@", [error description]);
}

/**
 When implemented, sent to the delegate when the object laoder has completed successfully
 and loaded a collection of objects. All objects mapped from the remote payload will be returned
 as a single array.
 */
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    _objects = objects;
    
    [self.tableView reloadData];
}

/**
 Sent when a request has finished loading
 
 @param request The RKRequest object that was handling the loading.
 @param response The RKResponse object containing the result of the request.
 */
- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    NSLog(@"body: %@", [response.body description]);
}

@end
