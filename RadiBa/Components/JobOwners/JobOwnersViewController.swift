//
//  ViewController.swift
//  SwiftExample
//
//  Created by Nick Lockwood on 30/07/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

import UIKit

class JobOwnersViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, UITableViewDelegate, UITableViewDataSource, ArrowProtocol {
    
    var items: [Int] = []
    var currentJobIndex: Int = 0
    @IBOutlet var carousel: iCarousel!
    @IBOutlet weak var carouselHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewJob: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0 ... 5 {
            items.append(i)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .linear
        carousel.scrollSpeed = 0.7
        carousel.decelerationRate = 0.4
        setupCarouselShadow()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let phoneNib = UINib(nibName: "PhonesTableViewCell", bundle: nil)
        tableView.register(phoneNib, forCellReuseIdentifier: "PhonesTableViewCell")
        
        addNewJob.backgroundColor = .addJobColor()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhonesTableViewCell", for: indexPath) as! PhonesTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.0
        let transform = CATransform3DTranslate(CATransform3DIdentity, -300, 50, 5)
        cell.layer.transform = transform
        
        UIView.animate(withDuration: 1) {
            cell.alpha = 1.0
            cell.layer.transform = CATransform3DIdentity
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let testView: TestContent = .fromNib()
        testView.delegate = self
        testView.layer.cornerRadius = 11.0
        
        carousel.frame = testView.layer.bounds
        return testView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.03
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if carousel.currentItemIndex > currentJobIndex {
            // svajpno sam prema desno
            tableView.alpha = 0.0
            let transform = CATransform3DTranslate(CATransform3DIdentity, 400, 50, 5)
            tableView.layer.transform = transform
            
            UIView.animate(withDuration: 0.7) {
                self.tableView.alpha = 1.0
                self.tableView.layer.transform = CATransform3DIdentity
            }
        } else {
            // svajpno sam prema lijevo
            tableView.alpha = 0.0
            let transform = CATransform3DTranslate(CATransform3DIdentity, -300, 50, 5)
            tableView.layer.transform = transform
            
            UIView.animate(withDuration: 0.7) {
                self.tableView.alpha = 1.0
                self.tableView.layer.transform = CATransform3DIdentity
            }
        }
        currentJobIndex = carousel.currentItemIndex
    }
    
    func setupCarouselShadow() {
        carousel!.layer.cornerRadius = 11
        carousel!.layer.shadowOffset = CGSize(width: 0, height: 15)
        carousel!.layer.shadowColor = UIColor(rgb: 0xa6adcc, alphaVal: 1.0).cgColor
        carousel!.layer.shadowRadius = 7.0
        carousel!.layer.shadowOpacity = 0.4
        carousel!.layer.masksToBounds = false;
        carousel!.clipsToBounds = false;
    }
    
    @objc func dajba() {
        print("clicked")
    }
    
    func arrowClicked(proto: TestContent, expanded: Bool) {
        let currentFrame = carousel.currentItemView?.frame

        if expanded == false {
            let newFrame = CGRect(x: (currentFrame?.origin.x)!, y: ((currentFrame?.origin.y)! - 20), width: (currentFrame?.size.width)!, height: (currentFrame?.size.height)! + 40)
            
            let currentItemView = self.carousel.currentItemView as! TestContent
            
            UIView.animate(withDuration: 0.6, animations: {
                currentItemView.frame = newFrame
                currentItemView.layoutIfNeeded()
                currentItemView.layoutSubviews()
            }) { (finished) in
                if finished {
                    currentItemView.arrow.transform = currentItemView.arrow.transform.rotated(by: .pi)
                }
            }
        } else {
            let newFrame = CGRect(x: (currentFrame?.origin.x)!, y: (currentFrame?.origin.y)! + 20, width: (currentFrame?.size.width)!, height: (currentFrame?.size.height)! - 40)
            let currentItemView = self.carousel.currentItemView as! TestContent
            
            UIView.animate(withDuration: 0.6, animations: {
                currentItemView.frame = newFrame
                currentItemView.layoutSubviews()
                currentItemView.layoutIfNeeded()
            }) { (finished) in
                if finished {
                    currentItemView.arrow.transform = currentItemView.arrow.transform.rotated(by: -.pi)
                    currentItemView.layoutSubviews()
                }
            }
        }
    }
    
    
}

