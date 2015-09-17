
//0&1 denotes for is used for which url type to be used currently
#define URL_TYPE 1
#if URL_TYPE == 0
#elif URL_TYPE == 1

//server url
#define ServerURL @"http://67.225.164.204:8081/Tracking.svc/"
//setting title for application
#define SAFEBUSTRACKER_TITLE @"SafeBusTracker"
//Setting appname ,establishment id ,title name
#define app_name  @"Chempaka"
#define title_name  @"Chempaka Kinder Garten"
#define establishment_id  @"0"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define METERS_PER_MILE 1609.344
#define IS_IPAD (( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? YES : NO)
#define IS_IPHONE_5 (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568)?YES:NO)
#define IS_RETINA_DISPLAY_DEVICE (([UIScreen mainScreen].scale == 2.f)?YES:NO)
#endif
