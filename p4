 #4.tcl
 set ns [new Simulator]
 set tf [open 4.tr w]
 $ns trace-all $tf
 set nf [open 4.nam w]
 $ns namtrace-all $nf
 set n0 [$ns node]
 set n1 [$ns node]
 $ns color 1 Blue
 $n0 label "Server"
 $n1 label "Client"
 USN: 1NT22CS057
 $ns duplex-link $n0 $n1 10Mb 22ms DropTail
 $ns duplex-link-op $n0 $n1 orient right
 set tcp1 [new Agent/TCP]
 $ns attach-agent $n0 $tcp1
 $tcp1 set packetSize_ 1500
 set sink1 [new Agent/TCPSink]
 $ns attach-agent $n1 $sink1
 $ns connect $tcp1 $sink1
 set ftp1 [new Application/FTP]
 $ftp1 attach-agent $tcp1
 $tcp1 set fid_ 1
 proc finish {} {
 global ns tf nf
 $ns flush-trace
 Batch: 5 A  2nd 
close $tf
 close $nf
 exec nam 4.nam &
 exec awk -f transfer.awk 4.tr &
 exec awk -f convert.awk 4.tr > convert.tr
 exec xgraph convert.tr -geometry 800*400 -t "Bytes_received_at_client" -x "Time_in_secs" -y 
"Bytes_in_bps" &
 }
 $ns at 0.01 "$ftp1 start"
 $ns at 15.0 "$ftp1 stop"
 $ns at 15.1 "finish"
 $ns run
 #transfer.awk
 BEGIN{
 count=0;
 time=0;
 total_bytes_received=0;
 total_bytes_sent=0;
 }
 {
 if($1=="r" && $4==1 && $5=="tcp")
 total_bytes_received+=$6;
 if($1=="+" && $3==0 && $5=="tcp")
 total_bytes_sent+=$6;
 }
 END{
 system("clear");
 printf("\n Transmission time required to transfer the file is %f",$2);
 printf("\n Actual data sent from the server is %f Mbps",(total_bytes_sent)/1000000);
 printf("\n Data received by the client is %f Mbps \n",(total_bytes_received)/1000000);
 }
 #convert.awk
 BEGIN{
 count=0;
 time=0;
 }
 {if($1=="r" && $4==1 && $5=="tcp")
 {
 count+=$6;
 time=$2;
 printf("\n %f \t %f",time,(count)/1000000);
 }
 }
 END{}
