package src.utils;

import sys.net.Host;
import sys.net.Address;
import sys.net.UdpSocket;
import haxe.io.Bytes;

class UDPListener {
	public static function start() {
		var udpIp = "0.0.0.0";
		var udpPort = 4405;
		var address:Address = new Address();
        var host = new Host(udpIp);

		address.host = host.ip;
        address.port = udpPort;

		var socket = new UdpSocket();

		try {
			socket.bind(host, udpPort);
			SlushiUtils.printMsg('Listening in [$host:$udpPort] by UDP...', INFO);
			SlushiUtils.printMsg('------------------', NONE);

			while (true) {
                var arrayData = new Array<cpp.UInt8>();
				var data:Bytes = Bytes.alloc(1024);
				var address = socket.readFrom(data, 0, 1024, address);

				if (address != 0) {
					var clientIp = host;
					var clientPort = udpPort;

					var receivedString = data.toString();
					SlushiUtils.printMsg('$receivedString', NONE);
				}
			}
		} catch (e:Dynamic) {
			SlushiUtils.printMsg('------------------', NONE);
			SlushiUtils.printMsg('\nUnknown error: $e', ERROR);
		}

		SlushiUtils.printMsg('------------------', NONE);
        socket.close();
        SlushiUtils.printMsg('Socket closed', INFO);
	}
}