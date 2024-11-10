module mult16bit(a,b,p);
//inputs
input [15:0]a,b;
//outputs
output reg [31:0]p;

//wires
reg w[15:0][15:0];
reg s[15:0][15:0];
reg c[15:0][15:0];

integer i,j,m,n,l,x,g,h;
always@*	
begin

//AND GATES
for (i=0; i<16; i=i+1)
begin
	for (j=0; j<16; j=j+1)
	begin
		w[i][j] = (a[j]&b[i]);
	end
end

//---------------------------------------------------------------------
//CHANGE OF TERMINOLOGY
for (j=0; j<16; j=j+1)
begin
	s[0][j] = w[0][j];
end

c[0][15] = 0;

//---------------------------------------------------------------------
//m=0;
//while(m<5)
l=1;
for (m=0; m<13; m=m+2)
begin
	i=1;
	j=m; 
	for (n=1 ; n<l; n=n+1)
	begin
		s[i][j] = (w[i][j] ^ s[i-1][j+1] ^ c[i][j-1]);
		c[i][j] = ((w[i][j]&s[i-1][j+1]) | (w[i][j]&c[i][j-1]) | (s[i-1][j+1]&c[i][j-1]));
		i=i+1; 
		j=j-2;
	end
	s[i][j] = (w[i][j] ^ s[i-1][j+1]);
	c[i][j] = (w[i][j] & s[i-1][j+1]);
	
	g=1;
	h=m+1;
	for (x=1 ; x<l+1; x=x+1)
	begin
		s[g][h] = (w[g][h] ^ s[g-1][h+1] ^ c[g][h-1]);
		c[g][h] = ((w[g][h]&s[g-1][h+1]) | (w[g][h]&c[g][h-1]) | (s[g-1][h+1]&c[g][h-1]));
		g=g+1;
		h=h-2;
	end
	l=l+1;
//	m=m+2;
end

//-----------------------------------------------------------------------
//m=1;
//while(m<5)
for (m=1; m<9; m=m+1)
begin
	i=m;
	j=14; 
	for (n=1 ; n<8; n=n+1)
	begin
		s[i][j] = (w[i][j] ^ s[i-1][j+1] ^ c[i][j-1]);
		c[i][j] = ((w[i][j]&s[i-1][j+1]) | (w[i][j]&c[i][j-1]) | (s[i-1][j+1]&c[i][j-1]));
		i=i+1;
		j=j-2;
	end
	
	s[i][j] = (s[i-1][j+1]^w[i][j]);
	c[i][j] = (s[i-1][j+1]&w[i][j]);
	
	g=m;
	h=15;
	s[g][h] = (w[g][h] ^ c[g-1][h] ^ c[g][h-1]);
	c[g][h] = ((w[g][h]&c[g-1][h]) | (w[g][h]&c[g][h-1]) | (c[g-1][h]&c[g][h-1]));
	g=g+1;
	h=h-2;
	
	for (x=1 ; x<8; x=x+1)
	begin
		s[g][h] = (w[g][h] ^ s[g-1][h+1] ^ c[g][h-1]);
		c[g][h] = ((w[g][h]&s[g-1][h+1]) | (w[g][h]&c[g][h-1]) | (s[g-1][h+1]&c[g][h-1]));
		g=g+1;
		h=h-2;
	end
//	m=m+1;
end

//-------------------------------------------------------------------------
//m=9;
//while(m<16)
l=7;
for (m=9; m<16; m=m+1)
begin
	i=m;
	j=14; 
	for (n=1 ; n<l+1; n=n+1)
	begin
		s[i][j] = (w[i][j] ^ s[i-1][j+1] ^ c[i][j-1]);
		c[i][j] = ((w[i][j]&s[i-1][j+1]) | (w[i][j]&c[i][j-1]) | (s[i-1][j+1]&c[i][j-1]));
		i=i+1;
		j=j-2;
	end
	
	g=m;
	h=15;
	s[g][h] = (w[g][h] ^ c[g-1][h] ^ c[g][h-1]);
	c[g][h] = ((w[g][h]&c[g-1][h]) | (w[g][h]&c[g][h-1]) | (c[g-1][h]&c[g][h-1]));
	g=g+1;
	h=h-2;
	
	for (x=1 ; x<l; x=x+1)
	begin
		s[g][h] = (w[g][h] ^ s[g-1][h+1] ^ c[g][h-1]);
		c[g][h] = ((w[g][h]&s[g-1][h+1]) | (w[g][h]&c[g][h-1]) | (s[g-1][h+1]&c[g][h-1]));	
		g=g+1;
		h=h-2;
	end
	l=l-1;
//	m=m+1;
end

//----------------------------------------------------------------------------
//OUTPUT ASSIGNMENTS
p[0] = w[0][0];
for (i=1; i<16; i=i+1)
begin
//assign p[i] = s[i][0];
p[i] = s[i][0];
end

for (i=1; i<16; i=i+1)
begin
//assign p[i+15] = s[15][i];
p[i+15] = s[15][i];
end

//assign p[31] = c[15][15];
p[31] = c[15][15];

end
endmodule
