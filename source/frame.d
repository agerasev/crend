module frame;

import derelict.sdl2.sdl;
import derelict.opengl3.gl;

import util.size;

import renderer;

/**
	SDL says you may open window only in main thread
	let's follow this adwise
*/
class Frame {
	
	private:
	bool _opened = false;
	Size _size = Size(800,600);
	SDL_Window *_window = null;
	SDL_GLContext _context;
	SDL_Event _event;
	bool _lmb,_mmb,_rmb;
	bool _fs;

	Renderer _renderer = null;
	
	public:
	
	/**
		'size' property allows you to set the window size
		but only when window is opened
	*/
	@property Size size() {
		return _size;
	}
	@property void size(Size res) {
		if(!_opened) {
			_size = res;
		}
	}
	
	/**
		'renderer' property allows you to set your renderer
		it must be inherited from 'Renderer' class
		but not when window is opened
	*/
	@property Renderer renderer() {
		return _renderer;
	}
	@property void renderer(Renderer rend) {
		if(!_opened) {
			_renderer = rend;
		}
	}
	
	private:
	
	void _create() {
		
		_window = SDL_CreateWindow(
    	"Frame", 
    	SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
    	_size.w, _size.h, 
    	SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE
    	);
    
	    SDL_GLContext con = SDL_GL_CreateContext(_window);
	    
	    DerelictGL.reload();
	    
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER,1);
		SDL_GL_SetAttribute(SDL_GL_RED_SIZE,5);
		SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE,6);
		SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE,5);
		SDL_GL_SetSwapInterval(0);
		
		glEnableClientState( GL_VERTEX_ARRAY );
		glEnableClientState( GL_COLOR_ARRAY );
		
		_opened = true;
	}
	
	void _destroy() {
		SDL_GL_DeleteContext(_context);
		_context = null;
		SDL_DestroyWindow(_window);
		_window = null;
	}
	
	void _resize() {
		glViewport(0,0,_size.w,_size.h);
	    glMatrixMode(GL_PROJECTION);
	    glLoadIdentity();
	    glOrtho(
	    	-0.5f,
	    	_size.w-0.5f,
	    	-0.5f,
	    	_size.h-0.5f,
	    	-1.0f,1.0f
	    	);
	    glMatrixMode(GL_MODELVIEW);
	    
	    _renderer.size = Size(_size.w,_size.h);
	}

	void _fullscreen() { 
		if(!_fs) {
			SDL_SetWindowFullscreen(_window,SDL_WINDOW_FULLSCREEN_DESKTOP);
			_fs = true;
		} else {
			SDL_SetWindowFullscreen(_window,0);
			_fs = false;
		}
	}
	
	void _handle() {
		while(SDL_PollEvent(&_event)) {
            if(_event.type == SDL_QUIT) {
                _opened = false;
            }else
            if(_event.type == SDL_KEYDOWN) {
                if(_event.key.keysym.sym == SDLK_ESCAPE) {
                    _opened = false;
				} else
				if(_event.key.keysym.sym == SDLK_F11) {
					_fullscreen();
				}
			} else
            if(_event.type == SDL_WINDOWEVENT) {
            	if(_event.window.event == SDL_WINDOWEVENT_RESIZED) {
					_size = Size(_event.window.data1,_event.window.data2);
            		_resize();
            	}
			} else
			if(_event.type == SDL_MOUSEBUTTONDOWN) {
				if(_event.button.button == SDL_BUTTON_LEFT) {
					_lmb = true;
				} else
				if(_event.button.button == SDL_BUTTON_MIDDLE) {
					_mmb = true;
				} else
				if(_event.button.button == SDL_BUTTON_RIGHT) {
					_rmb = true;
				}
			} else
			if(_event.type == SDL_MOUSEBUTTONUP) {
				if(_event.button.button == SDL_BUTTON_LEFT) {
					_lmb = false;
				} else
				if(_event.button.button == SDL_BUTTON_MIDDLE) {
					_mmb = false;
				} else
				if(_event.button.button == SDL_BUTTON_RIGHT) {
					_rmb = false;
				}
			} else
			if(_event.type == SDL_MOUSEMOTION) {
				creal delta = _renderer.scale*(1.0L*_event.motion.xrel - 1.0Li*_event.motion.yrel)/_size.h;
				if(_rmb) {
					_renderer.translation = _renderer.translation - delta;
				}
			} else
			if(_event.type == SDL_MOUSEWHEEL) {
				double zoomSens = 0.8;
				_renderer.scale = _renderer.scale*(zoomSens^^_event.wheel.y);
			}
        }
	}
	
	void _flip() {
		glFlush();
        SDL_GL_SwapWindow(_window);
	}
	
	void _render() {
		_renderer.render();
		_renderer.flip();
	}
	
	public:
	
	/**
		Frame main cycle
		ends when window is closed
		throws NullPointerException if renderer hasn't set
	*/
	void open() {
		_create();
		_resize();
		while(_opened) {
			_handle();
			_render();
			_flip();
		}
		_destroy();
	}
}
