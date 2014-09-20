#define WINVER 0x0500
#include <windows.h>
#include <stdio.h>

// Inspired by Ted Burke
void keystroke(const char* username) {
	// This structure will be used to create the keyboard
	// input event.
	INPUT ip;
	// Set up a generic keyboard event.
	ip.type = INPUT_KEYBOARD;
	ip.ki.wScan = 0; // hardware scan code for key
	ip.ki.time = 0;
	ip.ki.dwExtraInfo = 0;

	while (*username) {
		if ('a' <= *username && *username <= 'z') {
			// Press the key
			ip.ki.wVk = 0x41 + (*username - 'a'); // virtual-key code
			ip.ki.dwFlags = 0; // 0 for key press
			SendInput(1, &ip, sizeof(INPUT));

			// Release the key
			ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
			SendInput(1, &ip, sizeof(INPUT));
		}
		if ('A' <= *username && *username <= 'Z') {
			// Press the key
			ip.ki.wVk = 0x41 + (*username - 'A'); // virtual-key code
			ip.ki.dwFlags = 0; // 0 for key press
			SendInput(1, &ip, sizeof(INPUT));

			// Release the key
			ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
			SendInput(1, &ip, sizeof(INPUT));
		}
		if ('0' <= *username && *username <= '9') {
			// Press the key
			ip.ki.wVk = 0x30 + (*username - '0'); // virtual-key code
			ip.ki.dwFlags = 0; // 0 for key press
			SendInput(1, &ip, sizeof(INPUT));

			// Release the key
			ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
			SendInput(1, &ip, sizeof(INPUT));
		}
		if (*username == '\n') {
			// Press the key
			ip.ki.wVk = 0x0D; // virtual-key code
			ip.ki.dwFlags = 0; // 0 for key press
			SendInput(1, &ip, sizeof(INPUT));

			// Release the key
			ip.ki.dwFlags = KEYEVENTF_KEYUP; // KEYEVENTF_KEYUP for key release
			SendInput(1, &ip, sizeof(INPUT));
		}
		username++;
	}
}

void printFile(const char* file_path, const char* printer, int file_type) {
	if(file_type == 0) { // PDF
		char* tmp = malloc(10000);
		sprintf(tmp, "\"\"C:\\Program Files (x86)\\Adobe\\Reader 11.0\\Reader\\AcroRd32.exe\" /t \"%s\" \"%s\"\"", file_path, printer);
		system(tmp);
		free(tmp);
	}
}

void waitForPopup() {
	char* cmd = "tasklist /FI \"IMAGENAME eq popupcli.exe\" > tmp";
	system(cmd);
	FILE * fp;
	fp = fopen("tmp", "r");
	while(getc(fp) == 'I') {
		fclose(fp);
		Sleep(100);
		system(cmd);
		fp = fopen("tmp", "r");
	}
	fclose(fp);
	Sleep(500);
}

char* folder = "uploads";

int main() {
	printFile("E:\\TestPDF.pdf", "Mobile_black", 0);
	waitForPopup();
	keystroke("012abcD");
	return 0;
}
