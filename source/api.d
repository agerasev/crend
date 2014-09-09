module api;

import derelict.sdl2.sdl;
import derelict.opengl3.gl;

static class API {
	public:
	static void init() {
		DerelictSDL2.load();
		DerelictGL.load();
		SDL_Init(SDL_INIT_VIDEO);
	}
	static void quit() {
		SDL_Quit();
	}
}