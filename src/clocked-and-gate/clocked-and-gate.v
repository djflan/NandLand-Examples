// Example 2
module clocked_and_gate (
    input input_1,
    input input_2,
    input clock,
    output reg and_result
);
    always @(posedge clock)
    begin
        and_result <= input_1 & input_2;
    end
endmodule