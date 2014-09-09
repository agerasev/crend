module runtime.expr;

import runtime.stack;

/**
	Expression of operations with some type 'T'
	If types are fully differernt, set type 'Object'
*/
class RTExpr(T) {
	public Operand!T[] operand;
	
	/*
	public void append(Operand!T op) {
		operand[operand.length++] = op;
	}
	*/
	
	/**
		Operand types
	*/
	public:
	abstract class Operand(T) {
		public abstract void opCall(RTStack!T stack) const;
	}
	
	class Const(T) : Operand!T {
		private T value;
		public this(T val) {
			value = val;
		}
		override public void opCall(RTStack!T stack) const {
			stack.push(value);
		}
	}
	
	class Variable(T) : Operand!T {
		private uint num;
		public this(uint n) {
			num = n;
		}
		override public void opCall(RTStack!T stack) const {
			stack.push(stack.arg(num));
		}
	}
	
	class Unary(T) : Operand!T {
		private T function(T) func;
		public this(T function(T) f) {
			func = f;
		}
		override public void opCall(RTStack!T stack) const {
			stack.push(func(stack.pop()));
		}
	}
	
	class Binary(T) : Operand!T {
		private T function(T,T) func;
		public this(T function(T,T) f) {
			func = f;
		}
		override public void opCall(RTStack!T stack) const {
			T one = stack.pop();
			T two = stack.pop();
			stack.push(func(one,two));
		}
	}
}