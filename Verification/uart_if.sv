interface uart_if;  // Declaration of the interface
  logic clk;            // Clock signal
  logic uclktx;         // Clock for TX
  logic uclkrx;         // Clock for RX
  logic rst;            // Reset signal
  logic rx;             // Receive signal
  logic [7:0] dintx;    // Data to be transmitted
  logic newd;           // New data flag
  logic tx;             // Transmit signal
  logic [7:0] doutrx;   // Data received
  logic donetx;         // Transmit done flag
  logic donerx;         // Receive done flag
endinterface // End of the interface declaration