import classes_pkg::*;

class transaction;
 typedef enum bit {Transmit = 1'b0, Receive = 1'b1} oper_type;
 randc oper_type oper;
 bit rx;
 rand bit [7:0] dintx;
 bit newd; 
 bit tx, donetx, donerx;
 bit [7:0] doutrx;

function transaction copy(); //to create deep copy
 copy = new();
 copy.rx = this.rx;
 copy.dintx = this.dintx;
 copy.newd = this.newd;
 copy.tx = this.tx;
 copy.doutrx = this.doutrx;
 copy.donetx = this.donetx;
 copy.donerx = this.donerx;
 copy.oper = this.oper; 
endfunction

endclass
