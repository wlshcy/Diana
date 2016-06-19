
#import <UIKit/UIKit.h>

@protocol HomeHeaderDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface HomeHeader : UIView

@property (nonatomic, strong) UIButton *allCaiBtn;
@property (nonatomic, strong) UIButton *myCaiBtn;
@property (nonatomic, assign) id<HomeHeaderDelegate>delegate;

- (void)configHomeHeader:(NSMutableArray *)data;

- (void)stopTimer;

@end
