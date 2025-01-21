module http_server;

import std::net::tcp;
import std::net::url;
import std::thread::pool;

import std::collections::map;

import std::io;

struct HttpServer {
    TcpServerSocket* socket;
    // TODO: why 128?? it's definitly must be more then cores but how many? make a generic module?
    ThreadPool(<128>) pool;
    uint port;
    String addr;
}

fn void! HttpServer.init(&self, String addr = "localhost", uint port = 8080) {
    self.pool.init()!;
    self.port = port;
    self.addr = addr;
}

fn void! HttpServer.destroy(&self) {
    self.pool.stop_and_destroy()!;
}

fn int echo(void* arg) {
    Socket* sock = (TcpSocket*)arg;
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

fn void! HttpServer.listen(&self) {
    io::printfn("server starts on port: %s", self.port);
    self.socket = &&(tcp::listen("localhost", self.port, 5)!);

    while (true) {
        TcpSocket sock = tcp::accept(self.socket)!;

        self.pool.push(&echo, &sock)!;
    }
}

struct Request {
    // maybe enum??
    String method;
    Url url;
    String protocol; // HTTP/1.0
    Map(<String, String[]>) headers;
    InStream body;
}

struct Response {
    // enum???
    int code;
    OutStream body;
    Map(<String, String[]>) headers;
}
