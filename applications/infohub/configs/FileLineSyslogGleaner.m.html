;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;								;
; 	Copyright 2013 Fidelity Information Services, Inc	;
; 								;
; 	This source code contains the intellectual property	;
; 	of its copyright holder(s), and is made available	;
; 	under a license.  If you do not know the terms of	;
; 	the license, please stop and do not read further.	;
;	    	     	    	     	    	 		;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONFIGURATION START                                                                                               ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; InfoHub paths to include in the key of the returned string; should be in the order in which they are to
; be appended to the resultant string.
AllMessagePath		; 314
GtmMessagePath		; 159
FatalMessagePath	; 265
GtmsecshrMessagePath	; 358
KillMessagePath		; 979
FailMessagePath		; 323
IndividualMessagePath	; 0

; Delimiter string between the key and the value in the returned data.
;   <Key1><Delimiter><Value1><Key2><Delimiter><Value2>...<KeyN><Delimiter><ValueN>
Delimiter		; $char(30)

; Delimiter string between the fields within the returned value.
;   <ValueX> is delimited by FieldDelimiter, for IndividualMessagePath and error messages
FieldDelimiter		; $char(31)

; Substitution characters for a tab and a newline in the syslog on the current platform.
Tab			; $char(9)
Newline			; ", "

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONFIGURATION END                                                                                                 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Invoked prior to a new file getting processed, this function picks up a few configuration options and sets the    ;
; suppplementary information for message processing and argument extraction in particular.                          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PreExpr(%l)
	do doWrite^InfoHubUtils("In PreExpr") ;#

	; We only want PreExpr to be invoked once, so quit on subsequent file rotations.
	quit:($get(^flgInitialized,0)) ""
	set ^flgInitialized=1

	; New used variables for scope separation.
	new foundBeginning,filterPosition,line,i,label,setCommand

	; Read in the configuration from the top of this module. For that go over every line and process it depending on whether it is a
	; path-related setting or not. For path-related settings the order in which they appear is the order in which they are appended
	; to the string this gleaner returns in InfoExpr.
	set (foundBeginning,filterPosition)=0
	for i=1:1 set line=$text(@("+"_i)) quit:(line["CONFIGURATION END")  set:(line["CONFIGURATION START") foundBeginning=1 do:foundBeginning
	.	set label=$$getLabel^InfoHubUtils(line)
	.	do doWrite^InfoHubUtils("  label is "_label) ;#
	.	quit:(""=label)
	.
	.	if (label["Path") do
	.	.	set setCommand="^flg"_label_"=+"_$$getCommentArg^InfoHubUtils(line)
	.	.	do doWrite^InfoHubUtils("  path setCommand1 is "_setCommand) ;#
	.	.	set @setCommand
	.	.
	.	.	set setCommand="^flg"_label_"(""pos"")="_$increment(filterPosition)
	.	.	do doWrite^InfoHubUtils("  path setCommand2 is "_setCommand) ;#
	.	.	set @setCommand
	.	else  do
	.	.	set setCommand="^flg"_label_"="_$$getCommentArg^InfoHubUtils(line)
	.	.	do doWrite^InfoHubUtils("  path setCommand is "_setCommand) ;#
	.	.	set @setCommand
	set ^flgNumOfPaths=filterPosition

	; Prepare message-processing clues.
	do setMsgInfo^messages

	quit ""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Invoked for every line read, this function returns a string that encodes various information about the syslog     ;
; message, such as whether it is from GT.M or not, the originating facility and address, mnemonic, severity, number ;
; of arguments, and the value of each argument.                                                                     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
InfoExpr(%l)
	do doWrite^InfoHubUtils("In InfoExpr") ;#

	; New used variables for scope separation.
	new fullMessage,i,j,length,allGtm,timeBlock,time,part,pos,pid,quit,isGtmMessage,posStart,posEnd,mnemonic
	new prefix,postfix,from,start,pos,count,message,failure,delimiter,returnValue

	; Find out whether this message is coming from GT.M.
	set isGtmMessage=%l?.E1"GTM".2(1"-"1.10U).10U.5N1"["1.10N1"]: %".E

	; Reporting is very simple for non-GT.M messages.
	quit:('isGtmMessage) ^flgAllMessagePath_^flgDelimiter_%l

	; Copy the full message because of the subsequent mangling.
	set fullMessage=%l

	; If there is more than one '%GTM-'-delimited part, we might be dealing with a multi-line message,
	; so make sure to break the message down into individual parts correctly.
	set length=$length(%l,": %GTM-")+$select((": "'=^flgNewline):($length(%l,^flgNewline_"%GTM-")-1),1:0)
	set allGtm=(length>1)
	do doWrite^InfoHubUtils("  allGtm: "_allGtm_"; length: "_length) ;#

	; Try to extract the timestamp.
	set time=""
	for i=3:1:4 set timeBlock=$piece(%l," ",1,i) set:(timeBlock?1U2L1.2" "1.2N1" "2N1":"2N1":"2N) time=timeBlock
	;if (""=time) do IHError^FileLine("Not able to find the timestamp.")
	quit:(""=time) ^flgFailMessagePath_^flgDelimiter_%fullMessage_^flgFieldDelimiter_"Not able to find the timestamp."

	; Try to extract the process ID.
	set (start,posStart)=$find(%l,"[")
	;if ('posStart) do IHError^FileLine("Not able to find the process ID.")
	quit:('posStart) ^flgFailMessagePath_^flgDelimiter_%fullMessage_^flgFieldDelimiter_"Not able to find the process ID."

	set posStart=$find(%l,"]: %",posStart)
	;do:('posStart) IHError^FileLine("Not able to find the beginning of a GT.M message.")
	quit:('posStart) ^flgFailMessagePath_^flgDelimiter_%fullMessage_^flgFieldDelimiter_"Not able to find the beginning of a GT.M message."
	set pid=+$extract(%l,start,posStart)
	set prefix=$extract(%l,0,posStart-2)
	set %l=$extract(%l,posStart-1,$length(%l))
	set:allGtm %l=^flgNewline_%l

	; Get the "generated from ..." part and remove it from the message.
	set from=" -- generated from "
	set postfix=""
	set quit=0
	for start=$length(%l):-1:1 do  quit:quit
	.	set pos=$find(%l,from,start)
	.	set:pos message("from")=$extract(%l,pos,$length(%l)),%l=$extract(%l,1,start-1),postfix=from_message("from"),quit=1

	; Before starting to concatenate the return value, set it to an empty string.
	set returnValue=""

	for i=1:1:length do
	.	set quit=0
	.
	.	; In case this message contains only '%GTM-'-type part(s), skip the first (empty) part.
	.	quit:(allGtm&(1=i))
	.
	.	; Get the current message part.
	.	set part=$piece(%l,(^flgNewline_"%GTM-"),i)
	.
	.	; Start with empty return value parts.
	.	for j=1:1:^flgNumOfPaths set returnValue(j)=""
	.
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.	; The following block is to report any message in its entirety.                                ;
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.
	.	; In case we have delimited the message by '%GTM-', we need to prepend the delimiter. Also start
	.	; setting the returnValue by including the key and the full message.
	.	set pos=^flgAllMessagePath("pos")
	.	set:(allGtm) returnValue(pos)="%GTM-"
	.	set returnValue(pos)=^flgAllMessagePath_^flgDelimiter_prefix_returnValue(pos)_part_postfix
	.
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.	; The following block is to report any GT.M message in its entirety.                           ;
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.
	.	; In case we have delimited the message by '%GTM-', we need to prepend the delimiter. Also start
	.	; setting the returnValue by including the key and the full message.
	.	set pos=^flgGtmMessagePath("pos")
	.	set:(allGtm) returnValue(pos)="%GTM-"
	.	set returnValue(pos)=^flgGtmMessagePath_^flgDelimiter_prefix_returnValue(pos)_part_postfix
	.
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.	; The following block is to report a processed GT.M message, which might be of interest to the ;
	.	; receiving party, depending on the current InfoHub configuration.                             ;
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.
	.	; Advance to the severity bit.
	.	set posStart=$find(part,"-")
	.	;do:('posStart) IHError^FileLine("Severity bit not found in a GT.M message.")
	.	if ('posStart) do
	.	.	set pos=^flgFailMessagePath("pos")
	.	.	set returnValue(pos)=^flgFailMessagePath_^flgDelimiter_%fullMessage_^flgFieldDelimiter_"Severity bit not found in a GT.M message."
	.	.	set quit=1
	.	; do doWrite^InfoHubUtils("  first hyphen found") ;##
	.	quit:quit
	.
	.	; Find the end position of the mnemonic block.
	.	set posEnd=$find(part,", ",posStart)
	.	;do:('posEnd) IHError^FileLine("Textual part not found in a GT.M message.")
	.	if ('posEnd) do
	.	.	set pos=^flgFailMessagePath("pos")
	.	.	set returnValue(pos)=^flgFailMessagePath_^flgDelimiter_%l_^flgFieldDelimiter_"Textual part not found in a GT.M message."
	.	.	set quit=1
	.	; do doWrite^InfoHubUtils("  end of mnemonic block found") ;##
	.	quit:quit
	.
	.	; Get the mnemonic.
	.	set mnemonic=$extract(part,posStart,posEnd-3)
	.	; do doWrite^InfoHubUtils("  mnemonic is "_mnemonic) ;##
	.
	.	; If we have preset info on the message, process it, also extracting individual arguments.
	.	set count=0,quit=0
	.	if ($data(^flgMessages(mnemonic))) do
	.	.	merge message=^flgMessages(mnemonic)
	.	.	set count=^flgMessages(mnemonic,"args")
	.	.	if (0'=count) do
	.	.	.	; Extract arguments out of the message part sans the mnemonic piece.
	.	.	.	set failure=$$parseArgs($extract(part,posEnd,$length(part)),mnemonic,count,.message)
	.	.	.	;do:failure IHError^FileLine("Failed to parse message arguments for '"_part_"'.")
	.	.	.	if (failure) do
	.	.	.	.	set pos=^flgFailMessagePath("pos")
	.	.	.	.	set returnValue(pos)=^flgFailMessagePath_^flgDelimiter_%l_^flgFieldDelimiter_"Failed to parse messages arguments for '"_part_"'."
	.	.	.	.	set quit=1
	.	if ('$data(^flgMessages(mnemonic))) do
	.	.	set pos=^flgFailMessagePath("pos")
	.	.	set returnValue(pos)=^flgFailMessagePath_^flgDelimiter_%l_^flgFieldDelimiter_"Unrecognized mnemonic "_mnemonic_"."
	.	.	set quit=1
	.	;else do IHError^FileLine("Unrecognized mnemonic '"_mnemonic_"'.")
	.
	.	quit:quit
	.
	.	; In case we have delimited the message by '%GTM-', we need to prepend the delimiter. Also start
	.	; setting the returnValue by including the key and the full message.
	.	set pos=^flgIndividualMessagePath("pos")
	.	set:(allGtm) returnValue(pos)="%GTM-"
	.	set returnValue(pos)=returnValue(pos)_part_postfix
	.
	.	; Set the extracted information about the message.
	.	set returnValue(pos)=returnValue(pos)_^flgFieldDelimiter_time
	.	set returnValue(pos)=returnValue(pos)_^flgFieldDelimiter_$get(message("facility"))
	.	set returnValue(pos)=returnValue(pos)_^flgFieldDelimiter_mnemonic
	.	set returnValue(pos)=returnValue(pos)_^flgFieldDelimiter_$get(message("severity"))
	.	set returnValue(pos)=returnValue(pos)_^flgFieldDelimiter_$get(message("from"))
	.	set returnValue(pos)=returnValue(pos)_^flgFieldDelimiter_$get(pid)
	.	set returnValue(pos)=returnValue(pos)_^flgFieldDelimiter_count
	.	if (0<count) for j=1:1:count set returnValue(pos)=returnValue(pos)_^flgFieldDelimiter_message("args",j)
	.
	.	set returnValue(pos)=$get(message("id"),-1)_^flgDelimiter_prefix_returnValue(pos)
	.
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.	; The following block is to report any fatal GT.M message in its entirety.                     ;
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.
	.	; In case we have delimited the message by '%GTM-', we need to prepend the delimiter. Also start
	.	; setting the returnValue by including the key and the full message.
	.	if ("fatal"=$get(message("severity"))) do
	.	.	set pos=^flgFatalMessagePath("pos")
	.	.	set:(allGtm) returnValue(pos)="%GTM-"
	.	.	set returnValue(pos)=^flgFatalMessagePath_^flgDelimiter_prefix_returnValue(pos)_part_postfix
	.
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.	; The following block is to report any GT.M message coming from gtmsecshr.                     ;
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.
	.	; In case we have delimited the message by '%GTM-', we need to prepend the delimiter. Also start
	.	; setting the returnValue by including the key and the full message.
	.	if (mnemonic["SECSHR") do
	.	.	set pos=^flgGtmsecshrMessagePath("pos")
	.	.	set:(allGtm) returnValue(pos)="%GTM-"
	.	.	set returnValue(pos)=^flgGtmsecshrMessagePath_^flgDelimiter_prefix_returnValue(pos)_part_postfix
	.
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.	; The following block is to report any GT.M message about a process getting killed.            ;
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.
	.	; In case we have delimited the message by '%GTM-', we need to prepend the delimiter. Also start
	.	; setting the returnValue by including the key and the full message.
	.	if (mnemonic["KILLBYSIG") do
	.	.	set pos=^flgKillMessagePath("pos")
	.	.	set:(allGtm) returnValue(pos)="%GTM-"
	.	.	set returnValue(pos)=^flgKillMessagePath_^flgDelimiter_prefix_returnValue(pos)_part_postfix
	.
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.	; Now glue the pieces together.                                                                ;
	.	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	.
	.	; Concatenate all return value parts; be sure to exclude the delimiter for the ones that are empty.
	.	for j=1:1:^flgNumOfPaths do
	.	.	if (""'=returnValue(j)) set:(""'=returnValue) returnValue=returnValue_^flgDelimiter set returnValue=returnValue_returnValue(j)

	do doWrite^InfoHubUtils("    the value of returnValue: "_returnValue) ;#

	quit returnValue

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Invoked before termination, there is currently nothing to do for this function.                                   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PostExpr(%l)
	do doWrite^InfoHubUtils("In PostExpr") ;#

	quit ""

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Extract individual arguments from the message based on the precompiled messages.m file.                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
parseArgs(message,mnemonic,count,var)
	do doWrite^InfoHubUtils("In parseArgs: "_message) ;#
	new (message,mnemonic,count,var)

	set quit=0
	set searchStart=$length(message)
	set searchLimit=searchStart+1

	for i=count:-1:1 do  quit:quit
	.	; do doWrite^InfoHubUtils("  processing arg "_i_"...") ;##
	.	set postChars=$translate(^flgMessages(mnemonic,"args",i,"postChars"),$char(9),^flgTab)
	.	; do doWrite^InfoHubUtils("  looking for '"_postChars_"' starting @"_searchStart) ;##
	.	if ((count=i)&("<END>"=postChars)) set endPos=$length(message)
	.	else  do
	.	.	set endFound=0
	.	.	for searchStart=searchStart:-1:1 quit:endFound  do
	.	.	.	; do doWrite^InfoHubUtils("    @"_searchStart_"...") ;##
	.	.	.	set endPos=$find(message,postChars,searchStart)
	.	.	.	set:(endPos&(endPos<=searchLimit)) endPos=searchStart-1,endFound=1
	.	.	.	; do:endFound doWrite^InfoHubUtils("    found arg end: "_endPos) ;##
	.	.	if ('endFound) set quit=1
	.	.	else  set searchLimit=endPos+1
	.	quit:quit
	.
	.	; do doWrite^InfoHubUtils("  found arg end: "_endPos) ;##
	.
	.	set preChars=$translate(^flgMessages(mnemonic,"args",i,"preChars"),$char(9),^flgTab)
	.	; do doWrite^InfoHubUtils("  looking for '"_preChars_"' starting @"_searchStart) ;##
	.	if ((1=i)&("<START>"=preChars)) set startPos=1
	.	else  do
	.	.	set startFound=0
	.	.	for searchStart=searchStart:-1:1 do  quit:startFound
	.	.	.	; do doWrite^InfoHubUtils("    @"_searchStart_"...") ;##
	.	.	.	set startPos=$find(message,preChars,searchStart)
	.	.	.	set:(startPos&(startPos<=searchLimit)) startFound=1
	.	.	if ('startFound) set quit=1
	.	.	else  set searchLimit=startPos
	.	quit:quit
	.
	.	; do doWrite^InfoHubUtils("  found arg start: "_startPos) ;##
	.
	.	set var("args",i)=$extract(message,startPos,endPos)
	.	; do doWrite^InfoHubUtils("  arg is '"_var("args",i)_"'") ;##

	do doWrite^InfoHubUtils("      returning "_quit) ;#
	quit quit
