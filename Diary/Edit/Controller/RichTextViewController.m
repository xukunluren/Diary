//
//  ViewController.m
//  InputimageExample
//
//
//  Copyright (c) 2017年 tutuge. All rights reserved.
//

#import "RichTextViewController.h"
#import "RichTextPreviewVC.h"
#import "DPImagePickerVC.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ImageTextAttachment.h"
#import "NSAttributedString+RichText.h"
#import "UIView+TYAlertView.h"
#import "Masonry.h"
#import "LGAudioKit.h"
#import "audioModel.h"
#import "audioImage.h"
#import "EditOfGroups.h"
#import "WeatherKeyBoard.h"
#import "ItemView.h"
#import "EditTestViewController.h"
#import "UzysAssetsPickerController.h"
#import "videoView.h"
#import "editDiaryModel.h"
#import "CRToast.h"
#import "SecondItemViewController.h"
#import "GroupListViewController.h"
#import "groupModel.h"
#import "functionKeyView.h"
#import "UIView+LQXkeyboard.h"
#import "videoModel.h"
#import "Waver.h"
#import "GLBucket.h"
#import "RadiaViewLayer.h"

//Image default max size

static NSString *kAnimationNameKey = @"animation_name";
static NSString *kScrapDriveUpAnimationName = @"scrap_drive_up_animation";
static NSString *kScrapDriveDownAnimationName = @"scrap_drive_down_animation";
static NSString *kBucketDriveUpAnimationName = @"bucket_drive_up_animation";
static NSString *kBucketDriveDownAnimationName = @"bucket_drive_down_animation";

static const CGFloat kScrapDriveUpAnimationHeight = 150;
static const CGFloat kScrapYOffsetFromBase = 7;


#define IMAGE_MAX_SIZE ([UIScreen mainScreen].bounds.size.width-20)

#define ImageTag (@"[UIImageView]")
#define DefaultFont (16)
#define MaxLength (2000)

#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface RichTextViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,DPImagePickerDelegate,UzysAssetsPickerControllerDelegate,sendClickEvent>
//@property (weak, nonatomic) IBOutlet UIView *upkeyboardView;
@property (strong, nonatomic)   UITextView *textView;

@property (nonatomic, weak) NSTimer *timerOf60Second;
@property (weak, nonatomic)   UISlider *imageSizeSlider;
@property (weak, nonatomic)  NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic)  DPImagePickerVC * Viewasd;
@property (strong, nonatomic)  UIImageView *audioImageKeyBoard;//录音键盘
@property (strong, nonatomic)  UIView *weatherKeyBoard;//天气键盘
@property (strong, nonatomic)  UIButton *audioButton;
@property (assign, nonatomic)  Boolean willhiddleKeyBoard;
@property (nonatomic,assign) CGFloat lastPosition;    //最后的位置

//设置
@property (nonatomic,assign) BOOL isBold;          //是否加粗
@property (nonatomic,strong) UIColor * fontColor;  //字体颜色
@property (nonatomic,assign) CGFloat  font;        //字体大小
@property (nonatomic,assign) NSUInteger location;  //纪录变化的起始位置
@property (nonatomic,strong) NSMutableAttributedString * locationStr;
@property (nonatomic,assign) CGRect textViewBounds;    //TextView的bounds
@property (nonatomic,assign) CGFloat lineSapce;    //行间距
@property (nonatomic,assign) CGFloat keyBoardHeigh;    //键盘高度
@property (nonatomic,assign) CGFloat GDkeyBoardHeigh;    //固定键盘高度
@property (nonatomic,copy) NSMutableArray *heightOfAudioArray;    //录音高度记录用于删除使用
@property (nonatomic,copy) NSMutableArray *AudioArray;    //用于存储录音控件便于删除
@property (nonatomic,strong) audioImage *audioimage;//录音控件
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger audioImageTag;//录音控件
@property (nonatomic,strong) videoView *videoView;//录音控件
@property (nonatomic,strong) EditOfGroups *editOfGroups;//当前分组View
@property (nonatomic,strong) UIView *audioView;//录音键盘
@property (nonatomic,assign) BOOL isAudioKeyOnTop;    //是否录音键盘在最顶部的判断
@property (nonatomic, strong) NSMutableArray *weatherImageArray;//天气图片数组
@property (nonatomic, strong) NSMutableArray *weatherIconArray;//天气图标名称按钮
@property (nonatomic,assign) NSInteger deleteAction;//记录删除动作
@property (nonatomic,assign) long groupRow;//分组第几行

@property (nonatomic,assign) NSInteger groupdiaryNum;//分组有几篇文章
@property (nonatomic,strong) groupModel *groupModel;//分组模型
@property (nonatomic,strong) editDiaryModel *editModel;//分组模型
@property (nonatomic,assign) BOOL isTapToGroupPage;//分组是否点击事件

@property (nonatomic,assign) NSInteger weatherType;//天气类型
@property (nonatomic,assign) BOOL weatherSelct;//天气类型

@property (strong, nonatomic) NSMutableAttributedString * context;//存储图文信息
@property(strong ,nonatomic) functionKeyView *functionView;//底部功能键View
@property (nonatomic, strong) AVAudioRecorder *recorder;




@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CALayer *scrapLayer;
@property (nonatomic, strong) CALayer *scrapLayer1;
@property (nonatomic, strong) CALayer *bucketContainerLayer;
@property (nonatomic, strong) GLBucket *bucket;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CGFloat baseviewYOrigin;
@property (nonatomic, assign) CGFloat bucketContainerLayerActualYPos;

@end

@implementation RichTextViewController
{
    NSURL *mp4Url;
    UIView *nnview;
    AVPlayer *righrPlayer;
    AVPlayerLayer *rightPlayerLayer;
    AVPlayerItem *rightPlayerItem;
    BOOL haveVideoInfo;
    BOOL haveAudioInfo;
    BOOL havePictureInfo;
    BOOL haveWeatherInfo;
    NSString *groupTitle;//分组title
    NSInteger videoTag;//视频控件tag
    NSMutableArray *audioHeightLocation;//音频控件位置
    NSMutableArray *videoHeightLocation;//视频控件位置
    
    NSMutableArray *videoDataArray;//视频数组
    BOOL openOrNot;//是否公开
    UILabel  *secondText;//剩余说话时间
    UIButton *cancelBtnLeft;
    UIButton *cancelBtnRight;
    NSInteger pictureLocation;//图片位置
    BOOL havePicture;//是否有图片插入
    UILabel *_saySomething;
    UILabel *_timeLabel;
    Waver *_leftWave;
    Waver *_rightLeft;
    
    CGRect CGFrome;
    
    BOOL _isCancel;
    NSTimer *time;
    RadiaViewLayer *animationlayer;

}
//+(instancetype)ViewController
//{
//    RichTextViewController * ctrl=[[UIStoryboard storyboardWithName:@"RichText" bundle:nil]instantiateViewControllerWithIdentifier:@"RichTextViewController"];
//    
//    return ctrl;
//}

-(void)CommomInit
{

    self.font=DefaultFont;
    self.fontColor=[UIColor blackColor];
    self.location=0;
    self.isBold=NO;
    self.lineSapce=5;
    [self setInitLocation];
}
- (void)viewWillAppear:(BOOL)animated{
    
   

}
-(void)viewDidAppear:(BOOL)animated{
 
}


