#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PPAddressBookHandle.h"
#import "PPGetAddressBook.h"
#import "PPPersonModel.h"
#import "PPSingleton.h"

FOUNDATION_EXPORT double PPGetAddressBookVersionNumber;
FOUNDATION_EXPORT const unsigned char PPGetAddressBookVersionString[];

