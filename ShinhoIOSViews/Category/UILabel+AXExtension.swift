//
//  UILabel+AXExtension.swift
//  FSFA
//
//  Created by Lcm on 2018/2/6.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit
import AXKit
private let requiredString = "  *"
extension UILabel {
    var noRequiredStringText: String? {
        if let _ = attributedText?.string.contains(requiredString) {
            let range = ((attributedText?.string)! as NSString).range(of: requiredString)
            if range.location != NSNotFound {
                let temp = attributedText?.mutableCopy() as? NSMutableAttributedString
                temp?.replaceCharacters(in: range, with: "")
                return temp?.string
            }
        }
        return self.text
    }
    @discardableResult
    func addRequired() -> Self {
        if let text = self.text, !text.isEmpty {
            var attributes = [NSAttributedString.Key: Any]()
            attributes[.font] = font
            attributes[.foregroundColor] = textColor
            let attrText = NSMutableAttributedString(string: text, attributes: attributes)
            attrText.append(NSAttributedString(string: requiredString, attributes: [.font:UIFont.pfscRegular(12), .foregroundColor: UIColor.redf0]))
            self.text = nil
            self.attributedText = attrText
        }
        return self
    }
    
    @discardableResult
    func removeRequired() -> Self {
        if let _ = attributedText?.string.contains(requiredString) {
            let range = ((attributedText?.string)! as NSString).range(of: requiredString)
            if range.location != NSNotFound {
                attributedText = attributedText?.attributedSubstring(from: NSRange(location: 0, length: range.location))
            }
        }
        return self
    }
    
    static func titleLabelBlack() -> Self {
        return self.init().ax.textColor(.black).font(.pfscMedium(16)).lineBreakMode(.byCharWrapping).value
    }
    
    static func titleLabelRegulartBlack() -> Self {
        return self.init().ax.textColor(.black).font(.pfscRegular(16)).lineBreakMode(.byCharWrapping).value
    }
    
    static func titleLabel() -> Self {
        return self.init().ax.textColor(.black70).font(.pfscMedium(16)).lineBreakMode(.byCharWrapping).value
    }
    
    static func mediumTitleLabel() -> Self {
        return self.init().ax.textColor(.black70).font(.pfscMedium(14)).lineBreakMode(.byCharWrapping).value
    }
    
    static func subTitleLabel() -> Self {
        return self.init().ax.textColor(.black38).font(.pfscRegular(12)).lineBreakMode(.byCharWrapping).value
    }
    
    static func thirdTitleLabel() -> Self {
        return self.init().ax.textColor(.black38).font(.pfscRegular(10)).lineBreakMode(.byCharWrapping).value
    }
    
    @discardableResult
    func addPrefixImage(image: UIImage) -> Self {
        let attr = NSMutableAttributedString(string: text ?? "")
        let attach = NSTextAttachment()
        let offsetY = (font.capHeight - image.size.height)/2
        if offsetY > 0 {
            attach.bounds.origin.y = offsetY
        }
        attach.bounds.size = image.size
        attach.image = image
        attr.insert(NSAttributedString(string: "  "), at: 0)
        attr.insert(NSAttributedString(attachment: attach), at: 0)
        attributedText = attr
        return self
    }
}


class UILabelPadding: UILabel {
    
    private var padding = UIEdgeInsets.zero
    
    @IBInspectable
    var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        if rect != .zero {
            let insets = padding
            var rect = super.textRect(forBounds: bounds.inset(by: padding), limitedToNumberOfLines: numberOfLines)
            rect.origin.x    -= insets.left
            rect.origin.y    -= insets.top
            rect.size.width  += (insets.left + insets.right)
            rect.size.height += (insets.top + insets.bottom)
            return rect
        }
        return rect
    }
}
