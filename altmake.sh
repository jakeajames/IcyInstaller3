xcodebuild clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
ldid -S build/Release-iphoneos/IcyInstaller3.app/IcyInstaller3
curl -T './build/Release-iphoneos/IcyInstaller3.app/IcyInstaller3' '192.168.1.132:80'
ssh root@localhost -p 2222 'mv /IcyInstaller3 /Applications/IcyInstaller3.app && chmod 777 /Applications/IcyInstaller3.app/IcyInstaller3 && uicache && killall IcyInstaller3 && open com.artikus.IcyInstaller3'
