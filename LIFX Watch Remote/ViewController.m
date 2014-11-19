//
//  ViewController.m
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 19/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import "ViewController.h"
#import <LIFXKit/LIFXKit.h>

@interface ViewController () <LFXLightCollectionObserver, UITableViewDataSource, UITableViewDelegate>
{
    LFXLightCollection * allLightsCollection;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * lights;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    allLightsCollection = [[LFXClient sharedClient] localNetworkContext].allLightsCollection;
    [allLightsCollection addLightCollectionObserver:self];

    self.lights = [allLightsCollection.lights mutableCopy];
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didAddLight:(LFXLight *)light
{
    if (![self.lights containsObject:light])
    {
        [self.lights addObject:light];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.lights count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)lightCollection:(LFXLightCollection *)lightCollection didRemoveLight:(LFXLight *)light
{
    NSUInteger row = [self.lights indexOfObject:light];
    [self.lights removeObject:light];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lights count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LightCell"];
    cell.textLabel.text = [self.lights[indexPath.row] label];
    return cell;
}

@end
