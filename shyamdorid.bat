SET /P apk= Enter APK file name 	
SET /P javaloc= Enter JavaLocation	
java -jar apktool.jar d -d %apk% apk_smali
fart.exe -c "apk_smali\AndroidManifest.xml" "<application" "<application android:debuggable=\"true\""
java  -jar apktool.jar b -d apk_smali
cd apk_smali
cd dist
copy %apk% "..\..\shyam.apk"
cd ..
cd ..
"%javaloc%\jarsigner" -keystore mystore.keystore -storepass shyamkumar shyam.apk skssk
unzip shyam.apk -d apk_dex
dex2jar\dex2jar.bat "apk_dex\classes.dex"
