module server;

import std::net::tcp;
import std::thread::pool;
import std::io;

struct HttpServer {
    TcpServerSocket* socket;
    ThreadPool(<128>) pool;
}

fn void! HttpServer.init(&self) {
    self.pool.init()!;
}

fn void! HttpServer.destroy(&self) {
    self.pool.stop_and_destroy()!;
}

fn int defaultFunc(void* arg) {
    Socket* sock = (TcpSocket*)arg;

    char[128] buf;
    usz! read = sock.read(&buf);
    if (catch err = read) {
        io::printfn("read error: %s", err);
        return -1;
    }

    io::printfn("read: %s", buf);

    if (catch err = sock.write(&buf)) {
        io::printfn("write error: %s", err);
        return -1;
    }

    return 0;
}

fn void! HttpServer.listen(&self) {
    self.socket = &&(tcp::listen("localhost", 8084, 5)!);

    while (true) {
        TcpSocket sock = tcp::accept(self.socket)!;

        self.pool.push(&defaultFunc, &sock)!;
    }
}
