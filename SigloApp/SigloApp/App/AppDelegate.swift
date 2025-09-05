import UIKit
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Delegado de Messaging
        Messaging.messaging().delegate = self
        
        // Solicitar permisos de notificaciones
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            print("Permiso notificaciones: \(granted)")
        }

        application.registerForRemoteNotifications()
        return true
    }

    // Registrar token APNs
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // Recibir notificación mientras la app está en primer plano
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("📲 FCM Token recibido: \(fcmToken)")

        if let tokenData = fcmToken.data(using: .utf8) {
            let base64Token = tokenData.base64EncodedString()
            
            // Obtener token de auth de TokenService
            if let authToken = TokenService.shared.getStoredToken() {
                // 👇 Si tienes usuario logueado, úsalo, si no, pasa 0
                let userId = UserManager.shared.user?.id ?? 0
                
                PushService.registerDevice(
                    deviceType: 1,         // iOS
                    userId: userId,
                    tokenBase64: base64Token,
                    authToken: authToken   // 🔑 token del login
                )
            } else {
                print("⚠️ No hay token de autenticación disponible aún")
            }
        }
    }
}
