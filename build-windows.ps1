Write-host "Fetch Submodules"
git submodule update --init
cd supercollider
git submodule update --init
cd ../sc3-plugins
git submodule update --init
cd ../
New-Item -ItemType Directory -Force target
cd target
Remove-Item -Recurse -ErrorAction Ignore scmake
Remove-Item -Recurse -ErrorAction Ignore scmake-extras
mkdir scmake
mkdir scmake-extras
cd scmake
cmake ../../supercollider -DSUPERNOVA:BOOL=OFF -DLIBSCSYNTH:BOOL=ON -DSC_IDE:BOOL=OFF -DSC_QT:BOOL=OFF
MSBuild.exe .\ALL_BUILD.vcxproj /p:VCTargetsPath="C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\IDE\VC\VCTargets"
cd C:\Users\Obby\Documents\supercollider\scsynth