module runtime.stack;

class RTStack(T) {
	private T[] stack;
	private T[] argument;
	public this(Args...)(Args args) {
		argument.length = args.length;
		foreach(i, val; args) {
			argument[i] = val;
		}
	}
	public @property void length(uint l) {
		stack.length = l;
	}
	public @property ulong length() {
		return stack.length;
	}
	public void push(T val) {
		stack[stack.length++] = val;
	}
	public T pop() {
		T val = stack[$-1];
		stack.length--;
		return val;
	}
	public T arg(uint n) {
		return argument[n];
	}
}
