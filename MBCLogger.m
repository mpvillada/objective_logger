//
//  MBCLogger.m
//  mobiDocs-Premium
//
//  Created by mperez on 8/15/13.
//  Copyright (c) 2013 mobicloud. All rights reserved.
//

#import "MBCLogger.h"

static MBCLogger * gLogger;

@interface MBCLogger ()
{
    NSMutableSet * _classes;
    NSInteger _level;
}

@end

@implementation MBCLogger

+(MBCLogger*)getLogger
{
    if (!gLogger)
    {
        gLogger = [[MBCLogger alloc] initWithConfiguration:@"LoggerConfig"];
    }
    
    return gLogger;
}

-(id)init
{
    self = [super init];
    if (self)
    {
        _classes = [[NSMutableSet alloc] init];
    }
    return self;
}

-(id)initWithConfiguration:(NSString*)config
{
    self = [super init];
    if (self)
    {
        [self configureLogger:config];
    }
    return self;
}

-(void) dealloc
{
    [_classes release];
    [super dealloc];
}

-(void)configureLogger:(NSString*)config
{
    NSString * path = [[NSBundle mainBundle] pathForResource:config ofType:@"plist"];
    NSDictionary * configData = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSLog(@"Logger configuration: %@", configData);
    if (configData)
    {
        [self addClasses:configData[@"Classes2Log"]];
        [self setLevel:[configData[@"LogLevel"] integerValue] ];
    }
}

-(void)addClass:(NSString*)clazz
{
    [_classes addObject:clazz];
}

-(void)addClasses:(NSArray*)classes
{
    NSLog(@"adding:%@",classes);
    [_classes addObjectsFromArray:classes];
}

-(void)setLevel:(NSInteger)level
{
    NSLog(@"level:%i",level);
    _level = level;
}

-(void)logInClass:(NSString*)clazz method:(NSString*)method level:(NSInteger)level text:(NSString*)text
{
    
    if ( ![self isLevelOK:level] || ![self isClassInDebug:clazz]  )
    {
        return;
    }
    
    NSLog(@"%@ - %@(%@): %@",clazz,method,[self levelToString:level],text);
}

-(BOOL)isClassInDebug:(NSString*)clazz
{
    if ([_classes count] == 0)
        return true;
    
    NSPredicate * stringComparison = [NSPredicate predicateWithFormat:@"%@ LIKE SELF",clazz];
    NSSet * matchingSet = [_classes filteredSetUsingPredicate:stringComparison];
    return [matchingSet count] > 0;
}

-(BOOL)isLevelOK:(NSInteger)level
{
    return (_level <= level);
}

-(NSString*)levelToString:(LoggerLevel)level
{
    NSDictionary * level2String =
        @{
          @(MBCLogger_EXIT   ) : @"EXIT",
          @(MBCLogger_ENTER  ) : @"ENTER",
          @(MBCLogger_DEBUG  ) : @"DEBUG",
          @(MBCLogger_INFO   ) : @"INFO",
          @(MBCLogger_WARNING) : @"WARNING",
          @(MBCLogger_ERROR  ) : @"ERROR",
          @(MBCLogger_NOLOG  ) : @"NOLOG"
        };
                                    
    return level2String[@(level)];
}

@end
