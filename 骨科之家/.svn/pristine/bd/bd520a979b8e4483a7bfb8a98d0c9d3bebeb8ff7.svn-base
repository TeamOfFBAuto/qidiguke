//
//  ConfigRefC.h
//  VColleagueChat
//
//  Created by lqy on 4/26/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#ifndef VColleagueChat_ConfigRefC_h
#define VColleagueChat_ConfigRefC_h

#if ! __has_feature(objc_arc)
//-mrc
#define SSRCAutorelease(__v) ([__v autorelease]);
#define SSRCRetain(__v) ([__v retain]);
#define SSRCReturnRetained SSRCRetain



#define SSRCRelease(__v) ([__v release]);
#define SSRCSafeRelease(__v) ([__v release], __v = nil);

#define SSRCSuperDealloc [super dealloc];

#define SSRCWeak

//retain copy

#define SSRCAutoIdRetainOrStrong retain

//block操作


//siyou
#define ASISafeRelease(__v) ([__v clearDelegatesAndCancel],[__v release], __v = nil);
#define MBHUDSafeRelease(__v) (__v.delegate = nil,[__v release], __v = nil);

#else
//-fobjc-arc
#define SSRCAutorelease(__v)
#define SSRCRetain(__v)
#define SSRCReturnRetained(__v) (__v)


#define SSRCRelease(__v)
#define SSRCSafeRelease(__v) (__v = nil);

#define SSRCSuperDealloc

#define SSRCWeak __unsafe_unretained

//retain copy
#define SSRCAutoIdRetainOrStrong strong

//block操作

//siyou
#define ASISafeRelease(__v) ([__v clearDelegatesAndCancel]);
#define MBHUDSafeRelease(__v) (__v.delegate = nil);

#endif


#endif
