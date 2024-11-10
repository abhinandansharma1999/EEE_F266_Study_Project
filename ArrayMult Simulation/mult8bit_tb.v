module mult8bit_tb();
wire [15:0]t_p;
reg [7:0]t_a, t_b;
integer i;

mult8bit my_multiplier_8(.a(t_a), .b(t_b), .p(t_p));
initial begin
$monitor("%d	%d	%d", t_a, t_b, t_p);

t_a=8'b10000001;
t_b=8'b11111111;
#100

t_a=8'b11001100;
t_b=8'b10101010;
#100

t_a=8'b10000111;
t_b=8'b11100011;
#100

t_a=8'b11000000;
t_b=8'b00000111;
#100

t_a=8'b0110;
t_b=8'b0010;
#100

t_a=8'b1111;
t_b=8'b1111;
#100

t_a=8'ha;//10
t_b=8'b1001;//9
#100

t_a=8'b1101;//13
t_b=8'b1111;//15
#100

t_a=8'b0101;//5
t_b=8'b1001;//9
#100


t_a=8'b1000;//8
t_b=8'b1101;//13

end
endmodule
 
  