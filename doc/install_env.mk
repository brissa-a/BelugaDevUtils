Install Beluga and BelugaDemo environement
==========================================

Prerequest
----------

You must have all of the following on your machine first:

*   [Haxe 3](http://haxe.org/download#haxe-3-0-1)
*   Un client git 
*   Apache2
*   Mysql version???

Install
-------

1.  Fork the [HaxeBeluga/Beluga](https://github.com/HaxeBeluga/Beluga) and [HaxeBeluga/Beluga](https://github.com/HaxeBeluga/BelugaDemo) on github

2.  Clone it on your desktop

3.  Update haxelib with: *haxelib selfupdate*

4.  Set your Beluga folder has local library with: *haxelib dev PATH_TO_BELUGA_FOLDER*

5.  Now you should be able to compil belugaDemo with: *haxe BelugaDemo.xml*

6.  Paste the .htaccess file to the build folder (/bin).

7.  Copy the content of the /bin folder in your document root apache folder

8.  Create belugeDemo database in mysql (login: root, password: \*no password\*)

9.  You are done !
