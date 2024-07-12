//
//  APIRequest.swift
//  MovieApp
//
//  Created by MMahdiMokadem on 11/07/2024.
//

import Foundation
import Alamofire

class APIRequest<T: Decodable> {
    var url: URLConstants!
    var method: HTTPMethod!
    var params: [String: Any]?
    var headers: HTTPHeaders
    var responseObjectType: T.Type!
    var interceptor: Bool!
    var tokenInterceptor = TokenInterceptor()
    var encoding: ParameterEncoding?
    
    init(url: URLConstants, methode: HTTPMethod, responseObjectType: T.Type, params: [String: Any]?, encoding: ParameterEncoding? = nil, headers: HTTPHeaders?, authentication: Bool = false, interceptor: Bool, notificationToken: Bool = false) {
                
        self.url = url
        self.method = methode
        self.responseObjectType = responseObjectType
        self.params = params
        self.headers = headers ?? []
        self.interceptor = interceptor
        self.encoding = encoding
        setDeafultHeaders()
        
        if authentication {
            self.addAuthentication()
        }
        
        if notificationToken {
            self.addNotificationToken()
        }
    }
    
    func request() async throws -> T  {
        
        return try await withCheckedThrowingContinuation ({ continuation in
            request(urlString: url.urlString, method: method, params: params, encoding: encoding, headers: headers, withAuthorizationInterceptor: interceptor, objectType: responseObjectType) { response, error in
                if let response {
                    continuation.resume(returning: response)
                }else{
                    continuation.resume(throwing: error ?? ResponseError.defaultError())
                }
            }
        })
    }
    
    func setDeafultHeaders() {
        self.headers.add(name: "Content-Type", value: "application/json")
    }
    
    func addAuthentication() {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MGQ1NzMyYjdmMGM1YjVjYjJkNmQzNjI4ZWU0ZmUwYSIsIm5iZiI6MTcyMDY5NzE2Mi43NjQ2OTYsInN1YiI6IjY2OGU1ZWM2ODQyZjlhYTkyM2IzMDdiMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.cv7klbX5LSlMyNy4Ypfj_gYFWG2n6RGXWzZLS_FCLrg"
        self.headers.add(name: "Authorization", value: "Bearer \(token)")
    }

    func addNotificationToken() {
        self.headers.add(name: "x-notification-token", value: "APNS_TOKEN")
    }
    
    private func request<T: Decodable>(urlString: String, method: HTTPMethod, params: Parameters? = nil, encoding: ParameterEncoding? = nil ,headers: HTTPHeaders?, withAuthorizationInterceptor: Bool? = false, URLParams: [String:String]? = nil, objectType: T.Type, completion: @escaping (T?, ResponseError?) -> Void) {
        
        if let validURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: validURL) {
            
            let request = AF.request(url, method: method, parameters: params, encoding: encoding ?? URLEncoding.default, headers: headers, interceptor: ((withAuthorizationInterceptor ?? false) ? tokenInterceptor : nil)) { $0.timeoutInterval = 45 }
            
            print("[API REQUEST] Start: \(urlString)")
            
            request
                .validate()
                .validate(contentType: ["application/json"])
                .validate(statusCode: 200..<300)
                .responseDecodable(of: objectType.self, completionHandler: { response in
                    let duration = response.metrics?.taskInterval.duration
                    _ = response.error.debugDescription
                    let statusCode = response.response?.statusCode
                    
                    guard let responseObject = response.value else {
                        if let data = response.data, let responseJSon = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
                            print("[API REQUEST] Error: \(urlString), duration \(duration.orDefault()), statusCode: \(statusCode.orDefault()), response: \(responseJSon)")
                        }else{
                            print("[API REQUEST] Error: \(urlString), duration \(duration.orDefault()), statusCode: \(statusCode.orDefault()), response: nil")
                        }
                        
                        if let urlError = response.error?.underlyingError as? URLError, urlError.code == .notConnectedToInternet {
                            print("[API REQUEST] Error: No Internet Connection: \(urlString), duration \(duration.orDefault())")
                            
                            let error = ResponseError(type: .ERR_NO_INTERNET_CONNECTION, message: "No internet connection", statusCode: 0)
                            
                            completion(nil, error)
                        } else {
                            print("[API REQUEST] Error: Something went wrong: \(urlString), duration \(duration.orDefault())")
                            completion(nil, ResponseError(type: .ERR_SOMETHING_WENT_WRONG, message: "Something went wrong from our side.", statusCode: statusCode ?? 0))
                        }
                        return
                    }
                    
                    print("[API REQUEST] End: \(urlString), duration \(duration.orDefault()), statusCode: \(statusCode.orDefault())")
                    
                    completion(responseObject, nil)
                })
        }else{
            print("[API REQUEST] Error: URL corrupted: \(urlString), ")
            completion(nil, ResponseError(type: .ERR_SOMETHING_WENT_WRONG, message: "Something went wrong from our side.", statusCode: 0))
        }
    }

    private func checkInternetConnection() {
        let reachabilityManager = NetworkReachabilityManager()
        
        reachabilityManager?.startListening(onUpdatePerforming: { status in
            switch status {
            case .unknown, .notReachable:
                print("No Internet Connection")
                // Handle the case where there is no internet connection
            case .reachable:
                print("Internet Connection Available")
                // Proceed with your network request or other tasks requiring internet connectivity
            }
        })
    }
}

enum APIResult<T> {
    case success(T)
    case failure(ResponseError)
}

class ResponseError: NSError {
    var type: ResponseErrorType
    var message: String
    var statusCode: Int
    
    init() {
        self.type = .ERR_DEFAULT
        self.message = ""
        self.statusCode = 0
        super.init(domain: "", code: 0, userInfo: nil)
    }
    
    convenience init(type: ResponseErrorType, message: String, statusCode: Int){
        self.init()
        self.type = type
        self.message = message
        self.statusCode = statusCode
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func defaultError() -> ResponseError{
        return ResponseError(type: ResponseErrorType.ERR_DEFAULT, message: "", statusCode: 0)
    }
}

enum ResponseErrorType: String {
    case ERR_DEFAULT = "ERR_DEFAULT"
    case ERR_NO_INTERNET_CONNECTION = "ERR_NO_INTERNET_CONNECTION"
    case ERR_SOMETHING_WENT_WRONG = "ERR_SOMETHING_WENT_WRONG"
}
