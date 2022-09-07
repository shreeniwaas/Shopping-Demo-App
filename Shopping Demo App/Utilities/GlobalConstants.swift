//
//  GlobalConstants.swift
//  Shopping Demo App
//
//  Created by Srinivas Katta on 07/09/22.
//

import Foundation
struct APIConstants{
    static var baseURL = "free.beeceptor.com"
    static var babyProcutsAPI = "https://getbabyfoodsOne.\(baseURL)"
    static var chocolateAPI = "https://getchocolateslistOne.\(baseURL)"

}
struct APIMethods{
    static var getMethod = "GET"
}
struct Headers{
    static var appJson = "application/json"
    static var contentKey = "Content-Type"
}
