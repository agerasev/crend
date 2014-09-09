module runtime.func;

import runtime.stack;
import runtime.expr;

class RTFunc(T) {
	private const RTExpr!T expr;
	
	/**
		expression in reverse polish notation
	*/
	public this(const RTExpr!T ex) {
		expr = ex;
	}
	public T opCall(Args...)(Args args) const {
		RTStack!T stack = new RTStack!T(args);
		foreach(operand; expr.operand) {
			operand(stack);
		}
		T rv = stack.pop();
		delete stack;
		return rv;
	}
}