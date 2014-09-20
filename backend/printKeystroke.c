//
// keystroke.c - Pauses, then simulates a key press
// and release of the "A" key.
//
// Written by Ted Burke - last updated 17-4-2012
//
// To compile with MinGW:
//
//      gcc -o keystroke.exe keystroke.c
//
// To run the program:
//
//      keystroke.exe
//
// ...then switch to e.g. a Notepad window and wait
// 5 seconds for the A key to be magically pressed.
//
 
// Because the SendInput function is only supported in
// Windows 2000 and later, WINVER needs to be set as
// follows so that SendInput gets defined when windows.h
// is included below.
#define WINVER 0x0500
#include <windows.h>

#include <stdio.h>
 
int main()
{
    system("\"\"C:\\Program Files (x86)\\Adobe\\Reader 11.0\\Reader\\AcroRd32.exe\" /t E:\\TestPDF.pdf \"Mobile_black\"\"");
    printf("NOW!!\n");
    // This structure will be used to create the keyboard
    // input event.
    INPUT ip;
 
    // Pause for 5 seconds.
    Sleep(5000);
 
    // Set up a generic keyboard event.
    ip.type = INPUT_KEYBOARD;
    ip.ki.wScan = 0; // hardware scan code for key
    ip.ki.time = 0;
    ip.ki.dwExtraInfo = 0;
 
    // Press the "y" key
    ip.ki.wVk = 0x59; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "y" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));

    // Press the "w" key
    ip.ki.wVk = 0x57; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "w" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));
    // Press the "a" key
    ip.ki.wVk = 0x41; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "a" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));
    // Press the "n" key
    ip.ki.wVk = 0x4e; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "n" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));
    // Press the "g" key
    ip.ki.wVk = 0x47; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "g" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));
    // Press the "6" key
    ip.ki.wVk = 0x36; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "6" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));
    // Press the "9" key
    ip.ki.wVk = 0x39; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "9" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));
    // Press the "3" key
    ip.ki.wVk = 0x33; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "enter" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));
// Press the "3" key
    ip.ki.wVk = 0x0d; // virtual-key code for the "a" key
    ip.ki.dwFlags = 0; // 0 for key press
    SendInput(1, &ip, sizeof(INPUT));
 
    // Release the "enter" key
    ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
    SendInput(1, &ip, sizeof(INPUT));

 
    // Exit normally
    return 0;
}