module util.oper;

int mod(int num, int den)
{
    return (num<0)?(((num+1)%den)+den-1):(num%den);
}
int div(int num, int den)
{
    if(den<0){num=-num;den=-den;}
    return (num<0)?(((num+1)/den)-1):(num/den);
}

int max(int a, int b) {
	if( a > b ) {
		return a;
	}
	return b;
}

int min(int a, int b) {
	if( a < b ) {
		return a;
	}
	return b;
}