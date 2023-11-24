//
//  LiveActivityManager.swift
//  DynamicIslandDemoProject
//
//  Created by Javid Shaikh on 13/11/23.
//

import Foundation
import ActivityKit

class LiveActivityManager {
    
    @discardableResult
    static func startActivity(arrivalTime: String, phoneNumber: String, restaurantName: String, customerAddress: String, remainingDistance: String) throws -> String {
       
        var activity: Activity<FoodDeliveryAttributes>?
        let initialState =  FoodDeliveryAttributes.ContentState(arrivalTime: arrivalTime, phoneNumber: phoneNumber, restaurantName: restaurantName, customerAddress: customerAddress, remainingDistance: remainingDistance)
        
        do {
            activity = try Activity.request(attributes: FoodDeliveryAttributes(), contentState: initialState, pushType: nil)
            
            guard let id = activity?.id else { throw
                LiveActivityErrorType.failedToGetID }
            return id
        } catch {
            throw error
        }
    }
        
    static func listAllActivities() -> [[String:String]] {
        let sortedActivities = Activity<FoodDeliveryAttributes>.activities.sorted{ $0.id > $1.id }
        
        return sortedActivities.map {
            [
                "id": $0.id,
                "arrivalTime": $0.contentState.arrivalTime,
                "phoneNumber": $0.contentState.phoneNumber,
                "restaurantName": $0.contentState.restaurantName,
                "customerAddress": $0.contentState.customerAddress,
                "remainingDistance": $0.contentState.remainingDistance
            ]
        }
    }
    
    static func endAllActivities() async {
        for activity in Activity<FoodDeliveryAttributes>.activities {
            await activity.end(dismissalPolicy: .immediate)
        }
    }
    
    static func endActivity(_ id: String) async {
        await Activity<FoodDeliveryAttributes>.activities.first(where: {
            $0.id == id
        })?.end(dismissalPolicy: .immediate)
    }
    
    static func updateActivity(id: String, arrivalTime: String, phoneNumber: String, restaurantName: String, customerAddress: String, remainingDistnace: String) async {
        
        let updatedContentState = FoodDeliveryAttributes.ContentState(arrivalTime: arrivalTime, phoneNumber: phoneNumber, restaurantName: restaurantName, customerAddress: customerAddress, remainingDistance: remainingDistnace)
        
        let activity = Activity<FoodDeliveryAttributes>.activities.first(where: { $0.id == id })
        
        await activity?.update(using: updatedContentState)
    }
    
}

enum LiveActivityErrorType: Error {
    case failedToGetID
}
