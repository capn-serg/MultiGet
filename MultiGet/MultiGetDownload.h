//
//  MultiGetDownload.h
//  MultiGet
//
//  Created by Sergio Azua on 6/17/18.
//  Copyright © 2018 Sergio Azua. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MultiGetDownloadDelegate<NSObject>

- (void)didStartDownload:(NSURL*)url;
- (void)didReceive:(NSData*)chunk atIndex:(NSInteger)index for:(NSURL*)url;
- (void)didCompleteDownload:(NSURL*)url outputPath:(NSString*)outputPath;

@end

@interface MultiGetDownload : NSObject

-(instancetype)initWith:(id<MultiGetDownloadDelegate>)delegate
               downloadUrl:(NSString*)urlString
               outputDirectory:(NSString*)outputDirectory
               numberOfChunks:(NSUInteger)numChunks
               chunkByteSize:(NSUInteger)chunkSize
               maxDownloadByteSize:(NSUInteger)maxSize;

-(void)start;

@end
