//
//  ViewController.swift
//  SwiftExample
//
//  Created by Nick Lockwood on 30/07/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

import UIKit

class JobOwnerViewController: UIViewController, iCarouselDataSource, iCarouselDelegate, UITableViewDelegate, UITableViewDataSource, ArrowProtocol {
    
    var items: [Int] = []
    var currentJobIndex: Int = 0
    @IBOutlet var carousel: iCarousel!
    @IBOutlet weak var carouselHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewJob: UIButton!
    @IBOutlet weak var tableMask: UIView!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var noUsersView: UIView!
    @IBOutlet weak var noJobBackground: UIImageView!
    
    var viewModel: JobOwnerViewModel = JobOwnerViewModel()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if viewModel.screenStatus == .NoUsers {
            items = [1]
        } else {
            for i in 0 ... 5 {
                items.append(i)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScreen()
        setupTableGradient()
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
        
        viewModel.getOwnerData()
    }
    
    func setupScreen() {
        switch viewModel.screenStatus {
            case .NoJobs:
                carousel.isHidden = true
                tableMask.isHidden = true
                interestedLabel.isHidden = true
                noUsersView.isHidden = true
                noJobBackground.isHidden = false
            case .NoUsers:
                tableMask.isHidden = true
                interestedLabel.isHidden = true
                carousel.isHidden = false
                noUsersView.isHidden = false
                noJobBackground.isHidden = true
            default:
                carousel.isHidden = false
                tableMask.isHidden = false
                interestedLabel.isHidden = false
                noUsersView.isHidden = true
                noJobBackground.isHidden = true
        }
    }
    
    func setupTableGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = tableMask.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0 as NSNumber, 1.0 / 16.0 as NSNumber, 15.0 / 16.0 as NSNumber, 1 as NSNumber]
        tableMask.layer.mask = gradient
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhonesTableViewCell", for: indexPath) as! PhonesTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked on cell")
    }

    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let testView: JobCard = .fromNib()
        testView.delegate = self
        testView.layer.cornerRadius = 11.0
        
        if viewModel.screenStatus == .NoUsers {
            testView.featuresLabel.text = "Nema konkretnih zathjeva za poziciju"
            testView.arrow.isHidden = true
            testView.featuresLabel.isUserInteractionEnabled = false
        } else {
            testView.featuresLabel.isUserInteractionEnabled = true
            testView.arrow.isHidden = false
            testView.arrow.isUserInteractionEnabled = true
        }
                
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
            tableView.alpha = 0.0
            let transform = CATransform3DTranslate(CATransform3DIdentity, 400, 0, 0)
            tableView.layer.transform = transform
            
            UIView.animate(withDuration: 0.7) {
                self.tableView.alpha = 1.0
                self.tableView.layer.transform = CATransform3DIdentity
            }
        } else {
            tableView.alpha = 0.0
            let transform = CATransform3DTranslate(CATransform3DIdentity, -300, 0, 0)
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
    
    func arrowClicked(expanded: Bool) {
        let currentFrame = carousel.currentItemView?.frame

        if expanded == false {
            let newFrame = CGRect(x: (currentFrame?.origin.x)!, y: ((currentFrame?.origin.y)! - 20), width: (currentFrame?.size.width)!, height: (currentFrame?.size.height)! + 40)
            
            let currentItemView = self.carousel.currentItemView as! JobCard
            
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
            let currentItemView = self.carousel.currentItemView as! JobCard
            
            UIView.animate(withDuration: 0.6, animations: {
                currentItemView.frame = newFrame
                currentItemView.layoutSubviews()
                currentItemView.layoutIfNeeded()
            }) { (finished) in
                if finished {
                    currentItemView.arrow.transform = currentItemView.arrow.transform.rotated(by: -.pi)
                    currentItemView.jobContentView.roundCorners([.bottomLeft, .bottomRight], radius: 11.0)
                }
            }
        }
    }
}

