//
//  DownloadManager.swift
//  Mist
//
//  Created by Nindi Gill on 23/6/2022.
//

import Foundation

class DownloadManager: NSObject, ObservableObject {

    static let shared: DownloadManager = DownloadManager()
    private var task: URLSessionDownloadTask?
    private var progress: Progress = Progress()
    var currentValue: Double {
        progress.fractionCompleted
    }

    func download(_ url: URL, to destination: URL, retries retriesMaximum: Int, delay retryDelay: Int) async throws {

        guard !FileManager.default.fileExists(atPath: destination.path) else {
            return
        }

        let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0)
        var mistError: MistError?
        var urlError: URLError?
        var retries: Int = 0
        let completionHandler: (URL?, URLResponse?, Error?) -> Void = { url, _, error in

            if let error: URLError = error as? URLError {

                guard error.code != .cancelled else {
                    mistError = .userCancelled
                    semaphore.signal()
                    return
                }

                urlError = error
                semaphore.signal()
                return
            }

            if let error: Error = error {
                mistError = MistError.generalError(error.localizedDescription)
                semaphore.signal()
                return
            }

            guard let url: URL = url else {
                mistError = MistError.invalidDestinationURL
                semaphore.signal()
                return
            }

            do {
                if FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }

                try FileManager.default.moveItem(at: url, to: destination)
            } catch {
                mistError = MistError.generalError(error.localizedDescription)
            }

            semaphore.signal()
        }

        while mistError == nil {

            guard retries < retriesMaximum else {
                throw MistError.maximumRetriesReached
            }

            if let error: URLError = urlError {

                guard let data: Data = error.downloadTaskResumeData else {
                    throw MistError.invalidDownloadResumeData
                }

                sleep(UInt32(retryDelay))
                retries += 1
                task = URLSession.shared.downloadTask(withResumeData: data, completionHandler: completionHandler)
            } else {
                task = URLSession.shared.downloadTask(with: url, completionHandler: completionHandler)
            }

            if let task: URLSessionDownloadTask = task {
                progress = task.progress
            }

            urlError = nil
            task?.resume()
            semaphore.wait()
        }

        if let mistError: MistError = mistError {
            throw mistError
        }
    }

    func cancelTask() {
        task?.cancel()
    }
}
