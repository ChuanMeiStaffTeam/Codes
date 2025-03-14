//
//  PermissionService.swift
//  huanxi
//
//  Created by rslz on 2025/3/14.
//

import Foundation
import AppTrackingTransparency
import AdSupport
import AVFoundation
import Photos
import CoreLocation
import UserNotifications

// 定义权限类型
enum PermissionType {
    case idfa                      // 广告标识符
    case camera                    // 相机
    case photoLibrary              // 相册
    case microphone                // 麦克风
    case location                  // 定位
    case notification              // 通知
}

// 定义权限状态
enum PermissionStatus {
    case authorized
    case denied
    case notDetermined
    case restricted
    case unknown
}

class PermissionService: NSObject, CLLocationManagerDelegate {
    static let shared = PermissionService()
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((PermissionStatus) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // 请求权限
    func requestPermission(_ type: PermissionType, completion: @escaping (PermissionStatus) -> Void) {
        switch type {
        case .idfa:
            requestIDFA(completion: completion)
        case .camera:
            requestCameraPermission(completion: completion)
        case .photoLibrary:
            requestPhotoLibraryPermission(completion: completion)
        case .microphone:
            requestMicrophonePermission(completion: completion)
        case .location:
            requestLocationPermission(completion: completion)
        case .notification:
            requestNotificationPermission(completion: completion)
        }
    }
}

// MARK: - 各权限请求逻辑
extension PermissionService {
    
    // IDFA 权限
    private func requestIDFA(completion: @escaping (PermissionStatus) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                        debugPrint("IDFA 权限: 已授权== \(idfa)")
                        completion(.authorized)
                    case .denied:
                        debugPrint("IDFA 权限: 被拒绝")
                        completion(.denied)
                    case .restricted, .notDetermined:
                        debugPrint("IDFA 权限: 受限/未决定")
                        completion(.notDetermined)
                    @unknown default:
                        completion(.unknown)
                    }
                }
            }
        } else {
            let isTrackingEnabled = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            completion(isTrackingEnabled ? .authorized : .denied)
        }
    }
    
    // 相机权限
    private func requestCameraPermission(completion: @escaping (PermissionStatus) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            completion(.authorized)
        case .denied:
            completion(.denied)
        case .restricted:
            completion(.restricted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted ? .authorized : .denied)
                }
            }
        @unknown default:
            completion(.unknown)
        }
    }
    
    // 相册权限
    private func requestPhotoLibraryPermission(completion: @escaping (PermissionStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            completion(.authorized)
        case .denied:
            completion(.denied)
        case .restricted:
            completion(.restricted)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized ? .authorized : .denied)
                }
            }
        @unknown default:
            completion(.unknown)
        }
    }
    
    // 麦克风权限
    private func requestMicrophonePermission(completion: @escaping (PermissionStatus) -> Void) {
        let status = AVAudioSession.sharedInstance().recordPermission
        switch status {
        case .granted:
            completion(.authorized)
        case .denied:
            completion(.denied)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted ? .authorized : .denied)
                }
            }
        @unknown default:
            completion(.unknown)
        }
    }
    
    // 定位权限
    private func requestLocationPermission(completion: @escaping (PermissionStatus) -> Void) {
        let status = CLLocationManager().authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            completion(.authorized)
        case .denied:
            completion(.denied)
        case .restricted:
            completion(.restricted)
        case .notDetermined:
            locationCompletion = completion
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            completion(.unknown)
        }
    }
    
    // 处理定位授权回调
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let completion = locationCompletion else { return }
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            completion(.authorized)
        case .denied:
            completion(.denied)
        case .restricted:
            completion(.restricted)
        default:
            completion(.unknown)
        }
        locationCompletion = nil
    }
    
    // 通知权限
    private func requestNotificationPermission(completion: @escaping (PermissionStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted ? .authorized : .denied)
            }
        }
    }
}
