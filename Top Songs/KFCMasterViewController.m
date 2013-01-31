//
//  KFCMasterViewController.m
//  Top Songs
//
//  Created by wangyongqi on 1/26/13.
//  Copyright (c) 2013 wyq. All rights reserved.
//

//#define kCLIENTID "AIQF31DJE4AOG4TEORSJX1QJFQHMQKMNT5UO5M5DPS0KTB4W"
//#define kCLIENTSECRET "WFJY4HK4DXMDAZDX3PGUMBYOIKYSJVRFJYLONPGMZRSKIQQG"
//#define kBASE_URL @"https://api.Foursquare.com/v2"
//#define kRESOURCE_PATH @"/venues/search"


#define kBASE_URL @"http://ax.phobos.apple.com.edgesuite.net"
#define kRESOURCE_PATH @"/WebObjects/MZStore.woa/wpa/MRSS/newreleases/limit=100/rss.xml"

#import "KFCMasterViewController.h"
#import "KFCDetailViewController.h"
#import <RestKit/RestKit.h>

#import "Song.h"

@interface KFCMasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation KFCMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    RKURL *baseUrl = [RKURL URLWithString:kBASE_URL];
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:baseUrl];
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Song class]];
    
    [mapping mapAttributes:@"title", @"link", @"description", @"category", nil];
    [mapping mapKeyPath:@"artist" toAttribute:@"itms:artist"];
    [mapping mapKeyPath:@"albumPrice" toAttribute:@"itms:albumPrice"];
    
    [manager.mappingProvider setMapping:mapping forKeyPath:@"rss.channel.item"];
    manager.serializationMIMEType = RKMIMETypeXML;
    
    [self sendRequest];
    
}

-(void)sendRequest
{
    RKObjectManager *manager = [RKObjectManager sharedManager];
    
    RKURL *url = [RKURL URLWithBaseURLString:kBASE_URL resourcePath:kRESOURCE_PATH];
    
    [manager loadObjectsAtResourcePath:[url resourcePath] delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma make - RKObjectLoaderDelegate

/**
 * Sent when an object loaded failed to load the collection due to an error
 */
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"error: %@\n", [error description]);
}

/**
 When implemented, sent to the delegate when the object laoder has completed successfully
 and loaded a collection of objects. All objects mapped from the remote payload will be returned
 as a single array.
 */
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    _objects = [NSMutableArray arrayWithArray:objects];
    
}


@end
