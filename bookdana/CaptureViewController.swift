                    //
//  CaptureViewController.swift
//  bookdana
//
//  Created by 渡辺大智 on 2022/11/27.
//

import UIKit
import AVFoundation

class CaptureViewController: UIViewController {

    //検出エリアを指定
    let x: CGFloat = 0.05
    let y: CGFloat = 0.4
    let width: CGFloat = 0.9
    let height: CGFloat = 0.15
    
    var captureSession: AVCaptureSession? //画像や動画の出力データの管理を行うクラス
    var videoLayer: AVCaptureVideoPreviewLayer? //カメラが取得した映像を画面に表示させるクラス
    var ISBN: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Barcode Leader"
    }
    
    @IBAction func onPreComplete(_ sender: Any) {
        self.captureSession?.stopRunning()
        self.captureSession = nil
        if self.presentingViewController is UINavigationController {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.captureSession?.stopRunning()
        self.captureSession = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startCapture()
        
        //枠線の表示
        let loadArea = UIView()
        let x: CGFloat = 0.05
        let y: CGFloat = 0.4
        let width: CGFloat = 0.9
        let height: CGFloat = 0.15
        loadArea.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
        loadArea.layer.borderColor = UIColor.red.cgColor
        loadArea.layer.borderWidth = 4
        loadArea.layer.cornerRadius = 6
        loadArea.clipsToBounds = true
        self.view.addSubview(loadArea)
        
    }
    
    func startCapture() {
        //画像や動画といった出力データの管理を行うクラス
        let session = AVCaptureSession()
        
        //カメラデバイスの管理を行うクラス
        guard let device: AVCaptureDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        
        //AVCaptureDeviceをAVCaptureSessionに渡すためのクラス
        guard let input: AVCaptureInput = try? AVCaptureDeviceInput(device: device) else {
            return
        }
        
        //inputをセッションに追加
        session.addInput(input)
        
        //outputをセッションに追加
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        //取得したメタデータを置くAVCaptureMetadataOutputの設定(delegateの設定)
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        //取得したメタデータを置くAVCaptureMetadataOutputの設定(何を検出するか JANコード→ean8&ean13)
        output.metadataObjectTypes = [.ean13]
        
        //バーコードの検出エリアの設定(設定しない場合，画面全体が検出エリアになる)
        output.rectOfInterest = CGRect(x: y, y: 1-x-width, width: height, height: width)
        
        //セッションを開始
        session.startRunning()
        
        //画面上にカメラの映像を表示するためにvideoLayerを作る
        let videoLayer = AVCaptureVideoPreviewLayer(session: session)
        videoLayer.videoGravity = .resizeAspect
        videoLayer.frame = self.view.bounds
        
        //videoLayerを最初に宣言した定数に追加する
        self.videoLayer = videoLayer
        self.view.layer.addSublayer(videoLayer)
        
        //開放用に保持
        self.captureSession = session
    }
}

extension CaptureViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //バーコードが検出されたら呼び出される
        for metadataObject in metadataObjects {
            guard self.videoLayer?.transformedMetadataObject(for: metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
            guard let object = metadataObject as? AVMetadataMachineReadableCodeObject else {
                continue
            }
            guard let detectionString = object.stringValue else {
                continue
            }
            //冒頭の文字や文字数を検出して正しいコードの場合のみ処理が行われるようにする
            //JANコードは978から開始される13桁の数字
            if detectionString.starts(with: "978") && detectionString.count == 13 {
                self.ISBN = detectionString
            }
        }
        //self.ISBNが空じゃない時
        if self.ISBN != nil {
            //アラート生成
            //UIAlertControllerのスタイルがalert
            let alert: UIAlertController = UIAlertController(title: "読み取り成功！", message:  self.ISBN, preferredStyle:  UIAlertController.Style.alert)
            // 確定ボタンの処理
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                // 確定ボタンが押された時の処理をクロージャ実装する
                (action: UIAlertAction!) -> Void in
                //実際の処理
                self.performSegue(withIdentifier: "setISBN", sender: self)
                self.captureSession?.stopRunning()
                self.captureSession = nil
                if self.presentingViewController is UINavigationController {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
                print("\(self.ISBN!)")
                print("確定")
            })

            //UIAlertControllerに確定ボタンをActionを追加
            alert.addAction(confirmAction)

            //実際にAlertを表示する
            present(alert, animated: true, completion: nil)
            //取得し終わったらセッションを止めて空にします
            self.captureSession?.stopRunning()
            self.captureSession = nil
        }
    }
}