#pragma mark  分组列表部分
//当前分组列表View
-(void)setEditOfGroups{
    _editOfGroups = [[EditOfGroups alloc] initWithFrame:CGRectMake(0, KTopHeight, ScreenWidth, 35)];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGroupTap:)];
    [_editOfGroups addGestureRecognizer:ges];
    [self.view addSubview:_editOfGroups];
    if (_NewDiary) {
        if (_groupTitle.length>0) {
            _editOfGroups.groupLabel.text  = _groupTitle;
        }else{
            NSLog(@"默认的日记分类");
        }
    }else{
    _editOfGroups.groupLabel.text = _editDiary.atGroupTitle;
    }
    
   // [self addDataToDB];
   
    
    
}


-(void)editGroupTap:(UITapGestureRecognizer*)gap{
    
    _isTapToGroupPage = YES;
    _groupModel = [[groupModel alloc] init];
    GroupListViewController *list = [[GroupListViewController alloc] init];
    if (_NewDiary) {
        if (_groupTitle.length>0) {
            list.selectedIndexPath = [NSIndexPath indexPathForRow:_atGroup inSection:0];
        }else{
            list.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        }
        
    }else{
         list.selectedIndexPath = [NSIndexPath indexPathForRow:_editDiary.atGroup inSection:0];
    }
    
    [list   returnText:^(groupModel *model) {
        _editOfGroups.groupLabel.text = model.title;
        _groupRow = model.groupId;
        groupTitle = model.title;
        _groupdiaryNum = model.diaryNum;
    }];
    [self.navigationController pushViewController:list animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set animation duration
    self.duration = 0.6;
    
    // configure zindex of each and every layers/views
    self.button.layer.zPosition = 99;
    self.bucketContainerLayer.zPosition = 98;
    self.scrapLayer.zPosition = 97;
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _groupRow = 0;
    groupTitle = @"我的日记";
    openOrNot = YES;
    _weatherType = 8;
    pictureLocation = 0;
    _isTapToGroupPage = NO;
     [self setEditOfGroups];//添加日记分组view
    [self.view addSubview:self.textView];//设置日记书写区域
    [self.view addSubview:self.functionView];
    _GDkeyBoardHeigh = 2;//给键盘高度一个随意小的初始值
    _deleteAction = 0;
   
    _willhiddleKeyBoard = YES;
    [self setBackWithText:@"取消"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];;
    //Init text font
    //可变数组初始化
    _heightOfAudioArray = [[NSMutableArray alloc] init];
    _AudioArray = [[NSMutableArray alloc] init];
    _dataArray  = [NSMutableArray arrayWithCapacity:0];
    videoDataArray  = [NSMutableArray arrayWithCapacity:0];
    audioHeightLocation =[[NSMutableArray alloc] init];
    _audioImageTag = 0;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [self CommomInit];//设置textView中的字体样式等
    
    
    
    UIControl *control = [[UIControl alloc] initWithFrame:_textView.bounds];
    [control addTarget:self action:@selector(inputViewTapHandle) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:control];
    
   
    
    //Add keyboard notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];

//    
    
    //注册通知,监听键盘出现
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidShow:)
                                                name:UIKeyboardDidShowNotification
                                              object:nil];
    //注册通知，监听键盘消失事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleKeyboardDidHidden)
                                                name:UIKeyboardDidHideNotification
                                              object:nil];
    
    [[NSNotificationCenter
      defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:)
     name:UIKeyboardWillChangeFrameNotification object:nil];//在这里注册通知
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(moviePlayDidEnd)
     
                                                name:AVPlayerItemDidPlayToEndTimeNotification
     
                                            object:rightPlayerItem];
    
    
    
    [self initGroupData];
    //再次编辑进来后渲染上次编辑保存时的状态
    if (_NewDiary) {
    }else{
        [self putDiaryOnThePage];
    }
   
    
   
}


-(void)putDiaryOnThePage{
    NSAttributedString *temp = [[NSAttributedString alloc] initWithData:_diaryData options:@{NSDocumentTypeDocumentAttribute : NSRTFDTextDocumentType} documentAttributes:nil error:nil];     //读取

    
    _functionView.openOrNotButton.on = _editDiary.openOrNo;
    [_functionView setweatherIconPicture: _editDiary.weatherType];
    if (_editDiary.havePictureInfo) {
        havePicture = YES;
        pictureLocation = _editDiary.pictureLocation;
    }
    
    [_textView setAttributedText:temp];
    
    [self putAudioAndVideoOnPage];//放置好audio和video后将数组状态还原，用于保存。
    
}

-(void)putAudioAndVideoOnPage{
    NSArray *audioArray = (NSArray *)_editDiary.audioDataModel;
    if (audioArray.count>0) {
        for (audioModel *model in audioArray) {
            [self putAudioViewAndBackImage:model];//放置语音控件的位置。
        }
    }
    
    
     NSArray *video = (NSArray *)_editDiary.videoDataModel;
    if (video.count>0) {
        for (videoModel *model in video) {
            [self putVideoAndBackImage:model];
        }
    }
    
    

}
-(void)initGroupData{
    RLMResults* tempArray = [groupModel allObjects];
    if (tempArray.count == 0) {
        //数据库操作对象
        RLMRealm *realm = [RLMRealm defaultRealm];
        //打开数据库事务
        [realm transactionWithBlock:^(){
            groupModel *model = [[groupModel alloc] init];
            model.title = @"我的日记";
            model.groupId = 0;
            //添加到数据库
            [realm addObject:model];
            //提交事务
            [realm commitWriteTransaction];
        }];
    }
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_editOfGroups.frame), ScreenWidth, ScreenHeight - KTopHeight - 112)];
        _textView.delegate = self;
        _textView.editable = YES;
        _textView.scrollEnabled = YES;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
         self.textView.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 5);//设置页边距
    }
    return _textView;
}

#pragma mark   functionView 初始化及代理事件
-(functionKeyView *)functionView{
    if (!_functionView) {
        _functionView = [[functionKeyView alloc] initWithFrame:CGRectMake(0,ScreenHeight-72, ScreenHeight, 72)];
        _functionView.delegate = self;
    }
    return _functionView;
}

-(void)sendswitchAction:(id)sender{
    [self switchAction:sender];
}
-(void)sendFunctionClick:(id)sender{
    UIButton *button = sender;
    switch (button.tag) {
        case 0:
            [self keyboardClick];
            break;
        case 1:
            [self colorClick:sender];
            break;
        case 2:
            [self videoClick:sender];
            break;
        case 3:
            [self pictureClick:sender];
            break;
        case 4:
            [self imageClick:sender];
            break;
        case 5:
            [self weatherChose:sender];
            break;
            
            
        default:
            break;
    }

}

#pragma mark 键盘监听事件


#pragma mark - 监听方法
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            _functionView.y = self.view.height - _functionView.height;//这里的<span style="background-color: rgb(240, 240, 240);">self.toolbar就是我的输入框。</span>
            
        } else {
            _functionView.y = keyboardF.origin.y - _functionView.height;
        }
    }];
}

