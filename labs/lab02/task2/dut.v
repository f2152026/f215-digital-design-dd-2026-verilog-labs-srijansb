module DUT (
  input  [1:0] sel,
  output [7:0] dout
);

  lut U1 (
    .sel(sel),
    .dout(dout)
  );

endmodule