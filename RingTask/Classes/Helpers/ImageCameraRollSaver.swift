//
//  ImageCameraRollSaver.swift
//  RingTask
//
//  Created by Gregory on 8/17/17.
//  Copyright © 2017 Gregory M. All rights reserved.
//

import UIKit


class ImageCameraRollSaver: NSObject {
    
    typealias CompletionHandler = (Result<Void, Error>) -> Void
    
    private var completionBlock: CompletionHandler?
    
    func saveImageToCameraRoll(image: UIImage, completion: @escaping CompletionHandler) {
        completionBlock = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completionBlock?(error.flatMap { .failure($0) } ?? .success(()))
        completionBlock = nil
    }
}