//键盘即将隐藏
- (void)onKeyboardWillHideNotification:(NSNotification *)notification {
    _willhiddleKeyBoard = YES;
    _bottomConstraint.constant = -80;
    [UIView animateWithDuration:3.0f animations:^{
        [self.view layoutIfNeeded];
    }];
}



////监听事件键盘显示
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    [UIView animateWithDuration:0.9 animations:^{
        self.textView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height+70, 0);
    }];
    

    _keyBoardHeigh = keyboardRect.size.height;
    if (_GDkeyBoardHeigh<_keyBoardHeigh+70) {
        _GDkeyBoardHeigh = _keyBoardHeigh;
    }else{
        _keyBoardHeigh = _GDkeyBoardHeigh;
    }
}
//键盘隐藏
- (void)handleKeyboardDidHidden
{
    [UIView animateWithDuration:0.5 animations:^{
        _textView.contentInset=UIEdgeInsetsZero;
    }];
  }
//当键盘即将出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[aNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    
    self.textView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height+70, 0);
    
//    _willhiddleKeyBoard = NO;
//   
//    //获取键盘的高度
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//     _keyBoardHeigh = keyboardRect.size.height;
//      _bottomConstraint.constant = _keyBoardHeigh;
//    
//    CGFloat upHeight = _upkeyboardView.frame.size.height;
//    _upkeyboardView.frame = CGRectMake(0, ScreenHeight - upHeight-_keyBoardHeigh, ScreenWidth, upHeight);
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)resetTextStyle {
//    //After changing text selection, should reset style.
//    [self CommomInit];
//    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
//    
//    
//    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
//    [_textView.textStorage removeAttribute:NSForegroundColorAttributeName range:wholeRange];
//    
//    //字体颜色
//    [_textView.textStorage addAttribute:NSForegroundColorAttributeName value:self.fontColor range:wholeRange];
//    
//    //字体加粗
//    if (self.isBold) {
//        [_textView.textStorage addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.font] range:wholeRange];
//    }
//    //字体大小
//    else
//    {
//        
//        [_textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.font] range:wholeRange];
//    }
//    
//    
//    
//}
-(void)setInitLocation
{
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    //重新设置位置
    self.location=_textView.textStorage.length;
    
}
-(void)setStyle
{
    //每次后拼装
    if (_textView.textStorage.length<self.location) {
        [self setInitLocation];
        return;
    }
    NSString * str=[_textView.text substringFromIndex:self.location];
    
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = self.lineSapce;// 字体的行间距
    NSDictionary *attributes=nil;
    if (self.isBold) {
        attributes = @{
                       NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font],
                       NSForegroundColorAttributeName:self.fontColor,
                       NSParagraphStyleAttributeName:paragraphStyle
                       };
        
    }
    else
    {
        attributes = @{
                       NSFontAttributeName:[UIFont systemFontOfSize:self.font],
                       NSForegroundColorAttributeName:self.fontColor,
                       NSParagraphStyleAttributeName:paragraphStyle
                       };
        
    }
    
    NSAttributedString * appendStr=[[NSAttributedString alloc] initWithString:str attributes:attributes];
    [self.locationStr appendAttributedString:appendStr];
    _textView.attributedText =self.locationStr;
    
    //重新设置位置
    self.location=_textView.textStorage.length;
}
#pragma mark  右侧保存按钮点击事件
-(void)rightButtonClick{
    NSLog(@"保存事件");
    [self dataStore];//数据保存数据库
    [self updataToServer];
    [self showToastWithString:@"保存成功"];
    [self.navigationController popViewControllerAnimated:YES];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//         [self dataStore];//数据保存数据库
//         [self updataToServer];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self showToastWithString:@"保存成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//        });
//    });
    
}

//数据修改及保存
-(void)dataStore{
    NSString *diaryText = _textView.text;
    NSString *title;
    if (diaryText.length>20) {
        title = [diaryText substringToIndex:20];
    }else{
        title = diaryText;
    }
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *nowtimeStr = [formatter stringFromDate:currentDate];
    NSString *time = [[nowtimeStr substringFromIndex:11] substringToIndex:5];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentDate];
    NSInteger years=[components year];
    NSInteger month=[components month];
    NSInteger day=[components day];
    
    NSString *year = [NSString stringWithFormat:@"%ld",(long)years];
    NSString *monthDay = [NSString stringWithFormat:@"%ld - %ld",(long)month,(long)day];
    
    
    
    _context = _textView.textStorage;
    NSData *data = [_context dataFromRange:NSMakeRange(0, _context.length) documentAttributes:@{NSDocumentTypeDocumentAttribute:NSRTFDTextDocumentType} error:nil];
    if (_NewDiary) {
           //将 NSAttributedString 转为NSData
        NSInteger  dId;
        RLMResults* tempArray = [[editDiaryModel allObjects] sortedResultsUsingKeyPath:@"diaryId" ascending:NO];
        if (tempArray.count == 0) {
            dId = 0;
        }else{
        editDiaryModel *model =   tempArray.firstObject;
        dId = model.diaryId+1;
        }
        //数据库操作对象
        RLMRealm *realm = [RLMRealm defaultRealm];
        //打开数据库事务
        [realm transactionWithBlock:^(){
            editDiaryModel *model = [[editDiaryModel alloc] init];
            model.title = title;
            model.year = year;
            model.monthAndDay = monthDay;
            model.time = time;
            model.supportNum = 22;
            model.diaryInfo = data;
            model.diaryId = dId;
            if (_weatherType == 8) {
             
                model.haveWeatherInfo = NO;
            }else{
               model.haveWeatherInfo = YES;
            }
            model.weatherType = _weatherType;
            model.pictureLocation = pictureLocation;
            
            model.havePictureInfo = havePicture;
            model.openOrNo = openOrNot;
            if (_weatherSelct) {
                model.weatherType = _weatherType;
            }else{
             model.weatherType = 8;
            }
            //新的增加属于哪个组
           
            if (_isTapToGroupPage) {
                 model.atGroupTitle = groupTitle;
                 model.atGroup = _groupRow;
            }else{
                model.atGroupTitle = @"我的日记";
            }
            for (videoModel *video in videoDataArray) {
                [model.videoDataModel addObject:video];
                model.haveVideoInfo = YES;
               
            }
            
            for (audioModel *audiomodel in _dataArray) {
                [model.audioDataModel addObject:audiomodel];
                model.haveAudioInfo = YES;
            }
        
            
            //添加到数据库
            [realm addObject:model];
            //提交事务
            [realm commitWriteTransaction];
            _editModel = model;//为数据上传服务器做准备；
        }];
        
        
        //分组model上的groupNum加一
        [self addGroupModelNum];
        
        
    }else{
        RLMResults<editDiaryModel *> *model1 = [editDiaryModel   objectsWhere:@"diaryId == %@",@(_diaryId)];
        long weatherty = 0;
        long groupAtRow = 0;
        for (editDiaryModel *modelaa in model1) {
            weatherty = modelaa.weatherType;
            groupAtRow = modelaa.atGroup;
        }
        

        RLMRealm *realm = [RLMRealm defaultRealm];
 
        editDiaryModel *model = [[editDiaryModel alloc] init];
        model.title = title;
        model.year = year;
        model.monthAndDay = monthDay;
        model.time = time;
        model.supportNum = 22;
        model.havePictureInfo = havePicture;
        model.diaryInfo = data;
        model.diaryId = _diaryId;
        model.openOrNo = openOrNot;
        model.pictureLocation = pictureLocation;
        //对日记所在的分组进行记录
        if (_isTapToGroupPage) {
            model.atGroup = _groupRow;
            model.atGroupTitle = groupTitle;
        }else{
            model.atGroup = _atGroup;
            model.atGroupTitle = _groupTitle;
        }
      
        if (_weatherSelct) {
            model.weatherType = _weatherType;
        }else{
            model.weatherType = 8;
        }
        if (_weatherSelct) {
           model.weatherType = _weatherType;
        }else{
           model.weatherType =  weatherty;
        }
        for (videoModel *video in videoDataArray) {
            [model.videoDataModel addObject:video];
            model.haveVideoInfo = YES;
        }
        for (audioModel *audiomodel in _dataArray) {
            [model.audioDataModel addObject:audiomodel];
            model.haveAudioInfo = YES;
        }
    
        // 通过 id = 1 更新该书籍
        [realm beginWriteTransaction];
        [editDiaryModel createOrUpdateInRealm:realm withValue:model];
        [realm commitWriteTransaction];
        _editModel = model;//为数据上传服务器做准备；
       //若分组更改，对原分组的groupNum减一，新的分组groupNum➕1
        [self changeGroup];
    }
    
}

