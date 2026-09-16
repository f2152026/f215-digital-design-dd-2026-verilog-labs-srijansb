`timescale 1ns/1ps

module tb;

  reg  [1:0] A;
  reg  [1:0] B;
  wire       GT;
  wire       LT;
  wire       EQ;

  comp2 dut (
    .A(A),
    .B(B),
    .GT(GT),
    .LT(LT),
    .EQ(EQ)
  );

  task check;
    input [1:0] a;
    input [1:0] b;
    reg exp_gt, exp_lt, exp_eq;
    begin
      A = a;
      B = b;
      #1;

      exp_gt = (a > b);
      exp_lt = (a < b);
      exp_eq = (a == b);

      if ({GT, LT, EQ} !== {exp_gt, exp_lt, exp_eq}) begin
        $display("FAIL: A=%b B=%b | Got GT=%b LT=%b EQ=%b | Expected GT=%b LT=%b EQ=%b",
                 A, B, GT, LT, EQ,
                 exp_gt, exp_lt, exp_eq);
      end
      else begin
        $display("PASS: A=%b B=%b | GT=%b LT=%b EQ=%b",
                 A, B, GT, LT, EQ);
      end
    end
  endtask

  initial begin
    // Test all 16 possible combinations
    check(2'b00, 2'b00);
    check(2'b00, 2'b01);
    check(2'b00, 2'b10);
    check(2'b00, 2'b11);

    check(2'b01, 2'b00);
    check(2'b01, 2'b01);
    check(2'b01, 2'b10);
    check(2'b01, 2'b11);

    check(2'b10, 2'b00);
    check(2'b10, 2'b01);
    check(2'b10, 2'b10);
    check(2'b10, 2'b11);

    check(2'b11, 2'b00);
    check(2'b11, 2'b01);
    check(2'b11, 2'b10);
    check(2'b11, 2'b11);

    $finish;
  end

endmodule