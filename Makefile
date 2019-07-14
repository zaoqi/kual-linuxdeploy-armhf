all: menu.json
menu.json: gen.menu.json.js
	./gen.menu.json.js > menu.json