-(void)addGroupModelNum{
    RLMRealm *realm = [RLMRealm defaultRealm];
    groupModel *model = [[groupModel alloc] init];
    model.groupId = _groupRow;
    model.title = groupTitle;
    
    if (_groupRow == 0) {
        RLMResults<groupModel *> *model1 = [groupModel   objectsWhere:@"groupId == %@",@(_groupRow)];
        for (groupModel *modelaa in model1) {
           model.diaryNum = modelaa.diaryNum+1;
        }
        
    }else{
        model.diaryNum = _groupdiaryNum+1;
    }
    
    // 通过 id = 1 更新该书籍
    [realm beginWriteTransaction];
    [groupModel createOrUpdateInRealm:realm withValue:model];
    [realm commitWriteTransaction];
}

-(void)changeGroup{
    
    if (!_isTapToGroupPage) {
        NSLog(@"donoting");
    }else{
    if (_atGroup ==_groupRow) {
        NSLog(@"do nothing");
    }
    else
    {//分组的title变更了  ，需要修改
        RLMRealm *realm = [RLMRealm defaultRealm];
        groupModel *model = [[groupModel alloc] init];
        
        model.groupId = _groupRow;
        model.title = groupTitle;
        model.diaryNum = _groupdiaryNum+1;
        // 通过 id = 1 更新该书籍
        [realm beginWriteTransaction];
        [groupModel createOrUpdateInRealm:realm withValue:model];
        [realm commitWriteTransaction];
        
        
        NSString *title;
        RLMResults<groupModel *> *groupM = [groupModel   objectsWhere:@"groupId == %@",@(_atGroup)];
        for (groupModel *modelaa in groupM) {
            title = modelaa.title;
        }
        
        groupModel *model1 = [[groupModel alloc] init];
        
        model1.groupId = _atGroup;
        model1.title = title;
        if (_groupdiaryNum == 0) {
            model1.diaryNum = 0;
        }else{
            model1.diaryNum = _groupdiaryNum-1;
        }
        // 通过 id = 1 更新该书籍
        [realm beginWriteTransaction];
        [groupModel createOrUpdateInRealm:realm withValue:model1];
        [realm commitWriteTransaction];
    }
    }

}


-(void)updataToServer{
    
    NSLog(@"%@",_editModel);
    AFHTTPSessionManager *manage1 = [AFHTTPSessionManager manager];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"nihao" forKey:@"key"];
    [manage1 POST:@"http://202.121.66.52:8010/" parameters:_editModel success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"成功");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
//
//    
//    
//    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
//    [manage POST:@"ni" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //上传文件参数
//        UIImage *iamge = [UIImage imageNamed:@"123.png"];
//        NSData *data = UIImagePNGRepresentation(iamge);
//        //这个就是参数
//        [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
//
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        
//    }];
//    NSDictionary *modelString = _editModel.mj_keyValues;
//    NSLog(@"%@",modelString);
}
#pragma mark 滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

