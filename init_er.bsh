echo ""
echo "Starting to initialize ER"
echo "Initializing ER in Instance 4"
cdr define server --connect=inst_4 --init g_inst4 echo ""
## give the remote server a chance to come up and fully initialize. sleep 10
echo "ER in Instance 4 is initialized"
echo ""
echo "Now initializing on the Pi"
cdr define serv --connect=iotkitstu13 --init --sync=g_inst4 g_stu13 echo ""
echo "ER on the Pi is initialized"
echo ""
cdr list server