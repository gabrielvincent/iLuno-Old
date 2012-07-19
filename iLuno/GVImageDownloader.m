//
//  GVImageDownloader.m
//  ImageDownloader
//
//  Created by Gabriel Vincent on 10/09/11.
//  Copyright 2011 _A_Z. All rights reserved.
//

#import "GVImageDownloader.h"

@implementation GVImageDownloader

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) downloadImageFromURL:(NSString *)url AndSaveItWithFileName:(NSString *)imageName WithFormat:(NSString *)imageFormat {
	
	NSLog(@"Downloading...");
	// Get an image from the URL below
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
	
	NSLog(@"%f,%f",image.size.width,image.size.height);
	
	// Let's save the file into Document folder.
	// You can also change this to your desktop for testing. (e.g. /Users/kiichi/Desktop/)
	// NSString *deskTopDir = @"/Users/kiichi/Desktop";
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	// If you go to the folder below, you will find those pictures
	NSLog(@"%@",docDir);
	
	if ([imageFormat isEqualToString:@"png"] || [imageFormat isEqualToString:@"PNG"]) {
		NSLog(@"saving png");
		NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, imageName];
		NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
		[data1 writeToFile:pngFilePath atomically:YES];
		NSLog(@"saving image done");
	}
	else if ([imageFormat isEqualToString:@"jpg"] || [imageFormat isEqualToString:@"JPG"] || [imageFormat isEqualToString:@"jpeg"] || [imageFormat isEqualToString:@"JPEG"]) {
		NSLog(@"saving jpeg");
		NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@.jpeg",docDir, imageName];
		NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
		[data2 writeToFile:jpegFilePath atomically:YES];
		NSLog(@"saving image done");
	}
	else {
		NSLog(@"iPhone can't donwload images with this \"%@\" format. Try using jpg or png instead.", imageFormat);
	}
	
}

- (void) downloadImageFromURL:(NSString *)url WithFormat:(NSString *)imageFormat {
	
	NSLog(@"Downloading...");
	// Get an image from the URL below
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
	
	NSLog(@"%f,%f",image.size.width,image.size.height);
	
	// Let's save the file into Document folder.
	// You can also change this to your desktop for testing. (e.g. /Users/kiichi/Desktop/)
	// NSString *deskTopDir = @"/Users/kiichi/Desktop";
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	// If you go to the folder below, you will find those pictures
	NSLog(@"%@",docDir);
	
	if ([imageFormat isEqualToString:@"png"] || [imageFormat isEqualToString:@"PNG"]) {
		NSLog(@"saving png");
		NSString *pngFilePath = [NSString stringWithFormat:@"%@/image.png",docDir];
		NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
		[data1 writeToFile:pngFilePath atomically:YES];
		NSLog(@"saving image done");
	}
	else if ([imageFormat isEqualToString:@"jpg"] || [imageFormat isEqualToString:@"JPG"] || [imageFormat isEqualToString:@"jpeg"] || [imageFormat isEqualToString:@"JPEG"]) {
		NSLog(@"saving jpeg");
		NSString *jpegFilePath = [NSString stringWithFormat:@"%@/image.jpg",docDir];
		NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
		[data2 writeToFile:jpegFilePath atomically:YES];
		NSLog(@"saving image done");
	}
	else {
		NSLog(@"iPhone can't donwload images with this \"%@\" format. Try using jpg or png instead.", imageFormat);
	}
	
}

- (UIImage *) pickExistentImageWithFileName:(NSString *)imageName {
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *filePath = [NSString stringWithFormat:@"%@/%@.png", docDir, imageName];
	
	NSLog(@"Image File Path: %@", filePath);
	
	if ([UIImage imageWithContentsOfFile:filePath]) {
		NSLog(@"%@ was found!", imageName);
		return [UIImage imageWithContentsOfFile:filePath];
	}
	else {
		NSLog(@"%@ was not found!", imageName);
		return nil;
	}
}

- (UIImage *) pickImageFromURL:(NSString *)url AndNameIt:(NSString *)imageName WithFormat:(NSString *)imageFormat {
	
	NSLog(@"Downloading...");
	// Get an image from the URL below
	UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
	
	NSLog(@"Image URL: %@", url);
	
	NSLog(@"%f,%f",image.size.width,image.size.height);
	
	// Let's save the file into Document folder.
	// You can also change this to your desktop for testing. (e.g. /Users/kiichi/Desktop/)
	// NSString *deskTopDir = @"/Users/kiichi/Desktop";
	
	NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	
	// If you go to the folder below, you will find those pictures
	NSLog(@"%@",docDir);
	
	if ([imageFormat isEqualToString:@"png"] || [imageFormat isEqualToString:@"PNG"]) {
		NSLog(@"saving png");
		NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png",docDir, imageName];
		NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
		[data1 writeToFile:pngFilePath atomically:YES];
		NSLog(@"saving image done");
	}
	else if ([imageFormat isEqualToString:@"jpg"] || [imageFormat isEqualToString:@"JPG"] || [imageFormat isEqualToString:@"jpeg"] || [imageFormat isEqualToString:@"JPEG"]) {
		NSLog(@"saving jpeg");
		NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@.jpeg",docDir, imageName];
		NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
		[data2 writeToFile:jpegFilePath atomically:YES];
		NSLog(@"saving image done");
	}
	else {
		NSLog(@"iPhone can't donwload images with this \"%@\" format. Try using jpg or png instead.", imageFormat);
	}
	
	return image;
}

@end
