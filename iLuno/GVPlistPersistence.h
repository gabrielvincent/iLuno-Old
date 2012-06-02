//
//  GVPlistPersistence.h
//  PlistPersistanceManager
//
//  Created by Gabriel Vincent on 09/09/11.
//  Copyright 2011 _A_Z. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVPlistPersistence : NSObject {
	BOOL plistAlreadyExists;
}

- (void) createNewDatabaseWithName:(NSString *) name;
- (NSArray *) databaseWithName:(NSString *) fileName;
- (NSArray *) plistFromURL:(NSString *) url;
- (void) downloadPlistFromURL:(NSString *)url AndSaveItAs:(NSString *)fileName;
- (void) downloadPlistFromURL:(NSString *)url AndSaveItAs:(NSString *)fileName OverwrittingExistingFiles:(BOOL) overwrite;
- (void) addNewEntry: (NSMutableDictionary *)dict ToDatabase: (NSString *) fileName;
- (void) addValue:(NSString *)value ForKey:(NSString *)key ForEntryAtIndex:(NSInteger)index ToDatabase: (NSString *) fileName;
- (void) removeEntryAtIndex:(NSInteger) index FromDatabase:(NSString *) fileName;
- (NSString *) valueOfKey:(NSString *) key ForEntryAtIndex:(NSInteger) index FromDatabase:(NSString *)fileName;
- (NSArray *) valueOfKey:(NSString *) key ForAllEntriesFromDatabase:(NSString *)fileName;
- (void) setValue:(NSString *) value ForKey:(NSString *) key ForEntryAtIndex:(NSInteger) index InDatabase:(NSString *) fileName;
- (void) setValue:(NSString *)value ForKey:(NSString *)key ForAllEntriesInDatabase:(NSString *) fileName;
- (NSInteger) countEntriesInDatabase:(NSString *) fileName;
- (void) removeDatabase:(NSString *) fileName;

@end
