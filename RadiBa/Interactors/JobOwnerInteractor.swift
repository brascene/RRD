//
//  JobOwnerInteractor.swift
//  RadiBa
//
//  Created by Dino Pelic on 5/11/18.
//  Copyright © 2018 Ant Colony. All rights reserved.
//

import Foundation

protocol JobOwnerInteractorOutput {
    func ownerDataRetrieved(success: Bool, data: JobOwnerViewModel?, error: Error?)
}

class JobOwnerInteractor: ServiceOutput {
    var service: JobOwnerService = JobOwnerService()
    var output: JobOwnerInteractorOutput?
    
    init() {
        service.output = self
    }
    
    func getOwnerData() {
        service.getJobOwnerData()
    }
    
    func deleteJob() {
        
    }
    
    func createJob() {
        
    }
    
    func resultForCall(object: [String : AnyObject]?, error: Error?) {
        // implement
    }
}
