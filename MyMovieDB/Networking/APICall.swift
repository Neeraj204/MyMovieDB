//
//  APICall.swift
//  MyMovieDB
//
//  Created by Neeraj on 10/06/23.
//

import UIKit

public enum ApiCallResult<Value,ResponseError : GeneralResponseModel> {
    case success(Value)
    case failure(ResponseError)
    case error(Error?)
}

class APICall: NSObject {
    
    private let constValueField = "application/json"
    private let constHeaderField = "Content-Type"
    
    private var observationLoaderView: NSKeyValueObservation?
    
    public func get<T : Decodable>(apiUrl : String, model: T.Type, loaderInView : UIView? = nil, completion: @escaping (ApiCallResult<T,GeneralResponseModel>) -> ()) {
        requestMethod(apiUrl:apiUrl, params: [:], method: "GET",model: model, loaderInView : loaderInView, completion: completion)
    }
    
    public func requestMethod<T : Decodable>(apiUrl : String, params: [String: AnyObject], isToken: Bool = true, method: String, model: T.Type, loaderInView : UIView? = nil, completion: @escaping (ApiCallResult<T,GeneralResponseModel>) -> ()) {
        
        var loaderView : UIView?
        if var view = loaderInView {
            self.addLoaderInView(&view, loaderView:&loaderView)
        }
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = method
        request.setValue(constValueField, forHTTPHeaderField: constHeaderField)
        
        if !params.isEmpty {
            let jsonTodo: NSData
            do {
                jsonTodo = try JSONSerialization.data(withJSONObject: params, options: []) as NSData
                request.httpBody = jsonTodo as Data
            } catch {
                print("Error: cannot create JSON from todo")
                return
            }
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with : request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                if error != nil { completion(.error(error)) } else { completion(.error(nil)) }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(convertedJsonIntoDict)
                }
                
                //                let dictResponse = try decoder.decode(GeneralResponseModel.self, from: data )
                //
                //                let strStatus = dictResponse.status ?? 0
                //                if strStatus == 200 {
                let dictResponsee = try decoder.decode(model, from: data )
                mainThread {
                    completion(.success(dictResponsee))
                }
                //                }
                //                else{
                //                    mainThread {
                //                        completion(.failure(dictResponse))
                //                        debugPrint(dictResponse.message ?? 0)
                //                    }
                //                }
            } catch let error as NSError {
                debugPrint(error.localizedDescription)
                mainThread {
                    completion(.error(error))
                }
            }
            
            if let loaderView = loaderView {
                mainThread { loaderView.removeFromSuperview() }
            }
        })
        task.resume()
    }
    
    private func addLoaderInView(_ view: inout UIView, loaderView : inout UIView?) {
        loaderView = UIView(frame: view.bounds)
        loaderView?.backgroundColor = getBGColor(view)
        let activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        loaderView?.addSubview(activityIndicator)
        activityIndicator.anchorCenterSuperview()
        view.addSubview(loaderView!)
        observationLoaderView = view.observe(\UIView.bounds, options: .new) { [weak loaderView] view, change in
            if let value =  change.newValue {
                loaderView?.frame = value
            }
        }
    }
    
    private func getBGColor(_ view : UIView?) -> UIColor {
        guard let view = view , let bgColor = view.backgroundColor else {
            return .white
        }
        return bgColor == .clear ? getBGColor(view.superview) : bgColor
    }
    
}

public class GeneralResponseModel : Decodable {
    var message : String?
    var status : Int?
}
