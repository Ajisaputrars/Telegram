#import "TGInterfaceAssets.h"

#import <LegacyComponents/LegacyComponents.h>

#include <map>
#import <CommonCrypto/CommonDigest.h>

#import "TGTelegraph.h"

#define TGStretchableImageInCenterWithName(s,t) { UIImage *rawImage = [UIImage imageNamed:s]; t = [rawImage stretchableImageWithLeftCapWidth:(int)((rawImage.size.width / 2)) topCapHeight:(int)((rawImage.size.height / 2))]; }

static TG_SYNCHRONIZED_DEFINE(uidToColor) = PTHREAD_MUTEX_INITIALIZER;
static std::map<int64_t, int> uidToColor;

static TG_SYNCHRONIZED_DEFINE(gidToColor) = PTHREAD_MUTEX_INITIALIZER;
static std::map<int64_t, int> gidToColor;

@implementation TGInterfaceAssets

+ (TGInterfaceAssets *)instance
{
    static TGInterfaceAssets *singleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        singleton = [[TGInterfaceAssets alloc] init];
    });
    
    return singleton;
}

- (void)clearColorMapping
{
    TG_SYNCHRONIZED_BEGIN(uidToColor);
    uidToColor.clear();
    TG_SYNCHRONIZED_END(uidToColor);
    
    TG_SYNCHRONIZED_BEGIN(gidToColor);
    gidToColor.clear();
    TG_SYNCHRONIZED_END(gidToColor);
}

- (UIColor *)userColor:(int)uid
{
    static __strong UIColor *userColors[8];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        userColors[0] = UIColorRGB(0xfc5c51); // red
        userColors[1] = UIColorRGB(0xfa790f); // orange
        userColors[2] = UIColorRGB(0x895dd5); // violet
        userColors[3] = UIColorRGB(0x0fb297); // green
        userColors[4] = UIColorRGB(0x00c1a6); // cyan
        userColors[5] = UIColorRGB(0x3ca5ec); // light blue
        userColors[6] = UIColorRGB(0x3d72ed); // blue
    });
    
    return userColors[[self userColorIndex:uid]];
}

- (int)userColorIndex:(int)uid
{
    return uid % 7;
}

- (int)groupColorIndex:(int64_t)groupId
{
    int64_t peerId = groupId;
    if (TGPeerIdIsChannel(peerId))
        peerId = TGChannelIdFromPeerId(peerId);
    else if (TGPeerIdIsGroup(peerId))
        peerId = TGGroupIdFromPeerId(peerId);
    return labs(peerId) % 7;
}

- (UIColor *)groupColor:(int64_t)groupId
{
    static __strong UIColor *userColors[8];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        userColors[0] = UIColorRGB(0xfc5c51); // red
        userColors[1] = UIColorRGB(0xfa790f); // orange
        userColors[2] = UIColorRGB(0x895dd5); // violet
        userColors[3] = UIColorRGB(0x0fb297); // green
        userColors[4] = UIColorRGB(0x00c0c2); // cyan
        userColors[5] = UIColorRGB(0x3ca5ec); // light blue
        userColors[6] = UIColorRGB(0x3d72ed); // blue
    });
    
    return userColors[[self groupColorIndex:groupId]];
}

+ (UIColor *)listsBackgroundColor
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        color = UIColorRGB(0xefeff4);
    });
    return color;
}

- (UIColor *)blueLinenBackground
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Linen.png"]];
    });
    return color;
}

- (UIColor *)darkLinenBackground
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DarkLinen.png"]];
    });
    return color;
}

- (UIColor *)linesBackground
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SettingsBackground.png"]];
    });
    return color;
}

- (UIColor *)footerBackground
{
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Footer.png"]];
    });
    return color;
}

- (UIColor *)dialogListBackgroundColor
{
    return [UIColor whiteColor];
}

- (UIColor *)dialogListTableBackgroundColor
{
    return [UIColor whiteColor];
}

- (UIColor *)dialogListHeaderColor
{
    return UIColorRGB(0xefeff4);
}

