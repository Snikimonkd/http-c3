module http_server;
import std::io;

fn int main(String[] args)
{
    HttpServer s;
    s.init(8083)!!;
    s.listen()!!;

	return 0;
}
