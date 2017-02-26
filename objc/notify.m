#import "notify.h"

BOOL setApplication(NSString *newbundleIdentifier) {
  if(LSCopyApplicationURLsForBundleIdentifier((CFStringRef)newbundleIdentifier, NULL) != NULL){
    fakeBundleIdentifier = newbundleIdentifier;
    return YES;
  }
  return NO;
}

void sendNotification(NSString *title, NSString *message, NSString *sound) {
  @autoreleasepool {
    if (!installNSBundleHook()) {
      return;
    }

    NSUserNotificationCenter *nc = [NSUserNotificationCenter defaultUserNotificationCenter];
    NotificationCenterDelegate *ncDelegate = [[NotificationCenterDelegate alloc]init];
    ncDelegate.keepRunning = YES;
    nc.delegate = ncDelegate;

    NSUserNotification *note = [[NSUserNotification alloc] init];
    note.title = title;
    note.informativeText = message;


    if ([sound isEqualToString:@"_mute"] == NO) {
      note.soundName = sound;
    }
    [nc deliverNotification:note];

    while (ncDelegate.keepRunning) {
      [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
  }
}