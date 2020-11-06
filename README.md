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
