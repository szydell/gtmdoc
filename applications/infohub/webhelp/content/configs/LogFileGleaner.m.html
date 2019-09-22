; No claim of copyright is made with regard to to this code. YOU MUST UNDERSTAND,
; AND APPROPRIATELY ADJUST, THIS MODULE BEFORE USING IN A PRODUCTION ENVIRONMENT.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LogFileGleaner.m is the FileLine Gleaner of the uptime and Log File Monitoring (ULFM)
; Reference Implementation. It monitors /var/log/messages and /var/log/auth.log.
;
; The ULFM Reference Implementation monitors:
;
; *  uptime: It captures up days and load averages after every 15 seconds from
;    /usr/bin/uptime output and files them in the InfoHub database.
;    It generates two notifications.when up days is less than 30 days and when
;    the 15 minutes load average is less than 1. Note that the notification for up
;    days is generated only once per day because up days gets updated only once per day.
;    The notification criteria were chosen specifically so that they generate alerts.
;
; *  System log (/var/log/messages): It automatically generates a notification when it
;    detect a GT.M error in the system log.
;
; *  Authentication log (/var/log/auth.log): It automatically generates a notification
;    when it detects a login failure in the authentication log.
;
; No claim of copyright is made with respect to this code. Please ensure that you have a correctly
; configured Infohub, correctly configured environment variables, with
; appropriate directories and files.
;
; LogFileGleaner.m is a part of ULFM_RI.zip which can be download from the User Documentation website.
; The structure of the ULFM_RI.zip is as follows:
;
;    ULFM_RI.zip
;    |-- LogFileGleaner.m      #FileLine Gleaner program for system log and authentication log).
;    |-- UptimeGleaner.m       #PipeLine Gleaner program for monitoring the outpuf of uptime.
;    |-- configs
;        `-- SimpleMonitor.cfg #InfoHub Configuration File for ULFM Reference Implementation.
;
; ULFM files are also available as part of your InfoHub distribution. For instructions on installing the ULFM
; reference implementation, please refer to the comment lines in SimpleMonitor.cfg.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Invoked prior to a new file getting processed, the PreExpr function defines a few	;
; configuration options. Note that in the current implementations, the id 9999      	;
; is hard coded to match the InfoDictItem GenericAny:Anything.		   	        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PreExpr(%l)
	set ^SuperSimplePath($job)=9999
	set ^Delimiter($job)=$char(30)
	write $ztrnlnm("InfoHubName"),!
	quit ""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; InfoExpr returns the Input read with the static path					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InfoExpr(%l)
	quit ^SuperSimplePath($job)_^Delimiter($job)_%l

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PostExpr is invoked before termination						;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PostExpr(%l)
	kill ^SuperSimplePath($job)
	kill ^Delimiter($job)
	quit ""

