// Ensure these imports are still there if you are using key.properties for release signing
import java.io.FileInputStream
import java.util.Properties

// Keep your keystore properties setup at the top if you intend to sign release builds
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use {
        keystoreProperties.load(it)
    }
}

plugins {
    id("com.android.application")
    // REMOVED: id("com.google.gms.google-services") // This line is GONE
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Make sure this is YOUR unique package name, not com.example.food
    namespace = "com.rawaz.foodprophet" // Or your actual unique package name
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        // Make sure this is YOUR unique package name, not com.example.food
        applicationId = "com.rawaz.foodprophet" // Or your actual unique package name
        minSdk = 21
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties.getProperty("storeFile"))
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
        getByName("debug") {
            // Keep this debug configuration clean, no custom signingConfig here
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.8.0")
    
}

flutter {
    source = "../.."
}