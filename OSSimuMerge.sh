#set the path for check out
output_path="${PROJECT_DIR}/SDK/"
xcodeproj_name=${PROJECT_NAME}.xcodeproj
mkdir -p "${output_path}"
 
 #copy the os.framework to the ouput path
cp -R "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework" "${output_path}/"

 #merge the library and then it will come out under the output path
 lipo -create "${BUILD_DIR}/${CONFIGURATION}-iphoneos/${PROJECT_NAME}.framework/${PROJECT_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/${PROJECT_NAME}"  -output "${output_path}/${PROJECT_NAME}.framework/${PROJECT_NAME}"
 

 #copy the architectures support for simulator to the output framework
simulator_proj_path="${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/."
 cp -R "${simulator_proj_path}" "${output_path}/${PROJECT_NAME}.framework/Modules/${PROJECT_NAME}.swiftmodule/"
 
  #change the architecture support for build defines in the SDKName-Swift.h
swiftHeader="${output_path}${PROJECT_NAME}.framework/Headers/${PROJECT_NAME}-Swift.h"
str1="#if 0"
str2="#elif defined(__arm64__) && __arm64__"
str3="#if defined(__x86_64__) && __x86_64__ || (__arm64__) && __arm64__"
sed -i '' 's/#if 0//g' $swiftHeader
sed -i '' 's/#elif defined(__arm64__) && __arm64__//g' $swiftHeader
sed -i '' "1 a\\
$str3" $swiftHeader

#ok
open "${output_path}"
