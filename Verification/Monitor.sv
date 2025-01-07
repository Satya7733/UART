import classes_pkg::*;
class monitor;
 transaction tr;
 mailbox #(bit[7:0])mbxms;
 bit [7:0] srx;
 bit [7:0] rrx;

 function new (mailbox #(bit [7:0]) mbxms);
  this.mbxms = mbxms;
 endfunction

 event scorun; // this event will be used to trigger the scoreboard 
 virtual uart_if vif;
 
 task run();
 forever begin
 @(posedge vif.uclktx); 
 if((vif.newd == 1'b1) && (vif.rx == 1'b1))begin //tx
 @(posedge vif.uclktx);
 for(int i = 0; i<= 7; i++)begin
 @(posedge vif.uclktx);
  srx[i] = vif.tx;
//$display("srx[%d]: %d",i, srx[i]);
 end
 $display("[MON] : DATA SEND on UART TX %0d", srx);
 wait(vif.donetx == 1'b1);//wait for done tx before proceeding next transaction  
 @(posedge vif.uclktx);
 mbxms.put(srx);
//$display("srx: %d", srx);
  ->scorun;
 end
 else if ((vif.rx == 1'b0) && (vif.newd == 1'b0))begin //rx
 wait(vif.donerx == 1'b1);
 rrx = vif.doutrx;
 $display("[MON] : DATA RCVD RX %0d", rrx); 
 @(posedge vif.uclkrx); // rx clk
 mbxms.put(rrx);
//$display("rrx: %d", rrx);
//$display("MR sent rcvd data to scb");
 ->scorun;
//$display("MONITOR TRIGERRING SCB");
 end
 
 end 
 endtask

endclass
