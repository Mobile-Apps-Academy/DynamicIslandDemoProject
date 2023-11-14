//
//  FoodDeliveryAttributes.swift
//  DynamicIslandDemoProject
//
//  Created by Javid Shaikh on 13/11/23.
//

import Foundation
import ActivityKit

struct FoodDeliveryAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var arrivalTime: String
        var phoneNumber: String
        var restaurantName: String
        var customerAddress: String
    }
}
