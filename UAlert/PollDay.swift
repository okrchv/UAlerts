//
//  PollDay.swift
//  UAlert
//
//  Created by Oleh Kiurchev on 03.11.2022.
//

import Foundation
import UkraineAlertAPI

public struct PollDay: Hashable {
    public var date: Date
    public var alerts: [AlertType: Int]
}
