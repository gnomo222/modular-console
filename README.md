This project consists of a console application run in Lua.  
It allows the creation of new commands by simply adding Lua files to the `comms` folder .

> This project uses Lua 5.4.6.  
> This project is a **work in progress.**  

In order to `make`, you will need to edit the `LUASRCDIR`, `LIBLUA` and `plat` variables inside the Makefile.  
Update `plat` to match your system; it can either be linux or mingw.  
To get the liblua.a file, you need to `make` Lua.

Linux testing hasn't begun yet.
