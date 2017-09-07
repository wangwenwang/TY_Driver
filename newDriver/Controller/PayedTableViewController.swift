//
//  NotPayTableViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/6/27.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class PayedTableViewController: UITableViewController, HttpResponseProtocol {
    
    
    /// 界面显示到前台的时候是否要刷新数据、登陆界面使用
    static var shouldRefresh: Bool = true
    
    /// 是否弹出对话框显示警告信息，pagemenue bug 滑动到底部的时候再进行左右滑动切换的时候会刷新数据
    fileprivate var shouldShowAlert = false
    
    /// 已交付订单业务类
    fileprivate let biz: PayedOrderBiz = PayedOrderBiz()
    
    var eSRefreshFooterView : ESRefreshFooterView! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global().async {
            usleep(300000)
            DispatchQueue.main.async {
                if PayedTableViewController.shouldRefresh {
                    self.biz.tempPage = 1
                    self.tableView.es_startPullToRefresh()
                    PayedTableViewController.shouldRefresh = false
                }
                self.shouldShowAlert = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.register(UINib.init(nibName: "PayedOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "PayedOrderTableViewCell")
        
        initRefreshView()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldShowAlert = false
    }
    
    // MARK: - 网络回调
    /// 初始化显示未交付订单的上拉刷新河下拉加载的 tableview
    fileprivate func initRefreshView () {
        _ = self.tableView.es_addPullToRefresh {
            self.biz.tempPage = 1
            //判断连接状态
            let reachability = Reachability.forInternetConnection()
            if reachability!.isReachable(){
                self.biz.getPayedOrderData(httpresponseProtocol: self)
            }else{
                self.responseError("网络连接不可用!")
            }
        }
        
        self.tableView.refreshIdentifier = NSStringFromClass(NotPayTableViewController.self) // Set refresh identifier
        self.tableView.expriedTimeInterval = 20.0 // 20 second alive.
        
        eSRefreshFooterView = self.tableView.es_addInfiniteScrolling {
            //判断连接状态
            let reachability = Reachability.forInternetConnection()
            if reachability!.isReachable(){
                self.biz.tempPage = self.biz.page + 1
                self.biz.getPayedOrderData(httpresponseProtocol: self)
            }else{
                self.responseError("网络连接不可用!")
            }
        }
    }
    
    /// 获取已交付订单成功回调方法
    func responseSuccess() {
        self.tableView.reloadData()
        self.tableView.es_stopPullToRefresh(completion: true)
        self.tableView.es_stopLoadingMore()
        
        tableView.removeNoOrderPrompt()
    }
    
    /**
     * 获取已交付订单信息失败回调方法
     *
     * message: 显示的信息
     */
    func responseError(_ error: String) {
        self.tableView.reloadData()
        self.tableView.es_stopPullToRefresh(completion: true)
        self.tableView.es_stopLoadingMore()
        Tools.showAlertDialog(error, self)
    }
    
    /// 获取成功，但是没有数据
    func responseSuccess_noData() {
        self.tableView.es_stopPullToRefresh(completion: true)
        if(eSRefreshFooterView != nil) {
            self.tableView.es_noticeNoMoreData()
            eSRefreshFooterView.animator?.setloadingMoreDescription1("\(biz.orders.count)")
        }
        
        if(biz.orders.count == 0) {
            self.tableView.es_stopLoadingMore()
            tableView.noOrder(title: "您还没有已交付订单")
        } else {
            tableView.removeNoOrderPrompt()
        }
    }
    
    //MARK: - UITableViewDelegate
    /// 设置 tableview 数据数量
    override func numberOfSections(in tableView: UITableView) -> Int {
        return biz.orders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// 设置 cell 高度
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    /// 设置自定义的 cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayedOrderTableViewCell", for: indexPath) as! PayedOrderTableViewCell
        cell.order = biz.orders[(indexPath as NSIndexPath).section]
        return cell
    }
    
    /// 点击 tableview 的 cell ，跳转到订单详情界面
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let orderDetailController = OrderDetailViewController(nibName: "OrderDetailViewController", bundle: nil)
        orderDetailController.orderIDX = "\(biz.orders[(indexPath as NSIndexPath).section].ORD_IDX)"
        self.navigationController?.pushViewController(orderDetailController, animated: true)
    }
    
}
