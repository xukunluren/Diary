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
//Image default max size
#define IMAGE_MAX_SIZE ([UIScreen mainScreen].bounds.size.width-20)

#define ImageTag (@"[UIImageView]")
#define DefaultFont (16)
#define MaxLength (2000)

#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface RichTextViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,DPImagePickerDelegate,UzysAssetsPickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *upkeyboardView;
@property (weak, nonatomic)   UITextView *textView;

@property (nonatomic, weak) NSTimer *timerOf60Second;
@property (weak, nonatomic)   UISlider *imageSizeSlider;
@property (weak, nonatomic)  NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic)  UIImageView *imageV;

@property (strong, nonatomic)  DPImagePickerVC * Viewasd;
@property (strong, nonatomic)  UIImageView *audioImage;//录音键盘
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
@property (nonatomic,assign) NSInteger groupRow;//分组第几行

@property (strong, nonatomic) NSMutableAttributedString * context;//存储图文信息
@end

@implementation RichTextViewController
{
    NSURL *mp4Url;
    UIView *nnview;
    AVPlayer *righrPlayer;
    AVPlayerLayer *rightPlayerLayer;
    AVPlayerItem *rightPlayerItem;
    UIImageView *imagView;
    BOOL haveVideoInfo;
    BOOL haveAudioInfo;
    BOOL havePictureInfo;
    BOOL haveWeatherInfo;
}
+(instancetype)ViewController
{
    RichTextViewController * ctrl=[[UIStoryboard storyboardWithName:@"RichText" bundle:nil]instantiateViewControllerWithIdentifier:@"RichTextViewController"];
    
    return ctrl;
}

-(void)CommomInit
{
    self.textView.delegate=self;
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
//是否公开日记模块
-(void)setOpenOrNotView{
    UIView *openOrNot = [[UIView alloc] initWithFrame:CGRectMake(-1, 13, ScreenWidth+1, 30)];
    openOrNot.layer.borderWidth = 0.5;
    openOrNot.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_upkeyboardView addSubview:openOrNot];
    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 3, ScreenWidth*0.5-6, openOrNot.frame.size.height-6)];
    textlabel.text = @"公开这篇日记";
    [textlabel setFont:[UIFont boldSystemFontOfSize:10.0]];
    [textlabel setTextColor:[UIColor blackColor]];
    [openOrNot addSubview:textlabel];
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-50, 0,50,0 )];
     switchButton.transform = CGAffineTransformMakeScale(0.65, 0.55);
     switchButton.onTintColor = [UIColor colorWithHexString:@"12B7F5"];
    [switchButton setOn:YES];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [openOrNot addSubview:switchButton];
}

#pragma mark  分组列表部分
//当前分组列表View
-(void)setEditOfGroups{
    _editOfGroups = [[EditOfGroups alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editGroupTap:)];
    [_editOfGroups addGestureRecognizer:ges];
    [self.textView addSubview:_editOfGroups];
    
   // [self addDataToDB];
   
    
    
}


-(void)editGroupTap:(UITapGestureRecognizer*)gap{
    GroupListViewController *list = [[GroupListViewController alloc] init];
    list.selectedIndexPath = [NSIndexPath indexPathForRow:_groupRow inSection:0];
    [list   returnText:^(groupModel *model) {
        _editOfGroups.groupLabel.text = model.title;
        _groupRow = model.groupId;
    }];
    [self.navigationController pushViewController:list animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _groupRow = 0;
    if (_NewDiary) {
    }else{
        NSAttributedString *temp = [[NSAttributedString alloc] initWithData:_diaryData options:@{NSDocumentTypeDocumentAttribute : NSRTFDTextDocumentType} documentAttributes:nil error:nil];     //读取
        [_textView setAttributedText:temp];
    }
    _GDkeyBoardHeigh = 2;//给键盘高度一个随意小的初始值
    _deleteAction = 0;
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    [_textView scrollRangeToVisible:NSMakeRange(_textView.text.length, 1)];
    _willhiddleKeyBoard = YES;
    [self setBackWithText:@"取消"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];;
    //Init text font
    //可变数组初始化
    _heightOfAudioArray = [[NSMutableArray alloc] init];
    _AudioArray = [[NSMutableArray alloc] init];
    _dataArray  = [NSMutableArray arrayWithCapacity:0];
    _audioImageTag = 0;
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [self resetTextStyle];
    
    
    
    UIControl *control = [[UIControl alloc] initWithFrame:_textView.bounds];
    [control addTarget:self action:@selector(inputViewTapHandle) forControlEvents:UIControlEventTouchUpInside];
    [_textView addSubview:control];
    
    self.textView.textContainerInset = UIEdgeInsetsMake(30, 5, 0, 5);//设置页边距
    
    //Add keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];

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
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
     
                                            selector:@selector(moviePlayDidEnd)
     
                                                name:AVPlayerItemDidPlayToEndTimeNotification
     
                                              object:rightPlayerItem];
    
    [self setOpenOrNotView];//添加是否公开日记view
    [self setEditOfGroups];//添加日记分组view
    
}




