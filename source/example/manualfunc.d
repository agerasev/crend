module example.manualfunc;

import example.func;
import runtime.func;
import runtime.expr;

class ManualFunc : Func {
	RTFunc!creal rtfunc;
	
	this() {
		RTExpr!creal expr = new RTExpr!creal;
		static creal mult(creal a, creal b) {
			return a*b;
		}
		expr.operand = [
			cast(expr.Operand!creal)expr.new Variable!creal(0),
			cast(expr.Operand!creal)expr.new Variable!creal(0),
			cast(expr.Operand!creal)expr.new Binary!creal(&mult),
			cast(expr.Operand!creal)expr.new Variable!creal(0),
			cast(expr.Operand!creal)expr.new Binary!creal(&mult)
			];
		rtfunc = new RTFunc!creal(expr);
	}
	override protected creal func(creal z) const {
		return rtfunc(z);
	}
}
