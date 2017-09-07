//
//  PushOrderViewController.swift
//  newDriver
//
//  Created by 凯东源 on 16/12/15.
//  Copyright © 2016年 凯东源. All rights reserved.
//

import UIKit

class PushOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableView: UITableView!
    
    var SHIPMENT_List: [SHIPMENT_List] = []
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.myTableView.register(UINib.init(nibName: "PushOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "PushOrderTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return SHIPMENT_List.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pushOrderSimple: SHIPMENT_List = SHIPMENT_List[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PushOrderTableViewCell", for: indexPath) as! PushOrderTableViewCell
        cell.ORD_NO.text = pushOrderSimple.ORD_NO
        cell.ORD_NO_CLIENT.text = pushOrderSimple.ORD_NO_CLIENT
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myTableView.deselectRow(at: indexPath, animated: true)
        
        let orderDetailController : OrderDetailViewController? = OrderDetailViewController(nibName:"OrderDetailViewController", bundle:nil)
        
        let pushOrderSimple: SHIPMENT_List = SHIPMENT_List[(indexPath as NSIndexPath).row]
        
        if let ODVC = orderDetailController {
            ODVC.orderIDX = pushOrderSimple.ORD_IDX
            self.navigationController?.pushViewController(ODVC, animated: true)
        } else {
            Tools.showAlertDialog("orderDetailController = nil", self)
        }
    }
}

