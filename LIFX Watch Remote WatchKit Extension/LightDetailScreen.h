//
//  LightDetailScreen.h
//  LIFX Watch Remote
//
//  Created by Mark Aufflick on 20/11/2014.
//  Copyright (c) 2014 The High Technology Bureau. All rights reserved.
//

#import <WatchKit/WatchKit.h>

// because Nick uses CGFloats and otherwise we don't need to load CoreGraphics
// into the extension...

#undef CGFloat
#define CGFloat double

#import <LIFXKit/LIFXKit.h>

@interface LightDetailScreen : WKInterfaceController

@end
