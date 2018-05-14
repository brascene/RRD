//
//  JobOwnerViewModel.swift
//  RadiBa
//
//  Created by Dino Pelic on 5/11/18.
//  Copyright © 2018 Ant Colony. All rights reserved.
//

import Foundation

class AppliedUser {
    var userName: String = ""
    var phoneNumber: String = ""
    var userImage: UIImage = UIImage()
    var isRated: Bool = false
    var ratingNumber: Int = -1
    
    init (userName: String, phone: String, image: UIImage, rated: Bool, ratingNumber: Int) {
        self.userName = userName
        self.phoneNumber = phone
        self.userImage = image
        self.isRated = rated
        self.ratingNumber = ratingNumber
    }
    
    func savePhoneCallRating(with stars: Int) {
        // save stars for phone call
    }
}

class SingleJob {
    var jobName: String = ""
    var jobTags: [String] = []
    
    init(name: String, tags: [String]) {
        self.jobName = name
        self.jobTags = tags
    }
}

enum OwnerScreenStatus: Int {
    case Full = 1
    case NoJobs = 2
    case NoUsers = 3
}

class JobOwnerViewModel: JobOwnerInteractorOutput {
    var ownerName: String = ""
    var openJobs: [SingleJob] = []
    var appliedUsers: [AppliedUser] = []
    var screenStatus: OwnerScreenStatus = .Full
    
    let interactor: JobOwnerInteractor?
    
    init() {
        interactor = JobOwnerInteractor()
        interactor?.output = self
        
        let app1 = AppliedUser(userName: "Dino Pelic", phone: "+38762436669", image: UIImage(), rated: true, ratingNumber: 4)
        let app2 = AppliedUser(userName: "John Doe", phone: "+38762436669", image: UIImage(), rated: false, ratingNumber: 5)
        let app3 = AppliedUser(userName: "Lepi Lepi", phone: "+38762436669", image: UIImage(), rated: true, ratingNumber: 3)
        let app4 = AppliedUser(userName: "Chimp Monkey", phone: "+38762436669", image: UIImage(), rated: false, ratingNumber: 4)
        
        self.appliedUsers = [app1, app2, app3, app4]
        
        let sg1 = SingleJob(name: "Job Name 1", tags: ["3+ godine iskustva", "fleksibilnost", "poznavanje engleskog jezika"])
        let sg2 = SingleJob(name: "Job Name 2", tags: ["3+ godine iskustva", "fleksibilnost", "poznavanje engleskog jezika", "poznavanje rada na racunaru"])
        let sg3 = SingleJob(name: "Job Name3 ", tags: ["3+ godine iskustva", "fleksibilnost", "poznavanje engleskog jezika", "poznavanje rada na racunaru", "poznavanje jos nekih gluposti", "da voli poes i popit"])
        let sg4 = SingleJob(name: "Job Name 4", tags: ["3+ godine iskustva", "fleksibilnost", "poznavanje engleskog jezika", "takodje neki bla bla bla osobine vrline mahane itd", "bitno je da ostanes sto duze ako te posalju na teren"])
        
        self.openJobs = [sg1, sg2, sg3, sg4]
    }
    
    func deleteJob() {
        interactor?.deleteJob()
    }
    
    func createJob() {
        interactor?.createJob()
    }
    
    func getOwnerData() {
        interactor?.getOwnerData()
    }
    
    func ownerDataRetrieved(success: Bool, data: JobOwnerViewModel?, error: Error?) {
        // fill data
        determineScreenStatus()
    }
    
    func determineScreenStatus() {
        if openJobs.count == 0 {
            screenStatus = .NoJobs
        } else {
            if appliedUsers.count == 0 {
                screenStatus = .NoUsers
            } else {
                screenStatus = .Full
            }
        }
    }
    
}
