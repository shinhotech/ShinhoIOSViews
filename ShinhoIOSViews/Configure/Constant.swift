//
//  Constant.swift
//  FSFA
//
//  Created by Lcm on 2018/2/6.
//  Copyright © 2018年 shinho. All rights reserved.
//

import UIKit

// MARK: - layout size

/// CGFloat 8.0
let margin1: CGFloat = 8.0

/// CGFloat 16.0
let margin2: CGFloat = 16.0

/// CGFloat 24.0
let margin3: CGFloat = 24.0

/// CGFloat 32.0
let margin4: CGFloat = 32.0

/// CGFloat 40.0
let margin5: CGFloat = 40.0

/// CGFloat 48.0
let margin6: CGFloat = 48.0


/// 页面左边距 24.0
let leftMargin: CGFloat = 24.0

/// 页面右边距 24.0
let rightMargin: CGFloat = 24.0

/** other size **/
/// CGFloat 104.0
let textViewHeight: CGFloat = 104.0

/// photo size
let photoSize = CGSize(width: 104, height: 104)

/// bottom navgation bar height 56.0
let navBarHeight: CGFloat = 56.0

/// title bar height 67.0
let titleBarHeight: CGFloat = 67.0

/// CGFloat 104.0
let addPhotoHeight = textViewHeight


let maxTextCount = 200
/// 一页20条
let pageSize = 20

// MARK: - reuse identifier
let cellId = "cellId"
let headerId = "headerId"
let footerId = "footerId"

let authorityKey = "authority"
let enableLoginHistoryKey = "enableLoginHistoryKey"
let enableDebugBallKey = "enableDebugBallKey"
let pushUserInfoKey = "content"

/// 列表中客户名、商品名字体
let titleFont = UIFont.pfscMedium(16)

// MARK: - Notification Name

let refreshPlanListNotification = Notification.Name("refreshPlanListNotification")
let refreshPlanStatusNotification = Notification.Name("refreshPlanStatusNotification")
let networkStatusChangedNotification = NSNotification.Name("networkStatusChangedNotification")
let requestStatusChangedNotification = NSNotification.Name("requestStatusChangedNotification")
let refreshWorkListNotification = NSNotification.Name("refreshWorkListNotification")
let fetchWholeInfoNotification = NSNotification.Name("fetchWholeInfoNotification")
let logininSuccessNotification = Notification.Name("logininSuccessNotification")
let refreshSupplierCountNotification = Notification.Name("refreshSupplierCountNotification")
let refreshApilogNotification = Notification.Name("refreshApilogNotification")
let auditCompleteNotification = Notification.Name("auditCompleteNotification")


let mustwin = "Must-Win"
let emptyPlaceholder = "信息尚未补充"
