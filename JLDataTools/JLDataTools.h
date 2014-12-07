//
//  JLDataTools.h
//  JLDataTools
//
//  Created by Jordan Lewis on 7/12/2014.
//  Copyright (c) 2014 Jordan Lewis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JLDataTools : NSObject

// Data

/**
 *  Converts data in metres to a formatted string
 *
 *  @param metres A distance in metres
 *
 *  @return A Formatted string of the distance
 */
-(NSString *)readableDistanceFromMetres:(double)metres;
-(NSArray *)convertNSStringArraytoNSNumberArrayFromArray:(NSArray *)stringArray;
-(NSArray *)mergeContentsOfArrayInsideAnArrayIntoOneArrayFromArray:(NSArray *)array;
-(NSArray *)convertNSStringLocationsIntoCLLocationFromArray:(NSArray *)array;
-(NSArray *)addPointsInGraphToMakeValuesIncreaseFromArray:(NSArray *)array;// Do this
-(NSArray *)convertEverythingToStringsFromArray:(NSArray *)array;
-(NSString *)convertTimeInSecondsToReadableString:(int)timeSeconds;

// Storage
-(NSString *)createNewFolderWithName:(NSString *)name inSubDir:(NSString *)folderNameInDocumentsFolder; // Creates a new folder in the documents folder is BOOL is YES, if no, will create a new folder in a folder inside the documents folder (Documents/<folderName>/<newFolder>); and will return the directory of the folder created.

-(NSDictionary *)getRootDictionaryOfPlist:(NSString *)plistDir;

-(void)storeThis:(id)object withKey:(NSString *)key inplistdir:(NSString *)plistdir;
-(void)writeThis:(NSArray *)array toCSV:(NSString *)csvName inDir:(NSString *)dir; // If dir is nil will write to Documents
-(void)write:(NSDictionary *)_this toPlist:(NSString *)fileDir;
-(void)removeFileAtDir:(NSString *)dir;

-(NSArray *)getArrayOfFilesInDirectory:(NSString *)folderName;
-(NSArray *)parseCSV:(NSString *)csvName inDir:(NSString *)dir;

-(id)getThisWithKey:(NSString *)key fromplist:(NSString *)fileDir;

/**
 *  Gets and returns the Documents Directory of the App
 *
 *  @return NSString with the directory of the Documents folder of the app
 */
-(NSString *)getDocumentsDir;

/**
 *  Checks if a file exists at a path and returns the available file name by adding (x) where x is a number at the end of the file name.
 *
 *  @param path      The path to check for.
 *  @param extention The file extension of the file.
 *
 *  @return An Array Index 0: Bool if the file exists 1: The available file path 2: available file name with extenstion 3: without extension
 */
-(NSArray *)fileExistsAtPath:(NSString *)path withFileExtension:(NSString *)extention;

@end
