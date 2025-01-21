module http_server;
import std::io;

fn int main(String[] args)
{
    HttpServer s;
    s.init(port: 8083)!!;
    s.listen()!!;

	return 0;
}
