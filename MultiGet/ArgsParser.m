//
//  ArgsParser.m
//  MultiGet
//
//  Created by Sergio Azua on 6/20/18.
//  Copyright © 2018 Sergio Azua. All rights reserved.
//

#import "ArgsParser.h"

NSString *const OutDirectoryArgName = @"--output";
NSString *const ChunkSizeArgName = @"--chunk_size";
NSString *const NumChunksArgName = @"--num_chunks";
NSString *const MaxSizeArgName = @"--max_size";

@implementation ArgsParser

- (id)initWithArgs:(int)argc argv:(const char **)argv {
    
    if ([self init] && argc > 1) {
        _downloadUrl = [NSString stringWithUTF8String:argv[1]];
        _downloadUrlIsValid = [self validateUrl:_downloadUrl];
        
        for (int i=0; i<argc; i++)
        {
            NSString *value = [NSString stringWithUTF8String:argv[i]];
            
            if ([value isEqualToString: OutDirectoryArgName]) {
                i++;
                _outpurDirectory = [NSString stringWithUTF8String:argv[i]];
            } else if ([value isEqualToString: ChunkSizeArgName]) {
                i++;
                _chunkSizeInBytes = [[NSString stringWithUTF8String:argv[i]] integerValue];
            } else if ([value isEqualToString: NumChunksArgName]) {
                i++;
                _numChunks = [[NSString stringWithUTF8String:argv[i]] integerValue];
            } else if ([value isEqualToString: MaxSizeArgName]) {
                i++;
                _maxSizeInBytes = [[NSString stringWithUTF8String:argv[i]] integerValue];
            }
        }
    }
    
    return self;
}

//https://stackoverflow.com/a/5081447
- (BOOL) validateUrl: (NSString *) candidate {
    
    NSURL *candidateURL = [NSURL URLWithString:candidate];
    return (candidateURL && candidateURL.scheme && candidateURL.host);
}

@end