#pragma mark textViewDelegate
/**
 *  点击图片触发代理事件
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    NSLog(@"%@", textAttachment);
    return YES;
}


/**
 *  点击链接，触发代理事件
 */
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    [[UIApplication sharedApplication] openURL:URL];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //    textview 改变字体的行间距
    
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    for(UIView *imageView in [_textView subviews])//删除多余的UIImageView
    {
        if ([imageView isKindOfClass:[UIImageView class]]) {
            [imageView removeFromSuperview];
        }
    }
    
    if([text length] != 0) //点击了非删除键
    {
    }
    else
    {
        NSInteger nowLocation =  _textView.selectedRange.location;
        if (nowLocation<=pictureLocation) {
            havePicture = NO;
        }
        if (_heightOfAudioArray.count == 0) {//这里修改
            NSLog(@"子控件删除完");
        }else{
 
       
        //用户数据删除中
        NSInteger viewTag = [_heightOfAudioArray.lastObject integerValue];
        if (viewTag >= nowLocation) {
            if (viewTag == videoTag) {
                [_videoView removeFromSuperview];
                [_heightOfAudioArray removeLastObject];
                [videoDataArray removeLastObject];
            }else{
                if (_NewDiary) {
                [_textView.subviews.lastObject removeFromSuperview];
                }else{
                     
                    
                    [_textView.subviews.lastObject removeFromSuperview];
                }
           
            [_dataArray removeLastObject];
            [_heightOfAudioArray removeLastObject];
            _audioImageTag  = _audioImageTag -1;
            [audioHeightLocation removeLastObject];
        
            }
        }
        }
        
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
 
    
 
    
    bool isChinese;//判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *textInputMode = [currentar firstObject];
    if ([[textInputMode primaryLanguage] isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    NSString *str = [[ self.textView text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [ self.textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [ self.textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
 
            
            [self setStyle];
 
     
            if ( str.length>=MaxLength) {
                NSString *strNew = [NSString stringWithString:str];
                [ self.textView setText:[strNew substringToIndex:MaxLength]];
            }
        }
        else
        {
            NSLog(@"输入的英文还没有转化为汉字的状态");
            if ([str length]>=MaxLength+10) {
                NSString *strNew = [NSString stringWithString:str];
                [ self.textView setText:[strNew substringToIndex:MaxLength+10]];
            }
            
        }
    }else{
 
        [self setStyle];
 
        if ([str length]>=MaxLength) {
            NSString *strNew = [NSString stringWithString:str];
            [ self.textView setText:[strNew substringToIndex:MaxLength]];
        }
    }
    
    
}




- (void)textViewDidBeginEditing:(UITextView *)textView{
 
    [_textView becomeFirstResponder];
//    _upkeyboardView.hidden = NO;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
   // [_textView endEditing:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesbegan:withevent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    
}




#pragma mark - Action
//完成
- (IBAction)finishClick:(UIButton *)sender {
     if (self.finished!=nil) {
        self.finished([_textView.attributedText getArrayWithAttributed]);
    }
}
- (void)keyboardClick {
    if ([_textView isFirstResponder]) {
        if (!_isAudioKeyOnTop) {
            [_textView resignFirstResponder];
                }else{
                        [_textView becomeFirstResponder];
                        _textView.inputView = nil;
                        _isAudioKeyOnTop = NO;
                        [_textView reloadInputViews];
                    }
        
    }else{
        [_textView becomeFirstResponder];
    }
}
#pragma mark - 选择天气模块
// 数据准备
-(void)initData{
    _weatherImageArray = [[NSMutableArray alloc] initWithObjects:@"Eqingtian",@"Eduoyun",@"Efeng",@"Exiaoyu",@"Edayu",@"Eshandian",@"Exue",@"Ewumai", nil];
    _weatherIconArray = [[NSMutableArray alloc] initWithObjects:@"晴天",@"多云",@"刮风",@"小雨",@"大雨",@"闪电",@"下雪",@"雾霾", nil];
}

- (CGSize)itemSize
{
    CGFloat itemWidth = (CGRectGetWidth(self.view.frame)) / 4;
    CGFloat itemHeight = _keyBoardHeigh*0.3;
    return CGSizeMake(itemWidth, itemHeight);
}
- (void)weatherChose:(id)sender {
    
    [_textView becomeFirstResponder];
    _weatherSelct = NO;
    [self initData];
    CGSize size = [self itemSize];
    NSInteger row, col;
    NSInteger count = _weatherIconArray.count;
    _weatherKeyBoard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _keyBoardHeigh*0.7 )];
    _weatherKeyBoard.backgroundColor = [UIColor whiteColor];
    [_weatherKeyBoard addSubview:[self drawThreadWithFram:CGRectMake(0, 5, ScreenWidth, 0.5) andColor:[UIColor colorWithHexString:@"e7e7e7"]]];
    UIView *weatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 6, ScreenWidth, _weatherKeyBoard.frame.size.height)];
    [_weatherKeyBoard addSubview:weatherView];
 
    for(NSInteger i = 0; i < count; i++) {
        row = i / 4;
        col = i % 4;
        ItemView *itemView = [[ItemView alloc] initWithFrame:CGRectMake(col * size.width,   row * size.height, size.width, size.height)];
//        [itemView setBackgroundColor:[UIColor yellowColor]];
        [itemView setTitle:_weatherIconArray[i] imageName:_weatherImageArray[i]];
        itemView.tag = i;
        [weatherView addSubview:itemView];
        [itemView addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
     _isAudioKeyOnTop = YES;
    self.textView.inputView = _weatherKeyBoard;
    
    [self.textView reloadInputViews];
  }


-(void)itemClicked:(UIButton *)button{
    NSLog(@"%ld",(long)button.tag);
    _weatherSelct = YES;
    _weatherType = button.tag;//将天气类型传过去
  NSMutableArray  *weatherImageselect = [[NSMutableArray alloc] initWithObjects:@"qingtian",@"tianqi",@"feng",@"xiaoyu",@"dayu",@"lei",@"xue",@"wu", nil];
    NSString *picture = weatherImageselect[button.tag];
 
    [_functionView.weatherBT setImage:[UIImage imageNamed:picture] forState:UIControlStateNormal];
 
    [_textView becomeFirstResponder];
    _textView.inputView = nil;
    [_textView reloadInputViews];
    [UIView animateWithDuration:0.5 animations:^{
    }];
 
}
//录音
- (IBAction)colorClick:(UIButton *)sender {
    if (_dataArray.count == 3) {
        NSLog(@"不能再添加语音");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"这是一篇日记，请不要用录音偷懒哦！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"已阅" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_textView becomeFirstResponder];
            _textView.inputView = nil;
            _isAudioKeyOnTop = NO;
            [_textView reloadInputViews];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:^{
        }];
     
    }
    [_textView becomeFirstResponder];
 
    _audioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _keyBoardHeigh*0.7)];
    [_audioView setBackgroundColor:[UIColor whiteColor]];
     [_audioView addSubview:[self drawThreadWithFram:CGRectMake(0, 5, ScreenWidth, 0.5) andColor:[UIColor colorWithHexString:@"e7e7e7"]]];
    //按住说话
    _saySomething = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, ScreenWidth, 20)];
    _saySomething.contentMode = UIViewContentModeCenter;
    _saySomething.textAlignment  = NSTextAlignmentCenter;
    [_saySomething setText:@"按住说话"];
    _saySomething.font = [UIFont systemFontOfSize:14.0];
    [_saySomething setTextColor:[UIColor grayColor]];
    [_audioView addSubview:_saySomething];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    _timeLabel.contentMode = UIViewContentModeCenter;
    _timeLabel.textAlignment  = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:12.0];
    [_timeLabel setTextColor:[UIColor grayColor]];
    _timeLabel.hidden = YES;
    [_audioView addSubview:_timeLabel];

    CGFrome=self.view.bounds;
    
    //按住说话
    secondText = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_timeLabel.frame), ScreenWidth, 20)];

    secondText.contentMode = UIViewContentModeCenter;
    secondText.textAlignment  = NSTextAlignmentCenter;
    [secondText setText:@"左右滑动取消"];
    secondText.hidden = YES;
    secondText.font = [UIFont systemFontOfSize:12.0];

    [secondText setTextColor:[UIColor grayColor]];
    [_audioView addSubview:secondText];
    
    //录音icon
    _audioButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-48, CGRectGetMaxY(_timeLabel.frame)+20, 96, 96)];

    _audioImageKeyBoard.backgroundColor = [UIColor clearColor];
    //[audioView addSubview:_audioImage];
    
    //录音icon添加点击事件
    _audioButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-48, CGRectGetMaxY(_timeLabel.frame)+20, 96, 96)];
    _audioButton.center = _audioView.center;
    _audioButton.centerY = _audioView.centerY+20;
    [_audioButton setBackgroundImage:[UIImage imageNamed:@"luyinicon"] forState:UIControlStateNormal];
    [_audioButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [_audioButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_audioButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [_audioButton addTarget:self action:@selector(mayCancelRecord:forEvent:) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchDragOutside ];
    [_audioButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    [_audioView addSubview:_audioButton];
    
    CGRect rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 200, 40) withRect:_audioView.frame];
    self.baseviewYOrigin = rect.origin.y + 100;
    

    // scrap layer
    UIImage *img = [UIImage imageNamed:@"MicRecBtn"];
    rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, img.size.width, img.size.height) withRect:_audioView.frame];
    rect.origin.y = self.baseviewYOrigin - CGRectGetHeight(rect) - kScrapYOffsetFromBase;
    rect.origin.x = 50;
    self.scrapLayer = [CALayer layer];
    self.scrapLayer.frame = rect;
    self.scrapLayer.bounds = rect;
    self.scrapLayer.hidden = YES;
    [self.scrapLayer setContents:(id)img.CGImage];
    [_audioView.layer addSublayer:self.scrapLayer];
    
    
    // trash layer
        rect.origin.y = self.baseviewYOrigin;
    self.bucketContainerLayer = [CALayer layer];
    self.bucketContainerLayer.frame = rect;
    self.bucketContainerLayer.bounds = rect;
    self.bucketContainerLayer.hidden = YES;
    [_audioView.layer addSublayer:self.bucketContainerLayer];
    
    
    // bucket layer
    CGRect centeredRect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 22, 20 + 12) withRect:rect]; //image size(20x32)
    centeredRect.origin.x = CGRectGetMinX(rect) + CGRectGetMinX(centeredRect);
    centeredRect.origin.y = CGRectGetMinY(rect);
    
    self.bucket = [[GLBucket alloc] initWithFrame:centeredRect inLayer:self.bucketContainerLayer];
    self.bucket.bucketStyle = BucketStyle2OpenFromRight;
    
    
    // set bucket-container-layer actual y origin
    self.bucketContainerLayerActualYPos = self.baseviewYOrigin - (self.bucket.actualHeight / 2) - kScrapYOffsetFromBase; //divide by 2 considering center from y-axis
    
    
  
    
    self.textView.inputView = _audioView;
    _isAudioKeyOnTop = YES;
    [self.textView reloadInputViews];
 
}


