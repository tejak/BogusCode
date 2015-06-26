//
//  MasterViewController.m
//  BogusCode
//
//  Created by Johnny Blockingcall on 6/26/15.
//  Copyright (c) 2015 Vimeo. All rights reserved.
//

#define kOneConstant 1

#import "MasterViewController.h"

@interface MasterViewController () <NSURLConnectionDelegate>

@property NSMutableArray *objects;
@property NSMutableArray *pictures;
@property UITableView *tableView;

@end

@implementation MasterViewController

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:self.view.bounds];
    
    @try
    {
        NSObject *object = [self.objects objectAtIndex:indexPath.row];
        cell.text = [object valueForKey:@"name"];
        
        NSString *url = [[[[object valueForKey:@"pictures"] valueForKey:@"sizes"] objectAtIndex:0] valueForKey:@"link"];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        cell.image = image;
    }
    @catch (NSException *exception)
    {
        cell.text = @"no more videos, scroll up...";
    }
    
    return cell;
}

- (void)viewDidAppear:(BOOL)animated
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.vimeo.com/channels/staffpicks/videos"]];
    [request setValue:@"bearer b8e31bd89ba1ee093dc6ab0f863db1bd" forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [NSString stringWithCString:[response bytes] encoding:NSUTF8StringEncoding];
    NSDictionary *resDict = [NSJSONSerialization JSONObjectWithData:response options:0 error:nil];
    self.objects = resDict[@"data"];
    
    NSLog(@"found %li objects", resDict.count);
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kOneConstant;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView = tableView;
    
    return 1000;
}

- (void)viewDidLoad
{
    self.objects = [NSMutableArray arrayWithCapacity:1000];
    self.pictures = [NSMutableArray arrayWithCapacity:1000];
    
    self.navigationItem.title = @"Vimeo Staf Pics";
}

@end
