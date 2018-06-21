//
//  MultiGetDownloader.m
//  MultiGet
//
//  Created by Sergio Azua on 6/20/18.
//  Copyright © 2018 Sergio Azua. All rights reserved.
//

#import "MultiGetDownloader.h"

@interface MultiGetDownloader()

@property (nonatomic, retain) NSMutableDictionary<NSURL*, NSMutableDictionary<NSNumber*, NSData*>*> *partionsForURL;
@property (atomic, assign) NSInteger downloadsInFlight;

@end

@implementation MultiGetDownloader

- (instancetype)init
{
    self = [super init];
    if (self) {
        _partionsForURL = [NSMutableDictionary new];
    }
    return self;
}

- (void)startMultiGetDownload:(MultiGetDownload *)download {
    [download start];
}

- (void)didCompleteDownload:(NSURL*)url outputPath:(NSString*)outputPath {
    NSDictionary *allDataForUrl = _partionsForURL[url];
    NSMutableData *fileData = [NSMutableData new];
    for (int i = 0; i < allDataForUrl.count; i++) {
        [fileData appendData:allDataForUrl[@(i)]];
    }
    
    [self writeDataToOutput:fileData outputPath:outputPath];
    _downloadsInFlight--;
}

-(void)writeDataToOutput:(NSData*)data outputPath:(NSString*)outputPath {
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:[outputPath stringByDeletingLastPathComponent]
                              withIntermediateDirectories:false attributes:nil error:&error];
    
    if (!error) {
        [data writeToFile:outputPath atomically:YES];
    } else {
        NSLog(@"%@", error);
    }
}

- (void)didReceive:(NSData *)chunk atIndex:(NSInteger)index for:(NSURL *)url {
    [_partionsForURL[url] setObject:chunk forKey:@(index)];
}

- (void)didStartDownload:(NSURL*)url {
    _downloadsInFlight++;
    _partionsForURL[url] = [NSMutableDictionary new];
}

- (BOOL)isDownloading {
    return _downloadsInFlight;
}

@end