-(void)clickAnimation{
    
    
    
    //对封装的动画初始化
    animationlayer = [RadiaViewLayer layer];
    //设置动画的位置(根据需要自己修改)
    animationlayer.position = _audioButton.center ;
    //将动画添加到显示动画的视图的layer层上
    [_audioView.layer insertSublayer:animationlayer below:_audioButton.layer];
    
    
}


- (CGRect)CGRectIntegralCenteredInRect:(CGRect)innerRect withRect:(CGRect)outerRect
{
    CGFloat originX = floorf((outerRect.size.width - innerRect.size.width) * 0.5f);
    CGFloat originY = floorf((outerRect.size.height - innerRect.size.height) * 0.5f);
    CGRect bounds = CGRectMake(originX, originY, innerRect.size.width, innerRect.size.height);
    return bounds;
}

-(void)show{
    
    [self clickAnimation];
 }

-(void)hide{
    [animationlayer removeFromSuperlayer];

}
- (void)notificationEnterFoground
{
    [_centerRadarView setNeedsDisplay];
    _centerRadarView.lineColor = [UIColor whiteColor];
    _centerRadarView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
    _isCancel = YES;
    cancelBtnLeft.hidden = YES;
    cancelBtnRight.hidden = YES;
    _saySomething.hidden = YES;
    _timeLabel.hidden = NO;
    secondText.hidden = NO;

    NSArray*array = [NSArray arrayWithObjects:@"左右滑动取消",@"请控制在60s内", nil];
    secondText.text = array[(int)(arc4random() % (2))];
    if (_dataArray.count == 3) {
        NSLog(@"不能再添加语音");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"这是一篇日记，请不要用录音偷懒哦！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"已阅" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_textView becomeFirstResponder];
            _textView.inputView = nil;
            _isAudioKeyOnTop = NO;
            [_textView reloadInputViews];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    }
    [self show];
    
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //		//停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //		//开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self.view recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopSendVodio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    [self hide];
    _timeLabel.hidden = YES;
    _saySomething.hidden = NO;
    secondText.hidden = YES;

    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 61) {
        [self sendSound];
        [[LGSoundRecorder shareInstance] stopSoundRecord:self.view];
    }
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)mayCancelRecord:(UIButton *)btn forEvent:(UIEvent *)event
{
    
    UITouch *touch = [[event touchesForView:btn] anyObject];
    CGPoint curPoint = [touch locationInView:_audioView];
  
    
    if (curPoint.x>0.75*ScreenWidth) {
      
          NSLog(@"=======%f======",curPoint.x);
        CGRect rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 13 - 5, 20 - 5) withRect:_audioView.frame];
        rect.origin.y = self.baseviewYOrigin - CGRectGetHeight(rect) - kScrapYOffsetFromBase;
        rect.origin.x = ScreenWidth - 50;
        self.scrapLayer.frame = rect;
        self.scrapLayer.bounds = rect;
        self.scrapLayer.hidden = NO;
        if (_isCancel) {
            [self scrapDriveUpAnimation];
        }
        [[LGSoundRecorder shareInstance] readyCancelSound];
        cancelBtnRight.hidden = NO;
        cancelBtnLeft.hidden = NO;
    }else if (curPoint.x<0.25*ScreenWidth){
          NSLog(@"=======%f======",curPoint.x);
        
        CGRect rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 13 - 5, 20 - 5) withRect:_audioView.frame];
        rect.origin.y = self.baseviewYOrigin - CGRectGetHeight(rect) - kScrapYOffsetFromBase;
        rect.origin.x = 50;
        self.scrapLayer.frame = rect;
        self.scrapLayer.bounds = rect;
        self.scrapLayer.hidden = NO;
        if (_isCancel) {
               [self scrapDriveUpAnimation];
        }
     
        [[LGSoundRecorder shareInstance] readyCancelSound];
        cancelBtnRight.hidden = NO;
        cancelBtnLeft.hidden = NO;
    }
    
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
   // [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    [self hide];
    _timeLabel.hidden = YES;
    _saySomething.hidden = NO;
    secondText.hidden = YES;

    [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.view];
}


- (void)sixtyTimeStopSendVodio {
    int countDown = 60 - [[LGSoundRecorder shareInstance] soundRecordTime];
    _timeLabel.text = [NSString stringWithFormat:@"%ds",(int)[[LGSoundRecorder shareInstance] soundRecordTime]];

    
    if (countDown <= 20) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown - 1];
              }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= 60 && [[LGSoundRecorder shareInstance] soundRecordTime] <= 61) {
        
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
    }
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

