//
//  DetailViewController.swift
//  WxTouTiao
//
//  Created by Tebuy on 2018/1/30.
//  Copyright © 2018年 Tebuy. All rights reserved.
//

import UIKit
import WebKit
import LeoDanmakuKit

class DetailViewController: UIViewController {
    var webView : WKWebView!
    var post : Post!
    var danmuOnoff = true
    
    
    @IBOutlet weak var danmuView: LeoDanmakuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHtml()
        loadDanmu(comments: post.comments, postAComment:nil)
    }
    func loadDanmu(comments: [Comment]? = nil, postAComment: String? = nil) {
        if danmuOnoff {
            danmuView.resume()
            if let comments = comments {
                let danmus : [LeoDanmakuModel] = comments.map{
                    let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                    let str = $0.content.replacingOccurrences(of: "<p>", with: "")
                    let str1 = str.replacingOccurrences(of: "</p>", with: "")
                    model?.text = str1
                    return model!
                }
                danmuView.addDanmaku(with: danmus)
            }
            if let comment = postAComment {
                let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                model?.text = comment
                danmuView.addDanmaku(model)
            }
        }else{
            danmuView.stop()
        }
    }
    func loadHtml() {
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64)
        webView = WKWebView(frame: frame)
        view.insertSubview(webView, at: 0)
        //        webView.load(URLRequest(url: url))
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" >
        <style>
        img {width: 100%} body {font-size:100%}
        </style>
        <title>\(title!.description)</title>
        </head>
        <body>
        \(post.content!)
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
