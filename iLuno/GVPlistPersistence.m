//
//  GVPlistPersistence.m
//  PlistPersistanceManager
//
//  Created by Gabriel Vincent on 09/09/11.
//  Copyright 2011 _A_Z. All rights reserved.
//

#import "GVPlistPersistence.h"

@implementation GVPlistPersistence

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) createNewDatabaseWithName:(NSString *)name {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *existentPath;
	
	plistAlreadyExists = NO;
	
	NSMutableArray *existing = [[NSMutableArray alloc] initWithArray:[self databaseWithName:@"ExistentDatabases"]];
	if ([existing count] == 0) {
		existentPath = [documentsDirectory stringByAppendingPathComponent:@"ExistentDatabases.plist"];
		NSArray *existentArray = [[NSArray alloc] init];
		[existentArray writeToFile:existentPath atomically: TRUE];
		plistAlreadyExists = NO;
	}
	else {
		existentPath = [documentsDirectory stringByAppendingPathComponent:@"ExistentDatabases.plist"];
		for (int i = 0; i < [existing count]; i++) {
			if ([[existing objectAtIndex:i] isEqualToString:name]) {
				NSLog(@"GVPlistPersistence (in createNewDatabaseWithName function): Database with specified name already exists.");
				plistAlreadyExists = YES;
				break;
			}
			else {
				plistAlreadyExists = NO;
			}
		}
	}
	
	if (!plistAlreadyExists) {
		[existing addObject:name];
		[existing writeToFile:existentPath atomically: TRUE];
		
		NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
		NSArray *array = [[NSArray alloc] init];
		[array writeToFile:plistPath atomically: TRUE];
	}
}

- (NSArray *) databaseWithName:(NSString *) fileName {
	fileName = [NSString stringWithFormat:@"%@.plist", fileName];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:fileName];
	NSArray *arrayLoaded = [[NSArray alloc] initWithContentsOfFile:plistPath];
	
	if (!arrayLoaded) {
		NSLog(@"GVPlistPersistence (in databaseWithName function): Database with specified name not found: \"%@\"", fileName);
	}
	
	return arrayLoaded;
}

- (NSArray *) plistFromURL:(NSString *) url {
	NSArray *arrayLoaded = [[NSArray alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	
	return arrayLoaded;
}

- (void) downloadPlistFromURL:(NSString *)url AndSaveItAs:(NSString *)fileName {
	NSMutableArray *downloadedArray;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *existent = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ExistentDatabases.plist"]];
	NSMutableArray *existentArray = [[NSMutableArray alloc] initWithContentsOfFile:existent];
	if ([existentArray count] == 0) {
		[self createNewDatabaseWithName:@"ExistentDatabases"];
		existentArray = [[NSMutableArray alloc] initWithContentsOfFile:existent];
	}
	plistAlreadyExists = NO;
	int i;
	for (i = 0; i < [existentArray count]; i++) {
		if ([[existentArray objectAtIndex:i] isEqualToString:fileName]) {
			NSLog(@"GVPlistPersistence (in downloadPlistFromURL:AndSaveItAs function): Plist with specified name already exists.");
			plistAlreadyExists = YES;
			break;
		}
	}
	
	if (!plistAlreadyExists) {
		downloadedArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
		NSString *plistName = [[NSString alloc] initWithFormat:@"%@.plist", fileName];
		[downloadedArray writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:plistName] atomically:YES];
		[existentArray addObject:fileName];
		[existentArray writeToFile:existent atomically:YES];
	}
}

- (void) downloadPlistFromURL:(NSString *)url AndSaveItAs:(NSString *)fileName OverwrittingExistingFiles:(BOOL) overwrite {
	NSMutableArray *downloadedArray;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *existent = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"ExistentDatabases.plist"]];
	NSMutableArray *existentArray = [[NSMutableArray alloc] initWithContentsOfFile:existent];
	if ([existentArray count] == 0) {
		[self createNewDatabaseWithName:@"ExistentDatabases"];
		existentArray = [[NSMutableArray alloc] initWithContentsOfFile:existent];
	}
	
	if (overwrite) {
		downloadedArray = [[NSMutableArray alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
		NSString *plistName = [[NSString alloc] initWithFormat:@"%@.plist", fileName];
		[downloadedArray writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:plistName] atomically:YES];
		[existentArray addObject:fileName];
		[existentArray writeToFile:existent atomically:YES];
	}
	else {
		plistAlreadyExists = NO;
		int i;
		for (i = 0; i < [existentArray count]; i++) {
			if ([[existentArray objectAtIndex:i] isEqualToString:fileName]) {
				NSLog(@"GVPlistPersistence (in downloadPlistFromURL:AndSaveItAs function): Plist with specified name already exists.");
				plistAlreadyExists = YES;
				break;
			}
		}
	}
}

- (void) addNewEntry: (NSMutableDictionary *)dict ToDatabase: (NSString *) fileName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSMutableArray *arrayLoaded = [[NSMutableArray alloc] init];
	arrayLoaded = [NSMutableArray arrayWithArray:[self databaseWithName:fileName]];
	
	[arrayLoaded addObject:dict];
	
	[arrayLoaded writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]] atomically:YES];
	
}

