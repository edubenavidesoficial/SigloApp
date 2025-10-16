import UIKit
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Delegado de Firebase Messaging
        Messaging.messaging().delegate = self
        
        // Permisos de notificaciones push
        UNUserNotificationCenter.current().delegate = self
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            print("Permiso notificaciones: \(granted)")
        }
        
        // Registrar dispositivo para notificaciones remotas
        application.registerForRemoteNotifications()
        
        return true
    }

    // Registrar token APNs en Firebase
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // Mostrar notificación cuando la app está activa
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }

    // Token FCM recibido o actualizado
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("📲 FCM Token recibido: \(fcmToken)")
        
        // Convertir FCM a Base64
        guard let tokenData = fcmToken.data(using: .utf8) else { return }
        let base64Token = tokenData.base64EncodedString()
        
        // Obtener ID del usuario logueado (si lo hay)
        let userId = UserManager.shared.user?.id ?? 0
        
        // Registrar dispositivo en tu API con token válido
        Task {
            await PushService.registerDevice(
                deviceType: 1, // iOS
                userId: userId,
                tokenBase64: base64Token
            )
        }
    }
}
