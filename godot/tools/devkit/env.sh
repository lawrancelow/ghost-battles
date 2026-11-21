set -e
mkdir -p /opt/godot /opt/android/sdk ~/.local/share/godot/export_templates/4.3.stable ~/.config/godot
cd /opt/godot
[ -f Godot_v4.3-stable_linux.x86_64 ] || { curl -sSL -o g.zip https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_linux.x86_64.zip && unzip -oq g.zip && rm g.zip; }
echo godot-ok
if [ ! -f ~/.local/share/godot/export_templates/4.3.stable/android_debug.apk ]; then
 curl -sSL -o /tmp/t.tpz https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_export_templates.tpz
 cd /tmp && unzip -oq t.tpz && cp -r templates/* ~/.local/share/godot/export_templates/4.3.stable/ && rm -rf t.tpz templates
fi
echo tpl-ok
cd /opt/android/sdk
if [ ! -d cmdline-tools/latest ]; then
 curl -sSL -o c.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
 unzip -oq c.zip && mkdir -p cmdline-tools && mv cmdline-tools/ /tmp/clt && mkdir -p cmdline-tools && mv /tmp/clt cmdline-tools/latest && rm c.zip
fi
yes | cmdline-tools/latest/bin/sdkmanager --sdk_root=/opt/android/sdk --licenses >/dev/null 2>&1 || true
cmdline-tools/latest/bin/sdkmanager --sdk_root=/opt/android/sdk "platform-tools" "build-tools;34.0.0" "platforms;android-34" >/tmp/sdk.log 2>&1
echo sdk-ok
[ -f ~/debug.keystore ] || keytool -genkeypair -keystore ~/debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US" >/dev/null 2>&1
cat > ~/.config/godot/editor_settings-4.3.tres <<T
[gd_resource type="EditorSettings" format=3]

[resource]
export/android/android_sdk_path = "/opt/android/sdk"
export/android/debug_keystore = "$HOME/debug.keystore"
export/android/debug_keystore_user = "androiddebugkey"
export/android/debug_keystore_pass = "android"
export/android/java_sdk_path = "$(dirname $(dirname $(readlink -f $(which java))))"
T
echo all-ok
