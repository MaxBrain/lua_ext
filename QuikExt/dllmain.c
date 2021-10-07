// dllmain.cpp : Defines the entry point for the DLL application.

#include "lua.h"
#include "lauxlib.h"

#include <windows.h>

/* Pop-up a Windows message box with your choice of message and caption */
int lua_msgbox(lua_State* L)
{
    const char* message = luaL_checkstring(L, 1);
    const char* caption = luaL_optstring(L, 2, "");
    int result = MessageBoxA(NULL, message, caption, MB_OK);
    lua_pushnumber(L, result);
    return 1;
}

int __declspec(dllexport) libinit(lua_State* L)
{
    lua_register(L, "msgbox", lua_msgbox);
    return 0;
}

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}

