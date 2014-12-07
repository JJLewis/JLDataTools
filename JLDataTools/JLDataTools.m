//
//  JLDataTools.m
//  JLDataTools
//
//  Created by Jordan Lewis on 7/12/2014.
//  Copyright (c) 2014 Jordan Lewis. All rights reserved.
//

#import "JLDataTools.h"
#import "CHCSVParser.h"

@implementation JLDataTools

//#define PLIST APPDATA_PLIST

// Data
-(NSString *)readableDistanceFromMetres:(double)metres {
    
    NSString *readable;
    
    if (metres > 1000) {
        int km = floor(metres/1000.0);
        int m = metres-(km*1000);
        readable = [NSString stringWithFormat:@"%ikm %im", km, m];
    } else {
        readable = [NSString stringWithFormat:@"%.0fm", metres];
    }
    
    return readable;
}

-(NSArray *)convertNSStringArraytoNSNumberArrayFromArray:(NSArray *)stringArray {
    NSMutableArray *convertedArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = 0; i < [stringArray count]; i++) {
        [convertedArray addObject:[NSNumber numberWithFloat:[[stringArray objectAtIndex:i] floatValue]]];
    }
    
    return convertedArray;
}

-(NSArray *)mergeContentsOfArrayInsideAnArrayIntoOneArrayFromArray:(NSArray *)array {
    NSMutableArray *mergedArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int row = 0; row < [array count]; row++) {
        for (int col = 0; col < [array[row] count]; col++) {
            [mergedArray addObject:array[row][col]];
        }
    }
    //NSLog(@"Merged Count %i", mergedArray.count);
    return mergedArray;
}

-(NSArray *)convertNSStringLocationsIntoCLLocationFromArray:(NSArray *)array {
    NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    for (int i = 0; i < [array count]-1; i++) {
        NSArray *stringLocation = [array[i] componentsSeparatedByString:@":"];
        
        NSString *latStr = stringLocation[0];
        NSString *lonStr = stringLocation[1];
        
        double lat = [latStr doubleValue];
        double lon = [lonStr doubleValue];
        
        CLLocation *fullLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        [locations addObject:fullLocation];
    }
    
    return locations;
}

-(NSArray *)addPointsInGraphToMakeValuesIncreaseFromArray:(NSArray *)array {
    // Assuming the array is only NSNumbers
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithCapacity:[array count]];
    double total = 0;
    for (int i = 0; i < [array count]; i++) {
        double dNumber = [finalArray[i] doubleValue];
        total += dNumber;
        NSNumber *cTotal = [NSNumber numberWithDouble:total];
        [finalArray addObject:cTotal];
    }
    
    return finalArray;
}

-(NSArray *)convertEverythingToStringsFromArray:(NSArray *)array {
    NSMutableArray *convertedObjects = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (int i = 0; i < array.count; i++) {
        NSString *convertedString = @"";
        if ([array[i] isKindOfClass:[NSDate class]]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
            convertedString = [dateFormatter stringFromDate:array[i]];
        }
        if ([array[i] isKindOfClass:[NSNumber class]]) {
            if (strcmp([array[i] objCType], @encode(int)) == 0) {
                convertedString = [NSString stringWithFormat:@"%i", [array[i] intValue]];
            } else if (strcmp([array[i] objCType], @encode(NSUInteger)) == 0) {
                convertedString = [NSString stringWithFormat:@"%ld", (long)[array[i] integerValue]];
            } else {
                convertedString = [NSString stringWithFormat:@"%f", [array[i] floatValue]];
            }
        }
        if ([array[i] isKindOfClass:[NSString class]]) {
            convertedString = array[i];
        }
        [convertedObjects addObject:convertedString];
    }
    
    return convertedObjects;
}

-(NSString *)convertTimeInSecondsToReadableString:(int)timeSeconds {
    NSString *convertedString;
    int seconds;
    int minutes;
    int hours;
    if (timeSeconds >= 3600) {
        hours = floorf(timeSeconds/3600);
        minutes = floorf((timeSeconds - hours*3600)/60);
        convertedString = [NSString stringWithFormat:@"%ih:%im",hours, minutes];
        if (hours < 10) convertedString = [NSString stringWithFormat:@"0%ih:%im",hours, minutes];
        if (minutes <10) convertedString = [NSString stringWithFormat:@"%ih:0%im",hours, minutes];
        if (hours < 10 && minutes < 10) convertedString = [NSString stringWithFormat:@"0%ih:0%im",hours, minutes];
        if (minutes == 0) convertedString = [NSString stringWithFormat:@"%ih",hours];
        if (hours < 10 && minutes == 0) convertedString = [NSString stringWithFormat:@"0%ih",hours];
    } else {
        minutes = floorf(timeSeconds/60);
        seconds = timeSeconds - minutes*60;
        convertedString = [NSString stringWithFormat:@"%im:%is",minutes, seconds];
        if (minutes < 10) convertedString = [NSString stringWithFormat:@"0%im:%is",minutes, seconds];
        if (seconds < 10) convertedString = [NSString stringWithFormat:@"%im:0%is",minutes, seconds];
        if (minutes < 10 && seconds < 10) convertedString = [NSString stringWithFormat:@"0%im:0%is",minutes, seconds];
        if (seconds == 0) convertedString = [NSString stringWithFormat:@"%im",minutes];
        if (minutes < 10 && seconds == 0) convertedString = [NSString stringWithFormat:@"0%im",minutes];
        if (minutes == 0) convertedString = [NSString stringWithFormat:@"%is",seconds];
    }
    return convertedString;
}

