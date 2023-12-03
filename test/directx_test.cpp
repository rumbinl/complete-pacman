#ifndef UNICODE
#define UNICODE
#endif

#ifndef NOMINMAX
#define NOMINMAX 
#endif

#include <windows.h>

#include <iostream>

LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	switch(uMsg)
	{
		case WM_DESTROY:
			PostQuitMessage(0);
			return 0;
		case WM_PAINT:
		{
		}
		return 0;
	}
	return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

int main()
{
	const wchar_t CLASS_NAME[] = L"DirectX Test";

	HINSTANCE hInstance = GetModuleHandle(0);
	
	WNDCLASS wc = {};
	wc.lpfnWndProc = WindowProc;
	wc.hInstance = hInstance; 
	wc.lpszClassName = CLASS_NAME;

	RegisterClass(&wc);

	HWND hwnd = CreateWindowEx(0, CLASS_NAME, L"DirectX Test", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL);

	if(hwnd == NULL)
	{
		return 0;
	}
	
	ShowWindow(hwnd, SW_SHOW);

	MSG msg = {};
	while (GetMessage(&msg, NULL, 0, 0) > 0)
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return 0;
}
