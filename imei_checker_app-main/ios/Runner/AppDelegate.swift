import UIKit
import Flutter
import SwiftUI
// import FirebaseCore
//  import GoogleMaps

weak var screen : UIView? = nil
var secureView: UIView!
 private var textField = UITextField()

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    print("Inside app delegate")
    // FirebaseApp.configure()
    // GMSServices.provideAPIKey("AIzaSyAdGc2L2VjOlGeRQ8ITHix3Q1t-oGoXFfU")
    self.window.makeSecure()
      let isCaptured = UIScreen.main.isCaptured
      print("isCaptured: \(isCaptured)")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }


  override func applicationWillResignActive(_ application: UIApplication) {
    self.window.isHidden = true;
  }
  override func applicationDidBecomeActive(_ application: UIApplication) {
    self.window.isHidden = false;
  }

  @objc func preventScreenRecording() {
    let isCaptured = UIScreen.main.isCaptured
    print("isCaptured: \(isCaptured)")
    if isCaptured {
        blurScreen()
    }
    else {
        removeBlurScreen()
    }
}

func blurScreen(style: UIBlurEffect.Style = UIBlurEffect.Style.regular) {
    screen = UIScreen.main.snapshotView(afterScreenUpdates: false)
    let blurEffect = UIBlurEffect(style: style)
    let blurBackground = UIVisualEffectView(effect: blurEffect)
    screen?.addSubview(blurBackground)
    blurBackground.frame = (screen?.frame)!
    window?.addSubview(screen!)
}

func removeBlurScreen() {
    screen?.removeFromSuperview()
}
}


  extension UIWindow {
   func makeSecure() {
    let field = UITextField()
    field.isSecureTextEntry = true
    self.addSubview(field)
    field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.layer.superlayer?.addSublayer(field.layer)
    field.layer.sublayers?.first?.addSublayer(self.layer)
  }
}
