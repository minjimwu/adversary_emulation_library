x86_64-w64-mingw32-g++ -static -std=c++20 -Wall -Wextra -Werror -o Keylogger\bin\keylogger.exe Keylogger\Keylogger\keylogger.cpp  -lwtsapi32
strip -s Keylogger\bin\keylogger.exe
objdump --syms Keylogger\bin\keylogger.exe

cp .\Keylogger\bin\keylogger.exe ..\payloads\carbon\keylogger.exe