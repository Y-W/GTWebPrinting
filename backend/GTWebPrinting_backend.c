#define WINVER 0x0500
#include <windows.h>
#include <dirent.h>
#include <stdio.h>
#include <string.h>

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
	if (file_type == 0) { // PDF
		char tmp[10000];
		sprintf(tmp,
				"\"\"C:\\Program Files (x86)\\Adobe\\Reader 11.0\\Reader\\AcroRd32.exe\" /t \"%s\" \"%s\"\"",
				file_path, printer);
		system(tmp);
	}
}

void waitForPopup() {
	char* cmd = "tasklist /FI \"IMAGENAME eq popupcli.exe\" > tmp";
	system(cmd);
	FILE * fp;
	fp = fopen("tmp", "r");
	while (getc(fp) == 'I') {
		fclose(fp);
		Sleep(100);
		system(cmd);
		fp = fopen("tmp", "r");
	}
	fclose(fp);
	Sleep(500);
}

char* upload_directory = "uploads";
char* status_directory = "status";

struct file_list;
typedef struct file_list file_list;
struct file_list {
	char* file_name;
	file_list* next;
};

file_list* list_head = NULL;
file_list* list_tail = NULL;

void list_add(char* file_name) {
	if (list_head == NULL) {
		list_head = malloc(sizeof(file_list));
		list_tail = list_head;
		list_head->file_name = file_name;
		list_head->next = NULL;
	} else {
		file_list* tmp = malloc(sizeof(file_list));
		tmp->file_name = file_name;
		tmp->next = NULL;
		list_tail->next = tmp;
		list_tail = tmp;
	}
}

void list_pophead() {
	if (list_head->next == NULL) {
		list_tail = NULL;
	}
	file_list* tmp = list_head->next;
	free(list_head);
	list_head = tmp;
}


char* status1 = "In Queue";
char* status2 = "Printed";

int get_status(char* username, char* file_name) {
	char sfn[1000];
	sprintf(sfn, "%s\\%s.txt", status_directory, username);
	char s1[1000];
	sprintf(s1, "%s : %s\n",  file_name, status1);
	char s2[1000];
	sprintf(s2, "%s : %s\n",  file_name, status2);
	FILE* fp = fopen(sfn, "r");
	if (fp == NULL)
		return 0;
	char line[1000];
	int flag = 0;
	while (fgets(line, sizeof(line), fp)) {
		if (strcmp(line, s1) == 0) {
			flag = 1;
		}
		if (strcmp(line, s2) == 0) {
			flag = 2;
		}

	}
	fclose(fp);
	return flag;
}

void update_status(char* username, char* file_name, int flag) {
	FILE* tmp = fopen("tmp_status", "w");
	char sfn[1000];
	sprintf(sfn, "%s\\%s.txt", status_directory, username);
	char s1[1000];
	sprintf(s1, "%s : %s\n",  file_name, status1);
	char s2[1000];
	sprintf(s2, "%s : %s\n",  file_name, status2);
	FILE* fp = fopen(sfn, "r");
	if (fp != NULL) {
		char line[1000];
		while (fgets(line, sizeof(line), fp)) {
			if (strcmp(line, s1) != 0 && strcmp(line, s2) != 0) {
				fprintf(tmp, "%s", line);
			}
		}
		fclose(fp);
	}
	if (flag == 1) {
		fprintf(tmp, "%s", s1);
	}
	if (flag == 2) {
		fprintf(tmp, "%s", s2);
	}
	fclose(tmp);
	char cmd[10000];
	sprintf(cmd, "move tmp_status \"%s\\%s.txt\"", status_directory, username);
	system(cmd);
}


void scan_directory() {
	DIR *dp;
	struct dirent *dirp;
	dp = opendir(upload_directory);
	while ((dirp = readdir(dp)) != NULL) {
		if (dirp->d_name[0] == '.')
			continue;
		if (strchr(dirp->d_name, '-') == NULL)
			continue;
		printf("### %s %d\n", dirp->d_name, dirp->d_namlen);
	}
	closedir(dp);
}

int main() {
	printf("%d\n", get_status("a", "b-c.d"));
	update_status("a", "b-c.d", 1);
	update_status("a", "c-c.d", 1);
	printf("%d\n", get_status("a", "b-c.d"));
	update_status("a", "b-c.d", 2);
	printf("%d\n", get_status("a", "b-c.d"));
	update_status("a", "b-c.d", 0);
	printf("%d\n", get_status("a", "b-c.d"));

//	scan_directory();
//	printFile("E:\\TestPDF.pdf", "Mobile_black", 0);
//	waitForPopup();
//	keystroke("012abcD");
	return 0;
}
