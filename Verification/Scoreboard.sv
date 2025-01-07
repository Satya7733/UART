class scoreboard;

mailbox #(bit [7:0]) mbxms;
mailbox #(bit [7:0]) mbxds;
event sconext;
event scorun;
bit[7:0] ds;
bit[7:0] ms;

function new (mailbox #(bit [7:0]) mbxds, mailbox #(bit [7:0]) mbxms);
 this.mbxds = mbxds;
 this.mbxms = mbxms;
endfunction

task run();
forever begin
wait( scorun.triggered);
//scorun.triggered;// Once the Monitor has sent the data on mailbox it will start running
//$display("[SCO]: Started");
 //$display("[SCO] 1 : DRV : %0d, MON : %0d", ds, ms);
 #5 mbxds.get(ds);
 //$display("[SCO] 2 : DRV : %0d, MON : %0d", ds, ms);
  mbxms.get(ms);

 $display("[SCO] : DRV : %0d, MON : %0d", ds, ms);
 if(ms == ds) 
 $display("Data Matched");
 else 
 $display("Data Not Matched");
 $display("----------------------------------");
 ->sconext; //The Generator will start to generate new stimulus
end
endtask

endclass
