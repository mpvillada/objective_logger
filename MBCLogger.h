//
//  MBCLogger.h
//  mobiDocs-Premium
//
//  Created by mperez on 8/15/13.
//  Copyright (c) 2013 mobicloud. All rights reserved.
//

#import <Foundation/Foundation.h>

//------------------------------------------------------------------------------
//#define DEBUG

#ifdef DEBUG
    // Get method name:
    // - alternative 1: NSStringFromSelector(_cmd)
    //  less complete, only the name.
    // - alternative 2:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] or __func__ or __FUNCTION__
    //  also appends the class name.
    #define TRACEL(_LEVEL,...) [[MBCLogger getLogger] logInClass:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd) level:_LEVEL text:[NSString stringWithFormat:__VA_ARGS__]]
#else
    #define TRACEL(_LEVEL,...)
#endif

#define TWARNING(...)   TRACEL(MBCLogger_WARNING,__VA_ARGS__)
#define TERROR(...)     TRACEL(MBCLogger_ERROR,__VA_ARGS__)
#define TINFO(...)      TRACEL(MBCLogger_INFO,__VA_ARGS__)
#define TDEBUG(...)     TRACEL(MBCLogger_DEBUG,__VA_ARGS__)
#define TENTER          TRACEL(MBCLogger_ENTER,@"")
#define TEXIT           TRACEL(MBCLogger_EXIT,@"")

#define TRACE(...)      TRACEL(MBCLogger_DEBUG,__VA_ARGS__)

//------------------------------------------------------------------------------

typedef enum {
    MBCLogger_EXIT,
    MBCLogger_ENTER,
    MBCLogger_DEBUG,
    MBCLogger_INFO,
    MBCLogger_WARNING,
    MBCLogger_ERROR,
    MBCLogger_NOLOG
} LoggerLevel;

//------------------------------------------------------------------------------

@interface MBCLogger : NSObject

    +(MBCLogger*)getLogger;

    -(void)addClass:(NSString*)clazz;
    -(void)addClasses:(NSArray*)classes;

    -(void)setLevel:(NSInteger)level;

    -(void)logInClass:(NSString*)clazz
               method:(NSString*)method
                level:(NSInteger)level
                 text:(NSString*)text;

@end
