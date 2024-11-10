module mult4bit_tb();
wire [7:0]t_p;
reg [3:0]t_a, t_b;
integer i;

mult4bit my_multiplier_4(.a(t_a), .b(t_b), .p(t_p));
initial begin
$monitor("%d	%d	%d", t_a, t_b, t_p);

t_a=8'b1;
t_b=8'b1;
#100

t_a=4'b10;
t_b=4'b1;
#100

t_a=4'b11;
t_b=4'b1;
#100

t_a=4'b100;
t_b=4'b1;
#100

t_a=4'b0110;
t_b=4'b0010;
#100

t_a=4'b1111;
t_b=4'b1111;
#100

t_a=4'ha;//10
t_b=4'b1001;//9
#100

t_a=4'b1101;//13
t_b=4'b1111;//15
#100

t_a=4'b0101;//5
t_b=4'b1001;//9
#100

t_a=4'b1000;//8
t_b=4'b1101;//13

end
endmodule
 
  