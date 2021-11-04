//
//  DownloadItem.h
//  Vienna
//
//  Created by Steve on 10/7/05.
//  Copyright (c) 2004-2005 Steve Palmer. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@import Cocoa;

typedef NS_ENUM(NSInteger, DownloadState) {
    DownloadStateInit,
    DownloadStateStarted,
    DownloadStateCompleted,
    DownloadStateFailed,
    DownloadStateCancelled
};

@interface DownloadItem : NSObject <NSSecureCoding>

@property (nonatomic) DownloadState state;
@property (nonatomic) long long expectedSize;
@property (nonatomic) long long size;
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, readonly, copy) NSImage *image;

@property (nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic) NSURL *fileURL;

// MARK: WebDownload (deprecated)

@property (nonatomic) NSURLDownload *download;

@end
