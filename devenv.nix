# devenv.nix
{ inputs
, pkgs
, config
, ...
}:
let
  inherit (inputs) flutter-nix android-nixpkgs;
  flutter-sdk = flutter-nix.packages.${pkgs.stdenv.system};
  sdk = (import android-nixpkgs { }).sdk (sdkPkgs:
    with sdkPkgs; [
      build-tools-30-0-3
      build-tools-34-0-0
      cmdline-tools-latest
      emulator
      platform-tools
      platforms-android-34
      platforms-android-33
      platforms-android-31
      platforms-android-28
      system-images-android-34-google-apis-playstore-x86-64
    ]);
in
{
  # https://devenv.sh/basics/
  # dotenv.enable = true;
  env.ANDROID_AVD_HOME = "${config.env.DEVENV_ROOT}/.android/avd";
  env.ANDROID_SDK_ROOT = "${sdk}/share/android-sdk";
  env.ANDROID_HOME = config.env.ANDROID_SDK_ROOT;
  env.CHROME_EXECUTABLE = "chromium";
  env.FLUTTER_SDK = "${pkgs.flutter}";
  env.GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${sdk}/share/android-sdk/build-tools/34.0.0/aapt2";

  # https://devenv.sh/packages/
  packages = [
    flutter-sdk.flutter
    pkgs.git
    pkgs.lazygit
    pkgs.chromium
    pkgs.cmake
  ];

  # https://devenv.sh/scripts/
  # Create the initial AVD that's needed by the emulator
  scripts.create-avd.exec = "avdmanager create avd --force --name phone --package 'system-images;android-33;google_apis;x86_64'";

  # https://devenv.sh/processes/
  # These processes will all run whenever we run `devenv run`
  processes.emulator.exec = "emulator -avd phone -skin 720x1280";
  processes.generate.exec = "dart run build_runner watch || true";
  # processes.grovero-app.exec = "flutter run lib/main.dart";

  enterShell = ''
    mkdir -p $ANDROID_AVD_HOME
    export PATH="${sdk}/bin:$PATH"
    export FLUTTER_GRADLE_PLUGIN_BUILDDIR="''${XDG_CACHE_HOME:-$HOME/.cache}/flutter/gradle-plugin";
  '';

  # https://devenv.sh/languages/
  languages.dart = {
    enable = true;
    package = flutter-sdk.dart;
  };
  languages.java = {
    enable = true;
    gradle.enable = false;
    jdk.package = pkgs.jdk;
  };

  # See full reference at https://devenv.sh/reference/options/
}
