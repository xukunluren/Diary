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
//Image default max size
#define IMAGE_MAX_SIZE ([UIScreen mainScreen].bounds.size.width-10)

#define ImageTag (@"[UIImageView]")
#define DefaultFont (16)
#define MaxLength (2000)

#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface RichTextViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,DPImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UIView *upkeyboardView;
@property (weak, nonatomic)   UITextView *textView;

@property (nonatomic, weak) NSTimer *timerOf60Second;
@property (weak, nonatomic)   UISlider *imageSizeSlider;
@property (weak, nonatomic)  NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic)  UIImageView *imageV;

@property (strong, nonatomic)  DPImagePickerVC * Viewasd;
@property (strong, nonatomic)  UIImageView *audioImage;
@property (strong, nonatomic)  UIButton *audioButton;
@property (assign, nonatomic)  Boolean hiddleKeyBoard;
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
@property (nonatomic,copy) NSMutableArray *heightOfAudioArray;    //录音高度记录用于删除使用
@property (nonatomic,copy) NSMutableArray *AudioArray;    //用于存储录音控件便于删除
@property (nonatomic,strong) audioImage *audioimage;//录音控件
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger audioImageTag;//录音控件
@end

@implementation RichTextViewController
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
    _upkeyboardView.hidden = YES;
    [self setOpenOrNotView];
    
}
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
     switchButton.transform = CGAffineTransformMakeScale(0.7, 0.65);
     switchButton.onTintColor = [UIColor colorWithHexString:@"12B7F5"];
    [switchButton setOn:YES];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [openOrNot addSubview:switchButton];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _hiddleKeyBoard = NO;
    [self setBackWithText:@"取消"];
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
    
    //Add keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
     _keyBoardHeigh = keyboardRect.size.height;
    
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

#pragma mark 滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
////
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - _lastPosition >300) {
//        _lastPosition = currentPostion;
//         NSLog(@"ScrollUp now");
//  
//    }else if (_lastPosition - currentPostion > 300)
//    {
//        _lastPosition = currentPostion;
//        [_textView endEditing:YES];
//        NSLog(@"ScrollDown now");
//    }
//    NSLog(@"%f",scrollView.contentOffset.y);
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
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    
    if (_AudioArray.count == 0) {
        NSLog(@"录音控件删除完");
    }else{
    CGSize maxSize = CGSizeMake(_textView.bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [_textView sizeThatFits:maxSize];
    CGFloat deletHeight = newSize.height;
  
    CGFloat lastObjectHeight = [_heightOfAudioArray.lastObject floatValue];
    if (deletHeight<lastObjectHeight) {
        [[_audioimage viewWithTag:_audioImageTag--] removeFromSuperview];
        [_heightOfAudioArray removeLastObject];
        [_AudioArray  removeLastObject];
    }
    }
    
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
    [_textView endEditing:YES];
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
//录音
- (IBAction)colorClick:(UIButton *)sender {
    
    UIView *audioView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _keyBoardHeigh)];
    [audioView setBackgroundColor:[UIColor whiteColor]];
    //按住说话
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-40, 20, 80, 20)];
    label.contentMode = UIViewContentModeCenter;
    [label setText:@"按住说话"];
    label.font = [UIFont systemFontOfSize:15.0];
    [label setTextColor:[UIColor grayColor]];
    [audioView addSubview:label];
    
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
    [audioView addSubview:_audioButton];
    
    self.textView.inputView = audioView;
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, _textViewBounds.size.height, ScreenWidth-20, 30)];
    view.alpha = 0.0;
    view.backgroundColor = [UIColor clearColor];
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    view = nil;
    [self putAudioWithImage:viewImage];
    
    //添加录音控件
    _audioimage = [[audioImage alloc] initWithFrame:CGRectMake(10, _textViewBounds.size.height, ScreenWidth-20, 30)];
    _audioimage.tag = _audioImageTag++;
    CGFloat heightOfAudio = CGRectGetMaxY(_audioimage.frame);
    [_heightOfAudioArray addObject:@(heightOfAudio)];
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
    [_textView reloadInputViews];
    
}
//选择图片
- (IBAction)boldClick:(UIButton *)sender {
    [self.view endEditing:YES];
    DPImagePickerVC *vc = [[DPImagePickerVC alloc]init];
    vc.delegate = self;
    vc.isDouble = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
//字体设置
- (IBAction)fontClick:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.font=25.f;
        [sender setTitle:[NSString stringWithFormat:@"字体 %.f",self.font] forState:UIControlStateSelected];
    }
    else
    {
        self.font=DefaultFont;
        [sender setTitle:[NSString stringWithFormat:@"字体 %.f",self.font] forState:UIControlStateNormal];
    }
    
    //设置字的设置
    [self setInitLocation];
}
//选择图片
- (IBAction)imageClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
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
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
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


#pragma mark -- 录音添加
-(void)putAudioWithImage:(UIImage *)image{
    
    
    UIImage  *image1;
    ImageTextAttachment *imageTextAttachment = [ImageTextAttachment new];
    image1=[imageTextAttachment scaleImage:image withSize:CGSizeMake(ScreenWidth, 30)];
    //Set tag and image
    imageTextAttachment.imageTag = ImageTag;
    imageTextAttachment.image =image1;
    
    //Set image size
    imageTextAttachment.imageSize = CGSizeMake(ScreenWidth, 30);
    
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
    
    
    //设置字的设置
    [self setInitLocation];
}

- (void)getImageArray:(NSMutableArray *)arrayImage{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"------------------%ld",arrayImage.count);
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
#pragma mark - Keyboard notification

- (void)onKeyboardNotification:(NSNotification *)notification {
    //Reset constraint constant by keyboard height
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        CGRect keyboardFrame = ((NSValue *) notification.userInfo[UIKeyboardFrameEndUserInfoKey]).CGRectValue;
        _bottomConstraint.constant = keyboardFrame.size.height;
    } else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        _bottomConstraint.constant = -80;
    }
    //Animate change
    [UIView animateWithDuration:0.5f animations:^{
        [self.view layoutIfNeeded];
    }];
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RichTextPreviewVC * sub=[segue destinationViewController];
    if ([sub isKindOfClass:[RichTextPreviewVC class]]) {
        sub.content=self.textView.attributedText;
    }
}
@end
