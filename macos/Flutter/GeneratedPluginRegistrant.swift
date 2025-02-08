//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import app_installer
import cloud_firestore
import downloadsfolder
import firebase_auth
import firebase_core
import firebase_storage
import open_file_mac
import path_provider_foundation
import shared_preferences_foundation
import sqflite_darwin

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AppInstallerPlugin.register(with: registry.registrar(forPlugin: "AppInstallerPlugin"))
  FLTFirebaseFirestorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseFirestorePlugin"))
  DownloadsfolderPlugin.register(with: registry.registrar(forPlugin: "DownloadsfolderPlugin"))
  FLTFirebaseAuthPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseAuthPlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  FLTFirebaseStoragePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseStoragePlugin"))
  OpenFilePlugin.register(with: registry.registrar(forPlugin: "OpenFilePlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
}
