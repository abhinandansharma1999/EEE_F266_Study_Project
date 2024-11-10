module mult8bit(a,b,p);
//inputs
input [7:0]a,b;
//outputs
output reg [15:0]p;

//wires
reg w[7:0][7:0];
reg s[7:0][7:0];
reg c[7:0][7:0];

integer i,j,m,n,l,x,g,h;
always@*	
begin

//AND GATES
for (i=0; i<8; i=i+1)
begin
	for (j=0; j<8; j=j+1)
	begin
		w[i][j] = (a[j]&b[i]);
	end
end

//---------------------------------------------------------------------
//CHANGE OF TERMINOLOGY
for (j=0; j<8; j=j+1)
begin
	s[0][j] = w[0][j];
end

c[0][7] = 0;

//---------------------------------------------------------------------
//m=0;
//while(m<5)
l=1;
for (m=0; m<5; m=m+2)
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
for (m=1; m<5; m=m+1)
begin
	i=m;
	j=6; 
	for (n=1 ; n<4; n=n+1)
	begin
		s[i][j] = (w[i][j] ^ s[i-1][j+1] ^ c[i][j-1]);
		c[i][j] = ((w[i][j]&s[i-1][j+1]) | (w[i][j]&c[i][j-1]) | (s[i-1][j+1]&c[i][j-1]));
		i=i+1;
		j=j-2;
	end
	
	s[i][j] = (s[i-1][j+1]^w[i][j]);
	c[i][j] = (s[i-1][j+1]&w[i][j]);
	
	g=m;
	h=7;
	s[g][h] = (w[g][h] ^ c[g-1][h] ^ c[g][h-1]);
	c[g][h] = ((w[g][h]&c[g-1][h]) | (w[g][h]&c[g][h-1]) | (c[g-1][h]&c[g][h-1]));
	g=g+1;
	h=h-2;
	
	for (x=1 ; x<4; x=x+1)
	begin
		s[g][h] = (w[g][h] ^ s[g-1][h+1] ^ c[g][h-1]);
		c[g][h] = ((w[g][h]&s[g-1][h+1]) | (w[g][h]&c[g][h-1]) | (s[g-1][h+1]&c[g][h-1]));
		g=g+1;
		h=h-2;
	end
//	m=m+1;
end

//-------------------------------------------------------------------------
//m=5;
//while(m<8)
l=3;
for (m=5; m<8; m=m+1)
begin
	i=m;
	j=6; 
	for (n=1 ; n<l+1; n=n+1)
	begin
		s[i][j] = (w[i][j] ^ s[i-1][j+1] ^ c[i][j-1]);
		c[i][j] = ((w[i][j]&s[i-1][j+1]) | (w[i][j]&c[i][j-1]) | (s[i-1][j+1]&c[i][j-1]));
		i=i+1;
		j=j-2;
	end
	
	g=m;
	h=7;
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
for (i=1; i<8; i=i+1)
begin
//assign p[i] = s[i][0];
p[i] = s[i][0];
end

for (i=1; i<8; i=i+1)
begin
//assign p[i+15] = s[15][i];
p[i+7] = s[7][i];
end

//assign p[31] = c[15][15];
p[15] = c[7][7];

end
endmodule
