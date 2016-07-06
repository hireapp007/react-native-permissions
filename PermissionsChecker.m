//
//  PermissionsChecker
//  PermissionsChecker
//
//  Created by Yonah Forst on 18/02/16.
//  Copyright © 2016 Yonah Forst. All rights reserved.
//

@import Contacts;

#import "PermissionsChecker.h"

#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <EventKit/EventKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
@import Contacts;
@import Photos;
#endif


@interface PermissionsChecker()
@end

@implementation PermissionsChecker

+ (BOOL)canOpenSettings
{
    return UIApplicationOpenSettingsURLString != nil;
}

+ (void)openSettings
{
    if ([self canOpenSettings]) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}


+ (RNPermissionsStatus)locationPermissionStatus
{
    int status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return RNPermissionsStatusAuthorized;
        case kCLAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case kCLAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
}




+ (RNPermissionsStatus)cameraPermissionStatus
{
    int status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case AVAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case AVAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
}

+ (RNPermissionsStatus)microphonePermissionStatus
{
    int status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case AVAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case AVAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
}

+ (RNPermissionsStatus)photoPermissionStatus
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
    int status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case PHAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case PHAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
#else
    int status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case kABAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case kABAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
#endif
}


+ (RNPermissionsStatus)contactsPermissionStatus
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
    int status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case CNAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case CNAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
#else
    int status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case kABAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case kABAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
#endif
}


+ (RNPermissionsStatus)eventPermissionStatus
{
    int status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case EKAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case EKAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
}

+ (RNPermissionsStatus)reminderPermissionStatus
{
    int status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (status) {
        case EKAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case EKAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case EKAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
}


+ (RNPermissionsStatus)bluetoothPermissionStatus
{
    int status = [CBPeripheralManager authorizationStatus];
    switch (status) {
        case CBPeripheralManagerAuthorizationStatusAuthorized:
            return RNPermissionsStatusAuthorized;
        case CBPeripheralManagerAuthorizationStatusDenied:
            return RNPermissionsStatusDenied;
        case CBPeripheralManagerAuthorizationStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
}

//problem here is that we can only return Authorized or Undetermined
+ (RNPermissionsStatus)notificationPermissionStatus
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        // iOS8+
        BOOL isRegistered = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        BOOL isEnabled = [[[UIApplication sharedApplication] currentUserNotificationSettings] types] != UIUserNotificationTypeNone;
        if (isRegistered || isEnabled) {
            return isEnabled ? RNPermissionsStatusAuthorized : RNPermissionsStatusDenied;
        }
        else {
            return RNPermissionsStatusUndetermined;
        }
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_8_0
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            return RNPermissionsStatusUndetermined;
        }
        else {
            return RNPermissionsStatusAuthorized;
        }
#else
        return RNPermissionsStatusUndetermined;
#endif
        
    }
}

+ (RNPermissionsStatus)backgroundRefreshPermissionStatus
{
    int status = [[UIApplication sharedApplication] backgroundRefreshStatus];
    switch (status) {
        case UIBackgroundRefreshStatusAvailable:
            return RNPermissionsStatusAuthorized;
        case UIBackgroundRefreshStatusDenied:
            return RNPermissionsStatusDenied;
        case UIBackgroundRefreshStatusRestricted:
            return RNPermissionsStatusRestricted;
        default:
            return RNPermissionsStatusUndetermined;
    }
}

@end
