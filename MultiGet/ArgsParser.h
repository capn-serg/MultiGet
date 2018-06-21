//
//  ArgsParser.h
//  MultiGet
//
//  Created by Sergio Azua on 6/20/18.
//  Copyright © 2018 Sergio Azua. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const OutDirectoryArgName;
FOUNDATION_EXPORT NSString *const ChunkSizeArgName;
FOUNDATION_EXPORT NSString *const NumChunksArgName;
FOUNDATION_EXPORT NSString *const MaxSizeArgName;

@interface ArgsParser : NSObject

-(id)initWithArgs:(int)argc argv:(const char **)argv;

@property (nonatomic, assign, readonly) BOOL downloadUrlIsValid;
@property (nonatomic, strong, readonly) NSString* downloadUrl;
@property (nonatomic, strong, readonly) NSString* outpurDirectory;
@property (nonatomic, assign, readonly) NSUInteger numChunks;
@property (nonatomic, assign, readonly) NSUInteger chunkSizeInBytes;
@property (nonatomic, assign, readonly) NSUInteger maxSizeInBytes;

@end
