import java.util.Properties

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

    // Боевой ключ описан в android/key.properties — файл в репозиторий
    // не попадает и попасть не должен: с ним кто угодно выпустит
    // обновление приложения от вашего имени. Если файла нет, сборка
    // подписывается отладочным ключом и остаётся пригодной для проверки
    // на телефоне, но не для публикации.
    val keystoreProperties = Properties()
    val keystoreFile = rootProject.file("key.properties")
    val hasReleaseKey = keystoreFile.exists()
    if (hasReleaseKey) {
        keystoreFile.inputStream().use { keystoreProperties.load(it) }
    }

    signingConfigs {
        if (hasReleaseKey) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                val storePath = keystoreProperties.getProperty("storeFile")
                if (storePath != null) {
                    storeFile = rootProject.file(storePath)
                }
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKey) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }

            // Сжатие кода и ресурсов: APK меньше, а имена классов
            // в стектрейсах всё равно не нужны — крашлитики нет.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
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
