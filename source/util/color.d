module util.color;

struct tcolor(type) {
	
	static assert(__traits(isScalar,type),"color allowed only for scalar types");
	
	private:
	
	type[4] field;
	alias current = tcolor!(type);
	
	public:
	/*
		Constructors
	*/
	@property static current init() {
		current rv;
		rv.field[] = cast(type)0;
		return rv;
	}
	this(atype)(atype ar, atype ag, atype ab, atype aa = 0) {
		r = ar;
		g = ag;
		b = ab;
		a = aa;
	}
	this(vtype)(tcolor!(vtype) v) {
		r = v.r;
		g = v.g;
		b = v.b;
		a = v.a;
	}
	
	/*
		Property
	*/
	@property void set_(int n)(type v) {
		static assert(n >= 0 && n < 4, "component doesn't exist");
		field[n] = v;
	}
	@property type get_(int n)() {
		static assert(n >= 0 && n < 4, "component doesn't exist");
		return field[n];
	}
	alias set_!(0) r;
	alias get_!(0) r;
	alias set_!(1) g;
	alias get_!(1) g;
	alias set_!(2) b;
	alias get_!(2) b;
	alias set_!(3) a;
	alias get_!(3) a;
	
	/*
		Unary operators
	*/
	current opUnary(string op : "+")() const {
		return this;
	}
	current opUnary(string op : "-")() const {
		current rv;
		rv.field[] = -field[];
		return rv;
	}
	
	/*
		Binary operators
	*/
	current opBinary(string op)(auto ref const current v) const {
		current rv;
		static if(op == "+") {
			rv.field[] = field[] + v.field[];
		} else
		static if(op == "-") {
			rv.field[] = field[] - v.field[];
		}
		return rv;
	}
	current opBinary(string op : "*")(type s) const {
		current rv = this;
		rv.field[] *= s;
		return rv;
	}
	current opBinaryRight(string op : "*")(type s) const {
		return this*s;
	}
	current opBinary(string op : "/")(type s) const {
		return this*((cast(type)1)/s);
	}
	type opBinary(string op : "*")(current v) const {
		type rv = cast(type)0;
		for(int i = 0; i < 4; ++i) {
			rv += field[i]*v.field[i];
		}
		return rv;
	}
	
	/*
		OpAssigns
	*/
	ref current opOpAssign(string op)(current v) {
		static if(op == "+") {
			this = this + v;
		} else
		static if(op == "-") {
			this = this - v;
		}
		return this;
	}
	
	ref current opOpAssign(string op : "*")(type s) {
		this = s*this;
		return this;
	}
	ref current opOpAssign(string op : "/")(type s) {
		this = this/s;
		return this;
	}
}

alias color = tcolor!(float);