module server;

import std::net::tcp;
import std::thread::pool;
import std::io;

struct Server {
    TcpServerSocket socket;
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
    self.socket = tcp::listen("localhost", self.port, 5)!;

    while (true) {
        io::printfn("lol");
        TcpSocket sock = tcp::accept(&self.socket)!;
        io::printfn("kek");
        //        PoolFnArgs* pfa = allocator::new(allocator, PoolFnArgs);
        //        pfa.server = self;
        //        pfa.socket = &sock;
        self.pool.push(&handle, &sock)!;
    }
}

fn int handle(void* arg) {
    io::printfn("wtf");
    TcpSocket* sock = (TcpSocket*)arg;
    defer sock.destroy()!!;

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