#pragma mark 键盘监听事件


//键盘即将隐藏
- (void)onKeyboardWillHideNotification:(NSNotification *)notification {
    _willhiddleKeyBoard = YES;
    _bottomConstraint.constant = -80;
    [UIView animateWithDuration:3.0f animations:^{
        [self.view layoutIfNeeded];
    }];
}



//监听事件键盘显示
- (void)handleKeyboardDidShow:(NSNotification*)paramNotification
{
    //获取键盘高度
    NSValue *keyboardRectAsObject=[[paramNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect;
    [keyboardRectAsObject getValue:&keyboardRect];
    
    self.textView.contentInset=UIEdgeInsetsMake(0, 0,keyboardRect.size.height, 0);

    _keyBoardHeigh = keyboardRect.size.height;
    if (_GDkeyBoardHeigh<_keyBoardHeigh) {
        _GDkeyBoardHeigh = _keyBoardHeigh;
    }else{
        _keyBoardHeigh = _GDkeyBoardHeigh;
    }
}
//键盘隐藏
- (void)handleKeyboardDidHidden
{
    self.textView.contentInset=UIEdgeInsetsZero;
}
//当键盘即将出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    _willhiddleKeyBoard = NO;
   
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
     _keyBoardHeigh = keyboardRect.size.height;
      _bottomConstraint.constant = _keyBoardHeigh;
    
    CGFloat upHeight = _upkeyboardView.frame.size.height;
    _upkeyboardView.frame = CGRectMake(0, ScreenHeight - upHeight-_keyBoardHeigh, ScreenWidth, upHeight);
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resetTextStyle {
    //After changing text selection, should reset style.
    [self CommomInit];
    NSRange wholeRange = NSMakeRange(0, _textView.textStorage.length);
    
    
    [_textView.textStorage removeAttribute:NSFontAttributeName range:wholeRange];
    [_textView.textStorage removeAttribute:NSForegroundColorAttributeName range:wholeRange];
    
    //字体颜色
    [_textView.textStorage addAttribute:NSForegroundColorAttributeName value:self.fontColor range:wholeRange];
    
    //字体加粗
    if (self.isBold) {
        [_textView.textStorage addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.font] range:wholeRange];
    }
    //字体大小
    else
    {
        
        [_textView.textStorage addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.font] range:wholeRange];
    }
    
    
    
}
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         [self dataStore];//数据保存数据库
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showToast];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
}


