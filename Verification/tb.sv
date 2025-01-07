`include"Package.sv"
import classes_pkg::*;
`timescale 1ns/1ps
module tb;
 uart_if vif();
 uart_top #(1000000,9600) dut (vif.clk,vif.rst,vif.rx,vif.dintx,vif.newd,vif.tx,vif.doutrx,vif.donetx, vif.donerx);
 
 initial begin
 vif.clk <=0;
 end

 always #10 vif.clk <= ~vif.clk;

 environment env;
 
 initial begin
 env = new(vif);
 env.gen.count = 5;
 env.run();
 end

assign vif.uclktx = dut.utx.uclk;
assign vif.uclkrx = dut.rtx.uclk;

endmodule
