module util.tile;

import util.color;

struct Tile {
	public:
	int x, y, w, h;
	color average;
	bool monochrome = false;
	
	this(int ax, int ay) {
		x = ax;
		y = ay;
	}
	this(int ax, int ay, int aw, int ah) {
		this(ax,ay);
		w = aw;
		h = ah;
	}
	Tile correct(int ax, int ay, int aw, int ah) const {
		Tile corr = this;
	    if(x + w >= aw)
	    {
	        corr.w -= x + w - aw;
	    }
	    if(y + h >= ah)
	    {
	        corr.h -= y + h - ah;
	    }
	    if(x < ax)
	    {
	        corr.x = ax;
	        corr.w += x - ax;
	    }
	    if(y < ay)
	    {
	        corr.y = ay;
	        corr.h += y - ay;
	    }
	    return corr;
	}
	Tile correct(int aw, int ah) const {
		return correct(0,0,aw,ah);
	}
	bool empty() const {
		if(w > 0 && h > 0)
	    {
	        return false;
	    }
	    return true;
	}
}