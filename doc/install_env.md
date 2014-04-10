Install Beluga and BelugaDemo environment
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

3.  If you are on windows you need to Update haxelib
  
	-	type: *haxelib selfupdate*
  
  -	then as requested by the previous command: *haxe update.xml*

4.	Set your Beluga folder has local library with: *haxelib dev PATH_TO_BELUGA_FOLDER*

6.  Now you should be able to compil BelugaDemo with: *haxe BelugaDemo.xml*

7.  Paste the .htaccess file to the build folder (/bin).

8.  Copy the content of the /bin folder in your document root apache folder

9.  Create belugeDemo database in mysql (login: root, password: \*no password\*)

10.  You are done !
