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
import LLSwitch
import WZLBadge

class DetailViewController: UIViewController , LLSwitchDelegate{
    var webView : WKWebView!
    var post : Post!
    var isDanmuOn = true
    
    @IBOutlet weak var danmuSwitch: LLSwitch!
    @IBOutlet weak var danmuView: LeoDanmakuView!
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBAction func editBegin(_ sender: UITextField) {
        danmuSwitch.isHidden = true
        commentBtn.isHidden = true
    }
    @IBAction func clickComment(_ sender: UIButton) {
        doJavaScriptFunction()
    }
    @IBAction func editDone(_ sender: UITextField) {
        danmuSwitch.isHidden = false
        commentBtn.isHidden = false
        
        guard let commentText = sender.text else { return  }
        loadDanmu(postAComment: commentText)
        print("发表评论")
        Post.submitComment(postId: post.id, name: "Lee", email: "example@example.com", content: commentText) { (finish) in
            if finish {
                print("评论成功")
                OperationQueue.main.addOperation {
                    self.showCommentBadge(self.post.comment_count + 1)
                    NotificationCenter.default.post(name: NotificationHelper.updateList, object: nil)
                }
            }else {
                print("评论失败")
            }
        }
        sender.text = ""
    }
    func didTap(_ llSwitch: LLSwitch!) {
        if isDanmuOn {
            danmuSwitch.setOn(false, animated: true)
            danmuView.stop()
            danmuView.isHidden = true
            print("弹幕关闭")
        }else{
            danmuSwitch.setOn(true, animated: true)
            danmuView.resume()
            danmuView.isHidden = false
            print("弹幕开启")
        }
        isDanmuOn = !isDanmuOn
    }
    func showCommentBadge(_ count: Int) {
        if count > 0 {
            commentBtn.badgeCenterOffset = CGPoint(x: -13, y: 5)
            commentBtn.showBadge(with: .number, value: count, animationType: .bounce)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHtml()
        loadDanmu(comments: post.comments, postAComment:nil)
        danmuSwitch.delegate = self
        showCommentBadge(post.comment_count)
    }
    func loadDanmu(comments: [Comment]? = nil, postAComment: String? = nil) {
        if isDanmuOn {
            danmuView.resume()
            if let comments = comments {
                let danmus : [LeoDanmakuModel] = comments.map{
                    let model = LeoDanmakuModel.randomDanmku(withColors: UIColor.danmu, maxFontSize: 30, minFontSize: 15)
                    model?.text = $0.content.html2String
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
        let frame = CGRect(x: 0, y: 64, width: view.bounds.width, height: view.bounds.height - 64 - 40)
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
        <script src="https://cdn.bootcss.com/jquery/3.3.1/jquery.min.js"></script>
        <title>\(title!.description)</title>
        </head>
        <body>
        \(post.content!)<hr id="commentAnchor">\(commentHtml(comments: post.comments))
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
    func doJavaScriptFunction() {
        let js1 = """
                    $(document).ready(function() {
                            $('html, body').animate({
                                scrollTop: $("#commentAnchor").offset().top
                            }, 1000);
                    });
                  """
        let js2 = "window.location.hash = \"commentAnchor\""
        webView.evaluateJavaScript(js1) { (result, error) in
            print("执行结果",result,error)
        }
        
    }
    func commentHtml(comments: [Comment]) -> String {
        var result = ""
        for comment in comments {
            let paragaph = "<p><h5></h5>\(comment.name!)<h6>\(comment.content!)</h6><hr size=1></p>"
            result += paragaph
        }
        return result
        
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
