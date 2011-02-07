//
//  ImageSource.m
//  OTOduino
//
//  Created by UEHARA AKIHIRO on 10/12/21.
//  Copyright 2010 REINFORCE Lab. All rights reserved.
//

#import "ImageSource.h"


@interface ImageSource(Private)
+(NSString *)getImagePath:(NSString *)fileNameWithoutExtention;
+(UIImage *)getUIImage:(NSString *)fileNameWithoutExtension;
+(UIImageView *)getUIImageView:(NSString *)fileNameWithoutExtention;
@end

@implementation ImageSource
#pragma mark Helper methods
+(NSString *)getImagePath:(NSString * )fileNameWithoutExtention
{
	//	return [[NSBundle mainBundle] pathForResource:fileNameWithoutExtention ofType:@"png" inDirectory:@"Image"];
	return [[NSBundle mainBundle] pathForResource:fileNameWithoutExtention ofType:@"png"];
}
+(UIImage *)getUIImage:(NSString *)fileNameWithoutExtention
{
	return [UIImage imageWithContentsOfFile:[ImageSource getImagePath:fileNameWithoutExtention]];
}
+(UIImageView *)getUIImageView:(NSString *)fileNameWithoutExtention
{
	return [[[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[ImageSource getImagePath:fileNameWithoutExtention]]] autorelease];
}
#pragma mark Class methods
+(UIImage *)getColorBarImage:(int)index
{
	switch(index) {
//		case 0: return [ImageSource getUIImage:@"bar00"];
		case 1: return [ImageSource getUIImage:@"bar01"];
		case 2: return [ImageSource getUIImage:@"bar02"];
		case 3: return [ImageSource getUIImage:@"bar03"];
		case 4: return [ImageSource getUIImage:@"bar04"];
		case 5: return [ImageSource getUIImage:@"bar05"];
		case 6: return [ImageSource getUIImage:@"bar06"];
		case 7: return [ImageSource getUIImage:@"bar07"];
		case 8: return [ImageSource getUIImage:@"bar08"];
		case 9: return [ImageSource getUIImage:@"bar09"];
		case 10: return [ImageSource getUIImage:@"bar10"];
	}
	return [ImageSource getUIImage:@"bar00"];
}
@end
