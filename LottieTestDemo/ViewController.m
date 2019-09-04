//
//  ViewController.m
//  LottieTestDemo
//
//  Created by cheng on 2019/8/31.
//  Copyright © 2019年 cheng. All rights reserved.
//

#import "ViewController.h"
#import "Lottie.h"

@interface ViewController () {
    UILabel *_fileNameLabel;
    
    UIView *_detailView;
    
    NSInteger _fileIndex;
}

@property (nonatomic, strong) LOTAnimationView *animationView;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    int n = 4;
    CGFloat itemWidth = (width - 10 * n - 10) / n;
    NSArray *titles = @[@"上一个", @"背景色", @"填充模式", @"下一个"];
    
    while (n > 0) {
        int i = n - 1;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10 + (itemWidth +10) * i, height - 60, itemWidth, 40);
        btn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor colorWithDisplayP3Red:arc4random() % 150 + 100 / 255.f green:arc4random() % 100 / 255.f blue:arc4random() % 200 / 255.f alpha:1.f];
        btn.tag = i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        n --;
    }
    
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 90, self.view.frame.size.width, 24)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
        label.userInteractionEnabled = YES;
        _fileNameLabel = label;
    }
}

- (void)btnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    switch (sender.tag) {
        case 0:
        {
            _fileIndex --;
            [self playAnimation];
        }
            break;
        case 1:
        {
            if (sender.selected) {
                self.view.backgroundColor = [UIColor blackColor];
                _fileNameLabel.textColor = [UIColor whiteColor];
            } else {
                self.view.backgroundColor = [UIColor whiteColor];
                _fileNameLabel.textColor = [UIColor blackColor];
            }
        }
            break;
        case 2:
        {
            if (sender.selected) {
                _animationView.contentMode = UIViewContentModeScaleAspectFill;
            } else {
                _animationView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }
            break;
        case 3:
        {
            _fileIndex ++;
            [self playAnimation];
        }
            break;
            
        default:
            break;
    }
}

- (NSString *)filePath
{
    if (_fileIndex < 0) {
        _fileIndex = 0;
    }
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"animation"];
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (contents.count) {
        NSInteger i = _fileIndex % (contents.count);
        NSString *fileName = contents[i];
        NSString *filePath = [path stringByAppendingPathComponent:fileName];
        return filePath;
    }
    return nil;
}

- (void)playAnimation
{
    NSString *filePath = [self filePath];
    NSString *fileName = [filePath lastPathComponent];
    [self playAnimationWithPath:filePath];
    _fileNameLabel.text = fileName;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    if (point.y < 120) {
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass: UIButton.class]) {
                obj.backgroundColor = [UIColor colorWithDisplayP3Red:arc4random() % 255 / 255.f green:arc4random() % 255 / 255.f blue:arc4random() % 255 / 255.f alpha:1.f];
            }
        }];
        return;
    }
    if (touch.view == _fileNameLabel) {
        NSString *filePath = [self filePath];
        NSString *fileName = [filePath lastPathComponent];
        _fileNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", fileName, [self.class fileSize:filePath]];
    } else {
        if (_animationView) {
            if (_animationView.isAnimationPlaying) {
                [_animationView pause];
            } else {
                [_animationView play];
            }
        } else {
            [self playAnimation];
        }
    }
}

+ (NSString *)fileSize:(NSString *)path
{
    NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
    
    /*
     NSFileCreationDate = "2013-03-26 03:03:26 +0000";
         NSFileExtendedAttributes =     {
         "com.apple.TextEncoding" = <7574662d 383b3133 34323137 393834>;
         };
         NSFileExtensionHidden = 0;
         NSFileGroupOwnerAccountID = 20;
         NSFileGroupOwnerAccountName = staff;
         NSFileHFSCreatorCode = 0;
         NSFileHFSTypeCode = 0;
         NSFileModificationDate = "2013-03-26 03:03:58 +0000";
         NSFileOwnerAccountID = 501;
         NSFileOwnerAccountName = hehehe;
         NSFilePosixPermissions = 420;
         NSFileReferenceCount = 1;
         NSFileSize = 19;
     NSFileSystemFileNumber = 3145017;
     NSFileSystemNumber = 16777225;
     NSFileType = NSFileTypeRegular;
     */
    
    NSString *size = [info objectForKey:NSFileSize];
    
    NSInteger s = size.integerValue;
    if (s < 1024) {
        return [NSString stringWithFormat:@"%zd B", s];
    } else if (s < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2f KB", s/1024.f];
    } else {
        return [NSString stringWithFormat:@"%.2f MB", s/1024.f/1024.f];
    }
}

- (void)playAnimationWithPath:(NSString *)path
{
    if (!path) {
        return;
    }
    LOTComposition *sceneModel = [LOTComposition animationWithFilePath:path];
    if (!_animationView) {
        _animationView = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
        _animationView.frame = self.view.bounds;
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
        _animationView.loopAnimation = YES;
        _animationView.userInteractionEnabled = NO;
        _animationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:_animationView atIndex:0];
    } else {
        [_animationView stop];
        
        _animationView.sceneModel = sceneModel;
        _animationView.loopAnimation = YES;
    }
    
    if ([path rangeOfString:@"adrock"].length) {
        _animationView.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        _animationView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    if ([path rangeOfString:@"witch"].length) {
        if (!_detailView) {
            _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 300, 100)];
            _detailView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _detailView.backgroundColor = [UIColor lightGrayColor];
            [self.view addSubview:_detailView];
            
            int i = 0;
            {
                LOTAnimationView *view = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
                view.frame = CGRectMake(i%2 * 150, i/2 * 50, 150, 50);
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.loopAnimation = YES;
                view.userInteractionEnabled = NO;
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_detailView addSubview:view];
                
                [view setAnimationProgress:0];
                i++;
            }
            
            {
                LOTAnimationView *view = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
                view.frame = CGRectMake(i%2 * 150, i/2 * 50, 150, 50);
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.loopAnimation = YES;
                view.userInteractionEnabled = NO;
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_detailView addSubview:view];
                
                [view playFromProgress:0 toProgress:0.5 withCompletion:^(BOOL animationFinished) {
                    
                }];
                i++;
            }
            
            {
                LOTAnimationView *view = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
                view.frame = CGRectMake(i%2 * 150, i/2 * 50, 150, 50);
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.loopAnimation = YES;
                view.userInteractionEnabled = NO;
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_detailView addSubview:view];
                
                [view setAnimationProgress:0.5];
                
                i++;
            }
            
            {
                LOTAnimationView *view = [[LOTAnimationView alloc] initWithModel:sceneModel inBundle:[NSBundle mainBundle]];
                view.frame = CGRectMake(i%2 * 150, i/2 * 50, 150, 50);
                view.contentMode = UIViewContentModeScaleAspectFit;
                view.loopAnimation = YES;
                view.userInteractionEnabled = NO;
                view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                [_detailView addSubview:view];
                
                [view playFromProgress:0.5 toProgress:1.f withCompletion:^(BOOL animationFinished) {
                    
                }];
                i++;
            }
        }
        _detailView.hidden = NO;
    } else {
        if (_detailView) {
            [_detailView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            _detailView.hidden = YES;
        }
    }
    
    [_animationView playToProgress:1.0 withCompletion:^(BOOL animationFinished) {
        NSLog(@"###animationFinished");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
