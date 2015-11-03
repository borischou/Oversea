//
//  OSChatListViewController.m
//  Oversea
//
//  Created by Zhouboli on 15/11/2.
//  Copyright © 2015年 Bankwel. All rights reserved.
//

#import "OSChatListViewController.h"

static NSString *TARGET_ID = @"test_targetid";
static NSString *USER_NAME = @"testname";

@interface OSChatListViewController () <RCIMReceiveMessageDelegate>

@end

@implementation OSChatListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBarbuttonItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupBarbuttonItems
{
    UIBarButtonItem *newConversationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newConversationButtonPressed:)];
    self.navigationItem.rightBarButtonItem = newConversationButton;
}

-(void)newConversationButtonPressed:(UIBarButtonItem *)sender
{
    RCConversationViewController *cvc = [[RCConversationViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:TARGET_ID];
    cvc.userName = USER_NAME;
    cvc.title = USER_NAME;
    [self.navigationController pushViewController:cvc animated:YES];
}

-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *cvc = [[RCConversationViewController alloc] initWithConversationType:model.conversationType targetId:model.targetId];
    cvc.userName = model.conversationTitle;
    cvc.title = model.conversationTitle;
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark - RCIMClientReceiveMessageDelegate

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    NSLog(@"onRCIMReceiveMessage message: %@ left: %d", message, left);
}

-(BOOL)onRCIMCustomAlertSound:(RCMessage *)message
{
    NSLog(@"onRCIMCustomAlertSound message: %@", message);
    return YES;
}

-(BOOL)onRCIMCustomLocalNotification:(RCMessage *)message withSenderName:(NSString *)senderName
{
    NSLog(@"onRCIMCustomLocalNotification message: %@ withSenderName: %@", message, senderName);
    return YES;
}

@end
