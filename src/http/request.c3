module server;

import std::net::url;
import std::collections::map;
import std::io;
import std::net::tcp;

struct Request {
    // maybe enum??
    String method;
    Url url;
    String protocol;
    Map(<String, String[]>) headers;
    char[] body;
}

fault Error {
    READ_ERROR,
}

fn Request! init(TcpSocket* socket) {
    char[256] buf;

    usz n = socket.read(&buf)!;
    if (n < 1) {
        return Error.READ_ERROR?;
    }

    String str = (String)&buf;

    return Request{
        .method = str[0:str.index_of_char(' ')],
    };
}
