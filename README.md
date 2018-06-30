This is an attempt to duplicate a LunarPages LAMP stack using vagrant.
You should be able to create a virtual machine running Linux, Apache, 
MySql and PHP with a single command (`vagrant up`), after intial setup.

Initial setup:

1. Install [VirtualBox](https://www.virtualbox.org/)
   (feel free to take all the defaults)
2. Install [Vagrant](https://www.vagrantup.com/)
   (feel free to take all the defaults)
3. Place these files in a folder on your box 
   (see `Getting these files onto your box` below).
4. Open a command shell there and execute `vagrant up`.

Once that is done (first time will take about 10 minutes), you can browse 
to these locations as a test:

- http://127.0.0.1:4567/
- http://127.0.0.1:4567/phptest.php
- http://127.0.0.1:4567/php-mysql-test.php
- http://127.0.0.1:4567/testssi.shtml

And you can put real actual code in that same folder (from step 3 above), 
in the `html` subfolder there. Also if you want you can `vagrant ssh` to 
log into the box and mess around with it there.

Packing up is easy - just `vagrant halt` to shut things down, and later 
`vagrant up` again to return to work. The 2nd `vagrant up` will be *much* 
faster than the first one.  If you want to save disk space between work 
sessions, or when you're done working on the project for a long time, use 
`vagrant destroy` to delete the VM.  (You can still `vagrant up` again later, 
it will just take a bit longer than returning from `vagrant halt`.)

NOTE: the box is created using `private networking` -- it is reachable only from 
your host machine. Read more about vagrant before changing this -- except for 
`private networking`, the box is purposefully insecure (e.g. root password is 
`vagrant`, mysql password is `vagrant`, ports are open, etc).


# Getting these files onto your box

If you're viewing this readme on a website, and you're brand new to the world of 
git, then you may be wondering how to get these files onto your machine. 
- You can save the world of git for another day, and just download a zip file, by 
  looking for a `download` link or button -- it's there, just find it.
- If you do want to install a git client, you might want to use 
  [git scm](https://git-scm.com/), and you might want to check out the installation 
  notes below.


# Installation notes for git-scm on windows box

download and docs at https://git-scm.com/

select components
- everything checked except additional icons

adjusting your path environment
- 3rd option: use git and optional unix tools from the windows command prompt
  this just modfies your PATH. you can effectively switch this option later.
  http://stackoverflow.com/a/11038641
  http://mechanicalrevolution.com/blog/git_installation.html

choosing HTTPS transport backend
- use the native windows secure channel library [windows certificate store)
  this allows you to use providence root certs

configuring the line ending conversions
- checkout windows style, commit unit-style line endings
  recommended for cross-platform
  equiv to core.autocrlf=true (git config command)
  best way to ENSURE we avoid ugly false differences
  but everyone must do this to make it work

configuring the terminal emulator to use with git bash
- use MinTTY
  just a better experience
  linux command line is a good thing to have
  can still run windows commands
  could still run git commands from cmd.exe
  https://superuser.com/questions/828046/how-to-install-mintty-into-git-bash-on-windows

configuring extra options
- check all the boxes include Enable symbolic links
  https://github.com/git-for-windows/git/wiki/Symbolic-Links

