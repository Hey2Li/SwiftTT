//
//  HtmlToString.swift
//  WxTouTiao
//
//  Created by Tebuy on 2018/2/1.
//  Copyright © 2018年 Tebuy. All rights reserved.
//

//将换油HTML的String转换为没有HTMLString的字符串
extension String {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType:NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch  {
            print(error)
            return nil
        }
    }
    var html2String:String {
        return html2AttributedString?.string ?? ""
    }
}
