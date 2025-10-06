import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Servicio de autenticación que maneja todas las operaciones de Firebase Auth
/// 
/// Este servicio actúa como intermediario entre tu app y Firebase Authentication,
/// proporcionando métodos simples para registro, login y logout.
class AuthService {
  // Instancia de Firebase Authentication
  // Es el objeto principal que usamos para comunicarnos con Firebase Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Instancia de Google Sign In para autenticación con Google
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Obtiene el usuario actualmente autenticado
  /// Retorna null si no hay usuario logueado
  User? get currentUser => _auth.currentUser;

  /// Stream que emite eventos cuando el estado de autenticación cambia
  /// Útil para escuchar cambios en tiempo real (login/logout)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ============================================================================
  // REGISTRO CON EMAIL Y CONTRASEÑA
  // ============================================================================
  
  /// Registra un nuevo usuario con email y contraseña
  /// 
  /// Proceso:
  /// 1. Firebase recibe el email y contraseña en texto plano
  /// 2. Firebase hashea la contraseña automáticamente con scrypt (no lo ves, lo hace por ti)
  /// 3. Guarda el email y el hash en sus servidores
  /// 4. Retorna un objeto User si fue exitoso
  /// 
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario
  /// - [password]: Contraseña en texto plano (Firebase la hasheará automáticamente)
  /// 
  /// Retorna:
  /// - User si el registro fue exitoso
  /// - null si hubo un error
  /// 
  /// Errores comunes:
  /// - 'email-already-in-use': El email ya está registrado
  /// - 'invalid-email': El formato del email es inválido
  /// - 'weak-password': La contraseña es muy débil (menos de 6 caracteres)
  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // createUserWithEmailAndPassword es el método de Firebase que:
      // 1. Valida el email
      // 2. Hashea la contraseña automáticamente
      // 3. Crea la cuenta en Firebase
      // 4. Autentica al usuario automáticamente
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Si todo salió bien, retornamos el usuario
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException contiene información específica del error
      print('Error en registro: ${e.code} - ${e.message}');
      
      // Aquí puedes manejar errores específicos
      switch (e.code) {
        case 'email-already-in-use':
          print('Este email ya está registrado');
          break;
        case 'invalid-email':
          print('El formato del email es inválido');
          break;
        case 'weak-password':
          print('La contraseña debe tener al menos 6 caracteres');
          break;
        default:
          print('Error desconocido: ${e.message}');
      }
      
      return null;
    } catch (e) {
      // Captura cualquier otro error no relacionado con Firebase
      print('Error inesperado: $e');
      return null;
    }
  }

  // ============================================================================
  // INICIO DE SESIÓN CON EMAIL Y CONTRASEÑA
  // ============================================================================
  
  /// Inicia sesión con email y contraseña
  /// 
  /// Proceso:
  /// 1. Firebase recibe el email y contraseña
  /// 2. Firebase hashea la contraseña ingresada
  /// 3. Compara el hash con el almacenado en la base de datos
  /// 4. Si coinciden, autentica al usuario
  /// 
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario
  /// - [password]: Contraseña en texto plano
  /// 
  /// Retorna:
  /// - User si el inicio de sesión fue exitoso
  /// - null si hubo un error
  /// 
  /// Errores comunes:
  /// - 'user-not-found': No existe una cuenta con ese email
  /// - 'wrong-password': La contraseña es incorrecta
  /// - 'invalid-email': El formato del email es inválido
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // signInWithEmailAndPassword valida las credenciales
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('Error en inicio de sesión: ${e.code} - ${e.message}');
      
      switch (e.code) {
        case 'user-not-found':
          print('No existe una cuenta con este email');
          break;
        case 'wrong-password':
          print('Contraseña incorrecta');
          break;
        case 'invalid-email':
          print('El formato del email es inválido');
          break;
        default:
          print('Error desconocido: ${e.message}');
      }
      
      return null;
    } catch (e) {
      print('Error inesperado: $e');
      return null;
    }
  }

  // ============================================================================
  // INICIO DE SESIÓN CON GOOGLE
  // ============================================================================
  
  /// Inicia sesión con Google
  /// 
  /// Proceso:
  /// 1. Abre el popup de Google Sign In
  /// 2. El usuario selecciona su cuenta de Google
  /// 3. Google proporciona un token de autenticación
  /// 4. Firebase verifica el token con Google
  /// 5. Crea o autentica al usuario en Firebase
  /// 
  /// Retorna:
  /// - User si el inicio de sesión fue exitoso
  /// - null si el usuario canceló o hubo un error
  Future<User?> signInWithGoogle() async {
    try {
      // Paso 1: Iniciar el flujo de autenticación de Google
      // Esto abre el popup para seleccionar la cuenta de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // Si el usuario cancela el popup, googleUser será null
      if (googleUser == null) {
        print('Inicio de sesión con Google cancelado por el usuario');
        return null;
      }

      // Paso 2: Obtener los detalles de autenticación de Google
      // Esto incluye el token de acceso y el token de ID
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Paso 3: Crear una credencial de Firebase usando los tokens de Google
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Paso 4: Usar la credencial para autenticar en Firebase
      // Firebase verifica con Google que los tokens sean válidos
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error en inicio de sesión con Google: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error inesperado en Google Sign In: $e');
      return null;
    }
  }

  // ============================================================================
  // CERRAR SESIÓN
  // ============================================================================
  
  /// Cierra la sesión del usuario actual
  /// 
  /// Proceso:
  /// 1. Cierra la sesión en Firebase Auth
  /// 2. Si el usuario inició sesión con Google, también cierra sesión allí
  /// 3. Borra los tokens de autenticación locales
  Future<void> signOut() async {
    try {
      // Cerrar sesión en Firebase
      await _auth.signOut();
      
      // Cerrar sesión en Google (si se usó Google Sign In)
      await _googleSignIn.signOut();
      
      print('Sesión cerrada exitosamente');
    } catch (e) {
      print('Error al cerrar sesión: $e');
    }
  }

  // ============================================================================
  // MÉTODOS ADICIONALES ÚTILES
  // ============================================================================
  
  /// Envía un email de verificación al usuario actual
  /// Útil para verificar que el email es real
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('Email de verificación enviado');
      }
    } catch (e) {
      print('Error al enviar email de verificación: $e');
    }
  }

  /// Envía un email para restablecer la contraseña
  /// 
  /// Parámetros:
  /// - [email]: Email del usuario que olvidó su contraseña
  Future<void> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Email de restablecimiento enviado');
    } on FirebaseAuthException catch (e) {
      print('Error al enviar email de restablecimiento: ${e.code} - ${e.message}');
    }
  }

  /// Elimina la cuenta del usuario actual
  /// ⚠️ CUIDADO: Esta acción es irreversible
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        print('Cuenta eliminada exitosamente');
      }
    } on FirebaseAuthException catch (e) {
      print('Error al eliminar cuenta: ${e.code} - ${e.message}');
      
      // Si el error es 'requires-recent-login', el usuario debe
      // volver a autenticarse antes de poder eliminar su cuenta
      if (e.code == 'requires-recent-login') {
        print('Debes volver a iniciar sesión antes de eliminar tu cuenta');
      }
    }
  }
}