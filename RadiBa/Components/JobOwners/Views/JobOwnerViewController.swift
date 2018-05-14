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
    @IBOutlet weak var tableMaskTop: NSLayoutConstraint!  // 31 default
    @IBOutlet weak var interestedTop: NSLayoutConstraint!  // 0 default
    
    var viewModel: JobOwnerViewModel = JobOwnerViewModel()
    var currentJobExpanded = false
    var currentJobExpandedIndex = -1
    
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
        return viewModel.appliedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhonesTableViewCell", for: indexPath) as! PhonesTableViewCell
        cell.selectionStyle = .none
        cell.setupTable(with: viewModel.appliedUsers[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked on cell")
    }

    func numberOfItems(in carousel: iCarousel) -> Int {
        return viewModel.openJobs.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let jobCard: JobCard = .fromNib()
        jobCard.delegate = self
        jobCard.layer.cornerRadius = 11.0
        
        if viewModel.screenStatus == .NoUsers {
            jobCard.featuresLabel.text = "Nema konkretnih zathjeva za poziciju"
            jobCard.arrow.isHidden = true
            jobCard.featuresLabel.isUserInteractionEnabled = false
        } else {
            jobCard.featuresLabel.isUserInteractionEnabled = true
            jobCard.arrow.isHidden = false
            jobCard.arrow.isUserInteractionEnabled = true
            jobCard.singleJob = viewModel.openJobs[index]
        }
                
        carousel.frame = jobCard.layer.bounds
        return jobCard
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
            
            UIView.animate(withDuration: 0.7, animations: {
                self.tableView.alpha = 1.0
                self.tableView.layer.transform = CATransform3DIdentity
            }) { _ in
                if self.currentJobExpanded {
                    self.changeJobCardView(for: carousel.currentItemIndex - 1, expanded: true)
                }
            }
        } else {
            tableView.alpha = 0.0
            let transform = CATransform3DTranslate(CATransform3DIdentity, -300, 0, 0)
            tableView.layer.transform = transform
            
            UIView.animate(withDuration: 0.7, animations: {
                self.tableView.alpha = 1.0
                self.tableView.layer.transform = CATransform3DIdentity
            }) { _ in
                if self.currentJobExpanded {
                    self.changeJobCardView(for: carousel.currentItemIndex + 1, expanded: true)
                }
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
        self.currentJobExpanded = true
        self.currentJobExpandedIndex = carousel.currentItemIndex
        changeJobCardView(for: carousel.currentItemIndex, expanded: expanded)
    }
    
    func changeJobCardView(for index: Int, expanded: Bool) {
        let currentFrame = carousel.itemView(at: index)?.frame
        
        if expanded == false {
            let newFrame = CGRect(x: (currentFrame?.origin.x)!, y: ((currentFrame?.origin.y)!), width: (currentFrame?.size.width)!, height: (currentFrame?.size.height)! + 20)
            
            let civ = self.carousel.itemView(at: index) as! JobCard
            
            self.tableMaskTop.constant += 20
            self.interestedTop.constant += 20
            
            UIView.animate(withDuration: 0.6, animations: {
                civ.frame = newFrame
                self.view.layoutIfNeeded()
                civ.layoutSubviews()
            }) { (finished) in
                if finished {
                    civ.arrow.transform = civ.arrow.transform.rotated(by: .pi)
                    civ.contentViewExpanded = true
                    civ.layoutSubviews()
                }
            }
        } else {
            let newFrame = CGRect(x: (currentFrame?.origin.x)!, y: (currentFrame?.origin.y)!, width: (currentFrame?.size.width)!, height: (currentFrame?.size.height)! - 20)
            let civ = self.carousel.itemView(at: index) as! JobCard

            self.tableMaskTop.constant -= 20
            self.interestedTop.constant -= 20
            
            UIView.animate(withDuration: 0.6, animations: {
                civ.frame = newFrame
                civ.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }) { (finished) in
                if finished {
                    civ.arrow.transform = civ.arrow.transform.rotated(by: -.pi)
                    civ.jobContentView.roundCorners([.bottomLeft, .bottomRight], radius: 11.0)
                    civ.contentViewExpanded = false
                    self.currentJobExpanded = false
                }
            }
        }
    }
}

