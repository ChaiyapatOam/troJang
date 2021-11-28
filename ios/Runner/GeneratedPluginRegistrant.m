//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<contact_picker/ContactPickerPlugin.h>)
#import <contact_picker/ContactPickerPlugin.h>
#else
@import contact_picker;
#endif

#if __has_include(<contacts_service/ContactsServicePlugin.h>)
#import <contacts_service/ContactsServicePlugin.h>
#else
@import contacts_service;
#endif

#if __has_include(<flutter_phone_direct_caller/FlutterPhoneDirectCallerPlugin.h>)
#import <flutter_phone_direct_caller/FlutterPhoneDirectCallerPlugin.h>
#else
@import flutter_phone_direct_caller;
#endif

#if __has_include(<permission_handler/PermissionHandlerPlugin.h>)
#import <permission_handler/PermissionHandlerPlugin.h>
#else
@import permission_handler;
#endif

#if __has_include(<sqflite/SqflitePlugin.h>)
#import <sqflite/SqflitePlugin.h>
#else
@import sqflite;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [ContactPickerPlugin registerWithRegistrar:[registry registrarForPlugin:@"ContactPickerPlugin"]];
  [ContactsServicePlugin registerWithRegistrar:[registry registrarForPlugin:@"ContactsServicePlugin"]];
  [FlutterPhoneDirectCallerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterPhoneDirectCallerPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
}

@end
