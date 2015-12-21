//
//  AppDelegate.m
//  ThesApp
//
//  Created by Paolo Burzacca on 28/04/15.
//  Copyright (c) 2015 IIT Cnr. All rights reserved.
//

#import "AppDelegate.h"
#import "ScrollerViewController.h"
#import "SideMenuTableViewController.h"
#import "Global.h"  

@interface AppDelegate ()
@property(nonatomic, strong) void (^registrationHandler) (NSString *registrationToken, NSError *error);
@property(nonatomic, assign) BOOL connectedToGCM;
@property(nonatomic, strong) NSString* registrationToken;
@property(nonatomic, assign) BOOL subscribedToTopic;
@end

@implementation AppDelegate

+(CGFloat) getSidemenuWidth {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) return 350;
    return 270;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Global singleton].linguaInUso = [Utils getCurrentLanguage];
    
    NSLog(@"lingua trovata = %@", [Global singleton].linguaInUso);
    
    if ([Global singleton].linguaInUso == nil) {
        
        NSString *lingua = [Utils getDeviceLanguage];
        
        NSLog(@"lingua device = %@", lingua);
        
        [Utils saveLanguage:lingua];
        [Global singleton].linguaInUso = lingua;
    }
    
    //NSString *linguaDevice = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
    //NSString *linguaTrovata = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
    
    //NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                          //linguaDevice, @"language", nil];
    
    //[[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
    
   // NSString *linguaTrovata1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"language"];
   // NSLog(@"linguaTrovata dopo = %@", linguaTrovata1);
    
    if ([[Global singleton] isItalian]) {
        NSLog(@"italiano");
    }
    else NSLog(@"inglese");
    
    //UIPageControl *pageControl = [UIPageControl appearance];
    //pageControl.pageIndicatorTintColor = [UIColor blueColor];
    //pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    //pageControl.backgroundColor = [UIColor whiteColor];
    
    [self initAppStyle];
    [self initMMDrawer];
    [self initGCMNotifications];
    
    return YES;
}

-(void) initAppStyle {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //IOS 7
    [[UITableView appearance] setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [[UITableView appearance] setSeparatorInset:UIEdgeInsetsZero];
    [[UITableViewCell appearance] setSeparatorInset:UIEdgeInsetsZero];
    
    // iOS 8:
    if ([UITableView instancesRespondToSelector:@selector(setLayoutMargins:)]) {
        [[UITableView appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setLayoutMargins:UIEdgeInsetsZero];
        [[UITableViewCell appearance] setPreservesSuperviewLayoutMargins:NO];
    }
    
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

-(void) initMMDrawer {
    UIStoryboard * st =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSString *ScrollerViewControllerID = @"mainNavID";
    NSString *SideMenuTableViewControllerID = @"SideMenuTableViewControllerSID";
    
    UINavigationController *svc = (UINavigationController *) [st instantiateViewControllerWithIdentifier:ScrollerViewControllerID];
    
    SideMenuTableViewController *side = (SideMenuTableViewController *) [st instantiateViewControllerWithIdentifier:SideMenuTableViewControllerID];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc]
                                            initWithCenterViewController:svc
                                            leftDrawerViewController:nil
                                            rightDrawerViewController:side];
    
    //drawerController.view.clipsToBounds = YES;
    
    float menuWidth = [AppDelegate getSidemenuWidth];
    [drawerController setMaximumRightDrawerWidth:menuWidth];
    [drawerController setShowsShadow:YES];
    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    
    self.window.rootViewController = drawerController;
}

-(void) initGCMNotifications {
    
    // Register for remote notifications
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    // [START_EXCLUDE]
    _registrationKey = @"onRegistrationCompleted";
    _messageKey = @"onMessageReceived";
    
    // Configure the Google context: parses the GoogleService-Info.plist, and initializes
    // the services that have entries in the file
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    
    if (configureError != nil) {
        NSLog(@"Error configuring the Google context: %@", configureError);
    }
    _gcmSenderID = [[[GGLContext sharedInstance] configuration] gcmSenderID];
    
    // [END_EXCLUDE]
    // [END register_for_remote_notifications]
    // [START start_gcm_service]
    
    GCMConfig *config = [GCMConfig defaultConfig];
    
    [config setLogLevel:kGCMLogLevelDebug];
    
    [[GCMService sharedInstance] startWithConfig:config];
    // [END start_gcm_service]
    __weak typeof(self) weakSelf = self;
    // Handler for registration token request
    _registrationHandler = ^(NSString *registrationToken, NSError *error){
        if (registrationToken != nil) {
            weakSelf.registrationToken = registrationToken;
            
            NSLog(@"Token di registrazione: %@", registrationToken);
            
            NSString *topic = [[Global singleton] getTopicName];
            if (topic != nil) {
                [weakSelf subscribeToTopic:topic];
            }
            
            NSDictionary *userInfo = @{@"registrationToken":registrationToken};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];
        } else {
            
            NSLog(@"Registration to GCM failed with error: %@", error.localizedDescription);
            
            NSDictionary *userInfo = @{@"error":error.localizedDescription};
            [[NSNotificationCenter defaultCenter] postNotificationName:weakSelf.registrationKey
                                                                object:nil
                                                              userInfo:userInfo];
        }
    };
    
}

