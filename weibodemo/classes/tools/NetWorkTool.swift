//
//  NetWorkTool.swift
//  nettool
//
//  Created by macliu on 2021/1/18.
//

import AFNetworking


enum RequestType : String{
    case GET = "GET"
    case POST = "POST"
}
class NetWorkTool: AFHTTPSessionManager {
    //let 线程安全
    //manager.responseSerializer.acceptableContentTypes = [NSSetsetWithObjects:@"application/json",@"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    
    static let shareIntance : NetWorkTool = {
        let tools = NetWorkTool()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        tools.responseSerializer.acceptableContentTypes?.insert("application/json")
        tools.responseSerializer.acceptableContentTypes?.insert("text/json")
        tools.responseSerializer.acceptableContentTypes?.insert("text/javascript")
  
        return tools
    }()
    
    // 定义请求完成的回调的别名
    typealias httptoolBack = (_ response:AnyObject?,_ error:Error?)->()
    
}

// MARK:- 封装
extension NetWorkTool {
    func request(methodType : RequestType,urlString: String, parameters:[String: AnyObject]?, finished : @escaping (_ result: Any?,_ error:Error?) -> () ) {
        
        
        //定义成功回调函数格式
        let successCallBack = { (task: URLSessionDataTask,result: Any?) in
        
            finished(result,nil)
       }
        //
        let failCallBack = {(task: URLSessionDataTask?,error:Error) in
            
            //针对403 token过期 做处理
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                print("Token 过期了")
            }
            finished(nil,error)
        }
        
        
        
        
        if methodType == .GET {
              get(urlString, parameters: parameters, headers: nil, progress: nil, success: successCallBack, failure:failCallBack)
        }else{
            post(urlString, parameters: parameters, headers: nil, progress: nil, success: successCallBack, failure:failCallBack)
        }

        
       
  
    }
}
// MARK:- 请求accesscode
extension NetWorkTool {
    func loadAccessToken(code : String,endblock :@escaping (_ myresult : [String : AnyObject]? , _ myerror : Error?) -> ()) {
        //1. url地址
        let urlString = "https://api.weibo.com/oauth2/access_token"
        //2参数
        let parameters =  ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "code" : code, "redirect_uri" : redirect_uri]
        //3发送
        
        request(methodType: .POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (res, err) in
            endblock(res as? [String : AnyObject],err)
        }
        
    }
    //请求用户数据
    func loadUserInfo(access_token : String,uid : String,finish :@escaping (_ myresult : [String : AnyObject]? ,  _ myerror : Error?) -> ()) {
        //1
        let urlString = "https://api.weibo.com/2/users/show.json"
       // https://api.weibo.com/2/users/show.json?access_token=df2732399a93003ff56fbcfa838bde08&uid=1427368827
        //2uid    String?    "1427368827"    some
        let parameters = ["access_token" : access_token,"uid" : uid]
        //https://api.weibo.com/2/users/show.json?access_token=2.00rpFbYBK6b4RDf70f1ae2e4iejuJE&uid=1427368827
      //  Status Code: 403,
        //3
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (res, err) in
            finish(res as? [String : AnyObject],err)
        }
       
    }
    //
    
    
}
// MARK:- 请求主页信息
extension NetWorkTool {
    func loadStatuses(sinceid : Int, max_id : Int,finish :@escaping (_ result : [[String : AnyObject]]? ,  _ error : Error?) -> ()) {
        //1. url
        //1
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        //2
        let parameters = ["since_id" : "\(sinceid)","max_id" : "\(max_id)","access_token" : (UserAccountViewMode.shareInstance.account?.access_token)!]
        
        //3
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (res, err) in
            //
            guard let resultDict = res as? [String : AnyObject] else {
                finish(nil,err)
                return
            }
            
            finish(resultDict["statuses"] as? [[String : AnyObject]],err)
        }
    }
    
}
// MARK:- 发送微博
extension NetWorkTool {
    func sendStatus(statusText : String ,isSuccess :@escaping ((_ isSuccess : Bool) -> ()) ){
        //1.url
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        
        //2
        let parameters = ["status" : statusText,"access_token" : (UserAccountViewMode.shareInstance.account?.access_token)!]
        //3.
        request(methodType: .GET, urlString: urlString, parameters: parameters as [String : AnyObject]) { (res, err) in
            //
            if res != nil {
                isSuccess(true)
            } else {
                isSuccess( false)
            }
            
        }
        
    }
}
// MARK:- 发送微博+图
extension NetWorkTool {
    func sendStatus(statusText : String ,image : UIImage,isSuccess :@escaping ((_ isSuccess : Bool) -> ()) ){
        //1.url
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        
        //2
        let parameters = ["status" : statusText,"access_token" : (UserAccountViewMode.shareInstance.account?.access_token)!]
        
        //3发送微博
     //
        post(urlString, parameters: parameters, headers: nil,constructingBodyWith:{ (formData) in
            
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                formData.appendPart(withFileData: imageData, name: "pic", fileName: "123.jpg", mimeType: "image/png")
            }
  
        },progress: nil, success: { (_, _) in
            isSuccess(true)
        }) { (_, error) in
            isSuccess(false)
        }

        
    }
}
