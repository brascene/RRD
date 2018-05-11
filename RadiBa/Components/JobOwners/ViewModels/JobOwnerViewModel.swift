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
    
    func savePhoneCallRating(with stars: Int) {
        // save stars for phone call
    }
}

class SingleJob {
    var jobName: String = ""
    var jobTags: [String] = []
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