- (void)subscribeToTopic:(NSString *) topic {
    
    if (topic == nil) return;
    
    if (_registrationToken && _connectedToGCM) {
        [[GCMPubSub sharedInstance] subscribeWithToken:_registrationToken
                                                 topic:topic
                                               options:nil
                                               handler:^(NSError *error) {
                                                   if (error) {
                                                       
                                                       if (error.code == 3001) {
                                                           NSLog(@"Già iscritto a %@", topic);
                                                           NSLog(@"[errore finto = %@]", error.localizedDescription);
                                                           
                                                       } else {
                                                           NSLog(@"Iscrizione fallita: %@", error.localizedDescription);
                                                       }
                                                   } else {
                                                       
                                                       self.subscribedToTopic = true;
                                                       NSLog(@"Iscritto al topic %@", topic);
                                                       
                                                   }
                                               }];
    }
}

-(void) unsubscribeTopic:(NSString *) oldTopic andSubcribeTopic:(NSString *) newTopic {
    
    if (oldTopic == nil) return;
    
    if (_registrationToken == nil) {
        NSLog(@"esco, token mancante");
        return;
    }
    
    NSLog(@"oldTopic = %@", oldTopic);
    
    [[GCMPubSub sharedInstance] unsubscribeWithToken:_registrationToken topic:oldTopic options:nil handler:^(NSError *error) {
        
        if (!error) {
            
            NSLog(@"Disiscritto da topic %@", oldTopic);
            self.subscribedToTopic = NO;

            NSLog(@"ora mi sottoscrivo a %@", newTopic);
            [self subscribeToTopic:newTopic];
        }
        else {
            NSLog(@"errore = %@", error.localizedDescription);
        }
        
    }];
}

#pragma mark - GCM Delegate methods

-(void) didDeleteMessagesOnServer {
    NSLog(@"[GCM] didDeleteMessagesOnServer");
}

-(void) willSendDataMessageWithID:(NSString *)messageID error:(NSError *)error {
    NSLog(@"[GCM] willSendDataMessageWithID con id = %@", messageID);
}

-(void) didSendDataMessageWithID:(NSString *)messageID {
    NSLog(@"[GCM] didSendDataMessageWithID con id = %@", messageID);
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // [END receive_apns_token]
    // [START get_gcm_reg_token]
    
    NSLog(@"deviceToken = %@", deviceToken);
    
    // Start the GGLInstanceID shared instance with the default config and request a registration
    // token to enable reception of notifications
    [[GGLInstanceID sharedInstance] startWithConfig:[GGLInstanceIDConfig defaultConfig]];
    
    //NSString *tempToken = @"280f10d3d60bccb325a41553e079ad4309cda852cce917ca893b89bd0ce790cb";
    
    _registrationOptions = @{
                             kGGLInstanceIDRegisterAPNSOption:deviceToken,
                             kGGLInstanceIDAPNSServerTypeSandboxOption:@NO,
                             };
    
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
    // [END get_gcm_reg_token]
}

// [START receive_apns_token_error]
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registration for remote notification failed with error: %@", error.localizedDescription);
    
    NSLog(@"Registration for remote notification failed with error: %@", error.description);
    
    // [END receive_apns_token_error]
    NSDictionary *userInfo = @{@"error" :error.localizedDescription};
    [[NSNotificationCenter defaultCenter] postNotificationName:_registrationKey
                                                        object:nil
                                                      userInfo:userInfo];
}

// [START ack_message_reception]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"1] Notification received: %@", userInfo);
    
    if(application.applicationState != UIApplicationStateActive ){
        NSLog(@"App non attiva");
    } else NSLog(@"App attiva");
    
    
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // [START_EXCLUDE]
    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                      userInfo:userInfo];
    // [END_EXCLUDE]
}


//se ci metto "content_available": true, arriva QUI, altrimenti sopra
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
    
    NSLog(@"2] Notification received: %@", userInfo);
    // This works only if the app started the GCM service
    [[GCMService sharedInstance] appDidReceiveMessage:userInfo];
    // Handle the received message
    // Invoke the completion handler passing the appropriate UIBackgroundFetchResult value
    // [START_EXCLUDE]
    [[NSNotificationCenter defaultCenter] postNotificationName:_messageKey
                                                        object:nil
                                                        userInfo:userInfo];
    
    handler(UIBackgroundFetchResultNewData); //UIBackgroundFetchResultNoData

    // [END_EXCLUDE]
}
// [END ack_message_reception]

// [START on_token_refresh]
- (void)onTokenRefresh {
    // A rotation of the registration tokens is happening, so the app needs to request a new token.
    NSLog(@"The GCM registration token needs to be changed.");
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:_gcmSenderID
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:_registrationOptions
                                                      handler:_registrationHandler];
}
// [END on_token_refresh]

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[GCMService sharedInstance] disconnect];
    // [START_EXCLUDE]
    _connectedToGCM = NO;
    // [END_EXCLUDE]
    NSLog(@"applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    
    application.applicationIconBadgeNumber = 0;
    
    [[GCMService sharedInstance] connectWithHandler:^(NSError *error) {
        
        if (error) {
            
            NSLog(@"Impossibile connettersi a GCM: %@", error.localizedDescription);
            
        } else {
            _connectedToGCM = true;
            
            NSLog(@"CONNESSO A GCM");
            
            NSString *topic = [[Global singleton] getTopicName];
            if (topic != nil) {
                [self subscribeToTopic:topic];
            }
            else {
                NSLog(@"topic non trovato, non mi iscrivo");
            }
        }
    }];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
