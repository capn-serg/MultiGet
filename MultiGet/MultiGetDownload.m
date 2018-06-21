//
//  MultiGetDownload.m
//  MultiGet
//
//  Created by Sergio Azua on 6/17/18.
//  Copyright © 2018 Sergio Azua. All rights reserved.
//

#import "MultiGetDownload.h"

@interface MultiGetDownload()

@property (nonatomic, assign) id<MultiGetDownloadDelegate> delegate;
@property (nonatomic, strong) NSURL* downloadUrl;
@property (nonatomic, strong) NSString* outputPath;
@property (nonatomic, assign) NSInteger numChunks;
@property (nonatomic, assign) NSInteger chunkSize;
@property (nonatomic, assign) NSInteger maxSize;
@property (atomic, assign) NSInteger partitionsCompleted;

@end

NSString *const DefaultOutPutDirectory = @"./MultiGetOutput/";
NSUInteger const DefaultMaxFileSize = 4000000;

@implementation MultiGetDownload


- (instancetype)initWith:(id<MultiGetDownloadDelegate>)delegate
             downloadUrl:(NSString *)urlString
         outputDirectory:(NSString *)outputDirectory
          numberOfChunks:(NSUInteger)numChunks
           chunkByteSize:(NSUInteger)chunkSize
     maxDownloadByteSize:(NSUInteger)maxSize {
    
    if ([self init]) {
        _delegate = delegate;
        _downloadUrl = [NSURL URLWithString:urlString];
        
        NSString *fileName = [_downloadUrl lastPathComponent];
        
        _outputPath = outputDirectory ? outputDirectory : DefaultOutPutDirectory;
        _outputPath = [_outputPath stringByAppendingPathComponent:fileName];
    
        if (numChunks && chunkSize && !maxSize) {
            _maxSize = numChunks * chunkSize;
        } else if ((numChunks || chunkSize) && !maxSize) {
            _maxSize = DefaultMaxFileSize;
        } else {
            _maxSize = maxSize ? maxSize : DefaultMaxFileSize;
        }
        
        _numChunks = numChunks;
        _chunkSize = chunkSize ? chunkSize : 1000000;
    }
    
    return self;
}

- (void)start {
    
    [_delegate didStartDownload: _downloadUrl];
    long chunksToDownload = 0;
    long chunkDownloadSize = 0;
    long partialChunkSize = 0;
    
    //will respect num chunks since size, num chucks, and chunk size cannot always all be satisfied
    if (_numChunks) {
        chunksToDownload = _numChunks;
        chunkDownloadSize = _maxSize / _numChunks;
    } else if (_chunkSize) {
        chunksToDownload = _maxSize / _chunkSize;
        chunkDownloadSize = _chunkSize;
        
        //the specified chunk size may not fit the max size evenly. We will have to ask for the remaining bytes
        partialChunkSize = _maxSize % chunkDownloadSize;
    }
    
    NSUInteger totalRequests = chunksToDownload + ((partialChunkSize) ? 1 : 0);
    NSMutableArray<NSURLRequest*> *requests = [[NSMutableArray alloc] initWithCapacity:totalRequests];

    for (int i = 0; i < totalRequests; i++) {
    
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_downloadUrl];
        [request setHTTPMethod:@"GET"];
        long startRange = chunkDownloadSize * i;
        long endRange = startRange + ((partialChunkSize && i == totalRequests - 1) ? partialChunkSize : chunkDownloadSize) - 1;
        NSString *range = [NSString stringWithFormat:@"bytes=%ld-%ld", startRange, endRange];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        [requests addObject:request];
    }
    
    [self performRequests:requests];
}

-(void)performRequests:(NSArray<NSURLRequest*>*)requests {
    NSURLSession *session = NSURLSession.sharedSession;
    
    __weak typeof(self) weakSelf = self;
    for (int i = 0; i < requests.count; i++) {
        NSURLRequest *request = requests[i];
        
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            
            if (httpResponse.statusCode == 206) {
                [weakSelf.delegate didReceive:data atIndex:i for:httpResponse.URL];
                weakSelf.partitionsCompleted++;
                if (weakSelf.partitionsCompleted == requests.count) {
                    [weakSelf.delegate didCompleteDownload: weakSelf.downloadUrl outputPath: weakSelf.outputPath];
                }
            }
        }] resume];
    }
}

@end
