**sasbuild.ps1** is a very simple automated build system for SAS code in Windows.

## Motivation

Automated build systems are convenient. They help you execute multiple programs one after another to get to a final result, so that your project can be conveniently split up into discrete programs. And they help you figure out which programs need to be run to update the final results, so you don't have to run everything top-to-bottom each time you change a part of the code.

There are many excellent and powerful build systems. But I often use SAS to process confidential data on a secured Windows machine where I can't install new software. In that software environment, my build system is limited to something I can implement myself that only uses tools pre-installed on Windows. So I developed **sasbuild.ps1**, a roughly 50 line script which runs in a Windows Powershell terminal.

## How it works

**sasbuild.ps1** will go line-by-line through your build script and assess whether the SAS program on each line needs to be run. It decides by checking the timestamps on the `.sas` code file and the `.log` log file of the same name. Each SAS program is run if and only if:

1. It does not have an associated `.log` file.
2. The `.sas` file was changed more recently than the associated `.log` file.
3. The `.log` file of the **previous** SAS program in the build script was changed more recently than the associated `.log` file.
4. The `-force` option was specified.

Essentially, **sasbuild.ps1** finds the first program that needs to be re-run according to the timestamps, then runs that program and all subsequent programs in the build script.

Of course, it's entirely possible that a program needs to be re-run even if none of the code has changed. Perhaps the data it loads has changed! In that case, you can either delete the `.log` file or specify `-force` when you run **sasbuild.ps1**.

## Setup

* Download [**sasbuild.ps1**](https://raw.githubusercontent.com/michaelstepner/sasbuild/master/sasbuild.ps1), and save it somewhere convenient on your computer.
* Open **sasbuild.ps1** in a text editor. Look at the section marked `#Config`. If needed, update the paths to the SAS executable and the SAS config file to the correct paths on your computer.
* Create a plain text file with a list of the SAS programs that need to be run to build your project. Put the path to each SAS program on its own line, omitting the ".sas" file extension. Paths can be absolute or relative. For example, suppose you have two programs: **first.sas** and **second.sas**. Then you could open Notepad and create a file called **myproject.txt** containing:

```
code\first
code\second
```

or

```
C:\<full path>\myproject\code\first
C:\<full path>\myproject\code\second
```

* Open a Windows Powershell terminal (Start Menu > Accessories > Windows Powershell > Windows Powershell). Suppose you've saved **sasbuild.ps1** and a build script named **myproject.txt** in the same folder. Then you can use `cd` to navigate to that folder, then build your project by running `.\sasbuild.ps1 -build myproject.txt`. Alternatively, you can specify a full path to either the .ps1 executable or your build script.

## Syntax

**sasbuild.ps1** accepts the following arguments:

* `-build <path to build script>` is a mandatory argument that specifies which script to build
* `-force` will cause every SAS program listed in the build script to run, without checking whether it needs to be re-run
* `-dryrun` will print the SAS programs that would be run, without actually running them

## License

All of the files in this repository are released to the public domain under a [CC0 license](https://creativecommons.org/publicdomain/zero/1.0/) to permit the widest possible reuse.