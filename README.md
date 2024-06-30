This project consists of a console application run in Lua.  
It allows the creation of new commands by simply adding Lua files to the `comms` folder .

> This project uses Lua 5.4.6.  
> This project is a **work in progress.**  

In order to `make` the project, you will need to edit the `LUASRCDIR` and `LIBLUA` variables inside the Makefile.  
To get the lua library file, you need to `make` Lua54's [source](https://lua.org/versions.html#5.4).  
You also need to specify your platform by changing the variable `platform`; put either **"windows"** or **"linux"**.

Linux version requires the curses library to be installed in GNU.
