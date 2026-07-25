plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "ru.megacash.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "ru.megacash.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

    }

    // Нативные библиотеки сторонних плагинов приходят сразу под все
    // архитектуры: флаг --target-platform фильтрует только библиотеки
    // Flutter. Без этого в APK ехали x86_64 и armeabi-v7a сборки
    // Tesseract — двенадцать мегабайт, бесполезных на телефоне.
    packaging {
        jniLibs {
            excludes += listOf("lib/x86_64/**", "lib/armeabi-v7a/**")
        }
    }

    buildTypes {
        release {
            // Боевой ключ подключается на шаге 8, перед публикацией.
            // До тех пор release подписывается отладочным ключом,
            // чтобы `flutter run --release` работал.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
