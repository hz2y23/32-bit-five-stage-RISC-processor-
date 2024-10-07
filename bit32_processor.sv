
module bit32_processor(
  input logic clk,
  input logic [7:0] SW, // Switches SW0..SW7
  input logic nReset,
  output logic [9:0] LED); // LEDs
  logic slowclk;

  cpu myDesign (.clk(slowclk), .nReset(nReset),.SW(SW[7:0]),.LED(LED[9:0]));
  counter c (.fastclk(clk), .clk(slowclk));
endmodule  