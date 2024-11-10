module mult4bit(a,b,p);
//inputs
input [3:0]a,b;
//outputs
output reg [7:0]p;

//wires
reg w[3:0][3:0];
reg s[3:0][3:0];
reg c[3:0][3:0];

integer i,j;
integer n=4;
always@*	
begin

//AND GATES
for (i=0; i<4; i=i+1)
begin
	for (j=0; j<4; j=j+1)
	begin
		w[i][j] = (a[i]&b[j]);
	end
end

//1
s[1][0] = (w[1][0] ^ w[0][1]);	
c[1][0] = (w[1][0] & w[0][1]);

//2
s[1][1] = (w[1][1] ^ w[0][2] ^ c[1][0]);
c[1][1] = ((w[1][1]&w[0][2]) | (w[1][1]&c[1][0]) | (w[0][2]&c[1][0]));

//3
s[2][0] = (s[1][1] ^ w[2][0]);	
c[2][0] = (s[1][1] & w[2][0]);

s[1][2] = (w[0][3] ^ w[1][2] ^ c[1][1]);
c[1][2] = ((w[0][3]&w[1][2]) | (w[0][3]&c[1][1]) | (w[1][2]&c[1][1]));

//4
s[1][3] = (w[1][3] ^ c[1][2]);	
c[1][3] = (w[1][3] & c[1][2]);

s[2][1] = (w[2][1] ^ s[1][2] ^ c[2][0]);
c[2][1] = ((w[2][1]&s[1][2]) | (w[2][1]&c[2][0]) | (s[1][2]&c[2][0]));

//5
s[3][0] = (w[3][0] ^ s[2][1]);	
c[3][0] = (w[3][0] & s[2][1]);

s[2][2] = (w[2][2] ^ s[1][3] ^ c[2][1]);
c[2][2] = ((w[2][2]&s[1][3]) | (w[2][2]&c[2][1]) | (s[1][3]&c[2][1]));

//6
s[2][3] = (w[2][3] ^ c[1][3] ^ c[2][2]);
c[2][3] = ((w[2][3]&c[1][3]) | (w[2][3]&c[2][2]) | (c[1][3]&c[2][2]));

s[3][1] = (w[3][1] ^ s[2][2] ^ c[3][0]);
c[3][1] = ((w[3][1]&s[2][2]) | (w[3][1]&c[3][0]) | (s[2][2]&c[3][0]));

//7
s[3][2] = (w[3][2] ^ s[2][3] ^ c[3][1]);
c[3][2] = ((w[3][2]&s[2][3]) | (w[3][2]&c[3][1]) | (s[2][3]&c[3][1]));

//8
s[3][3] = (w[3][3] ^ c[2][3] ^ c[3][2]);
c[3][3] = ((w[3][3]&c[2][3]) | (w[3][3]&c[3][2]) | (c[2][3]&c[3][2]));



//OUTPUT ASSIGNMENTS
p[0] = w[0][0];

for (i=1; i<4; i=i+1)
begin
//assign p[i] = s[i][0];
p[i] = s[i][0];
end

for (i=1; i<4; i=i+1)
begin
//assign p[i+15] = s[15][i];
p[i+3] = s[3][i];
end

//assign p[31] = c[15][15];
p[7] = c[3][3];

end
endmodule