- (bool)dialogListSearchStripeHidden
{
    return true;
}

- (UIImage *)dialogListSearchIcon
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"SearchBarIcon.png"];
    return image;
}

- (UIImage *)dialogListSearchCancelButton
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *tile = [UIImage imageNamed:@"SearchCancelButton.png"];
        image = [tile stretchableImageWithLeftCapWidth:(int)(tile.size.width / 2) topCapHeight:(int)(tile.size.height / 2)];
    }
    return image;
}

- (UIImage *)dialogListSearchCancelButtonHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *tile = [UIImage imageNamed:@"SearchCancelButton_Pressed.png"];
        image = [tile stretchableImageWithLeftCapWidth:(int)(tile.size.width / 2) topCapHeight:(int)(tile.size.height / 2)];
    }
    return image;
}

- (UIImage *)dialogListUnreadCountBadge
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *rawImage = [UIImage imageNamed:@"DialogListUnreadBadge.png"];
        image = [rawImage stretchableImageWithLeftCapWidth:(int)((rawImage.size.width) / 2) topCapHeight:(int)((rawImage.size.height) / 2)];
    }
    return image;
}

- (UIImage *)dialogListUnreadCountBadgeHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *rawImage = [UIImage imageNamed:@"DialogListUnreadBadge_Highlighted.png"];
        image = [rawImage stretchableImageWithLeftCapWidth:(int)((rawImage.size.width) / 2) topCapHeight:(int)((rawImage.size.height) / 2)];
    }
    return image;
}

- (UIImage *)dialogListDeliveryErrorBadge
{
    static UIImage *image = nil;
    if (image == nil)
    {
        image = [UIImage imageNamed:@"DialogErrorBadge.png"];
    }
    return image;
}

- (UIImage *)dialogListDeliveryErrorBadgeHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
    {
        image = [UIImage imageNamed:@"DialogErrorBadge_Highlighted.png"];
    }
    return image;
}

- (UIImage *)avatarPlaceholderGeneric
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"DialogListAvatarPlaceholder.png"];
    return image;
}

- (UIImage *)authorAvatarPlaceholder
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"DialogListAuthorAvatarPlaceholder.png"];
    return image;
}

- (UIImage *)groupAvatarPlaceholderGeneric
{
    return [self avatarPlaceholderGeneric];
}

- (UIImage *)smallAvatarPlaceholderGeneric
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"DialogListAvatarPlaceholderSmall.png"];
    return image;
}

- (UIImage *)smallGroupAvatarPlaceholderGeneric
{
    return [self smallAvatarPlaceholderGeneric];
}

- (UIImage *)avatarMask
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"AvatarMask.png"];
    return image;
}

- (UIImage *)avatarMaskUnread
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"AvatarMaskUnread.png"];
    return image;
}

- (UIImage *)avatarMaskHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"AvatarMaskHighlighted.png"];
    return image;
}

- (UIImage *)avatarMask40
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"AvatarMask40.png"];
    return image;
}

- (UIImage *)avatarMask40Highlighted
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"AvatarMask40_Highlighted.png"];
    return image;
}

- (UIImage *)callButton
{
    static UIImage *image = nil;
    if (image == nil)
        image = [[UIImage imageNamed:@"Call_Button.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:15];
    return image;
}

- (UIImage *)callButtonHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
        image = [[UIImage imageNamed:@"Call_Button_Pressed.png"] stretchableImageWithLeftCapWidth:16 topCapHeight:15];
    return image;
}

- (UIImage *)callButtonPhone
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"Phone.png"];
    return image;
}

- (UIImage *)callButtonPhoneHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"Phone_Pressed.png"];
    return image;
}

+ (UIImage *)timelineHeaderShadow
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"Profile_Shadow.png"];
    return image;    
}

+ (UIImage *)settingsProfileAvatarOverlay
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"SettingsProfileAvatarOverlay.png", image);
    return image;
}

- (UIImage *)dialogListAuthorAvatarStroke
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"DialogListAvatarStroke.png"];
    return image;
}

