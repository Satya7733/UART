import classes_pkg::*;
class driver;
 virtual uart_if vif;
 transaction tr;

 mailbox #(transaction)mbxgd; // gen to drv
 mailbox #(bit [7:0])mbxds; // drv to scrbd
 
 event drvnext;
 bit [7:0] din;
 bit wr = 0; // random operation read/write
 bit [7:0] datarx; //data rcvd during read
 
 function new(mailbox #(bit [7:0]) mbxds, mailbox #(transaction) mbxgd);
 this.mbxgd = mbxgd;
 this.mbxds = mbxds;
 endfunction 

task reset();
 vif.rst <= 1'b1;
 vif.dintx <= 0;
 vif.newd <= 0;
 vif.rx <= 1'b1;
  repeat(5) @(posedge vif.uclktx);
   vif.rst <= 1'b0;
   @(posedge vif.uclktx);
   $display("[DRV] : RESET DONE");
   $display("----------------------------------------");
endtask

task run();
 forever begin
	mbxgd.get(tr);
	if(tr.oper == 1'b0)begin //Transmit
	@(posedge vif.uclktx);
	vif.rst <= 1'b0; // remove reset if it is
	vif.newd <= 1'b1; // start data sending op
	vif.rx <= 1'b1; 
	vif.dintx <= tr.dintx; // give random input data from transaction class to virtual interface 
	@(posedge vif.uclktx);
	vif.newd <= 1'b0;
	#2 mbxds.put(tr.dintx); //sent the generated random data to scoreboard for reference checking
	$display("[DRV] : Data Sent : %0d",tr.dintx);
	wait(vif.donetx ==1'b1);
	->drvnext; // trigger drivnext event
	end
	else if(tr.oper == 1'b1)begin //Receive
	@(posedge vif.uclkrx);
	vif.rst <=1'b0;
	vif.rx <= 1'b0;
        vif.newd <= 1'b0; 
	@(posedge vif.uclkrx);
	for(int i = 0; i<=7; i++ )begin
	@(posedge vif.uclkrx);
	vif.rx <= $urandom; //random inputs to rx
	datarx[i] = vif.rx;
	end
 	#2// debug
	mbxds.put(datarx);
        $display("[DRV] : Data RCVD : %0d", datarx); 
        wait(vif.donerx == 1'b1);
        vif.rx <= 1'b1;
	->drvnext;                	
	end
end
endtask
endclass
