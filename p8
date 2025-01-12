 8.tcl
 #code :
 set val(chan)
 set val(prop)
 set val(netif)
 set val(mac)
 set val(ifq)
 set val(ll)
 set val(ant)  
set val(x)  
set val(y)  
  Channel/WirelessChannel
  Propagation/TwoRayGround
  Phy/WirelessPhy
  Mac/802_11
  Queue/DropTail/PriQueue
      LL
 Antenna/OmniAntenna
  500
  500
 set val(ifqlen)   50
 set val(nn)  
set val(stop)
 set val(rp)    
set val(com)
 set val(mob)
  50.0
  "s"
  "m"
  25
 AODV
 set ns_ [new Simulator]
 set tracefd [open 003.tr w]
 $ns_ trace-all $tracefd
 set namtrace [open 003.nam w]
 $ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
 set prop [new $val(prop)]
 set topo [new Topography]
 $topo load_flatgrid $val(x) $val(y)
 set god_ [create-god $val(nn)]
 $ns_ node-config -adhocRouting $val(rp)\
                -llType $val(ll)\
                -macType $val(mac)\
                -ifqType $val(ifq)\
                -ifqLen $val(ifqlen)\
                -antType $val(ant)\
                -propType $val(prop)\
                -phyType $val(netif)\
                -channelType $val(chan)\
                -topoInstance $topo\
                -agentTrace ON\
                -routerTrace ON\
                -macTrace ON
for {set i 0} {$i<$val(nn)} {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0
 }
 for {set i 0} {$i<$val(nn)} {incr i} {
    set xx [expr rand()*400]
    set yy [expr rand()*400]
    $node_($i) set X_ $xx
    $node_($i) set Y_ $yy
 }
 for {set i 0} {$i<$val(nn)} {incr i} {
    $ns_ initial_node_pos $node_($i) 40
 }
 puts "Loading Scenario File..."
 source $val(com)
 puts "Loading Mobility File..."
 source $val(mob)
 for {set i 0} {$i<$val(nn)} {incr i} {
    $ns_ at $val(stop) "$node_($i) reset";
 }
 $ns_ at $val(stop) "puts \"NS EXITING...\"; finish"
 puts "Starting Simulation"
 proc finish {} {
     global ns_ tracefd namtrace
     $ns_ flush-trace
     close $tracefd
     close $namtrace
     exec nam 003.nam &
     exit 0
 }
 $ns_ run