+ (UIImage *)profileAvatarOverlay
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"ProfileAvatarOverlay.png", image);
    return image;
}

+ (UIImage *)profileAvatarPlaceholderGeneric
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"ProfilePhotoPlaceholderGeneric.png"];
    return image;
}

+ (UIImage *)profileAvatarPlaceholderEmpty
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"ProfilePhotoPlaceholder.png", image);
    return image;
}

+ (UIImage *)profileGroupAvatarPlaceholder
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"ProfilePhotoPlaceholder.png", image);
    return image;
}

+ (UIImage *)actionButton
{
    static UIImage *image = nil;
    if (image == nil)
        image = [[UIImage imageNamed:@"Actions_Button.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:22];
    return image;
}

+ (UIImage *)actionButtonHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
        image = [[UIImage imageNamed:@"Actions_Button_Pressed.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:22];
    return image;
}

+ (UIImage *)timelineLocationIcon
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"TimelineLocation.png"];
    return image;
}

+ (UIImage *)timelineImagePlaceholder
{
    static UIImage *image = nil;
    if (image == nil)
        image = [[UIImage imageNamed:@"TimelineImagePlaceholder.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
    return image;
}

+ (NSArray *)timelineImageCorners
{
    static NSArray *array = nil;
    if (array == nil)
    {
        array = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"TimelineImageCornerTL.png"], [UIImage imageNamed:@"TimelineImageCornerTR.png"], [UIImage imageNamed:@"TimelineImageCornerBL.png"], [UIImage imageNamed:@"TimelineImageCornerBR.png"], nil];
    }
    return array;
}

+ (UIImage *)conversationTitleAvatarOverlay
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"TitleAvatarOverlay.png", image);
    return image;
}

+ (UIImage *)conversationTitleAvatarOverlayLandscape
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"TitleAvatarOverlay_Landscape.png", image);
    return image;
}

+ (UIImage *)memberListAvatarOverlay
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"MembersAvatarOverlay.png"];
    return image;
}

+ (UIImage *)conversationGenericAvatarPlaceholder:(bool)useMonochrome
{
    if (useMonochrome)
    {
        static UIImage *image = nil;
        if (image == nil)
            image = [UIImage imageNamed:@"ConversationAvatarPlaceholder_Mono.png"];
        return image;
    }
    else
    {
        static UIImage *image = nil;
        if (image == nil)
            image = [UIImage imageNamed:@"ConversationAvatarPlaceholder.png"];
        return image;
    }
    
    return nil;
}

+ (UIImage *)conversationAvatarOverlay
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"MultichatAvatarOverlay.png"];
    return image;
}

+ (UIImage *)timelineDeletePhotoButton
{
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        image = [[UIImage imageNamed:@"DeletePhoto.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:12];
    });
    return image;
}

+ (UIImage *)timelineDeletePhotoButtonHighlighted
{
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        image = [[UIImage imageNamed:@"DeletePhoto_Pressed.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:12];
    });
    return image;
}

+ (UIImage *)timelineActionPhotoButton
{
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        image = [[UIImage imageNamed:@"ActionPhoto.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:13];
    });
    return image;
}

+ (UIImage *)timelineActionPhotoButtonHighlighted
{
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        image = [[UIImage imageNamed:@"ActionPhoto_Pressed.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:13];
    });
    return image;
}

+ (UIImage *)groupedCellTop
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"GroupedCellTop.png", image);
    return image;
}

+ (UIImage *)groupedCellTopHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *rawImage = [UIImage imageNamed:@"GroupedCellTop_Selected.png"];
        if ([rawImage respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
            image = [rawImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 13, 6, rawImage.size.width - 13 - 1) resizingMode:UIImageResizingModeStretch];
        else
            image = [rawImage stretchableImageWithLeftCapWidth:(int)((rawImage.size.width / 2)) topCapHeight:(int)(rawImage.size.height - 2)];
    }
    return image;
}

+ (UIImage *)groupedCellMiddle
{
    static UIImage *image = nil;
    if (image == nil)
    {
        TGStretchableImageInCenterWithName(@"GroupedCellMiddle.png", image);
    }
    return image;
}