- (void)sendSound {
    NSArray*array = [NSArray arrayWithObjects:@"左右滑动取消",@"请控制在60s内", nil];
    secondText.text = array[(int)(arc4random() % (2))];
    audioModel *messageModel = [[audioModel alloc] init];
    messageModel.soundFilePath = [[LGSoundRecorder shareInstance] soundFilePath];
    messageModel.seconds = [[LGSoundRecorder shareInstance] soundRecordTime];
    
    //计算textView中现在的内容高度，用于设置语音控件的位置
    _textViewBounds = _textView.bounds;
    CGSize maxSize = CGSizeMake(_textViewBounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    _textViewBounds.size = newSize;
    //赋值语音模型数值
    NSInteger subViewLocation = _textView.selectedRange.location+1;
    messageModel.textLocation = subViewLocation;
     messageModel.textHeight =  _textViewBounds.size.height;
    //添加语音控件图片底层
    [self putAudioViewAndBackImage:messageModel];
    
    
    
    
}
-(void)putAudioViewAndBackImage:(audioModel *)model{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10,model.textHeight, ScreenWidth-20, 50)];
    view.alpha = 0.0;
    view.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view = nil;
    [self putAudioWithImage:viewImage];
    viewImage = nil;
    
    //添加录音控件
    _audioimage = [[audioImage alloc] initWithFrame:CGRectMake(10, model.textHeight+10, ScreenWidth-20, 30)];
    _audioimage.tag = _audioImageTag++;
    [_heightOfAudioArray addObject:@(model.textLocation)];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audiotap:)];
    [_audioimage addGestureRecognizer:ges];
    [_audioimage builderViewWithSceond:model.seconds];
    [_textView addSubview:_audioimage];
    [_AudioArray addObject:_audioimage];
    [self.dataArray addObject:model];
}
-(void)audiotap:(UITapGestureRecognizer*)gap{
    NSLog(@"%ld",gap.view.tag);
    NSInteger indexrow = gap.view.tag;//删除后卫队tag进行修改
    audioImage *audio = (audioImage*)gap.view;
    [audio audioTapEvent];
    
    audioModel *messageModel = [self.dataArray objectAtIndex:indexrow];
    [[LGAudioPlayer sharePlayer] playAudioWithURLString:messageModel.soundFilePath atIndex:indexrow];
    NSLog(@"手势识别时间");
}
- (void)inputViewTapHandle
{
    [_textView becomeFirstResponder];
    _textView.inputView = nil;
    _isAudioKeyOnTop = NO;
    [_textView reloadInputViews];
    
}
//选择图片
- (void)pictureClick:(UIButton *)sender {

    DPImagePickerVC *vc = [[DPImagePickerVC alloc]init];
    vc.delegate = self;
    vc.isDouble = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
//视频添加
- (void)videoClick:(UIButton *)sender {
    if (videoDataArray.count == 1) {
        NSLog(@"不能再添加语音");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"暂支持插入一段视频到日记文本中！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"已阅" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [_textView becomeFirstResponder];
            _textView.inputView = nil;
            _isAudioKeyOnTop = NO;
            [_textView reloadInputViews];
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
    [_textView endEditing:NO];
    
    
#if 0
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker.png";
    appearanceConfig.cellSpacing = 1.0f;
    appearanceConfig.assetsCountInALine = 5;
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    picker.maximumNumberOfSelectionVideo = 1;
    picker.maximumNumberOfSelectionPhoto = 0;
    [self presentViewController:picker animated:YES completion:^{
    }];
}

-(void)putVideoOnTextViewWithUrl:(NSURL *)url image:(NSString *)pictueImage{
   videoModel *videoM = [[videoModel alloc] init];
    videoM.url = [url absoluteString];
    videoM.image = pictueImage;
    
    //计算textView中现在的内容高度，用于设置语音控件的位置
    _textViewBounds = _textView.bounds;
    CGSize maxSize = CGSizeMake(_textViewBounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    _textViewBounds.size = newSize;
    videoM.textHeight =  _textViewBounds.size.height;
    NSInteger subViewLocation = _textView.selectedRange.location+1;
    videoM.textLocation = subViewLocation;
    
    [self putVideoAndBackImage:videoM];
    

}
-(void)putVideoAndBackImage:(videoModel*)model{
    //添加图片底层
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, model.textHeight, ScreenWidth-20, 300)];
    view.alpha = 0.0;
    view.backgroundColor = [UIColor redColor];
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view = nil;
    [self putVideoWithImage:viewImage];
    viewImage = nil;
    
    //添加视频控件videoTap
    _videoView = [[videoView alloc] initWithFrame:CGRectMake(15, model.textHeight+10, ScreenWidth-30, 280)];
    
    _videoView.url = [NSURL URLWithString:model.url];
    
    UIImage *getimage = [UIImage imageWithContentsOfFile:model.image];
    
    [_videoView builderWithImage:getimage];
    
    videoTag = model.textLocation;
    _videoView.tag = videoTag;
    [_heightOfAudioArray addObject:@(videoTag)];
    [_textView addSubview:_videoView];
    UITapGestureRecognizer *videoGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTap:)];
    [_videoView addGestureRecognizer:videoGes];
    [videoDataArray addObject:model];
}


-(void)videoTap:(UITapGestureRecognizer*)gap{
    
    [righrPlayer pause];
    rightPlayerItem  = nil;
    [rightPlayerLayer removeFromSuperlayer];

    
    AVAsset *rightAsset       = [AVAsset assetWithURL:_videoView.url];
    rightPlayerItem  = [AVPlayerItem playerItemWithAsset:rightAsset];
    righrPlayer      = [[AVPlayer alloc]init];
    [righrPlayer replaceCurrentItemWithPlayerItem: rightPlayerItem];
    rightPlayerLayer  = [AVPlayerLayer playerLayerWithPlayer:righrPlayer];
    rightPlayerLayer.frame      = _videoView.bounds;
    [_videoView.layer addSublayer:rightPlayerLayer];
    rightPlayerLayer.videoGravity = AVLayerVideoGravityResize;
    [righrPlayer play];
}

-(void)moviePlayDidEnd
{
    [rightPlayerLayer removeFromSuperlayer];
    
}


//选择图片
- (IBAction)imageClick:(UIButton *)sender {
    [self.view endEditing:NO];
    
#if TARGET_IPHONE_SIMULATOR
    //模拟器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请真机测试！" message:@"提醒" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:^{
    }];
#elif TARGET_OS_IPHONE
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:([UIColor colorWithRed:231.0/255.0 green:56.0/255.0 blue:32.0/255.0 alpha:1.0]),NSForegroundColorAttributeName, nil];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
#endif
    
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:^{
        //        [self.navigationController popViewControllerAnimated:YES];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
            [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)image.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
                if (error) {
                }else{
                    NSData *date = UIImageJPEGRepresentation(image, 1.0);
                    [self putPictureWithImage:[UIImage imageWithData:date]];
                    
                }
            }];
        }
    }];
}


#pragma mark -- 录音底层图片添加
-(void)putAudioWithImage:(UIImage *)image{
    
    
    UIImage  *image1;
    
    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    image1=[imageTextAttachment scaleImage:image withSize:CGSizeMake(ScreenWidth, 50)];
    //Set tag and image
//    imageTextAttachment.imageTag = ImageTag;
    imageTextAttachment.image =image1;
    
    //Set image size
    imageTextAttachment.imageSize = CGSizeMake(ScreenWidth, 50);
    
    //Insert image image
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                          atIndex:_textView.selectedRange.location];
    
  
    //Move selection location
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    
    //设置字的设置
    [self setInitLocation];
}

#pragma mark -- 视频底层图片添加
-(void)putVideoWithImage:(UIImage *)image{
    
    
    UIImage  *image1;
    
    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    image1=[imageTextAttachment scaleImage:image withSize:CGSizeMake(ScreenWidth, 320)];
    //Set tag and image
//    imageTextAttachment.imageTag = ImageTag;
    imageTextAttachment.image =image1;
    
    //Set image size
    imageTextAttachment.imageSize = CGSizeMake(ScreenWidth, 320);
    
    //Insert image image
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                          atIndex:_textView.selectedRange.location];

    //Move selection location
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);

    //设置字的设置
    [self setInitLocation];
}


