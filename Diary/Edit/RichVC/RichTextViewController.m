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

//Image default max size
#define IMAGE_MAX_SIZE ([UIScreen mainScreen].bounds.size.width-10)

#define ImageTag (@"[UIImageView]")
#define DefaultFont (16)
#define MaxLength (2000)

@interface RichTextViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextViewDelegate,DPImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UIView *upkeyboardView;
@property (weak, nonatomic)   UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *openOrNotView;
@property (weak, nonatomic)   UISlider *imageSizeSlider;
@property (weak, nonatomic)  NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic)  UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (strong, nonatomic)  DPImagePickerVC * Viewasd;


//设置
@property (nonatomic,assign) BOOL isBold;          //是否加粗
@property (nonatomic,strong) UIColor * fontColor;  //字体颜色
@property (nonatomic,assign) CGFloat  font;        //字体大小
@property (nonatomic,assign) NSUInteger location;  //纪录变化的起始位置
@property (nonatomic,strong) NSMutableAttributedString * locationStr;

@property (nonatomic,assign) CGFloat lineSapce;    //行间距

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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    view.backgroundColor = [UIColor redColor];
    [_upkeyboardView addSubview:view];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _switchButton.frame = CGRectMake(ScreenWidth-69, 10, 60, 10);
    [self setBackWithText:@"取消"];
    //Init text font
    
    [self resetTextStyle];
    
    
    
    
    
    //Add keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
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
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    
}
#pragma mark - Action
//完成
- (IBAction)finishClick:(UIButton *)sender {
//    NSLog(@"text--%@",self.textView.text);
//    NSLog(@"textStorage。getPlainString--%@",[_textView.textStorage getPlainString]);
//    NSLog(@"attributedText。getPlainString--%@",[_textView.attributedText getPlainString]);
//    NSLog(@"attributedText--%@",self.textView.attributedText);
    

    if (self.finished!=nil) {
        self.finished([_textView.attributedText getArrayWithAttributed]);
        
    }
}
//颜色设置
- (IBAction)colorClick:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    if (sender.selected) {
        self.fontColor=[UIColor redColor];
        
    }
    else
    {
        
        self.fontColor=[UIColor blackColor];
    }
    
    [sender setTintColor:self.fontColor];
    
    
    //设置字的设置
    [self setInitLocation];
    
}
//加粗
- (IBAction)boldClick:(UIButton *)sender {
    
    sender.selected=!sender.selected;
    self.isBold=sender.selected;
    if (self.isBold) {
        sender.titleLabel.font=[UIFont systemFontOfSize:12];
        
        
    }
    else
    {
        
        sender.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    }
    
    //设置字的设置
    [self setInitLocation];
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
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
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
        
        
    }];
    UIAlertAction *confirm2 = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        DPImagePickerVC *vc = [[DPImagePickerVC alloc]init];
        vc.delegate = self;
        vc.isDouble = NO;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }];
    [alertVc addAction:cancle];
    [alertVc addAction:confirm];
    [alertVc addAction:confirm2];
    [self presentViewController:alertVc animated:YES completion:nil];

    
    
    
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