-(void)showToast{
    [CRToastManager setDefaultOptions:@{kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                        kCRToastFontKey             : [UIFont fontWithName:@"HelveticaNeue-Light" size:16],
                                        kCRToastTextColorKey        : [UIColor whiteColor],
                                        kCRToastBackgroundColorKey  : [UIColor orangeColor]}];
    
    
    
    
    NSMutableDictionary *options = [@{
                                      kCRToastTextKey : @"保存成功",
                                      kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                                      //kCRToastBackgroundColorKey : [UIColor redColor],
                                      kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                      kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionBottom),
                                      kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                      kCRToastImageKey :[UIImage imageNamed:@"alert_icon.png"]
                                      } mutableCopy];
    [CRToastManager showNotificationWithOptions:[NSDictionary dictionaryWithDictionary:options]
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
    
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
            model.haveAudioInfo = YES;
            model.haveVideoInfo = YES;
            model.havePictureInfo = YES;
            model.haveWeatherInfo = YES;
            model.diaryInfo = data;
            model.diaryId = dId;
            //新的增加属于哪个组
//            model.atGroup = _groupRow;
            
            //添加到数据库
            [realm addObject:model];
            //提交事务
            [realm commitWriteTransaction];
        }];
        
        
        //分组model上的groupNum加一
        
        
    }else{
        RLMResults<editDiaryModel *> *model1 = [editDiaryModel   objectsWhere:@"diaryId == %@",@(_diaryId)];
        
        RLMRealm *realm = [RLMRealm defaultRealm];
 
        editDiaryModel *model = [[editDiaryModel alloc] init];
        model.title = title;
        model.year = year;
        model.monthAndDay = monthDay;
        model.time = time;
        model.supportNum = 22;
        model.haveAudioInfo = YES;
        model.haveVideoInfo = YES;
        model.havePictureInfo = YES;
        model.haveWeatherInfo = YES;
        model.diaryInfo = data;
        model.diaryId = _diaryId;
        model.atGroup = _groupRow;
        // 通过 id = 1 更新该书籍
        [realm beginWriteTransaction];
        [editDiaryModel createOrUpdateInRealm:realm withValue:model];
        [realm commitWriteTransaction];
       //若分组更改，对原分组的groupNum减一，新的分组groupNum➕1
        
    }
    
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
    return NO;
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
    if([text length] != 0) //点击了非删除键
    {
    }
    else
    {
        if (_heightOfAudioArray.count == 0) {//这里修改
            NSLog(@"子控件删除完");
        }else{
        NSLog(@"点击了删除按键");
        NSInteger nowLocation =  _textView.selectedRange.location;
        //用户数据删除中
        NSInteger viewTag = [_heightOfAudioArray.lastObject integerValue];
        if (viewTag >= nowLocation) {
            [_textView.subviews.lastObject removeFromSuperview];
            // [[_audioimage viewWithTag:viewTag] removeFromSuperview];
            
            [_heightOfAudioArray removeLastObject];
            [_AudioArray  removeLastObject];
        }
        }
        
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    
//    else{
//    NSInteger nowLocation =  _textView.selectedRange.location;
//        if (nowLocation>_deleteAction) {
//            _deleteAction = nowLocation;//用户编辑中，字段不断增加中
//        }else{
//   
//    }
//    }
    
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
            NSLog(@"汉字");
            //   NSLog(@"str=%@; 本次长度=%lu",str,(unsigned long)[str length]);
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
        NSLog(@"英文");
        [self setStyle];
        if ([str length]>=MaxLength) {
            NSString *strNew = [NSString stringWithString:str];
            [ self.textView setText:[strNew substringToIndex:MaxLength]];
        }
    }
    
    
}




