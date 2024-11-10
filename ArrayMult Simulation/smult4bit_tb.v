module smult4bit_tb();
wire [7:0]t_p;
reg [3:0]t_a, t_b;
integer i;

smult4bit my_multiplier_4(.a(t_a), .b(t_b), .p(t_p));
initial begin
$monitor("%b	%b	%b", t_a, t_b, t_p);

t_a=4'sb1001;//-7
t_b=4'sb0001;//1
#100

t_a=4'sd6;//6
t_b=-4'sd1;//-1
#100

t_a=4'sb0101;//5
t_b=4'sb1000;//-8
#100

t_a=-4'sb1111;//1
t_b=-4'sb1111;//1
#100

t_a=4'sb0110;//6
t_b=4'sb1010;//-6
#100

t_a=4'sb1;//1
t_b=4'sb1;//1
#100

t_a=4'sha;//-6
t_b=4'sb1001;//-7
#100

t_a=4'sb1101;//-3
t_b=4'sb1111;//-1
#100

t_a=4'sb0101;//5
t_b=4'sb1001;//-7
#100

t_a=4'sb1100;//-4
t_b=4'sb0101;//5

end
endmodule
 
  