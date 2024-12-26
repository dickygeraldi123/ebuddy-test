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

    var uploadQueue: [(image: UIImage, filePath: String)] = []
    private var onDoneUpload: [(_ imageUrl: String) -> Void] = []
    private var isUploading = false
    private let queue = DispatchQueue(label: "com.backgroundUploader.queue")

    private init() {}

    func addToQueue(image: UIImage, onCompletion: @escaping (_ imageUrl: String) -> Void) {
        let filePath = NSTemporaryDirectory().appending(UUID().uuidString + ".jpg")
        queue.async { [weak self] in
            guard let self = self else { return }
            self.uploadQueue.append((image: image, filePath: filePath))
            self.onDoneUpload.append(onCompletion)
            self.saveQueueState()
            self.processQueue()
        }
    }

    func processQueue() {
        queue.async { [weak self] in
            guard let self = self else { return }
            guard !self.isUploading, !self.uploadQueue.isEmpty else { return }
            self.isUploading = true

            var currentUpload = self.uploadQueue.removeFirst()
            let actions = self.onDoneUpload.removeFirst()

            self.uploadImage(image: currentUpload.image) { [weak self] success, url in
                guard let self = self else { return }
                self.queue.async {
                    self.isUploading = false
                    if success, let url = url {
                        // Delete the temporary file
                        let fileManager = FileManager.default
                        do {
                            try fileManager.removeItem(atPath: currentUpload.filePath)
                            print("Temporary file deleted: \(currentUpload.filePath)")
                        } catch {
                            print("Failed to delete temporary file: \(error)")
                        }
                        actions(url.absoluteString)
                    } else {
                        // Re-add to queue on failure
                        self.uploadQueue.insert(currentUpload, at: 0)
                        self.onDoneUpload.insert(actions, at: 0)
                    }
                    self.saveQueueState()
                    self.processQueue()
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

        let uploadTask = storageRef.putData(imageData, metadata: nil) { _, error in
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
        let paths = uploadQueue.compactMap { pair -> String? in
            guard let data = pair.image.jpegData(compressionQuality: 0.8) else { return nil }
            let filePath = pair.filePath
            do {
                try data.write(to: URL(fileURLWithPath: filePath))
                return filePath
            } catch {
                print("Failed to save image to file: \(error)")
                return nil
            }
        }
        UserDefaults.standard.set(paths, forKey: "uploadQueuePaths")
        print("Upload queue saved.")
    }

    func restoreQueueState() {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let defaults = UserDefaults.standard
            if let paths = defaults.array(forKey: "uploadQueuePaths") as? [String] {
                var validQueue: [(image: UIImage, filePath: String)] = []
                let fileManager = FileManager.default
                
                for filePath in paths {
                    if let data = fileManager.contents(atPath: filePath), let image = UIImage(data: data) {
                        validQueue.append((image: image, filePath: filePath))
                    } else {
                        do {
                            try fileManager.removeItem(atPath: filePath)
                            print("Removed invalid or inaccessible file: \(filePath)")
                        } catch {
                            print("Failed to delete invalid file: \(error)")
                        }
                    }
                }
                
                self.uploadQueue = validQueue
                print("Upload queue restored with \(self.uploadQueue.count) valid items.")
                self.processQueue()
            }
        }
    }
}
