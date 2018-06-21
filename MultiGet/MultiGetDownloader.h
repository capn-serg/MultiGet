//
//  MultiGetDownloader.h
//  MultiGet
//
//  Created by Sergio Azua on 6/20/18.
//  Copyright © 2018 Sergio Azua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiGetDownload.h"
@class MultiGetDownload;

@interface MultiGetDownloader : NSObject<MultiGetDownloadDelegate>

-(void)startMultiGetDownload:(MultiGetDownload*)download;

@property (nonatomic, assign, readonly) BOOL isDownloading;

@end
