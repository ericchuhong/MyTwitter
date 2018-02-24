//
//  MTTTabBaseView.swift
//  MyTwitter
//
//  Created by LiuChuanan on 2018/2/24.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit

class MTTTabBaseView: MTTView {

    var tableView:UITableView!
    
    let reusedCellId:String = "reusedCellId"
    
    
    override init(frame: CGRect) 
    {
        super.init(frame: frame)
        setupNotification()
    }
    
    override func setupSubview() 
    {
        super.setupSubview()
        tableView = UITableView()
        tableView.backgroundColor = kMainRedColor()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reusedCellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.addSubview(tableView)
    }
    
    override func layoutSubview() 
    {
        tableView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(self)
        }
    }
    
    func setupNotification() -> Void 
    {
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(handleInnerTableViewCanScrollNotification), 
                                               name: NSNotification.Name(rawValue: kUserDetailInnerTableViewCanScrollNotification), 
                                               object: nil)
    }
    
    @objc func handleInnerTableViewCanScrollNotification() -> Void 
    {
        tableView.isScrollEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension MTTTabBaseView:UITableViewDelegate,UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int 
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
    {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedCellId)
        if cell == nil 
        {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: reusedCellId)
        }
        cell?.textLabel?.text = "\(indexPath.item)"
        
        return cell!
    }
}

extension MTTTabBaseView:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) 
    {
        print("MTTTabBaseView:\(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y <= 0.0 
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kUserDetailOuterTableViewCanScrollNotification), object: nil)
            self.tableView.contentOffset = CGPoint(x: 0, y: 0)
            self.tableView.isScrollEnabled = false
        }
    }
}
