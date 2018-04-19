xcodebuild clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
scp -r -P 2222 build/Release-iphoneos/IcyInstaller3.app root@localhost:/Applications
ssh mobile@localhost -p 2222 'uicache && killall IcyInstaller3; open com.artikus.IcyInstaller3'
