module server;

import std::net::url;
import std::collections::map;
import std::io;

struct Request {
    // maybe enum??
    String method;
    Url url;
    String protocol;
    Map(<String, String[]>) headers;
    InStream body;
}

