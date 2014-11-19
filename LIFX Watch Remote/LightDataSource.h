//
//  LightDataSource.h
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 19/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LightDataSourceDelegate;

@interface LightDataSource : NSObject

@property (nonatomic, weak) id<LightDataSourceDelegate> delegate;
@property (nonatomic, readonly) NSArray * lights;
@property (nonatomic, readonly) NSUInteger count;

@end

@protocol LightDataSourceDelegate <NSObject>

@required
- (void)lightDataSource:(LightDataSource *)lightSource didInsertLightAtIndex:(NSInteger)idx;
- (void)lightDataSource:(LightDataSource *)lightSource didRemoveLightAtIndex:(NSInteger)idx;

@end