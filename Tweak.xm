#import <UIKit/UIKit.h>



//Change every single UIView BG to black, except the UIButtons and the newspaper view


%hook UIView
- (void)setBackgroundColor:(UIColor *)color {
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
   if (red == 18.0/255.0 && green == 58.0/255.0 && blue == 116.0/255.0 && self.subviews.count == 0){
         // color is blue(18,58,116), don't modify
         %orig(color);
         
      } 
 else if (self.frame.size.height == 38 && [color isEqual:[UIColor whiteColor]]) {
        %orig(color=[UIColor blackColor]);
   } else if ([self isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")] ||
        [self isKindOfClass:NSClassFromString(@"UIButton")] ||
        [self isKindOfClass:NSClassFromString(@"UIButtonLabel")] ||
        [self.superview isKindOfClass:NSClassFromString(@"EditionContentView")] ||
        self.frame.size.height == 47||
        self.frame.size.height == 44||
        self.frame.size.height == 22||
        self.frame.size.height == 38||
        self.frame.size.height == 20||
        self.frame.size.height == 1){ //exclude various UI Elements
        %orig(color);
    } 
else {
        %orig(color=[UIColor blackColor]);
    }
}
%end

       // [self.backgroundColor isEqual:[UIColor colorWithRed:18/255.0 green:58/255.0 blue:116/255.0 alpha:1.0]]||
       // [self.backgroundColor isEqual:[UIColor colorWithRed:17/255.0 green:58/255.0 blue:116/255.0 alpha:1.0]]||
     //  [self.superview isKindOfClass:NSClassFromString(@"UIDropShadowView")]||
       // [self isKindOfClass:NSClassFromString(@"MainViewController")] ||
       // [self isKindOfClass:NSClassFromString(@"UIViewController")] ||
//[NSStringFromClass([self.superview class]) isEqualToString:@"LeSoir.MainViewController"]||
  //    [NSStringFromClass([self class]) isEqualToString:@"LeSoir_MainViewController"] ||
    //      [NSStringFromClass([self class]) isEqualToString:@"UIWindow"] ||
   //       [NSStringFromClass([self class]) isEqualToString:@"UIDropShadowView"]

//Change the detailed article view colors. Might need some tweakings to trigger faster.

%hook WKWebView
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    javaScriptString = [NSString stringWithFormat:@"document.body.style.backgroundColor = 'black'; document.body.style.color = 'white'; var header = document.getElementsByTagName('h1')[0]; header.style.color = 'white'; var allElements = document.getElementsByTagName('*'); for (var i = 0; i < allElements.length; i++) { if (allElements[i].offsetHeight > 10) { allElements[i].style.color = 'white'; } }; %@", javaScriptString];
    %orig(javaScriptString, completionHandler);
}
%end



//Change tab bar color to black
%hook UITabBar
- (void)layoutSubviews {
    %orig;
    self.backgroundColor =  [UIColor blackColor];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"_UIBarBackground")]) {
            subview.hidden = YES;
        }
    }
}
%end


//Hide the white shadow on top of feed view
%hook UIViewController
- (void)viewDidLoad {
    %orig;
    if ([self.title rangeOfString:@"Section"].location != NSNotFound) {
        for (UIView* view in self.view.subviews) {
            if ([view isKindOfClass:[UIView class]]) {
                view.layer.masksToBounds = YES;
            }
        }
    }
}
%end


//Hide a blackviewad
%hook DetailPdfAdViewController
- (void)viewDidLoad {
    %orig;
    UIView *viewAd = [self valueForKey:@"_viewAd"];
    if(viewAd){
        viewAd.hidden = YES;
    }
}
%end


//Change every UILabel to white (and force them to stay)
%hook UILabel
- (void)setTextColor:(UIColor *)color {
    %orig(color=[UIColor whiteColor]);
}
- (void)setAttributedText:(NSAttributedString *)attributedText {
    NSMutableAttributedString *newAttributedText = [attributedText mutableCopy];
    [newAttributedText addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, newAttributedText.length)];
    %orig(newAttributedText);
}
%end


//Change buttons text color
%hook UIButton
- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    %orig(color=[UIColor whiteColor], state);
}
%end


//Change text field text color
%hook UITextField
- (void)setTextColor:(UIColor *)color {
    %orig(color=[UIColor whiteColor]);
}
%end


//Might not be useful but who knows
%hook UITextView
- (void)setTextColor:(UIColor *)color {
    %orig(color=[UIColor whiteColor]);
}
%end

//Display an alert only on the first time launch View Controller
%hook UIViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    if ([NSStringFromClass(self.class) rangeOfString:@"Consent"].location != NSNotFound) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"LeSoirOLED" message:@"OLED mode by mago (⌐■_■)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Thank You !" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }

}
%end
    