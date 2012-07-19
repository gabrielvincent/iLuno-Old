//
//  GVImageDownloader.h
//  ImageDownloader
//
//  Created by Gabriel Vincent on 10/09/11.
//  Copyright 2011 _A_Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface GVImageDownloader : NSObject 

- (void) downloadImageFromURL:(NSString *)url AndSaveItWithFileName:(NSString *)imageName WithFormat:(NSString *)imageFormat;
- (void) downloadImageFromURL:(NSString *)url WithFormat:(NSString *)imageFormat;
- (UIImage *) pickExistentImageWithFileName:(NSString *)imageName;
- (UIImage *) pickImageFromURL:(NSString *)url AndNameIt:(NSString *)imageName WithFormat:(NSString *)imageFormat;

@end
