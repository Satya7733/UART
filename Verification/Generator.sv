import classes_pkg::*;
class generator;

transaction tr;
mailbox #(transaction) mbxgd;  // Created a mail box

event done;   //created event done
event drvnext;// created event for drv next to send the next inputs to driver
event sconext;//

int count =0;

function new(mailbox #(transaction) mbxgd);
 this.mbxgd = mbxgd;
 tr = new();
endfunction

task run();
 repeat(count) begin
	assert(tr.randomize) else $error("[GEN]: Randomization Failed");
	mbxgd.put(tr.copy); // Tranfer the randomized values to driver 
	$display("[GEN] : Oper : %0s, Din : %0d",tr.oper.name(), tr.dintx);
	//drvnext.triggered;
	//sconext.triggered;
	wait( drvnext.triggered);
	wait( sconext.triggered);
 end

 -> done;
endtask

endclass