#pragma mark -- DPImagePickerDelegate
- (void)getCutImage:(UIImage *)image{
    [self.navigationController popViewControllerAnimated:YES];
    [self putPictureWithImage:image];
   
}
-(void)putPictureWithImage:(UIImage *)image{
    
    UIImage  *image1 = [self compressImage:image toMaxFileSize:0.2];
    CGFloat bili = image1.size.height/image.size.width;
    
    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    
    image1=[imageTextAttachment scaleImage:image1 withSize:CGSizeMake(IMAGE_MAX_SIZE, IMAGE_MAX_SIZE*bili)];
    //Set tag and image
    imageTextAttachment.imageTag = ImageTag;
    imageTextAttachment.image =image1;
    //Set image size
    imageTextAttachment.imageSize = CGSizeMake(image1.size.width,  image1.size.width*bili);
    
    //Insert image image
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                          atIndex:_textView.selectedRange.location];
    //Move selection location
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    if (!havePicture) {
        havePicture = YES;
        pictureLocation = _textView.selectedRange.location;
    }
   
    
    //设置字的位置
    [self setInitLocation];
}



-(void)selectedImage
{
    
    NSUInteger sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}



-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"公开这篇日记");
        openOrNot = YES;
    }else {
        NSLog(@"不公开这篇日记");
        openOrNot = NO;
    }
}
#pragma mark - image picker delegte



- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RichTextPreviewVC * sub=[segue destinationViewController];
    if ([sub isKindOfClass:[RichTextPreviewVC class]]) {
        sub.content=self.textView.attributedText;
    }
}


#pragma mark --- 视频选择代理事件
#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    __weak typeof(self) weakSelf = self;
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            
            *stop = YES;
        }];
        
        
    }
    else //Video
    {
        ALAsset *alAsset = assets[0];
        
        UIImage *img = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
                                           scale:alAsset.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
        
        NSString *path_document = NSHomeDirectory();
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        
        [formatter setDateFormat:@"YYYYMMddHHmmss"];
        
        //现在时间,你可以输出来看下是什么格式
        
        NSDate *datenow = [NSDate date];
        
        //----------将nsdate按formatter格式转成nsstring
        
        NSString *nowtimeStr = [formatter stringFromDate:datenow];
        NSString *file = [NSString stringWithFormat:@"/Documents/%@",nowtimeStr];

        //设置一个图片的存储路径
        NSString *imagePath = [path_document stringByAppendingString:file];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(img) writeToFile:imagePath atomically:YES];
        
        
        ALAssetRepresentation *representation = alAsset.defaultRepresentation;
        AVAsset *avasset = [AVAsset assetWithURL:alAsset.defaultRepresentation.url];
        NSURL *movieURL = representation.url;
        mp4Url = movieURL;
      
        //在此处判断视频的大小，超出大小则提示用户视频过大，请重新选择
            [self putVideoOnTextViewWithUrl:movieURL image:imagePath];
        NSURL *uploadURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] stringByAppendingString:@".mp4"]];
        
        AVAsset *asset      = [AVURLAsset URLAssetWithURL:movieURL options:nil];
        AVAssetExportSession *session =
        [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        
        session.outputFileType  = AVFileTypeQuickTimeMovie;
        session.outputURL       = uploadURL;
        
        [session exportAsynchronouslyWithCompletionHandler:^{
            
            if (session.status == AVAssetExportSessionStatusCompleted)
            {
                DLog(@"output Video URL %@",uploadURL);
            }
            
        }];
        
    }
    
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedStringFromTable(@"Exceed Maximum Number Of Selection", @"UzysAssetsPickerController", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}




#pragma mark - Animation boilerplate

- (void)scrapDriveUpAnimation
{
    _isCancel = NO;
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:self.scrapLayer.position];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.scrapLayer.frame), CGRectGetMidY(self.scrapLayer.frame) - kScrapDriveUpAnimationHeight)];
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    NSArray* keyFrameValues = @[
                                @(0.0),
                                @(M_PI),
                                @(M_PI*1.5),
                                @(M_PI*2.0)
                                ];
    CAKeyframeAnimation* rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    [rotateAnimation setValues:keyFrameValues];
    [rotateAnimation setValueFunction:[CAValueFunction functionWithName: kCAValueFunctionRotateZ]];
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.delegate = self;
    [animGroup setValue:kScrapDriveUpAnimationName forKey:kAnimationNameKey];
    animGroup.animations = @[moveAnimation, rotateAnimation];
    animGroup.duration = self.duration;
    animGroup.removedOnCompletion = NO;
    animGroup.fillMode = kCAFillModeForwards;
    [self.scrapLayer addAnimation:animGroup forKey:nil];
}

- (void)scrapDriveDownAnimation
{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.delegate = self;
    [moveAnimation setValue:kScrapDriveDownAnimationName forKey:kAnimationNameKey];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.scrapLayer.position.x, self.scrapLayer.position.y - 5)];
    moveAnimation.duration = self.duration;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.scrapLayer addAnimation:moveAnimation forKey:nil];
}

- (void)bucketDriveUpAnimation
{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.delegate = self;
    [moveAnimation setValue:kBucketDriveUpAnimationName forKey:kAnimationNameKey];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:self.bucketContainerLayer.position];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.scrapLayer.frame), self.bucketContainerLayerActualYPos)];
    moveAnimation.duration = self.duration;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.bucketContainerLayer addAnimation:moveAnimation forKey:nil];
}

- (void)bucketDriveDownAnimation
{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.delegate = self;
    [moveAnimation setValue:kBucketDriveDownAnimationName forKey:kAnimationNameKey];
    moveAnimation.toValue = [NSValue valueWithCGPoint:self.bucketContainerLayer.position];
    moveAnimation.duration = self.duration;
    moveAnimation.removedOnCompletion = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.bucketContainerLayer addAnimation:moveAnimation forKey:nil];
}

#pragma mark - Animation Delegate methods

- (void)animationDidStart:(CAAnimation *)anim
{
    NSString *animationName = [anim valueForKey:kAnimationNameKey];
    if ([animationName isEqualToString:kScrapDriveDownAnimationName]) {
        [self bucketDriveUpAnimation];
        
    } else if ([animationName isEqualToString:kBucketDriveUpAnimationName]) {
        self.bucketContainerLayer.hidden = NO;
        [self.bucket performSelector:@selector(openBucket) withObject:nil afterDelay:self.duration * 0.3];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (flag) {
        NSString *animationName = [anim valueForKey:kAnimationNameKey];
        if ([animationName isEqualToString:kScrapDriveUpAnimationName]) {
            [self performSelector:@selector(scrapDriveDownAnimation) withObject:nil afterDelay:self.duration * 0.1];
            
        } else if ([animationName isEqualToString:kScrapDriveDownAnimationName]) {
            self.scrapLayer.hidden = YES;
            [self.bucket performSelector:@selector(closeBucket) withObject:nil afterDelay:self.duration * 0.1];
            [self performSelector:@selector(bucketDriveDownAnimation) withObject:nil afterDelay:self.duration * 1.0];
            
        } else if ([animationName isEqualToString:kBucketDriveDownAnimationName]) {
            self.bucketContainerLayer.hidden = YES;
            self.scrapLayer.hidden = YES;
            [self.button setTitle:@"Press me to kick off again!!" forState:UIControlStateNormal];
            [self.button setEnabled:YES];
        }
    }
}


@end
