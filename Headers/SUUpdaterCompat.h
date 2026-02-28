#import <Cocoa/Cocoa.h>

@protocol SUVersionComparison <NSObject>
- (NSComparisonResult)compareVersion:(NSString *)versionA toVersion:(NSString *)versionB;
@end

@interface SUUpdater : NSObject

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSURL *feedURL;

+ (SUUpdater *)sharedUpdater;
- (IBAction)checkForUpdates:(id)sender;

@end