- (void)textViewDidBeginEditing:(UITextView *)textView{
 
    [_textView becomeFirstResponder];
    _upkeyboardView.hidden = NO;
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
- (IBAction)keyboardClick:(id)sender {
    CGFloat upHeight = _upkeyboardView.frame.size.height;
    if (_willhiddleKeyBoard) {
        [_textView becomeFirstResponder];
        [UIView animateWithDuration:0.5 animations:^{
           _upkeyboardView.frame = CGRectMake(0, ScreenHeight - upHeight-_keyBoardHeigh-5, ScreenWidth, upHeight);
        }];
        
    }else{
        if (!_isAudioKeyOnTop) {
            [_textView endEditing:YES];
            [UIView animateWithDuration:0.5 animations:^{
               _upkeyboardView.frame = CGRectMake(0, ScreenHeight - upHeight-5, ScreenWidth, upHeight);
            }];
            
        }else{
            [_textView becomeFirstResponder];
            _textView.inputView = nil;
            _isAudioKeyOnTop = NO;
            [_textView reloadInputViews];
        }
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
- (IBAction)weatherChose:(id)sender {
    [_textView becomeFirstResponder];
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
 
    self.textView.inputView = _weatherKeyBoard;
    _isAudioKeyOnTop = YES;
    [self.textView reloadInputViews];
}


-(void)itemClicked:(UIButton *)button{
    NSLog(@"%ld",(long)button.tag);
    
}
//录音
- (IBAction)colorClick:(UIButton *)sender {
    [_textView becomeFirstResponder];
    
     _audioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _keyBoardHeigh*0.7)];
    [_audioView setBackgroundColor:[UIColor whiteColor]];
     [_audioView addSubview:[self drawThreadWithFram:CGRectMake(0, 5, ScreenWidth, 0.5) andColor:[UIColor colorWithHexString:@"e7e7e7"]]];
    //按住说话
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 20)];
    label.contentMode = UIViewContentModeCenter;
    label.textAlignment  = NSTextAlignmentCenter;
    [label setText:@"按住说话"];
    label.font = [UIFont systemFontOfSize:15.0];
    [label setTextColor:[UIColor grayColor]];
    [_audioView addSubview:label];
    
    //录音icon
    _audioImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-48, CGRectGetMaxY(label.frame)+20, 96, 96)];
    _audioImage.backgroundColor = [UIColor clearColor];
    //[audioView addSubview:_audioImage];
    
    //录音icon添加点击事件
    _audioButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-48, CGRectGetMaxY(label.frame)+20, 96, 96)];
    [_audioButton setBackgroundImage:[UIImage imageNamed:@"luyinicon"] forState:UIControlStateNormal];
    [_audioButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [_audioButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_audioButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [_audioButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [_audioButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    [_audioView addSubview:_audioButton];
    self.textView.inputView = _audioView;
    _isAudioKeyOnTop = YES;
    [self.textView reloadInputViews];
 
}

#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
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
- (void)updateCancelRecordVoice {
    //[[LGSoundRecorder shareInstance] readyCancelSound];
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
   // [[LGSoundRecorder shareInstance] soundRecordFailed:self.view];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.view];
}


- (void)sixtyTimeStopSendVodio {
    int countDown = 60 - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
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
    audioModel *messageModel = [[audioModel alloc] init];
    messageModel.soundFilePath = [[LGSoundRecorder shareInstance] soundFilePath];
    messageModel.seconds = [[LGSoundRecorder shareInstance] soundRecordTime];
    
    //计算textView中现在的内容高度，用于设置语音控件的位置
    _textViewBounds = _textView.bounds;
    CGSize maxSize = CGSizeMake(_textViewBounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    _textViewBounds.size = newSize;

    //添加图片底层
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, _textViewBounds.size.height, ScreenWidth-20, 50)];
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
    _audioimage = [[audioImage alloc] initWithFrame:CGRectMake(10, _textViewBounds.size.height, ScreenWidth-20, 30)];
    _audioimage.tag = _audioImageTag;
    NSInteger subViewLocation = _textView.selectedRange.location;
    [_heightOfAudioArray addObject:@(_audioImageTag)];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(audiotap:)];
    [_audioimage addGestureRecognizer:ges];
    
    [_audioimage builderViewWithSceond:[[LGSoundRecorder shareInstance] soundRecordTime]];

    [_textView addSubview:_audioimage];
    [_AudioArray addObject:_audioimage];
    [self.dataArray addObject:messageModel];
}

-(void)audiotap:(UITapGestureRecognizer*)gap{
    NSLog(@"%ld",gap.view.tag);
    NSInteger indexrow = gap.view.tag;
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
- (IBAction)boldClick:(UIButton *)sender {

    DPImagePickerVC *vc = [[DPImagePickerVC alloc]init];
    vc.delegate = self;
    vc.isDouble = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
//字体设置
- (IBAction)fontClick:(UIButton *)sender {
    NSLog(@"添加视频");
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
    
    
    picker.maximumNumberOfSelectionVideo = 2;
    picker.maximumNumberOfSelectionPhoto = 0;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];

}

-(void)putVideoOnTextViewWithUrl:(NSURL *)url image:(UIImage *)pictueImage{
    
    //计算textView中现在的内容高度，用于设置语音控件的位置
    _textViewBounds = _textView.bounds;
    CGSize maxSize = CGSizeMake(_textViewBounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    _textViewBounds.size = newSize;
    
    //添加图片底层
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, _textViewBounds.size.height, ScreenWidth-20, 300)];
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
    _videoView = [[videoView alloc] initWithFrame:CGRectMake(10, _textViewBounds.size.height, ScreenWidth-20, 300)];
    _videoView.url = url;
    _videoView.tag = _audioImageTag;
    [_videoView builderWithImage:pictueImage];
    NSInteger subViewLocation = _textView.selectedRange.location+1;
    [_heightOfAudioArray addObject:@(_audioImageTag)];
    [_textView addSubview:_videoView];
    UITapGestureRecognizer *videoGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTap:)];
    [_videoView addGestureRecognizer:videoGes];
