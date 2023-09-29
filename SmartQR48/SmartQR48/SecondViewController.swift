//
//  SecondViewController.swift
//  SmartQR48
//
//  Created by 出田和毅 on 2023/09/29.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // 各種プロパティの定義
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    let metadataOutput = AVCaptureMetadataOutput()
    let backgroundQueue = DispatchQueue.global()
    
    // 2023.9.25の変更点
    let boundingBoxContainer: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // カメラ使用許可リクエスト
        requestCameraPermission()
        // カメラセットアップ
        setupCamera()
        // レイヤーセットアップ
        setupPreviewLayer()
        // QRCode関連
        captureSession.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        // バウンディングボックス用コンテナの実装
        view.addSubview(boundingBoxContainer)
        boundingBoxContainer.frame = view.bounds
        boundingBoxContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // 非同期でのカメラの起動
        backgroundQueue.async {
            self.startRunningCaptureSession()
        }
    }
    // 挙動に関するスパークラスの継承
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.layer.bounds
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopRunningCaptureSession()
    }
}

// 拡張機能：カメラの使用許可リクエスト
extension SecondViewController {
    func requestCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        // ユーザーがまだ許可を与えていない場合
        case .notDetermined:
            // ユーザーに許可を要求
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    print("User granted access to the camera.")
                    // ここでカメラのセットアップなどを行う
                } else {
                    print("User denied access to the camera.")
                    // カメラへのアクセスが拒否された場合の処理をここで行う
                }
            }
        // 既に許可されている場合
        case .authorized:
            print("User has already granted access to the camera.")
            // ここでカメラのセットアップなどを行う

        // ユーザーがカメラへのアクセスを拒否している場合
        case .denied:
            print("User has denied access to the camera.")
            // カメラへのアクセスが拒否された場合の処理をここで行う

        // 許可が制限されている（ペアレンタルコントロールなど）場合
        case .restricted:
            print("Access to the camera is restricted.")
            // カメラへのアクセスが制限されている場合の処理をここで行う

        @unknown default:
            fatalError("Unhandled AVCaptureDevice authorizationStatus.")
        }
    }
}

// 拡張機能：カメラ設定等
extension SecondViewController {
    func setupCamera() {
        captureSession.sessionPreset = .photo
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        let devices = deviceDiscoverySession.devices
        for device in devices  {
            if device.position == .back {
                captureDevice = device
                print("capture success") // deviceの取得に成功
                break
            } else {
                print("capture failure") // deviceの取得に失敗
                continue
            }
        }
        print(type(of: captureDevice))
        let deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice!)
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            } else {
                print("addInput error")
                return
            }
        } catch {
            print("deviceInput error")
            return
        }
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = .resizeAspectFill
        previewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer!)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func stopRunningCaptureSession() {
        captureSession.stopRunning()
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
    }
}

// 拡張機能：QRコードの読み取り
extension SecondViewController {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        for subview in boundingBoxContainer.subviews {
            subview.removeFromSuperview()
        }
        
        for metadataObject in metadataObjects {
            guard let transformedObject = previewLayer?.transformedMetadataObject(for: metadataObject) else {continue}
            if let qrCodeObject = transformedObject as?  AVMetadataMachineReadableCodeObject {
                let qrCodeFrame = qrCodeObject.bounds
                
                let boundingBoxView = UIView(frame: qrCodeFrame)
                boundingBoxView.layer.borderColor = UIColor.green.cgColor
                boundingBoxView.layer.borderWidth = 2.0
                boundingBoxView.backgroundColor = UIColor.clear
                boundingBoxContainer.addSubview(boundingBoxView)
                
                // QRコードのデータを取得
                if let qrCodeString = qrCodeObject.stringValue {
                    saveQRCodeData(qrCodeString)
                    // バウンディングボックス上部に解読データを表示するラベルを作成
                    let label = UILabel(frame: CGRect(x: qrCodeFrame.origin.x, y: qrCodeFrame.origin.y - 20, width: qrCodeFrame.size.width, height: 20))
                    label.text = qrCodeString
                    label.textColor = UIColor.green
                    label.font = UIFont.systemFont(ofSize: 10)
                    boundingBoxContainer.addSubview(label)
                }
            }
        }
    }
    // QRコードデータの保存
    func saveQRCodeData(_ qrCodeString: String) {
        // 1. テキストファイルのパスを取得
        let fileName = "QRCodeData.txt"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsDirectory.appendingPathComponent(fileName)

        // 2. テキストファイルからすべてのデータを読み取る
        do {
            let fileContents = try String(contentsOf: filePath, encoding: .utf8)
            let savedQRCodes = fileContents.split(separator: "\n").map { String($0) }

            // 3. 既存のQRコードのデータと読み取ったデータを比較
            if !savedQRCodes.contains(qrCodeString) {
                // 4. 異なる場合のみファイルに追記
                let updatedContents = fileContents + "\n" + qrCodeString
                try updatedContents.write(to: filePath, atomically: true, encoding: .utf8)
            }
        } catch {
            print("Error reading or writing file: \(error)")
        }
    }
}

// String型へのメソッドの追加（改行とUTF-8へのデータ変換）
extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: .utf8)!
        try data.append(fileURL: fileURL)
    }
}
// appendメソッドの作成
extension Data {
    func append(fileURL: URL) throws {
        // 指定したパスのファイルを開き、データを格納する
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        // 指定したパスのファイルが存在しない場合、新たに作成
        else {
            try write(to: fileURL, options: .atomicWrite)
        }
    }
}
