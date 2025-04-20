module example_and_gate (
    // Inputs
    input_1,
    input_2,
    // Outputs
    and_result);
    
    input input_1;
    input input_2;
    output and_result;

    assign and_result = input_1 & input_2;
endmodule