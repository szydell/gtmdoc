;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; Copyright (c) 2017 Fidelity National Information		;
; Services, Inc. and/or its subsidiaries. All rights reserved.	;
;								;
;	This source code contains the intellectual property	;
;	of its copyright holder(s), and is made available	;
;	under a license.  If you do not know the terms of	;
;	the license, please stop and do not read further.	;
;								;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; salvage.m is a utility that removes all incorrectly marked busy blocks for the specified region.
; During execution it displays the DSE commands it attemping to execute and aborts execution
; when it encounters an error.
;
; It dumps the output of the incorrectly marked busy block in ZWR format to a file called <region>_db.zwr.
; It sets the abandoned_kills and kill_in_prog flags in the database fileheader to false.
;
;Steps to run the salvage utility are as follows:
;(1) Perform an argumentless MUPIP RUNDOWN before running this utility.
;    Ensure that there are no INTEG errors other than the incorrectly marked busy block errors.
;(2) $gtm_dist/mumps -r ^salvage
;(3) Specify the region name. If no region is specified, the utility assumes DEFAULT.
;(4) If the utility reports a DSE error, fix that error and run the salvage utility again.
;
; Note: After completing repairs with the salvage utility, open the <REGION>_db.zwr file and
;       examine its contents. If there is a need to recover the data from the incorrectly marked
;       busy blocks, perform a MUPIP LOAD <REGION>_db.zwr to load that data back to the database.
salvage
	new
	new $etrap
	set $etrap="use $principal write $zstatus,!,""See "",$zjobexam(),"" for more information"",!"
	; What region to target
	read !,"Set REGION to <DEFAULT>: ",region s:region="" region="DEFAULT"
	write !,?8,region,!
	set pipe="pipe"
	set dse="$gtm_dist/dse"
	set integcmd="$gtm_dist/mupip integ -fast -nomap -region "_region
	set skip=$char(32,10,13)
	set old="",lenold=0,blk=0
	;
	write !,"MUPIP INTEG for region '",region,"'",!
	open pipe:(command=integcmd)::pipe
	use pipe
	for  read integ($increment(integ)) quit:($zeof)
	close pipe
	;
	write !,"Generate DSE commands to clear benign bitmap errors",!
	set:region'=$VIEW("GVNEXT","") dsecmd($increment(dsecmd))="find -region="_region
	set dsecmd($increment(dsecmd))="open -file="_region_"_db.zwr"
	for i=1:1:integ do:integ(i)["%GTM-" checkerrors(i)
	;
	if 3>dsecmd write "There are no bitmap errors to fix. INTEG results to follow",! do  quit
	. for i=1:1:integ write integ(i),!
	; Clear the abandoned kills
	set dsecmd($increment(dsecmd))="close"
	set dsecmd($increment(dsecmd))="change -fileheader -abandoned_kills=0"
	set dsecmd($increment(dsecmd))="change -fileheader -kill_in_prog=0"
	write !,"Execute DSE commands to fix incorrect marked busy errors",!
	open pipe:(command=dse:exception=$etrap)::pipe
	use pipe
	for i=1:1 read line(i):1 quit:line(i)["DSE>"!(line(i)="")
	for dsecmd=1:1:dsecmd do
	. use $principal write:$length(dsecmd(dsecmd)) ?2,dsecmd(dsecmd),!
	. use pipe write:$length(dsecmd(dsecmd)) dsecmd(dsecmd),!
	. for i=1:1 read out($increment(out)):1 quit:out(out)["DSE>"!(out(out)["GTM-E")!($zeof)
	. do:(out(out)["GTM-E")!(out(out)["Error:") handleerr
	write /eof
	close pipe
	write ?8,"If you need to MUPIP LOAD the salvaged blocks, execute the following command",!
	write ?8,"$gtm_dist/mupip load ",region,"_db.zwr",!
	write !,"Salvage of region '",region,"' complete, see ",$zjobexam("salvage.zshow")," for more details",!
	zsystem integcmd
done	quit

; Verify the errors are only bitmap related & generate the DSE commands to dump blocks (if requested) & reset incorrect busy blocks
checkerrors(lineno)
	set line=integ(lineno)
	set nextline=$get(integ(lineno+1))
	do:(line["%GTM-W-DBMRKBUSY")  quit 	; Block incorrectly marked busy
	. if '$data(j) for j=1:1:$length(nextline) quit:skip'[$extract(nextline,j)
	. set blk=$piece($piece($extract(nextline,j,999)," ",1),":",1)
	. ; if you wish to eliminate, rather than save the contents of loose busy blocks comment out the below line
	. set dsecmd($increment(dsecmd))="dump -zwr -block="_blk
	. set dsecmd($increment(dsecmd))="map -block="_blk_" -free"
	quit:(line["%GTM-W-DBLOCMBINC")		; Local bitmap does not match block state
	quit:(line["%GTM-W-DBMBPFLDLBM") 	; Master bitmap shows block as full
	quit:(line["%GTM-E-INTEGERRS")		; Expected due to the above errors
	quit:(line["%GTM-W-MUKILLIP")		; Expected when kill_in_prog=1
	use $principal
	write !,"ERROR: Unexpected error encountered in MUPIP INTEG output. Printing the current three lines",!
	for k=lineno:1:lineno+3 write:$data(integ(k)) integ(k),!
	write "See ",$zjobexam()," for more information",!
	zgoto -1:done
disp(data,title)
	write title,!
	set x="" for  set x=$order(data(x)) quit:x=""  write:$length(data(x)) ?8,data(x),!
	quit
handleerr
	close pipe
	use $principal
	write "salvage.m encountered an error while executing ",!
	write ?8,dsecmd(dsecmd)
	write !,"Please fix the following error(s) and then run salvage.m again",!
	do disp(.out,"DSE Error:")
	zgoto 0
