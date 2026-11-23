import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")

    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration

    id("kotlin-android")

    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "br.com.avantiapps.petto"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "br.com.avantiapps.petto"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Lê a GOOGLE_API_KEY do arquivo .env
        val envApiKey = rootProject.file(".env").takeIf { it.exists() }
            ?.readLines()
            ?.firstOrNull { it.trim().startsWith("GOOGLE_API_KEY=") }
            ?.substringAfter("=")
            ?.trim()
            .orEmpty()

        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] =
            envApiKey.ifEmpty { System.getenv("GOOGLE_API_KEY").orEmpty() }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}