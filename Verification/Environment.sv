import classes_pkg::*;
class environment;
 generator gen;
 driver drv;
 monitor mon;
 scoreboard sco;

 event nextgd; // gen -> drv
 event nextgs; // gen -> sco
 event nextms; // mon -> sco

 mailbox #(transaction) mbxgd;
 mailbox #(bit [7:0]) mbxds;
 mailbox #(bit[7:0]) mbxms;
 
 virtual uart_if vif;
 
 function new( virtual uart_if vif);
 mbxgd = new();
 mbxms = new();
 mbxds = new();

 gen = new(mbxgd);
 drv = new(mbxds,mbxgd);
 mon = new(mbxms);
 sco = new(mbxds, mbxms);
 
 this.vif = vif;
 drv.vif = this.vif;
 mon.vif = this.vif;
    
 gen.sconext = nextgs;
 sco.sconext = nextgs;
 gen.drvnext = nextgd;
 drv.drvnext = nextgd;
 mon.scorun = nextms;
 sco.scorun = nextms;

 endfunction

task pre_test();
 drv.reset();
endtask

task test();
 fork
 gen.run();
 drv.run();
 mon.run();
 sco.run();
join_any
endtask

task post_test();
 wait(gen.done.triggered); 
 $finish();
endtask

task run ();
 pre_test();
 test();
 post_test();
endtask


endclass
