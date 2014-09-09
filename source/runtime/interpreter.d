module runtime.interpreter;

import runtime.expr;

static class Interpreter {
	public:
	/*
	RTExpr!cdouble parseInfix(string expr) {
		return parsePolish(infixToPolish(expr));
	}
	RTExpr!cdouble parsePolish(string expr) {
		/+
		bool isNumber(char sym)
		{
		    if((sym >= '0' && sym <= '9') || sym == '.')
		    {
		        return true;
		    }
		    return false;
		}
		
		bool is_oper(char sym)
		{
		    if(sym == '+' || sym == '-' || sym == '*' || sym == '/')
		    {
		        return true;
		    }
		    return false;
		}
		
		double read_number(int &i, const string &str)
		{
		    string num_str;
		    for(; (i < str.size())&&is_number(str[i]); ++i)
		    {
		        num_str += str[i];
		    }
		    return atof(&num_str.front());
		}
		
		void compute(char oper, vector<complex<double>> &vect)
		{
		    if(vect.size() >= 2)
		    {
		        complex<double> one = vect.back();
		        vect.pop_back();
		        complex<double> two = vect.back();
		        vect.pop_back();
		        switch(oper)
		        {
		        case '+':
		            vect.push_back(one + two);
		            return;
		        case '-':
		            vect.push_back(one - two);
		            return;
		        case '*':
		            vect.push_back(one*two);
		            return;
		        case '/':
		            vect.push_back(one/two);
		            return;
		        default:
		            return;
		        }
		    }
		}
		
		complex<double> func_polish(complex<double> x, const string &str)
		{
		    vector<complex<double>> num_stack;
		    for(int i = 0; i < str.size(); ++i)
		    {
		        if(str[i] == ' ')
		        {
		            continue;
		        }
		        if(is_number(str[i]))
		        {
		            double num = read_number(i,str);
		            num_stack.push_back(complex<double>(num,0.0));
		        }
		        else
		        if(is_oper(str[i]))
		        {
		            compute(str[i],num_stack);
		        }
		        else
		        if(str[i] == 'x')
		        {
		            num_stack.push_back(x);
		        }
		        else
		        if(str[i] == 'i')
		        {
		            num_stack.push_back(complex<double>(0.0,1.0));
		        }
		    }
		    complex<double> ret;
		    if(num_stack.size() > 0)
		    {
		        ret = num_stack.back();
		        num_stack.pop_back();
		    }
		    return ret;
		}
		+/
	}
	string infixToPolish(string expr) {
		return expr;
	}
	*/
}