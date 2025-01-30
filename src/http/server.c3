module server;

import std::net::tcp;
import std::thread::pool;
import std::io;

struct Server {
    TcpServerSocket serverSocket;
    // TODO: why 128?? it's definitly must be more then cores but how many? make a generic module? bench?
    ThreadPool(<128>) pool;
    uint port;
    String addr;
}

fn void! Server.init(&self, String addr = "localhost", uint port = 8080) {
    self.pool.init()!;
    self.port = port;
    self.addr = addr;
}

fn void! Server.destroy(&self) {
    self.pool.stop_and_destroy()!;
}

fn void! Server.listen(&self) {
    io::printfn("server starts on port: %s", self.port);
    self.serverSocket = tcp::listen("localhost", self.port, 5)!;

    while (true) {
        TcpSocket clientSocket = tcp::accept(&self.serverSocket)!;

        self.pool.push(&handle, &clientSocket)!;
    }
}

fn int handle(void* arg) {
    TcpSocket* socket = (TcpSocket*)arg;
    defer socket.destroy()!!;

    Request! req = init(socket);
    if (catch err = req) {
        io::printfn("wtf: %s", err);
        return -1;
    }

    io::printfn("method: %s", req.method);

    return 0;
}

