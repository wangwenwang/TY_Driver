//
//  ESRefreshAnimator.swift
//
//  Created by egg swift on 16/4/7.
//  Copyright (c) 2013-2016 ESPullToRefresh (https://github.com/eggswift/pull-to-refresh)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import UIKit

open class ESRefreshAnimator: ESRefreshProtocol, ESRefreshAnimatorProtocol {
    open var view: UIView
    open var insets: UIEdgeInsets
    open var trigger: CGFloat = 60.0
    open var executeIncremental: CGFloat = 60.0
    
    public init() {
        view = UIView()
        insets = UIEdgeInsets.zero
    }
    
    open func refreshAnimationDidBegin(_ view: ESRefreshComponent) {
        /// Do nothing!
    }
    
    open func refreshAnimationDidEnd(_ view: ESRefreshComponent) {
        /// Do nothing!
    }
    
    open func refresh(_ view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        /// Do nothing!
    }
    
    open func refresh(_ view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        /// Do nothing!
    }
    
    
    //MARK: - 添加者 王文望
    open func setloadingMoreDescription1(_ text: String) {
        /// Do nothing!
    }
    
    open func setanimatorOffX(_ offx: CGFloat) {
        /// Do nothing!
    }
}