// Storage
-(NSArray *)fileExistsAtPath:(NSString *)path withFileExtension:(NSString *)extention {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL fileExists = [fileManager fileExistsAtPath:[path stringByAppendingPathExtension:extention]];
    NSString *availableFileName = @"";
    if (fileExists) {
        int tries = 1;
        while ([fileManager fileExistsAtPath:[[NSString stringWithFormat:@"%@(%i)", path, tries] stringByAppendingPathExtension:extention]]) {
            NSString *fileName = [NSString stringWithFormat:@"%@(%i)", path, tries];
            BOOL availableFileNameFound = ![fileManager fileExistsAtPath:[fileName stringByAppendingPathExtension:extention]];
            if (availableFileNameFound) {
                break;
            }
            tries++;
        }
        availableFileName = [NSString stringWithFormat:@"%@(%i).%@",path, tries, extention];
    } else {
        return @[[NSNumber numberWithBool:fileExists]];
    }
    return @[[NSNumber numberWithBool:fileExists], availableFileName, [availableFileName lastPathComponent], [[availableFileName lastPathComponent] substringToIndex:[[availableFileName lastPathComponent] length]-4]];
}

-(NSString *)getDocumentsDir {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return documentsDir;
}

-(NSArray *)parseCSV:(NSString *)csvName inDir:(NSString *)dir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *parentFolder = [documentsDir stringByAppendingPathComponent:dir];
    NSString *csvFile = [parentFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", csvName]];
    
    return [NSArray arrayWithContentsOfCSVFile:csvFile];
}

-(NSArray *)getArrayOfFilesInDirectory:(NSString *)folderName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray *files = [[NSMutableArray alloc] init];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    if (folderName == nil) {
        files = (NSMutableArray *)[fileManager contentsOfDirectoryAtPath:documentsDir error:&error];
    } else {
        NSString *folderDir = [documentsDir stringByAppendingPathComponent:folderName];
        files = (NSMutableArray *)[fileManager contentsOfDirectoryAtPath:folderDir error:&error];
    }
    
    [files removeObject:@".DS_Store"]; // For Simulator Use
    
    return files;
}

-(void)removeFileAtDir:(NSString *)dir {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *folderToDelete = [documentsDir stringByAppendingPathComponent:dir];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager removeItemAtPath:folderToDelete error:nil];
}

-(void)writeThis:(NSArray *)array toCSV:(NSString *)csvName inDir:(NSString *)dir {
    NSString *csvDir = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", csvName]];
    CHCSVWriter *csvWriter = [[CHCSVWriter alloc] initForWritingToCSVFile:csvDir];
    int rows = (int)[array count];
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < [[array objectAtIndex:r] count]; c++) {
            [csvWriter writeField:array[r][c]];
        }
        if (r != rows-1) {
            [csvWriter finishLine];
        }
    }
    [csvWriter closeStream];
}

-(NSString *)createNewFolderWithName:(NSString *)name inSubDir:(NSString *)folderNameInDocumentsFolder {
    
    NSString *folderName = [name stringByReplacingOccurrencesOfString:@"/" withString:@"*"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *toCreateDir;
    
    if (folderNameInDocumentsFolder == nil) {
        toCreateDir = [documentsDir stringByAppendingPathComponent:folderName];
    } else {
        NSString *folderBeforeDir = [documentsDir stringByAppendingPathComponent:folderNameInDocumentsFolder];
        toCreateDir = [folderBeforeDir stringByAppendingPathComponent:folderName];
    }
    
    if([fileManager fileExistsAtPath:toCreateDir]) {
        return nil;
    } else {
        [fileManager createDirectoryAtPath:toCreateDir withIntermediateDirectories:NO attributes:nil error:&error];
    }
    
    return toCreateDir;
}

-(NSDictionary *)getRootDictionaryOfPlist:(NSString *)plistDir {
    
    NSString *full_plistDir = [[self getDocumentsDir] stringByAppendingPathComponent:plistDir];
    NSDictionary *root = [[NSMutableDictionary alloc] initWithContentsOfFile:full_plistDir];
    return root;
}

-(void)storeThis:(id)object withKey:(NSString *)key inplistdir:(NSString *)plistdir {
    // Get the File Path
    NSString *plistDir = [[self getDocumentsDir] stringByAppendingPathComponent:plistdir];
    
    NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithContentsOfFile:plistDir];
    [root setValue:object forKey:key];
    [root writeToFile:plistDir atomically:YES];
}

-(void)write:(NSDictionary *)_this toPlist:(NSString *)fileDir {
    // Get the File Path
    NSString *plistDir = [[self getDocumentsDir] stringByAppendingPathComponent:fileDir];
    [_this writeToFile:plistDir atomically:YES];
}

-(id)getThisWithKey:(NSString *)key fromplist:(NSString *)fileDir{
    // Get the File Path
    NSString *plistDir = [[self getDocumentsDir] stringByAppendingPathComponent:fileDir];
    
    NSDictionary *root = [[NSDictionary alloc] initWithContentsOfFile:plistDir];
    
    return [root objectForKey:key];
}

@end
