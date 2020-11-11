# ShinhoIOSViews
### Views
*AXTitleContentView
```
title: 标题
titleType: font12, font16, noTitle
isChanged: 当用户执行了操作, 这个控件要赋值为 true
isRequired: 必填项
permission: 访问权限 allowEdit history
showBottomLine: 显示隐藏最下面的分割线
bottomOffset: 下半部分的 padding
setRequired: 设置为必填项
```
* SelectorView
```
title1：item1 title
title2：item2 title
func select(_ index: Int): index = 0, 1, 第一控件，第二个控件
var didSelected: ((_ index: Int) -> ())?: index = 0, 1, 第一控件，第二个控件
```
*PhotoTransitionViewController
```
// extension UIImageView
url: 检索图片, 如果 UIImageView 有 url, 则使用 url, 否则使用 UIImageView 的 image
showPreviewPermitted: 配合图片检索, 如果 父视图 的 hideNotPermitted 为 true, 只有 showPreviewPermitted 的子 UIImageView 可以显示
showPreview(completion: (() -> ())? = nil): Parameter completion: 动画结束回调

// extension UIView
hideNotPermitted: 如果 hideNotPermitted 为 true, UIImageView showPreviewPermitted 必须为 true才可以显示, 如果为 false, 所有都可以显示
isAutoShowPreviews: 在当前 view 上加一个点击, 并且自动检索所有图片 auto set isUserInteractionEnabled = true
rectInWindow: 视图在 window 中的位置
showAllImages(touchPoint: CGPoint = .zero): 检索当前页面所有 imageView

//PhotoPreviewControllerDataSource
photoPreviewCount: 图片 count
photoPreviewResource: 图片资源
photoPreviewTransitionFrame: 返回图片的 frame
```
*AXStarBar
```
selectedStarCount: 选中 star 个数
selectAction: 选中事件
```
*AXStarBarExtension
```
infos: starBar right information, 个数必须大于等于5, 大于5取前五个
titleText: 标题
isRequired: 必填项
infoIsHidden: info 是否隐藏
countSubject: count 改变订阅事件
count: 选中个数
```
*ProgressView
```
// ProgressViewStyle
arc: 环形进度条
line: 线性进度条
style: 默认线性进度
animationStopped: 动画结束事件
repeatCount: 动画重复次数
autoreverses: 是否反向的
progressWidth: 进度条宽度
progressColors: 进度条颜色
placeholderColor: 预览的颜色
showPlaceholder: 是否显示预览
```
