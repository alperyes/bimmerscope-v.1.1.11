import java.util.Base64

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.chaquo.python")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.bmwenet.bmw_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    packaging {
        jniLibs {
            // Keep native libraries compressed in the APK using legacy packaging.
            // Serialize builds separately when investigating temporary-file locks.
            useLegacyPackaging = true
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.bmwenet.bmw_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        minSdk = maxOf(flutter.minSdkVersion, 24)
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }

    flavorDimensions += "edition"
    productFlavors {
        create("core") {
            dimension = "edition"
            resValue("string", "app_name", "BimmerScope")
        }
        create("tune") {
            dimension = "edition"
            applicationIdSuffix = ".tune"
            resValue("string", "app_name", "BimmerScope Tune")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// Run the existing SK Python seed-response implementation in the Android
// app process using versions with Chaquopy Android wheels.
chaquopy {
    defaultConfig {
        version = "3.11"
        pip {
            install("pycryptodome==3.21.0")
            install("cryptography==42.0.8")
            install("Pillow==11.0.0")
        }
    }
    sourceSets {
        getByName("main") {
            srcDir("../../SK Python")
        }
    }
}

flutter {
    source = "../.."
}

// Keep the Dart product edition in sync with the Android flavor. Without this,
// the Tune APK gets the Tune package name but can still compile Core UI.
tasks.withType<com.flutter.gradle.tasks.BaseFlutterTask>().configureEach {
    if (flavor == "tune") {
        val tuneEditionDefine = Base64.getEncoder().encodeToString(
            "BIMMERSCOPE_EDITION=tune".toByteArray()
        )
        val otherDefines = dartDefines.orEmpty()
            .split(",")
            .filter { it.isNotBlank() }
            .filterNot { encoded ->
                runCatching {
                    String(Base64.getDecoder().decode(encoded))
                        .startsWith("BIMMERSCOPE_EDITION=")
                }.getOrDefault(false)
            }
        dartDefines = (otherDefines + tuneEditionDefine).joinToString(",")
    }
}
