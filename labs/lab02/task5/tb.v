`timescale 1ns/1ps

module tb;

  reg  [3:0] a;
  reg  [3:0] b;
  reg        op;
  wire [3:0] result;

  alu dut (
    .a(a),
    .b(b),
    .op(op),
    .result(result)
  );

  reg [3:0] expected;

  task check;
    input [3:0] ta;
    input [3:0] tb;
    input       top;

    begin
      a  = ta;
      b  = tb;
      op = top;

      #1;

      if (top == 1'b0)
        expected = ta + tb;
      else
        expected = ta - tb;

      if (result !== expected) begin
        $display("FAIL: a=%b b=%b op=%b | got=%b expected=%b",
                 ta, tb, top, result, expected);
      end
      else begin
        $display("PASS: a=%b b=%b op=%b | result=%b",
                 ta, tb, top, result);
      end
    end
  endtask

  initial begin

    // Addition tests
    check(4'd0,  4'd0,  1'b0);
    check(4'd3,  4'd2,  1'b0);
    check(4'd7,  4'd5,  1'b0);
    check(4'd15, 4'd1,  1'b0);

    // Subtraction tests
    check(4'd5,  4'd2,  1'b1);
    check(4'd9,  4'd4,  1'b1);
    check(4'd4,  4'd9,  1'b1);
    check(4'd0,  4'd1,  1'b1);
    check(4'd15, 4'd15, 1'b1);

    // Specifically test changing op while a,b stay the same
    // This exposes the sensitivity-list bug.
    a = 4'd7;
    b = 4'd3;
    op = 1'b0;
    #1;

    if (result !== 4'd10)
      $display("FAIL: ADD before op toggle | got=%b expected=1010", result);
    else
      $display("PASS: ADD before op toggle");

    op = 1'b1;
    #1;

    if (result !== 4'd4)
      $display("FAIL: OP TOGGLE | got=%b expected=0100", result);
    else
      $display("PASS: OP TOGGLE");

    // More mixed tests
    check(4'd2,  4'd7,  1'b0);
    check(4'd2,  4'd7,  1'b1);
    check(4'd12, 4'd5,  1'b0);
    check(4'd12, 4'd5,  1'b1);

    $finish;
  end

endmodule