//
//  main.m
//  MultiGet
//
//  Created by Sergio Azua on 6/17/18.
//  Copyright © 2018 Sergio Azua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArgsParser.h"
#import "MultiGetDownloader.h"
#import "MultiGetDownload.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ArgsParser *parser = [[ArgsParser alloc] initWithArgs:argc argv: argv];
        
        if (!parser.downloadUrl) {
            NSLog(@"[OPTIONS] url\n%@ string\n    Write output to <file> instead of default\n%@ int\n     Size in bytes of download chunks. Defaults to 1MB.\n%@ int\n      Number of chunks to download. Defaults to 4.\n%@ int\n        Maximum size in bytes to download. Will respect %@  or %@ options. Will use %@ if both are set.", OutDirectoryArgName, ChunkSizeArgName, NumChunksArgName, MaxSizeArgName, ChunkSizeArgName, NumChunksArgName, NumChunksArgName);
            
            return 0;
        } else if (!parser.downloadUrlIsValid) {
            NSLog(@"A valid file URL is required. Please try again.");
            return 0;
        }
        
        MultiGetDownloader *downloader = [[MultiGetDownloader alloc] init];
        
        MultiGetDownload *download = [[MultiGetDownload alloc] initWith:downloader
                                                            downloadUrl:parser.downloadUrl
                                                        outputDirectory:parser.outpurDirectory
                                                         numberOfChunks:parser.numChunks
                                                          chunkByteSize:parser.chunkSizeInBytes
                                                    maxDownloadByteSize:parser.maxSizeInBytes];
        
        [downloader startMultiGetDownload:download];
        
        while (downloader.isDownloading) {
            usleep(1000);
        }
    }


    return 0;
}
