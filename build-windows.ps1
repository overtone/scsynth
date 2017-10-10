# Dependencies
# boost - libsndfile (32 bits)
# fftw3 (libfftw3f-3.dll) needs to be located in system32 dir
# change the paths in cmake compiler flags to fit the correct paths.

Write-host "Fetch Submodules"
git submodule update --init
cd supercollider
git submodule update --init
git checkout develop
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

pushd "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\Tools"
cmd /c "VsDevCmd.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd
Write-Host "`nVisual Studio 2017 Command Prompt variables set." -ForegroundColor Yellow

cmake -DSUPERNOVA:BOOL=OFF -DLIBSCSYNTH:BOOL=ON -DSC_IDE:BOOL=OFF -DSC_QT:BOOL=OFF --build ../../supercollider

#  -DSNDFILE_LIBRARY="C:\Program Files (x86)\Mega-Nerd\libsndfile\lib\libsndfile-1.lib" -DSNDFILE_INCLUDE_DIR="C:\Program Files (x86)\Mega-Nerd\libsndfile\include" -DFFTW3F_INCLUDE_DIR="C:\Users\Obby\Documents\supercollider\fftw-include\api" -DFFTW3F_LIBRARY="C:\Users\Obby\Documents\supercollider\fftw\libfftw3l-3.dll" 

MSBuild.exe .\ALL_BUILD.vcxproj /p:VCTargetsPath="C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\Common7\IDE\VC\VCTargets"
MSBuild.exe .\INSTALL.vcxproj
cd ..\scmake-extras
cmake ..\..\sc3-plugins -DSC_PATH=..\..\supercollider -DSC_QT:BOOL=OFF
MSBuild.exe .\ALL_BUILD.vcxproj
MSBuild.exe .\INSTALL.vcxproj
cd C:\Users\Obby\Documents\supercollider\scsynth