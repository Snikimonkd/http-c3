module server;
import std::io;

fn int main(String[] args)
{
    Server s;
    s.init(port: 8083)!!;
    s.listen()!!;

	return 0;
}
