import 'package:get/get.dart';

/// App Translations - Arabic, English, French
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': _enUS,
    'ar_DZ': _arDZ,
    'fr_FR': _frFR,
  };

  // ============ English Translations ============
  static const Map<String, String> _enUS = {
    // App Name
    'app_name': 'Avico Smart',
    'app_subtitle': 'Warehouse Monitoring System',

    // Onboarding
    'onboarding_title': 'Smart Warehouse Monitoring',
    'onboarding_subtitle':
        'Monitor your warehouse environment in real-time with advanced sensors',
    'get_started': 'Get Started',

    // Auth
    'login': 'Login',
    'email': 'Email',
    'password': 'Password',
    'email_hint': 'Enter your email',
    'password_hint': 'Enter your password',
    'login_button': 'Sign In',
    'logging_in': 'Signing in...',
    'login_success': 'Login successful!',
    'login_error': 'Login failed. Please check your credentials.',
    'invalid_email': 'Please enter a valid email',
    'password_required': 'Password is required',
    'password_too_short': 'Password must be at least 6 characters',
    'welcome_back': 'Welcome Back!',
    'login_subtitle': 'Sign in to monitor your warehouse',

    // Navigation
    'nav_status': 'Status',
    'nav_history': 'History',
    'nav_settings': 'Settings',

    // Home / Current Status
    'current_status': 'Current Status',
    'last_updated': 'Last updated',
    'refreshing': 'Refreshing...',
    'pull_to_refresh': 'Pull to refresh',

    // Sensors
    'temperature': 'Temperature',
    'humidity': 'Humidity',
    'co2_level': 'CO₂ Level',
    'nitrogen_level': 'NH3 Level',
    'unit_celsius': '°C',
    'unit_percent': '%',
    'unit_ppm': 'ppm',

    // History
    'history_title': 'History',
    'select_property': 'Select Property',
    'last_24_hours': 'Last 24 Hours',
    'no_data': 'No data available',

    // Settings
    'settings': 'Settings',
    'language': 'Language',
    'select_language': 'Select Language',
    'english': 'English',
    'arabic': 'العربية',
    'french': 'Français',
    'logout': 'Logout',
    'logout_confirm': 'Are you sure you want to logout?',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'app_version': 'App Version',
    'about': 'About',

    // Errors
    'error': 'Error',
    'network_error': 'Network error. Please check your connection.',
    'fetch_error': 'Failed to fetch data. Please try again.',
    'unknown_error': 'An unexpected error occurred.',
    'retry': 'Retry',

    // Status Messages
    'normal': 'Normal',
    'warning': 'Warning',
    'critical': 'Critical',

    // General
    'loading': 'Loading...',
    'success': 'Success',
    'ok': 'OK',

    // Dashboard & Hangars
    'nav_home': 'Home',
    'hangars': 'Hangars',
    'live_data': 'Live Data',
    'simulated': 'Simulated',

    // Hangar Details
    'hangar_map': 'Map',
    'sensor_readings': 'Sensor Readings',
    'food_level': 'Food Level',
    'unit_kg': 'kg',
    'low_level': 'Low Level',
    'refill': 'Refill',
    'refilling': 'Refilling...',

    // History Stats
    'min': 'Min',
    'avg': 'Avg',
    'max': 'Max',

    // Heat Map
    'legend': 'Legend',
    'cold': 'Cold',
    'hot': 'Hot',
    'zone_info': 'Zone Information',
    'zone_info_desc':
        'Zone 1 shows real sensor data. Other zones display simulated values.',

    // Settings Tab
    'owner': 'Owner',
    'hangar_settings': 'Hangar Settings',
    'hangar_name': 'Hangar Name',
    'data_source': 'Data Source',
    'food_capacity': 'Food Capacity',
    'edit_profile': 'Edit Profile',
    'feature_coming_soon': 'Coming Soon',
    'edit_profile_soon':
        'Profile editing will be available in the next update.',
  };

  // ============ Arabic Translations ============
  static const Map<String, String> _arDZ = {
    // App Name
    'app_name': 'افيكو سمارت',
    'app_subtitle': 'نظام مراقبة المستودعات',

    // Onboarding
    'onboarding_title': 'مراقبة ذكية للمستودعات',
    'onboarding_subtitle':
        'راقب بيئة مستودعك في الوقت الحقيقي باستخدام أجهزة استشعار متقدمة',
    'get_started': 'ابدأ الآن',

    // Auth
    'login': 'تسجيل الدخول',
    'email': 'البريد الإلكتروني',
    'password': 'كلمة المرور',
    'email_hint': 'أدخل بريدك الإلكتروني',
    'password_hint': 'أدخل كلمة المرور',
    'login_button': 'دخول',
    'logging_in': 'جاري تسجيل الدخول...',
    'login_success': 'تم تسجيل الدخول بنجاح!',
    'login_error': 'فشل تسجيل الدخول. يرجى التحقق من بياناتك.',
    'invalid_email': 'يرجى إدخال بريد إلكتروني صحيح',
    'password_required': 'كلمة المرور مطلوبة',
    'password_too_short': 'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل',
    'welcome_back': 'مرحباً بعودتك!',
    'login_subtitle': 'سجل دخولك لمراقبة مستودعك',

    // Navigation
    'nav_status': 'الحالة',
    'nav_history': 'السجل',
    'nav_settings': 'الإعدادات',

    // Home / Current Status
    'current_status': 'الحالة الحالية',
    'last_updated': 'آخر تحديث',
    'refreshing': 'جاري التحديث...',
    'pull_to_refresh': 'اسحب للتحديث',

    // Sensors
    'temperature': 'درجة الحرارة',
    'humidity': 'الرطوبة',
    'co2_level': 'مستوى CO₂',
    'nitrogen_level': 'مستوى NH3',
    'unit_celsius': '°م',
    'unit_percent': '%',
    'unit_ppm': 'جزء/مليون',

    // History
    'history_title': 'السجل',
    'select_property': 'اختر الخاصية',
    'last_24_hours': 'آخر 24 ساعة',
    'no_data': 'لا توجد بيانات',

    // Settings
    'settings': 'الإعدادات',
    'language': 'اللغة',
    'select_language': 'اختر اللغة',
    'english': 'English',
    'arabic': 'العربية',
    'french': 'Français',
    'logout': 'تسجيل الخروج',
    'logout_confirm': 'هل أنت متأكد من تسجيل الخروج؟',
    'cancel': 'إلغاء',
    'confirm': 'تأكيد',
    'app_version': 'إصدار التطبيق',
    'about': 'حول',

    // Errors
    'error': 'خطأ',
    'network_error': 'خطأ في الشبكة. يرجى التحقق من اتصالك.',
    'fetch_error': 'فشل في جلب البيانات. حاول مرة أخرى.',
    'unknown_error': 'حدث خطأ غير متوقع.',
    'retry': 'إعادة المحاولة',

    // Status Messages
    'normal': 'طبيعي',
    'warning': 'تحذير',
    'critical': 'حرج',

    // General
    'loading': 'جاري التحميل...',
    'success': 'نجاح',
    'ok': 'موافق',

    // Dashboard & Hangars
    'nav_home': 'الرئيسية',
    'hangars': 'الحظائر',
    'live_data': 'بيانات حية',
    'simulated': 'محاكاة',

    // Hangar Details
    'hangar_map': 'الخريطة',
    'sensor_readings': 'قراءات الحساسات',
    'food_level': 'مستوى الغذاء',
    'unit_kg': 'كغ',
    'low_level': 'مستوى منخفض',
    'refill': 'إعادة التعبئة',
    'refilling': 'جاري التعبئة...',

    // History Stats
    'min': 'أدنى',
    'avg': 'متوسط',
    'max': 'أقصى',

    // Heat Map
    'legend': 'دليل الألوان',
    'cold': 'بارد',
    'hot': 'حار',
    'zone_info': 'معلومات المناطق',
    'zone_info_desc':
        'المنطقة 1 تعرض بيانات حقيقية. المناطق الأخرى تعرض قيم محاكاة.',

    // Settings Tab
    'owner': 'المالك',
    'hangar_settings': 'إعدادات الحظيرة',
    'hangar_name': 'اسم الحظيرة',
    'data_source': 'مصدر البيانات',
    'food_capacity': 'سعة الغذاء',
    'edit_profile': 'تعديل الملف الشخصي',
    'feature_coming_soon': 'قريباً',
    'edit_profile_soon': 'تعديل الملف الشخصي سيكون متاحاً في التحديث القادم.',
  };

  // ============ French Translations ============
  static const Map<String, String> _frFR = {
    // App Name
    'app_name': 'Avico Smart',
    'app_subtitle': 'Système de Surveillance d\'Entrepôt',

    // Onboarding
    'onboarding_title': 'Surveillance Intelligente d\'Entrepôt',
    'onboarding_subtitle':
        'Surveillez l\'environnement de votre entrepôt en temps réel avec des capteurs avancés',
    'get_started': 'Commencer',

    // Auth
    'login': 'Connexion',
    'email': 'E-mail',
    'password': 'Mot de passe',
    'email_hint': 'Entrez votre e-mail',
    'password_hint': 'Entrez votre mot de passe',
    'login_button': 'Se Connecter',
    'logging_in': 'Connexion en cours...',
    'login_success': 'Connexion réussie!',
    'login_error': 'Échec de connexion. Vérifiez vos identifiants.',
    'invalid_email': 'Veuillez entrer un e-mail valide',
    'password_required': 'Le mot de passe est requis',
    'password_too_short': 'Le mot de passe doit contenir au moins 6 caractères',
    'welcome_back': 'Bon Retour!',
    'login_subtitle': 'Connectez-vous pour surveiller votre entrepôt',

    // Navigation
    'nav_status': 'État',
    'nav_history': 'Historique',
    'nav_settings': 'Paramètres',

    // Home / Current Status
    'current_status': 'État Actuel',
    'last_updated': 'Dernière mise à jour',
    'refreshing': 'Actualisation...',
    'pull_to_refresh': 'Tirez pour actualiser',

    // Sensors
    'temperature': 'Température',
    'humidity': 'Humidité',
    'co2_level': 'Niveau de CO₂',
    'nitrogen_level': 'Niveau de NH3',
    'unit_celsius': '°C',
    'unit_percent': '%',
    'unit_ppm': 'ppm',

    // History
    'history_title': 'Historique',
    'select_property': 'Sélectionner Propriété',
    'last_24_hours': 'Dernières 24 Heures',
    'no_data': 'Aucune donnée disponible',

    // Settings
    'settings': 'Paramètres',
    'language': 'Langue',
    'select_language': 'Sélectionner Langue',
    'english': 'English',
    'arabic': 'العربية',
    'french': 'Français',
    'logout': 'Déconnexion',
    'logout_confirm': 'Êtes-vous sûr de vouloir vous déconnecter?',
    'cancel': 'Annuler',
    'confirm': 'Confirmer',
    'app_version': 'Version de l\'App',
    'about': 'À Propos',

    // Errors
    'error': 'Erreur',
    'network_error': 'Erreur réseau. Vérifiez votre connexion.',
    'fetch_error': 'Échec de récupération. Veuillez réessayer.',
    'unknown_error': 'Une erreur inattendue s\'est produite.',
    'retry': 'Réessayer',

    // Status Messages
    'normal': 'Normal',
    'warning': 'Avertissement',
    'critical': 'Critique',

    // General
    'loading': 'Chargement...',
    'success': 'Succès',
    'ok': 'OK',

    // Dashboard & Hangars
    'nav_home': 'Accueil',
    'hangars': 'Hangars',
    'live_data': 'Données en direct',
    'simulated': 'Simulé',

    // Hangar Details
    'hangar_map': 'Carte',
    'sensor_readings': 'Lectures des capteurs',
    'food_level': "Niveau d'alimentation",
    'unit_kg': 'kg',
    'low_level': 'Niveau bas',
    'refill': 'Recharger',
    'refilling': 'Rechargement...',

    // History Stats
    'min': 'Min',
    'avg': 'Moy',
    'max': 'Max',

    // Heat Map
    'legend': 'Légende',
    'cold': 'Froid',
    'hot': 'Chaud',
    'zone_info': 'Informations sur les zones',
    'zone_info_desc':
        'La zone 1 affiche les données réelles. Les autres zones affichent des valeurs simulées.',

    // Settings Tab
    'owner': 'Propriétaire',
    'hangar_settings': 'Paramètres du hangar',
    'hangar_name': 'Nom du hangar',
    'data_source': 'Source de données',
    'food_capacity': 'Capacité alimentaire',
    'edit_profile': 'Modifier le profil',
    'feature_coming_soon': 'Bientôt disponible',
    'edit_profile_soon':
        "La modification du profil sera disponible dans la prochaine mise à jour.",
  };
}
