//
//  NetworkSession.swift
//
//  Created by Amen ASSOGBA on 07/05/2021.
//  Copyright © 2021  Amen IO. All rights reserved.
//
//  Create  a URLSessionTask. The caller is responsible for calling resume().
//

import Foundation

public protocol NetworkSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask?
  func uploadTask(with request: URLRequest, from fileURL: URL, progressHandler: ProgressHandler?, completion: @escaping (Data?, URLResponse?, Error?)-> Void) -> URLSessionUploadTask?
  
}

class NetworkSession: NSObject {
  
  var session: URLSession!
  private typealias ProgressAndCompletionHandlers = (progress: ProgressHandler?, completion: ((URL?, URLResponse?, Error?) -> Void)?)
  private var taskToHandlersMap: [URLSessionTask : ProgressAndCompletionHandlers] = [:]
  
  public override convenience init() {
    
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.timeoutIntervalForResource = 30
    if #available(iOS 11, *) {
      sessionConfiguration.waitsForConnectivity = true
    }
    
    // Create an `OperationQueue` instance for scheduling the delegate calls and completion handlers.
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 3
    queue.qualityOfService = .userInitiated
    
    self.init(configuration: sessionConfiguration, delegateQueue: queue)
  }
  
  public init(configuration: URLSessionConfiguration, delegateQueue: OperationQueue) {
    super.init()
    self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: delegateQueue)
  }
  
  private func set(handlers: ProgressAndCompletionHandlers?, for task: URLSessionTask) {
    taskToHandlersMap[task] = handlers
  }
  
  private func getHandlers(for task: URLSessionTask) -> ProgressAndCompletionHandlers? {
    return taskToHandlersMap[task]
  }
  
  deinit {
    session.invalidateAndCancel()
    session = nil
  }
}

extension NetworkSession: NetworkSessionProtocol {
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask? {
    let dataTask = session.dataTask(with: request) { (data, response, error) in
      completionHandler(data, response, error)
    }
    return dataTask
  }
  
  func uploadTask(with request: URLRequest, from fileURL: URL, progressHandler: ProgressHandler? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask? {
    let uploadTask = session.uploadTask(with: request, fromFile: fileURL, completionHandler: { (data, urlResponse, error) in
      completion(data, urlResponse, error)
    })

    set(handlers: (progressHandler, nil), for: uploadTask)
    return uploadTask
  }
  
}

extension NetworkSession: URLSessionDelegate {
  func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
    guard let handlers = getHandlers(for: task) else {
      return
    }
    
    let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    DispatchQueue.main.async {
      handlers.progress?(progress)
    }
    set(handlers: nil, for: task)
  }
  
  func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    guard let downloadTask = task as? URLSessionDownloadTask,
          let handlers = getHandlers(for: downloadTask) else {
      return
    }
    
    DispatchQueue.main.async {
      handlers.completion?(nil, downloadTask.response, downloadTask.error)
    }
    
    set(handlers: nil, for: task)
  }
  
}




