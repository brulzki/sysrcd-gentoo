<ALL> 
<ALL> 070FF107 | 0FF207 | 0FF307 | 0CF407 | 0FF507 | 0FF607 | 0FF707        0CSystemRescueCd07              09[autorun]07
<ALL> 
<ALL> 0CAutorun07 allows running your own shell scripts at system startup.
<ALL> 
<ALL> 0C*07 Autorun files are searched from many sources, in that order:
<ALL> 0Car_source07 root, 0Ccdrom07 root, 0C/root07, 0C/usr/share/sys.autorun07
<ALL> 0C*07 to be searched, 0Car_source07 must be enabled with boot option
<ALL> 0F ar_source=device07 : Attempts to use 0Cdevice07 as autorun source
<ALL> 0C/dev/fd007                     for first floppy disk
<ALL> 0C/dev/sda107                    for first partition of the sda disk
<ALL> 0Chttp://web-srv/path/to/dir07   for a web server
<ALL> 0Cnfs://nfs-srv:/path/to/dir07   for an NFS share
<ALL> 0Csmb://smb-srv:/path/to/dir07   for an SMB share
<ALL> 0C*07 In each source directory, autorun scripts are searched by name
<ALL> 0Cautorun07       script will be run unconditionally
<ALL> 0Cautorun[0-9]07  script will be run if allowed by option
<ALL> 0C*0F autoruns=1,2,7,807 : allow only some 0Cautorun[0-9]07 scripts to be run.
<ALL> - All allowed 0Cautorun[0-9]07 scripts will be chained in numeric order
<ALL> - The first script returning a non-0 value (error) breaks the chain
<ALL> 0C*07 Only the 0Cfirst07 source where autorun scripts are found is used.
<ALL> 0C*0F ar_nodel07 : do not delete the local copy of the script after execution.
<ALL> 0C*0F ar_ignorefail07 : do not stop autorun when an autorun script fails.
<ALL> 0C*0F ar_nowait07 : do not wait for keypress after execution of any autorun.
<ALL> 
