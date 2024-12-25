//
//  BackgroundUploaders.swift
//  EBuddyTest
//
//  Created by Dicky Geraldi on 25/12/24.
//

import FirebaseStorage
import UIKit

class BackgroundUploader {
    static let shared = BackgroundUploader()

    var uploadQueue: [UIImage] = []
    var onDoneUpload: [(_ imageUrl: String) -> Void] = []
    private var isUploading = false

    private init() {}

    func addToQueue(image: UIImage, onCompletion: @escaping (_ imageUrl: String) -> Void) {
        uploadQueue.append(image)
        onDoneUpload.append(onCompletion)
        saveQueueState()
        processQueue()
    }

    func processQueue() {
        guard !isUploading, !uploadQueue.isEmpty else { return }
        isUploading = true

        let image = uploadQueue.removeFirst()
        uploadImage(image: image) { [weak self] success, url in
            if let weakSelf = self {
                weakSelf.isUploading = false
                if !success {
                    weakSelf.uploadQueue.append(image)
                    weakSelf.saveQueueState()
                    weakSelf.processQueue()
                } else if let url = url {
                    let actions = weakSelf.onDoneUpload.removeFirst()
                    actions(url.absoluteString)
                }
            }
        }
    }

    private func uploadImage(image: UIImage, completion: @escaping (Bool, URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false, nil)
            return
        }

        let fileName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("images/\(fileName).jpg")

        let uploadTask = storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Upload failed with error: \(error.localizedDescription)")
                completion(false, nil)
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Failed to get download URL: \(error.localizedDescription)")
                    completion(false, nil)
                } else {
                    completion(true, url)
                }
            }
        }

        uploadTask.observe(.progress) { snapshot in
            if let progress = snapshot.progress {
                print("Upload progress: \(progress.fractionCompleted * 100)%")
            }
        }
    }

    func handleAppGoesToBackground() {
        guard !uploadQueue.isEmpty else { return }
        scheduleBackgroundUpload()
    }

    func scheduleBackgroundUpload() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.scheduleUploadTask()
    }

    func saveQueueState() {
        let defaults = UserDefaults.standard
        let queueData = uploadQueue.compactMap { $0.jpegData(compressionQuality: 0.8) }
        defaults.set(queueData, forKey: "uploadQueue")
        print("Upload queue saved.")
    }

    func restoreQueueState() {
        let defaults = UserDefaults.standard
        if let queueData = defaults.array(forKey: "uploadQueue") as? [Data] {
            uploadQueue = queueData.compactMap { UIImage(data: $0) }
            print("Upload queue restored with \(uploadQueue.count) items.")
            processQueue()
        }
    }
}
