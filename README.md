what_now
========

Executable (packed as a ruby gem) for finding TODO comments inside code
Requires Ruby 1.9.* and above


Installation
---------
If you use rbenv or RVM:
```
gem install what_now
```
Otherwise you might need
```
sudo gem install what_now
```


Usage
-----
```
$ wnow
```
Will return all the todos in the following format inside files:

* TODO this is the text

Where 'this is the text' will be returned, together with the path and line number

You can also use the options *--dir, -d*, in order to specify the directory in which
todos are going to be looked for, and *--ext -e* for checking only certain file extension
(without prepending the '.', this means, call *--ext rb* instead of *--ext .rb*).
