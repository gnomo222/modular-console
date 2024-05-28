This project consists of a console application run in Lua.  
It allows the creation of new commands by simply adding Lua files to the `comms` folder .

> This project uses Lua 5.4.6.  
> This project is a **work in progress.**  

In order to `make`, you will want to edit the `LUASRCDIR` and `LIBLUA`[^1] variables inside the Makefile.
You will also want to set your platform. Currently, this project supports Windows and Linux only.  
It also requires the *curses* library when building for Linux.

[^1]: in order to get the Lua library file **(liblua.a for Linux, lua54.dll for Windows)**, you'll need to `make` Lua