//

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
    
    /**
    TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"选择照片" message:@""];
    
    __weak typeof(self)weakSelf=self;
    [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancle handler:^(TYAlertAction *action) {
        
    }]];
    
    [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
        [weakSelf selectedImage];
    }]];
    
    // first way to show ,use UIView Category
    [alertView showInWindowWithOriginY:200 backgoundTapDismissEnable:YES];
     **/
//    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        
//    }];
//    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
#if TARGET_IPHONE_SIMULATOR
        //模拟器
        UIAlertView *alerView=[[UIAlertView alloc]initWithTitle:@"提醒" message:@"请真机测试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alerView show];
#elif TARGET_OS_IPHONE
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:([UIColor colorWithRed:231.0/255.0 green:56.0/255.0 blue:32.0/255.0 alpha:1.0]),NSForegroundColorAttributeName, nil];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePickerController animated:YES completion:^{}];
#endif
        
        
//    }];
//    UIAlertAction *confirm2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        DPImagePickerVC *vc = [[DPImagePickerVC alloc]init];
//        vc.delegate = self;
//        vc.isDouble = NO;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        
//    }];
//    [alertVc addAction:cancle];
//    [alertVc addAction:confirm];
//    [alertVc addAction:confirm2];
//    [self presentViewController:alertVc animated:YES completion:nil];

    
    
    
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
    imageTextAttachment.imageTag = ImageTag;
    imageTextAttachment.image =image1;
    
    //Set image size
    imageTextAttachment.imageSize = CGSizeMake(ScreenWidth, 50);
    
    //Insert image image
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                          atIndex:_textView.selectedRange.location];
    
  
    //Move selection location
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
      _audioImageTag = _textView.selectedRange.location;
    
    //设置字的设置
    [self setInitLocation];
}

#pragma mark -- 视频底层图片添加
-(void)putVideoWithImage:(UIImage *)image{
    
    
    UIImage  *image1;
    
    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    image1=[imageTextAttachment scaleImage:image withSize:CGSizeMake(ScreenWidth, 320)];
    //Set tag and image
    imageTextAttachment.imageTag = ImageTag;
    imageTextAttachment.image =image1;
    
    //Set image size
    imageTextAttachment.imageSize = CGSizeMake(ScreenWidth, 320);
    
    //Insert image image
    [_textView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:imageTextAttachment]
                                          atIndex:_textView.selectedRange.location];

    //Move selection location
    _textView.selectedRange = NSMakeRange(_textView.selectedRange.location + 1, _textView.selectedRange.length);
    _audioImageTag = _textView.selectedRange.location;
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
    
    
    //设置字的位置
    [self setInitLocation];
}

- (void)getImageArray:(NSMutableArray *)arrayImage{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"------------------%ld",(unsigned long)arrayImage.count);
    if (arrayImage.count !=0) {
        self.imageV.image = arrayImage[0];
    }
    
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
    }else {
        NSLog(@"不公开这篇日记");
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
        ALAssetRepresentation *representation = alAsset.defaultRepresentation;
        AVAsset *avasset = [AVAsset assetWithURL:alAsset.defaultRepresentation.url];
        NSURL *movieURL = representation.url;
        mp4Url = movieURL;
          long long size = representation.size;
        if (true) {//在此处判断视频的大小，超出大小则提示用户视频过大，请重新选择
            [self putVideoOnTextViewWithUrl:movieURL image:img];
            [_textView becomeFirstResponder];
        }
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

@end
