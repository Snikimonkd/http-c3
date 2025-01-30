module server;

import std::collections::map;
import std::io;

struct Response {
    // enum???
    int code;
    OutStream body;
    Map(<String, String[]>) headers;
}

