
================================================================
Welcome to SystemRescueCd for SPARC (www.sysresccd.org)   [help]
================================================================

________MAIN SCREEN__________
* Type "main"   to see the main boot screen

________BOOT PROBLEMS__________
You may have problems when booting linux on sparc. Many people 
have error messages like "illegal instruction" or messages about
interrupts when booting linux on sparc. Here is how to solve 
these boot problems:
1. Check you have a sparc64 architecture (sun4u, sun4v or newer)
2. Upgrade OBP (OpenBoot Prom is the firmware)
3. Cold boot instead of typing "boot cdrom". You will first have
   to define the cdrom as first boot device in OBP with 
   "setenv boot-device cdrom disk" and then poweroff and boot.
More details about these problems on http://www.sysresccd.org and
you can post questions in the SystemRescueCd forums.

