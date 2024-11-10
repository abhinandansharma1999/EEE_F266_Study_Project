module smult8bit_tb();
wire [15:0]t_p;
reg [7:0]t_a, t_b;
integer i;

smult8bit my_multiplier_8(.a(t_a), .b(t_b), .p(t_p));
initial begin
$monitor("%b	%b	%b", t_a, t_b, t_p);

t_a=8'sb10011001;//-103
t_b=8'sb00000001;//1
#100

t_a=8'sd126;//126
t_b=-8'sd1;//-1
#100

t_a=8'sb11110101;//-11
t_b=8'sb01111000;//120
#100

t_a=-8'sb01111111;//-127
t_b=-8'sb01111111;//-127
#100

t_a=8'sb10100110;//-90
t_b=8'sb01011010;//90
#100

t_a=8'sb1;//1
t_b=8'sb1;//1
#100

t_a=8'sh7a;//122
t_b=8'sb00111001;//57
#100

t_a=8'sb01111101;//125
t_b=8'sb10001111;//-113
#100

t_a=8'sb10100101;//-91
t_b=8'sb00111001;//57
#100

t_a=8'sb01001100;//76
t_b=8'sb10100101;//-91

end
endmodule
 
  