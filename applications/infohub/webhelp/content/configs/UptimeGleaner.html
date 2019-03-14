; No claim of copyright is made with regard to to this code. YOU MUST UNDERSTAND,
; AND APPROPRIATELY ADJUST, THIS MODULE BEFORE USING IN A PRODUCTION ENVIRONMENT.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UptimeGleaner.m is the PipeLine Gleaner of the uptime and Log File Monitoring (ULFM)
; Reference Implementation. It monitors the output of the uptime command.
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
; UptimeGleaner.m is a part of ULFM_RI.zip which can be download from the User Documentation website.
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Invoked prior to a new file getting processed, this function defines a few	;
; configuration options 							;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PreExpr(%l)
	; Define the hardcoded relationship with the InfoDict
	set ^UptimePath($job)=3030400
	set ^LoadPath($job,1)=3030401
	set ^LoadPath($job,5)=3030405
	set ^LoadPath($job,15)=3030415
	set ^Delimiter($job)=$char(30)
	quit ""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Return the decoded input with the hard coded InfoDict IDs			;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InfoExpr(%l)
	new DaysUp,FiveMinAvg,FifteenMinAvg,KV,LoadAvg,OneMinAvg
	;
	; Some platforms use variable length padding for the fields, use %MPIECE to reduce these
	set UptimeInfo=$$^%MPIECE(%l," "," ")
	;
	; Get the days up, ignoring the hours and minutes
	set DaysUp=+$piece(UptimeInfo," ",3)
	;
	; Break apart the load average string starting from the last field inward. Using the '+'
	; notation forces numeric evaluation of all pieces.
	set LastField=$length(UptimeInfo," ")
	set FifteenMinAvg=+$piece(UptimeInfo," ",LastField)
	set FiveMinAvg=+$piece(UptimeInfo," ",$increment(LastField,-1))
	set OneMinAvg=+$piece(UptimeInfo," ",$increment(LastField,-1))
	;
	; Build the Key<delimiter>Value sequence
	set KV=$get(KV)_^UptimePath($job)_^Delimiter($job)_DaysUp
	set KV=$get(KV)_^Delimiter($job)_^LoadPath($job,1)_^Delimiter($job)_OneMinAvg
	set KV=$get(KV)_^Delimiter($job)_^LoadPath($job,5)_^Delimiter($job)_FiveMinAvg
	set KV=$get(KV)_^Delimiter($job)_^LoadPath($job,15)_^Delimiter($job)_FifteenMinAvg
	;
	; Return the Key<delimiter>Value sequence
	set:$get(debug,0) ^KV($job,$increment(^KV($job)))=KV
	quit KV

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Invoked before termination							;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PostExpr(%l)
	; Clean up the local configuration. It is intentional to not clean up the debug global ^KV
	kill ^UptimePath($job)
	kill ^LoadPath($job)
	kill ^Delimiter($job)
	quit ""

