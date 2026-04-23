; No claim of copyright is made with regard to this code.
; This is example showing two-way READ and WRITE socket communication between a client process
; and a server process. It demonstrates a possible use of $KEY and $ZKEY in managing a socket I/O setup.
; It is for explanatory purposes and is not intended for production use.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; To run this example, open two terminals. In one terminal run $gtm_dist/mumps -r server^sockexamplemulti32.
; In the other, run $gtm_dist/mumps -r client^sockexamplemulti32
;
; server^sockexamplemulti32 opens a socket connection with listen queue size of 5.
;
; client^sockexamplemulti32 attempts to establish 5 socket connections with the server. When the connection is
; successfully established:
; * For odd-numbered (1,3,5) connections, it reads the full message coming from its handler
;   on the server and writes data in the form of "OK. from clientX" where X is the connection number (1, 3, or 5).
; * For even-numbered (2,4) connections, it writes "Ok." to the server handler and reads only
;   partial message (read x#3:timeout )that the server has sent. The server sends a Lorem ipsum message like
;   "Lorem ipsum dolor sit amet, convallis in sapien aenean ante dolor sodales." but the client only reads the first
;   three characters "Lor".
;
; Once the client establishes all five connections, server^sockexamplemulti32:
; * Reads 2 bytes (read#2:1).
; * For odd-numbered connections (1,3,5), it detaches that socket and launches a job
;   (with the DETACHed socket as INPUT) and reads the remaining data (if any).
; * For even numbered connections, as there is nothing to read, it just launches a job
;   (with DETACHed socket as INPUT)and writes $ZKEY value to the terminal.
;
;   Both server and client terminals display commentary of important actions occuring during socket I/O.
;   You can also run this example by running $gtm_dist/mumps -r ^sockexamplemulti32.
;   It forks two jobs - client and server, waits for both jobs to finish, and then displays the stdout and
;   stderr of both the jobs.

sockexamplemulti32
	new client,servererr,clienterr,line,serverout,clientout,server,servercmd,clientcmd
	set servererr=$text(+0)_"_"_$job_"_server.mje"
	set serverout=$extract(servererr,1,$length(servererr)-1)_"o"
	set servercmd="server(,,,):(ERROR="""_servererr_""":OUTPUT="""_serverout_""")"
	job @servercmd
	set server=$zjob
	set clienterr=$text(+0)_"_"_$job_"_client.mje"
	set clientout=$extract(clienterr,1,$length(clienterr)-1)_"o"
	set clientcmd="client(,,):(ERROR="""_clienterr_""":OUTPUT="""_clientout_""")"
	job @clientcmd
	set client=$zjob
	for  quit:$zsigproc(server,0)&$zsigproc(client,0)  write "At ",$zdate($horolog,"MON DD, YYYY 24:60:SS")," waiting for server job ",server," & client job ",client,! hang 3
	do showfile(servererr,"Server stderr:")
	do showfile(serverout,"Server stdout:")
	do showfile(clienterr,"Client stderr:")
	do showfile(clientout,"Client stdout:")
	quit

client(portno,connectnum,timeout)
	new connectionsock,delim,detach,host,i,report,sockdev,socksel,val,x,y,zkey  ; connectionsock is for debugging purposes. You can also use ZSHOW "D":glv, as appropriate.
	set:'($data(portno)#10) portno=$piece($horolog,",",1)#63487+2048 ; if portno is not specified, set portno to a value greater than or equal to 2048
	set:'($data(connectnum)#10) connectnum=5
	set:'($data(timeout)#10) timeout=7
	set delim=$char(10) ; line feed
	set detach=""
	set host="localhost"
	set sockdev="client"
	set msg="OK."
	for i=1:1:connectnum do ; open multiple socket connections to the server
	. set socksel="client"_i
	. open sockdev:(connect=host_":"_portno_":TCP":delim=delim:attach=socksel:exception="do ioerr(0,"_portno_")":ioerror="t"):timeout:"socket"
	. do:'$test ioerr(1,portno)
	. do log("client: Socket handler "_socksel_" successfully ATTACHed to sockdev");
	. kill x,y
	. use sockdev:exception="do ioerr(2,portno,$device)"
	. read x:timeout ; discard empty line from write !,msg,! by server
	. do:'$test ioerr(1,portno) ; always check for $TEST when using timeouts
	. if i#2 do
	. . read y:timeout ; read of write !,msg,! by server - y has msg
	. . do:'$test ioerr(1,portno) ; always check for $TEST when using timeouts
	. . do log("client: Full READ of '"_y_"' coming to "_socksel_" from the socket handler of the server is complete.");
	. . write msg_" from "_socksel,! ; ; respond to server with "OK."_"<selected socket>"
	. . do log("client: WRITE  """_msg_" from "_socksel_""" to server is complete.");
  	. else  do
	. . read y#3:timeout ; partial read of write !,msg,! by server - y has 3 characters of msg
	. . do:($length(y)<3)!'($test) ioerr(1,portno) ; always check for $TEST when using timeouts. This executes if y does not have 3 characters.
	. . do log("client: Partial READ of the first three characters '"_y_"' coming to "_socksel_" from the socket handler of the server.");
	. set connectionsock(socksel,"read")=$select($length(y):"Full",1:"Timeout")
	. set connectionsock(socksel,"zkey")=$zkey,connectionsock(socksel,"y")=y
	do log("client: After completing full and partial reads, $ZKEY is "_$ZKEY_". Therefore....");
	set totalpartialread=$length($zkey,"READ")-1 ; find the number of sockets which have partially read data
	for i=1:1:totalpartialread do
        . set sockpar=$piece($piece($zkey,"READ",i+1),"|",2);
	. set connectionsock(sockpar,"readafter")="Partial"
	. do log("client: "_sockpar_" has partially read data.");
	hang timeout*connectnum		; allow server to finish
	close sockdev
	do log("client ends at "_$zdate($horolog,"MON DD, YYYY 24:60:SS"))
	quit

; log error and terminate process
ioerr(code,port,opt)
	new msg,stack
	set msg=$text(ioerrs+$get(code))
	set ioerrio=$io,ioerrdev=$device,ioerrkey=$key,ioerrzstatus=$zstatus,ioerrzeof=$zeof
	use $principal ; since process will terminate, no need to save & restore $io
 	zshow "s":stack
	do log("At "_stack("S",2)_" "_$piece(msg,";",2)_" port "_$get(port)_$select($data(opt)#10:$piece(msg,";",3)_opt,1:""))
	use 0 zwrite ioerrio,ioerrdev,ioerrkey,ioerrzeof zshow "D"
	zwrite:$data(connectionsock) connectionsock
	zwrite:$data(connections) connections
	zwrite:$data(connectionsd) connectionsd
	zwrite:$data(listensock) listensock
	write $zstatus,!
	zhalt code

; text of error messages
ioerrs	;unable to OPEN
	;connection failure; timeout=
	;device error

; display a message on $principal
log(str)
	new previo
	set previo=$IO
	use $principal
	write $zdate($horolog,"MON DD, YYYY 24:60:SS")," ",str,!
	use previo
	quit

; entry point for the server code
server(portno,msg,listenqueue,timeout)
        new childsock,delim,i,ip,key,parentsock,listensock,start,sockdev,totalpartialread,x,x1,zkey
	set start=$horolog
	set:'($data(portno)#10) portno=$piece(start,",",1)#63487+2048
	set:'($data(msg)#10) msg="Lorem ipsum dolor sit amet, convallis in sapien aenean ante dolor sodales."
	set:'($data(listenqueue)#10) listenqueue=5
	set:'($data(timeout)#10) timeout=7
	set delim=$char(10) ; line feed
	set sockdev="server"
	do log("** tcpserver is getting ready to start.**")
	open sockdev:(listen=portno_":tcp":attach="server":delimiter=delim:exception="do ioerr(0,"_portno_")":ioerror="t")::"socket"
	use sockdev:exception="do ioerr(2,portno,$device)"
	write:listenqueue>1 /listen(listenqueue) ; if so specified, increase listen queue size from default of 1
	set key=$key
	do log("server: Open serverport "_portno_" is successful, $KEY="_key)
	set parentsock=$piece(key,"|",2)
	set available=""
	set (i,waits,waittimeouts,readtimeouts,quit,totalpartialread)=0
	use sockdev:ioerror="f"
	for  do  quit:quit
	. do log("server: Waiting for incoming connection with timeout="_timeout);
	. write /wait(timeout)
	. if $test=0 if $increment(waittimeouts)>10 set quit=1 quit
	. set key=$key,waits=$I(waits)
	. if $piece(key,"|",1)="CONNECT" do
	. . set childsock=$piece(key,"|",2),ip=$piece(key,"|",3)
	. . set connections(childsock)=0	; track which socket have read
	. . use sockdev:(socket=childsock)
	. . do log("server: Connection established, socket handler is="_childsock)
	. . write !,msg,!
	. . if +$device do ioerr(2,"",$device)
	. . do log("server: WRITE !,"_msg_",! to "_childsock_" for the client socket to READ")
	. else  if $piece(key,"|",1)="READ" do
	. . set childsock=$piece(key,"|",2),ip=$piece(key,"|",3)
	. . if connections(childsock)'=0 do	; WRITE /WAIT selected already read socket so select another
	. . . do log("server: Selecting a new read socket for WRITE /WAIT. $ZKEY="_$zkey);
	. . . set readhandle=$piece($zkey,"|",2)  ; Check the documentation of $ZKEY in the Programmers Guide for other possible values.
	. . . if (quitfound=0)!(readhandle="") quit	;no connection unread partially
	. . else  set readhandle=childsock	; no reads for childsock yet
	. . if readhandle="" set quit=1 quit
	. . set connections(readhandle)=$I(connections(readhandle))
	. . do log("server: Connection established, socket handler is="_readhandle)
	. . if $length(readhandle) do
	. . . use sockdev:socket=readhandle
	. . . read x#2:1 ; simulate a partial read - client sends three characters back but server reads only two
	. . . do:($length(x)<2)!'($test) log("A timeout occurred or client sent less characters for socket handler"_readhandle);
	. . . do log("server: Partially READ 2 characters """_x_""" from "_readhandle);
	. . . use sockdev:detach=readhandle
	. . . set jobprocessparam="handlepartialread(readhandle):(output="""_readhandle_".mjo"":input="_"""SOCKET:"_readhandle_""""_")"
	. . . job @jobprocessparam ; fork a process to handle the detached socket
	. . . do log("server: DETACHed "_readhandle_" and fork a process "_$zjob_" to read the remaining data");
	. . . set connections(readhandle)="Look in "_readhandle_".mjo"_" for the remaining data"
	close sockdev
	do log("server ends at "_$zdate($horolog,"MON DD, YYYY 24:60:SS"))
	use $principal
        write "server: Total socket handlers: ",!
	zwrite connections
        quit

; read & output a file, then delete it
showfile(file,title)
	new previo
	set previo=$io
	write !,title,!
	open file for  use file read line quit:$zeof  use previo write line,!
	use previo close file:delete
	quit

; read the remaining data on the partially read socket
handlepartialread(readhandle)
        use $principal:delim=$char(10) ; delimiters are not passed to the job
	read x:1  ; read the remaining data; As a programming practice, check for $TEST and expected length of the data
	do:($length(x)<1)!'($test) log("A timeout occurred or client sent less characters for socket handler"_readhandle);
	write x,!
        write $length(x)_" characters were read",!
	quit
