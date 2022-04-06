import zmq

context = zmq.Context()

print("Connecting to hello world server...")
socket = context.socket(zmq.REQ)
socket.connect("tcp://localhost:5555")

request = 'access'
print("Sending request %s ..." % request)
socket.send_string(request)

message = socket.recv()
print(f'Recieved reply %s %s' % (request, message))