+ (UIImage *)groupedCellMiddleHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *rawImage = [UIImage imageNamed:@"GroupedCellMiddle_Selected.png"];
        if ([rawImage respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
            image = [rawImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 13, 6, rawImage.size.width - 13 - 1) resizingMode:UIImageResizingModeStretch];
        else
            image = [rawImage stretchableImageWithLeftCapWidth:(int)((rawImage.size.width / 2)) topCapHeight:(int)(rawImage.size.height - 2)];
    }
    return image;
}

+ (UIImage *)groupedCellBottom
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"GroupedCellBottom.png", image);
    return image;
}

+ (UIImage *)groupedCellBottomHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *rawImage = [UIImage imageNamed:@"GroupedCellBottom_Selected.png"];
        image = [rawImage stretchableImageWithLeftCapWidth:(int)((rawImage.size.width / 2)) topCapHeight:1];
    }
    return image;
}

+ (UIImage *)groupedCellSingle
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"GroupedCellSingle.png", image);
    return image;
}

+ (UIImage *)groupedCellSingleHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *rawImage = [UIImage imageNamed:@"GroupedCellSingle_Selected.png"];
        if ([rawImage respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)])
            image = [rawImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 13, 6, rawImage.size.width - 13 - 1) resizingMode:UIImageResizingModeStretch];
        else
            image = [rawImage stretchableImageWithLeftCapWidth:(int)((rawImage.size.width / 2)) topCapHeight:(int)((rawImage.size.height / 2))];
    }
    return image;
}

+ (UIImage *)groupedCellDisclosureArrow
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"MenuDisclosureIndicator.png"];
    return image;
}

+ (UIImage *)groupedCellDisclosureArrowHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"MenuDisclosureIndicator_Highlighted.png"];
    return image;
}

+ (UIImage *)mediaGridImagePlaceholder
{
    static UIImage *image = nil;
    if (image == nil)
        image = [UIImage imageNamed:@"FlatImagePlaceholder.png"];
    return image;
}

+ (UIImage *)notificationBackground
{
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        UIImage *rawImage = [UIImage imageNamed:@"BannerBackground.png"];
        image = [rawImage stretchableImageWithLeftCapWidth:(int)((rawImage.size.width) / 2) topCapHeight:(int)((rawImage.size.height) / 2)];
    });
    return image;
}

+ (UIImage *)notificationBackgroundHighlighted
{
    return [TGInterfaceAssets notificationBackground];
}

+ (UIImage *)notificationAvatarOverlay
{
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        image = [UIImage imageNamed:@"BannerAvatarOverlay.png"];
    });
    return image;
}

+ (UIImage *)notificationAvatarPlaceholderGeneric
{
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        image = [UIImage imageNamed:@"BannerAvatarPlaceholderGeneric.png"];
    });
    return image;
}

+ (UIImage *)locationNotificationIcon
{
    return [UIImage imageNamed:@"BannerLocationIcon.png"];
}

+ (UIImage *)menuButtonBackgroundRed
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"MenuRedButton.png", image);
    return image;
}

+ (UIImage *)menuButtonBackgroundRedHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"MenuRedButton_Highlighted.png", image);
    return image;
}

+ (UIImage *)menuButtonBackgroundGray
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"MenuGrayButton.png", image);
    return image;
}

+ (UIImage *)menuButtonBackgroundGrayHighlighted
{
    static UIImage *image = nil;
    if (image == nil)
        TGStretchableImageInCenterWithName(@"MenuGrayButton_Highlighted.png", image);
    return image;
}

- (UIImage *)conversationUserPhotoOverlay
{
    static UIImage *image = nil;
    if (image == nil)
    {
        UIImage *rawImage = [UIImage imageNamed:@"ConversationUserPhotoOverlay.png"];
        image = [rawImage stretchableImageWithLeftCapWidth:(int)(rawImage.size.width / 2) topCapHeight:(int)(rawImage.size.height / 2)];
    }
    return image;
}

@end
