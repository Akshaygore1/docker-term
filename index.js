const express = require('express');
const { createServer } = require('node:http');
const { join } = require('node:path');
const { Server } = require('socket.io');
const { spawn } = require('node-pty');

const app = express();
const server = createServer(app);
const io = new Server(server);

app.get('/', (req, res) => {
	res.sendFile(join(__dirname, 'index.html'));
});

io.on('connection', (socket) => {
	console.log('User Connected');

	// Terminal Code
	const ptyProcess = spawn('bash', [], {
		name: 'xterm-color',
		cwd: './user',
	});

	socket.on('command', (data) => {
		ptyProcess.write(data);
	});

	socket.on('disconnect', () => {
		console.log('User disconnected');
	});

	ptyProcess.onData((data) => {
		socket.emit('data', data);
	});
});

server.listen(3000, () => {
	console.log('Server running at http://localhost:3000');
});
