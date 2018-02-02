//
//  MyService.swift
//  WxTouTiao
//
//  Created by Tebuy on 2018/1/26.
//  Copyright © 2018年 Tebuy. All rights reserved.
//

import Foundation
import Moya

enum MyService {
    case category
    case showCateNewList(id: Int)
    case submitComment(postId: Int, name: String, email: String, content: String)
}
extension MyService: TargetType {
    var baseURL: URL {
        let baseUrl = "http://192.168.2.1:8888/wordpress/api"
//        let baseUrl = "http://localhost:8888/wordpress/api"

        return URL(string: baseUrl)!
    }
    
    var path: String {
        switch self {
            case .category:
                return "/get_category_index"
        case .showCateNewList:
            return "/get_category_posts"
        case .submitComment:
            return "/respond/submit_comment/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .category, .showCateNewList, .submitComment:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .category:
            return "category test data".utf8Encoded
        case .showCateNewList(let id):
            return "newlist id is\(id)".utf8Encoded
        case .submitComment(let postId, let name, let email, let content):
            return "comment id is \(postId),\(name),\(email),\(content)".utf8Encoded
        }
    }
    
    var task: Task {
        switch self {
        case .category:
            return .requestPlain
        case .showCateNewList(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        case .submitComment(let postId, let name, let email, let content):
            return .requestParameters(parameters: ["post_id":postId, "name":name, "email":email, "content":content], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
         return ["Content-type": "application/json"]
    }
    
}
// MARK: - Helpers
private extension String {
        var urlEscaped: String {
            return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        
        var utf8Encoded: Data {
            return data(using: .utf8)!
        }
}
