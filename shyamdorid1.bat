unzip apk_dex\classes_dex2jar.jar -d apk_classes
for /r %%G in (*.class) do (
md "apk_java_temp%%~pG"
jad -s .java -d "apk_java_temp%%~pG\" "%%G"
) 
SET myloc=%~p0
cd apk_java_temp\%~p0
move apk_classes c:%myloc%\apk_java
cd\
cd %myloc%
RD apk_java_temp /s /q
copy scrippy.bat apk_java
copy grep.exe apk_java
copy gawk.exe apk_java
cd apk_java
mkdir OUTPUT
for /r %%G in (*.java) do (
grep -H -i -n -e "//" "%%G" >> "OUTPUT\Temp_comment.txt"
type -H -i  "%%G" |gawk "/\/\*/,/\*\//" >> "OUTPUT\MultilineComments.txt"
grep -H -i -n -v "TODO" "OUTPUT\Temp_comment.txt" >> "OUTPUT\SinglelineComments.txt"

grep -H -i -n -C2 -e "putString" "%%G" >> "OUTPUT\verify_sharedpreferences.txt"
grep -H -i -n -C2 -e "MODE_PRIVATE" "%%G" >> "OUTPUT\Modeprivate.txt"
grep -H -i -n -C2 -e "MODE_WORLD_READABLE" "%%G" >> "OUTPUT\Worldreadable.txt"
grep -H -i -n -C2 -e "MODE_WORLD_WRITEABLE" "%%G" >> "OUTPUT\Worldwritable.txt"
grep -H -i -n -C2 -e "addPreferencesFromResource" "%%G" >> "OUTPUT\verify_sharedpreferences.txt"

grep -H -i -n  -e "getExternalStorageDirectory()" "%%G" >> "OUTPUT\SdcardStorage.txt"
grep -H -i -n  -e "sdcard" "%%G" >> "OUTPUT\SdcardStorage.txt"

grep -H -i -n  -e "addJavascriptInterface()" "%%G" >> "OUTPUT\Temp_probableXss.txt"
grep -H -i -n  -e "setJavaScriptEnabled(true)" "%%G" >> "OUTPUT\Temp_probableXss.txt"
grep -H -i -n -v "import" "OUTPUT\Temp_probableXss.txt" >> "OUTPUT\probableXss.txt"

grep -H -i -n  -e "MD5" "%%G" >> "OUTPUT\Temp_weakencryption.txt"
grep -H -i -n  -e "base64" "%%G" >> "OUTPUT\Temp_weakencryption.txt"
grep -H -i -n  -e "des" "%%G" >> "OUTPUT\Temp_weakencryption.txt"
grep -H -i -n  -v "import" "OUTPUT\Temp_weakencryption.txt" >> "OUTPUT\Weakencryption.txt"

grep -H -i -n -C3  "http://" "%%G" >> "OUTPUT\Temp_overhttp.txt"
grep -H -i -n -C3 -e "HttpURLConnection" "%%G" >> "OUTPUT\Temp_overhttp.txt"
grep -H -i -n -C3 -e "URLConnection" "%%G" >> "OUTPUT\Temp_OtherUrlConnection.txt"
grep -H -i -n -C3 -e "URL" "%%G" >> "OUTPUT\Temp_OtherUrlConnection.txt"
grep -H -i -n  -e "TrustAllSSLSocket-Factory" "%%G" >> "OUTPUT\BypassSSLvalidations.txt"
grep -H -i -n -e "AllTrustSSLSocketFactory" "%%G" >> "OUTPUT\BypassSSLvalidations.txt"
grep -H -i -n -e "NonValidatingSSLSocketFactory" "%%G" >> "OUTPUT\BypassSSLvalidations.txt" 
grep -H -i -n  -v "import" "OUTPUT\Temp_OtherUrlConnection.txt" >> "OUTPUT\OtherUrlConnections.txt"
grep -H -i -n  -v "import" "OUTPUT\Temp_overhttp.txt" >> "OUTPUT\UnencryptedTransport.txt"

grep -H -i -n  -e "db" "%%G" >> "OUTPUT\Temp_sqlcontent.txt" 
grep -H -i -n  -e "sqlite" "%%G" >> "OUTPUT\Temp_sqlcontent.txt" 
grep -H -i -n  -e "database" "%%G" >> "OUTPUT\Temp_sqlcontent.txt" 
grep -H -i -n  -e "insert" "%%G" >> "OUTPUT\Temp_sqlcontent.txt" 
grep -H -i -n -e "delete" "%%G" >> "OUTPUT\Temp_sqlcontent.txt" 
grep -H -i -n  -e "select" "%%G" >> "OUTPUT\Temp_sqlcontent.txt" 
grep -H -i -n  -e "table" "%%G" >> "OUTPUT\Temp_sqlcontent.txt" 
grep -H -i -n -e "cursor" "%%G" >> "OUTPUT\Temp_sqlcontent.txt" 
grep -H -i -n -v "import" "OUTPUT\Temp_sqlcontent.txt" >> "OUTPUT\Sqlcontents.txt"


grep -H -i -n  -F "Log." "%%G" >> "OUTPUT\Logging.txt" 

grep -H -i -n -e "Toast.makeText" "%%G" >> "OUTPUT\Temp_Toast.txt" 
grep -H -i -n -v "//" "OUTPUT\Temp_Toast.txt" >> "OUTPUT\Toast_content.txt"

grep -H -i -n  -e "android:debuggable" "%%G" >> "OUTPUT\DebuggingAllowed.txt" 

grep -H -i -n  -e "uid\|user-id\|imei\|deviceId\|deviceSerialNumber\|devicePrint\|X-DSN\|phone\|mdn\|did\|IMSI\|uuid" "%%G" >> "OUTPUT\Temp_Identifiers.txt" 
grep -H -i -n -v "//" "OUTPUT\Temp_Identifiers.txt" >> "OUTPUT\Device_Identifier.txt"


grep -H -i -n  -e "getLastKnownLocation()\|requestLocationUpdates()\|getLatitude()\|getLongitude()\|LOCATION" "%%G" >> "OUTPUT\LocationInfo.txt" 
)
del grep.exe
del gawk.exe
cd ..
move apk_java\OUTPUT 
copy grep.exe apk_smali
copy gawk.exe apk_smali
cd apk_smali
mkdir OUTPUT
for /r %%G in (*.xml) do (
grep -H -i -n -e filterTouchesWhenObscured\=\"true\" "%%G" >> "OUTPUT\Temp_tapjacking.txt"
grep -H -i -n -e "<Button" "%%G" >> "OUTPUT\tapjackings.txt" 
grep -H -i -n  -e "WRITE_EXTERNAL_STORAGE" "%%G" >> "OUTPUT\SdcardStorage.txt"  
grep -H -i -n -e "<Input" "%%G" >> "OUTPUT\Temp_autocomp.txt" 
) 
del grep.exe
del gawk.exe
cd ..
move apk_smali\OUTPUT OUTPUT\XML