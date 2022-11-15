//
//  Message.swift
//  Visualize_Data
//
//  Created by Hieu Vuong on 2022-11-12.
//

import Foundation

//final class Message: Codable {
//    var id: Int?
//    var message: String
//    init(message: String){
//        self.message = message
//    }
//}

final class ProjectRegis: Codable {
    var leader: String
    var projectName: String
    var projectPeople: String
    var projectActivities: String
    init(leader: String, projectName: String, projectPeople: String, projectActivities: String){
        self.leader = leader
        self.projectName = projectName
        self.projectPeople = projectPeople
        self.projectActivities = projectActivities
    }
}