- (void) addValue:(NSString *)value ForKey:(NSString *)key ForEntryAtIndex:(NSInteger)index ToDatabase: (NSString *) fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSMutableArray *arrayLoaded = [[NSMutableArray alloc] init];
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	arrayLoaded = [NSMutableArray arrayWithArray:[self databaseWithName:fileName]];
	dict = [arrayLoaded objectAtIndex:index];
	
	NSString *string = [[NSString alloc] initWithFormat:@"%@", [dict objectForKey:key]];
	if (string.length > 0) {
		NSLog(@"GVPlistPersistence (in addValue:ForKey:ForEntryAtIndex:ToDatabase: function): Key \"%@\" already exists.", key);
	}
	else {
		[dict setValue:value forKey:key];
		
		[arrayLoaded removeObjectAtIndex:index];
		[arrayLoaded addObject:dict];
		
		[arrayLoaded writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]] atomically:YES];
	}
}

- (void) removeEntryAtIndex:(NSInteger) index FromDatabase:(NSString *) fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSMutableArray *arrayLoaded = [[NSMutableArray alloc] init];
	arrayLoaded = [NSMutableArray arrayWithArray:[self databaseWithName:fileName]];
	
	NSLog(@"FIleName: %@", fileName);
	
	[arrayLoaded removeObjectAtIndex:index];
	
	[arrayLoaded writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]] atomically:YES];
}

- (NSString *) valueOfKey:(NSString *) key ForEntryAtIndex:(NSInteger) index FromDatabase:(NSString *)fileName {
	NSMutableArray *arrayLoaded = [[NSMutableArray alloc] init];
	arrayLoaded = [NSMutableArray arrayWithArray:[self databaseWithName:fileName]];
	NSString *string = [[NSString alloc] initWithFormat:@"%@", [[arrayLoaded objectAtIndex:index] objectForKey:key]];
	
	if (string == nil) NSLog(@"GVPlistPersistence (in valueOfKey:OfEntryAtIndex:FromDatabase function): Key with specified name not found.");
	
	return string;
}

- (NSArray *) valueOfKey:(NSString *) key OfAllEntriesFromDatabase:(NSString *)fileName {
	NSMutableArray *arrayLoaded = [[NSMutableArray alloc] init];
	arrayLoaded = [NSMutableArray arrayWithArray:[self databaseWithName:fileName]];
	NSMutableArray *newArray = [[NSMutableArray alloc] init];
	
	int i = 0;
	for (NSDictionary *dict in arrayLoaded) {
		if ([dict objectForKey:key]) [newArray addObject:[dict objectForKey:key]];
		else NSLog(@"GVPlistPersistence (in valueOfKey:OfAllEntriesFromDatabase function): Key with specified name not found at index: %d.", i);
		i++;
	}
	
	return [NSArray arrayWithArray:newArray];
}

- (void) setValue:(NSString *) value ForKey:(NSString *) key ForEntryAtIndex:(NSInteger) index InDatabase:(NSString *) fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSMutableArray *arrayLoaded = [[NSMutableArray alloc] init];
	arrayLoaded = [NSMutableArray arrayWithArray:[self databaseWithName:fileName]];
	
	[[arrayLoaded objectAtIndex:index] setValue:value forKey:key];
	
	[arrayLoaded writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]] atomically:YES];
}

- (void) setValue:(NSString *)value ForKey:(NSString *)key ForAllEntriesInDatabase:(NSString *) fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSMutableArray *arrayLoaded = [[NSMutableArray alloc] init];
	arrayLoaded = [NSMutableArray arrayWithArray:[self databaseWithName:fileName]];
	
	for (NSMutableDictionary *dict in arrayLoaded) {
		[dict setValue:value forKey:key];
	}
	
	[arrayLoaded writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]] atomically:YES];
}

- (NSInteger) countEntriesInDatabase:(NSString *) fileName {
	NSMutableArray *arrayLoaded = [[NSMutableArray alloc] init];
	arrayLoaded = [NSMutableArray arrayWithArray:[self databaseWithName:fileName]];
	
	return [arrayLoaded count];
}

- (void) removeDatabase:(NSString *) fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *fileToBeDeletedPath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
	NSString *existent = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ExistentDatabases.plist"]];
	
	NSMutableArray *existentArray = [[NSMutableArray alloc] initWithContentsOfFile:existent];
	
	plistAlreadyExists = NO;
	int i;
	for (i = 0; i < [existentArray count]; i++) {
		if ([[existentArray objectAtIndex:i] isEqualToString:fileName]) {
			NSLog(@"GVPlistPersistence (in removeDatabase function): Database with specified name not found.");
			plistAlreadyExists = YES;
			break;
		}
	}
	
	if (plistAlreadyExists) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:fileToBeDeletedPath error:NULL];
		[existentArray removeObjectAtIndex:i];
		[existentArray writeToFile:existent atomically:YES];
	}
}

- (BOOL) databaseAlreadyExistsWithName:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *existent = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ExistentDatabases.plist"]];
	
	NSMutableArray *existentArray = [[NSMutableArray alloc] initWithContentsOfFile:existent];
	
	plistAlreadyExists = NO;
	for (NSString *database in existentArray) {
		if ([database isEqualToString:fileName]) {
			plistAlreadyExists = YES;
			break;
		}
	}
	
	return plistAlreadyExists;
}

@end
