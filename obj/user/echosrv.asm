
obj/user/echosrv.debug:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 fc 04 00 00       	call   80052d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <die>:
#define BUFFSIZE 32
#define MAXPENDING 5    // Max connection requests

static void
die(char *m)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80003d:	c7 04 24 f0 2a 80 00 	movl   $0x802af0,(%esp)
  800044:	e8 f2 05 00 00       	call   80063b <cprintf>
	exit();
  800049:	e8 31 05 00 00       	call   80057f <exit>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <handle_client>:

void
handle_client(int sock)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	57                   	push   %edi
  800054:	56                   	push   %esi
  800055:	53                   	push   %ebx
  800056:	83 ec 3c             	sub    $0x3c,%esp
  800059:	8b 75 08             	mov    0x8(%ebp),%esi
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  80005c:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  800063:	00 
  800064:	8d 45 c8             	lea    -0x38(%ebp),%eax
  800067:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006b:	89 34 24             	mov    %esi,(%esp)
  80006e:	e8 47 16 00 00       	call   8016ba <read>
  800073:	89 c3                	mov    %eax,%ebx
  800075:	85 c0                	test   %eax,%eax
  800077:	78 05                	js     80007e <handle_client+0x2e>
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  800079:	8d 7d c8             	lea    -0x38(%ebp),%edi
  80007c:	eb 4e                	jmp    8000cc <handle_client+0x7c>
{
	char buffer[BUFFSIZE];
	int received = -1;
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");
  80007e:	b8 f4 2a 80 00       	mov    $0x802af4,%eax
  800083:	e8 ab ff ff ff       	call   800033 <die>
  800088:	eb ef                	jmp    800079 <handle_client+0x29>

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
		// Send back received data
		if (write(sock, buffer, received) != received)
  80008a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80008e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800092:	89 34 24             	mov    %esi,(%esp)
  800095:	e8 fd 16 00 00       	call   801797 <write>
  80009a:	39 d8                	cmp    %ebx,%eax
  80009c:	74 0a                	je     8000a8 <handle_client+0x58>
			die("Failed to send bytes to client");
  80009e:	b8 20 2b 80 00       	mov    $0x802b20,%eax
  8000a3:	e8 8b ff ff ff       	call   800033 <die>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  8000a8:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
  8000af:	00 
  8000b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000b4:	89 34 24             	mov    %esi,(%esp)
  8000b7:	e8 fe 15 00 00       	call   8016ba <read>
  8000bc:	89 c3                	mov    %eax,%ebx
  8000be:	85 c0                	test   %eax,%eax
  8000c0:	79 0a                	jns    8000cc <handle_client+0x7c>
			die("Failed to receive additional bytes from client");
  8000c2:	b8 40 2b 80 00       	mov    $0x802b40,%eax
  8000c7:	e8 67 ff ff ff       	call   800033 <die>
	// Receive message
	if ((received = read(sock, buffer, BUFFSIZE)) < 0)
		die("Failed to receive initial bytes from client");

	// Send bytes and check for more incoming data in loop
	while (received > 0) {
  8000cc:	85 db                	test   %ebx,%ebx
  8000ce:	7f ba                	jg     80008a <handle_client+0x3a>

		// Check for more data
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
			die("Failed to receive additional bytes from client");
	}
	close(sock);
  8000d0:	89 34 24             	mov    %esi,(%esp)
  8000d3:	e8 7f 14 00 00       	call   801557 <close>
}
  8000d8:	83 c4 3c             	add    $0x3c,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5f                   	pop    %edi
  8000de:	5d                   	pop    %ebp
  8000df:	c3                   	ret    

008000e0 <umain>:

void
umain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 4c             	sub    $0x4c,%esp
	char buffer[BUFFSIZE];
	unsigned int echolen;
	int received = 0;

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  8000e9:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8000f0:	00 
  8000f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000f8:	00 
  8000f9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800100:	e8 52 1d 00 00       	call   801e57 <socket>
  800105:	89 c6                	mov    %eax,%esi
  800107:	85 c0                	test   %eax,%eax
  800109:	79 0a                	jns    800115 <umain+0x35>
		die("Failed to create socket");
  80010b:	b8 a0 2a 80 00       	mov    $0x802aa0,%eax
  800110:	e8 1e ff ff ff       	call   800033 <die>

	cprintf("opened socket\n");
  800115:	c7 04 24 b8 2a 80 00 	movl   $0x802ab8,(%esp)
  80011c:	e8 1a 05 00 00       	call   80063b <cprintf>

	// Construct the server sockaddr_in structure
	memset(&echoserver, 0, sizeof(echoserver));       // Clear struct
  800121:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800128:	00 
  800129:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800130:	00 
  800131:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  800134:	89 1c 24             	mov    %ebx,(%esp)
  800137:	e8 7b 0c 00 00       	call   800db7 <memset>
	echoserver.sin_family = AF_INET;                  // Internet/IP
  80013c:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	echoserver.sin_addr.s_addr = htonl(INADDR_ANY);   // IP address
  800140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800147:	e8 94 01 00 00       	call   8002e0 <htonl>
  80014c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	echoserver.sin_port = htons(PORT);		  // server port
  80014f:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800156:	e8 6b 01 00 00       	call   8002c6 <htons>
  80015b:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	cprintf("trying to bind\n");
  80015f:	c7 04 24 c7 2a 80 00 	movl   $0x802ac7,(%esp)
  800166:	e8 d0 04 00 00       	call   80063b <cprintf>

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &echoserver,
  80016b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800172:	00 
  800173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800177:	89 34 24             	mov    %esi,(%esp)
  80017a:	e8 36 1c 00 00       	call   801db5 <bind>
  80017f:	85 c0                	test   %eax,%eax
  800181:	79 0a                	jns    80018d <umain+0xad>
		 sizeof(echoserver)) < 0) {
		die("Failed to bind the server socket");
  800183:	b8 70 2b 80 00       	mov    $0x802b70,%eax
  800188:	e8 a6 fe ff ff       	call   800033 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  80018d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  800194:	00 
  800195:	89 34 24             	mov    %esi,(%esp)
  800198:	e8 95 1c 00 00       	call   801e32 <listen>
  80019d:	85 c0                	test   %eax,%eax
  80019f:	79 0a                	jns    8001ab <umain+0xcb>
		die("Failed to listen on server socket");
  8001a1:	b8 94 2b 80 00       	mov    $0x802b94,%eax
  8001a6:	e8 88 fe ff ff       	call   800033 <die>

	cprintf("bound\n");
  8001ab:	c7 04 24 d7 2a 80 00 	movl   $0x802ad7,(%esp)
  8001b2:	e8 84 04 00 00       	call   80063b <cprintf>

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
		// Wait for client connection
		if ((clientsock =
  8001b7:	8d 7d c4             	lea    -0x3c(%ebp),%edi

	cprintf("bound\n");

	// Run until canceled
	while (1) {
		unsigned int clientlen = sizeof(echoclient);
  8001ba:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock =
  8001c1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001c5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cc:	89 34 24             	mov    %esi,(%esp)
  8001cf:	e8 a6 1b 00 00       	call   801d7a <accept>
  8001d4:	89 c3                	mov    %eax,%ebx
  8001d6:	85 c0                	test   %eax,%eax
  8001d8:	79 0a                	jns    8001e4 <umain+0x104>
		     accept(serversock, (struct sockaddr *) &echoclient,
			    &clientlen)) < 0) {
			die("Failed to accept client connection");
  8001da:	b8 b8 2b 80 00       	mov    $0x802bb8,%eax
  8001df:	e8 4f fe ff ff       	call   800033 <die>
		}
		cprintf("Client connected: %s\n", inet_ntoa(echoclient.sin_addr));
  8001e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001e7:	89 04 24             	mov    %eax,(%esp)
  8001ea:	e8 21 00 00 00       	call   800210 <inet_ntoa>
  8001ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f3:	c7 04 24 de 2a 80 00 	movl   $0x802ade,(%esp)
  8001fa:	e8 3c 04 00 00       	call   80063b <cprintf>
		handle_client(clientsock);
  8001ff:	89 1c 24             	mov    %ebx,(%esp)
  800202:	e8 49 fe ff ff       	call   800050 <handle_client>
	}
  800207:	eb b1                	jmp    8001ba <umain+0xda>
  800209:	66 90                	xchg   %ax,%ax
  80020b:	66 90                	xchg   %ax,%ax
  80020d:	66 90                	xchg   %ax,%ax
  80020f:	90                   	nop

00800210 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800219:	8b 45 08             	mov    0x8(%ebp),%eax
  80021c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80021f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800223:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800226:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80022d:	be 00 00 00 00       	mov    $0x0,%esi
  800232:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800235:	eb 02                	jmp    800239 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800237:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800239:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80023c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80023f:	0f b6 c2             	movzbl %dl,%eax
  800242:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800245:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800248:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80024b:	66 c1 e8 0b          	shr    $0xb,%ax
  80024f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  800251:	8d 4e 01             	lea    0x1(%esi),%ecx
  800254:	89 f3                	mov    %esi,%ebx
  800256:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800259:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  80025c:	01 ff                	add    %edi,%edi
  80025e:	89 fb                	mov    %edi,%ebx
  800260:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  800262:	83 c2 30             	add    $0x30,%edx
  800265:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  800269:	84 c0                	test   %al,%al
  80026b:	75 ca                	jne    800237 <inet_ntoa+0x27>
  80026d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800270:	89 c8                	mov    %ecx,%eax
  800272:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800275:	89 cf                	mov    %ecx,%edi
  800277:	eb 0d                	jmp    800286 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  800279:	0f b6 f0             	movzbl %al,%esi
  80027c:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  800281:	88 0a                	mov    %cl,(%edx)
  800283:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  800286:	83 e8 01             	sub    $0x1,%eax
  800289:	3c ff                	cmp    $0xff,%al
  80028b:	75 ec                	jne    800279 <inet_ntoa+0x69>
  80028d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800290:	89 f9                	mov    %edi,%ecx
  800292:	0f b6 c9             	movzbl %cl,%ecx
  800295:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  800298:	8d 41 01             	lea    0x1(%ecx),%eax
  80029b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  80029e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8002a2:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  8002a6:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  8002aa:	77 0a                	ja     8002b6 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8002ac:	c6 01 2e             	movb   $0x2e,(%ecx)
  8002af:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b4:	eb 81                	jmp    800237 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  8002b6:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  8002b9:	b8 00 50 80 00       	mov    $0x805000,%eax
  8002be:	83 c4 19             	add    $0x19,%esp
  8002c1:	5b                   	pop    %ebx
  8002c2:	5e                   	pop    %esi
  8002c3:	5f                   	pop    %edi
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002c9:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002cd:	66 c1 c0 08          	rol    $0x8,%ax
}
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  8002d6:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8002da:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  8002de:	5d                   	pop    %ebp
  8002df:	c3                   	ret    

008002e0 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  8002e6:	89 d1                	mov    %edx,%ecx
  8002e8:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  8002eb:	89 d0                	mov    %edx,%eax
  8002ed:	c1 e0 18             	shl    $0x18,%eax
  8002f0:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  8002f2:	89 d1                	mov    %edx,%ecx
  8002f4:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8002fa:	c1 e1 08             	shl    $0x8,%ecx
  8002fd:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  8002ff:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800305:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800308:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80030a:	5d                   	pop    %ebp
  80030b:	c3                   	ret    

0080030c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	57                   	push   %edi
  800310:	56                   	push   %esi
  800311:	53                   	push   %ebx
  800312:	83 ec 20             	sub    $0x20,%esp
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800318:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80031b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80031e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800321:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800324:	80 f9 09             	cmp    $0x9,%cl
  800327:	0f 87 a6 01 00 00    	ja     8004d3 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80032d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800334:	83 fa 30             	cmp    $0x30,%edx
  800337:	75 2b                	jne    800364 <inet_aton+0x58>
      c = *++cp;
  800339:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80033d:	89 d1                	mov    %edx,%ecx
  80033f:	83 e1 df             	and    $0xffffffdf,%ecx
  800342:	80 f9 58             	cmp    $0x58,%cl
  800345:	74 0f                	je     800356 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800347:	83 c0 01             	add    $0x1,%eax
  80034a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80034d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  800354:	eb 0e                	jmp    800364 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  800356:	0f be 50 02          	movsbl 0x2(%eax),%edx
  80035a:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  80035d:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  800364:	83 c0 01             	add    $0x1,%eax
  800367:	bf 00 00 00 00       	mov    $0x0,%edi
  80036c:	eb 03                	jmp    800371 <inet_aton+0x65>
  80036e:	83 c0 01             	add    $0x1,%eax
  800371:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  800374:	89 d3                	mov    %edx,%ebx
  800376:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800379:	80 f9 09             	cmp    $0x9,%cl
  80037c:	77 0d                	ja     80038b <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  80037e:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  800382:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  800386:	0f be 10             	movsbl (%eax),%edx
  800389:	eb e3                	jmp    80036e <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  80038b:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  80038f:	75 30                	jne    8003c1 <inet_aton+0xb5>
  800391:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  800394:	88 4d df             	mov    %cl,-0x21(%ebp)
  800397:	89 d1                	mov    %edx,%ecx
  800399:	83 e1 df             	and    $0xffffffdf,%ecx
  80039c:	83 e9 41             	sub    $0x41,%ecx
  80039f:	80 f9 05             	cmp    $0x5,%cl
  8003a2:	77 23                	ja     8003c7 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8003a4:	89 fb                	mov    %edi,%ebx
  8003a6:	c1 e3 04             	shl    $0x4,%ebx
  8003a9:	8d 7a 0a             	lea    0xa(%edx),%edi
  8003ac:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  8003b0:	19 c9                	sbb    %ecx,%ecx
  8003b2:	83 e1 20             	and    $0x20,%ecx
  8003b5:	83 c1 41             	add    $0x41,%ecx
  8003b8:	29 cf                	sub    %ecx,%edi
  8003ba:	09 df                	or     %ebx,%edi
        c = *++cp;
  8003bc:	0f be 10             	movsbl (%eax),%edx
  8003bf:	eb ad                	jmp    80036e <inet_aton+0x62>
  8003c1:	89 d0                	mov    %edx,%eax
  8003c3:	89 f9                	mov    %edi,%ecx
  8003c5:	eb 04                	jmp    8003cb <inet_aton+0xbf>
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  8003cb:	83 f8 2e             	cmp    $0x2e,%eax
  8003ce:	75 22                	jne    8003f2 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  8003d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8003d3:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  8003d6:	0f 84 fe 00 00 00    	je     8004da <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  8003dc:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8003e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e3:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  8003e6:	8d 46 01             	lea    0x1(%esi),%eax
  8003e9:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  8003ed:	e9 2f ff ff ff       	jmp    800321 <inet_aton+0x15>
  8003f2:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003f4:	85 d2                	test   %edx,%edx
  8003f6:	74 27                	je     80041f <inet_aton+0x113>
    return (0);
  8003f8:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8003fd:	80 fb 1f             	cmp    $0x1f,%bl
  800400:	0f 86 e7 00 00 00    	jbe    8004ed <inet_aton+0x1e1>
  800406:	84 d2                	test   %dl,%dl
  800408:	0f 88 d3 00 00 00    	js     8004e1 <inet_aton+0x1d5>
  80040e:	83 fa 20             	cmp    $0x20,%edx
  800411:	74 0c                	je     80041f <inet_aton+0x113>
  800413:	83 ea 09             	sub    $0x9,%edx
  800416:	83 fa 04             	cmp    $0x4,%edx
  800419:	0f 87 ce 00 00 00    	ja     8004ed <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80041f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800422:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800425:	29 c2                	sub    %eax,%edx
  800427:	c1 fa 02             	sar    $0x2,%edx
  80042a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80042d:	83 fa 02             	cmp    $0x2,%edx
  800430:	74 22                	je     800454 <inet_aton+0x148>
  800432:	83 fa 02             	cmp    $0x2,%edx
  800435:	7f 0f                	jg     800446 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800437:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80043c:	85 d2                	test   %edx,%edx
  80043e:	0f 84 a9 00 00 00    	je     8004ed <inet_aton+0x1e1>
  800444:	eb 73                	jmp    8004b9 <inet_aton+0x1ad>
  800446:	83 fa 03             	cmp    $0x3,%edx
  800449:	74 26                	je     800471 <inet_aton+0x165>
  80044b:	83 fa 04             	cmp    $0x4,%edx
  80044e:	66 90                	xchg   %ax,%ax
  800450:	74 40                	je     800492 <inet_aton+0x186>
  800452:	eb 65                	jmp    8004b9 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  800454:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  800459:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  80045f:	0f 87 88 00 00 00    	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  800465:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800468:	c1 e0 18             	shl    $0x18,%eax
  80046b:	89 cf                	mov    %ecx,%edi
  80046d:	09 c7                	or     %eax,%edi
    break;
  80046f:	eb 48                	jmp    8004b9 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  800476:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  80047c:	77 6f                	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80047e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800481:	c1 e2 10             	shl    $0x10,%edx
  800484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800487:	c1 e0 18             	shl    $0x18,%eax
  80048a:	09 d0                	or     %edx,%eax
  80048c:	09 c8                	or     %ecx,%eax
  80048e:	89 c7                	mov    %eax,%edi
    break;
  800490:	eb 27                	jmp    8004b9 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  800492:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  800497:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  80049d:	77 4e                	ja     8004ed <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  80049f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a2:	c1 e2 10             	shl    $0x10,%edx
  8004a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a8:	c1 e0 18             	shl    $0x18,%eax
  8004ab:	09 c2                	or     %eax,%edx
  8004ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004b0:	c1 e0 08             	shl    $0x8,%eax
  8004b3:	09 d0                	or     %edx,%eax
  8004b5:	09 c8                	or     %ecx,%eax
  8004b7:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  8004b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004bd:	74 29                	je     8004e8 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  8004bf:	89 3c 24             	mov    %edi,(%esp)
  8004c2:	e8 19 fe ff ff       	call   8002e0 <htonl>
  8004c7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ca:	89 06                	mov    %eax,(%esi)
  return (1);
  8004cc:	b8 01 00 00 00       	mov    $0x1,%eax
  8004d1:	eb 1a                	jmp    8004ed <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  8004d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d8:	eb 13                	jmp    8004ed <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  8004da:	b8 00 00 00 00       	mov    $0x0,%eax
  8004df:	eb 0c                	jmp    8004ed <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e6:	eb 05                	jmp    8004ed <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  8004e8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8004ed:	83 c4 20             	add    $0x20,%esp
  8004f0:	5b                   	pop    %ebx
  8004f1:	5e                   	pop    %esi
  8004f2:	5f                   	pop    %edi
  8004f3:	5d                   	pop    %ebp
  8004f4:	c3                   	ret    

008004f5 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8004fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8004fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800502:	8b 45 08             	mov    0x8(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	e8 ff fd ff ff       	call   80030c <inet_aton>
  80050d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80050f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800514:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	89 04 24             	mov    %eax,(%esp)
  800526:	e8 b5 fd ff ff       	call   8002e0 <htonl>
}
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	56                   	push   %esi
  800531:	53                   	push   %ebx
  800532:	83 ec 10             	sub    $0x10,%esp
  800535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800538:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80053b:	c7 05 18 50 80 00 00 	movl   $0x0,0x805018
  800542:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800545:	e8 fb 0a 00 00       	call   801045 <sys_getenvid>
  80054a:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80054f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800552:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800557:	a3 18 50 80 00       	mov    %eax,0x805018


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80055c:	85 db                	test   %ebx,%ebx
  80055e:	7e 07                	jle    800567 <libmain+0x3a>
		binaryname = argv[0];
  800560:	8b 06                	mov    (%esi),%eax
  800562:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800567:	89 74 24 04          	mov    %esi,0x4(%esp)
  80056b:	89 1c 24             	mov    %ebx,(%esp)
  80056e:	e8 6d fb ff ff       	call   8000e0 <umain>

	// exit gracefully
	exit();
  800573:	e8 07 00 00 00       	call   80057f <exit>
}
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	5b                   	pop    %ebx
  80057c:	5e                   	pop    %esi
  80057d:	5d                   	pop    %ebp
  80057e:	c3                   	ret    

0080057f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
  800582:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800585:	e8 00 10 00 00       	call   80158a <close_all>
	sys_env_destroy(0);
  80058a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800591:	e8 5d 0a 00 00       	call   800ff3 <sys_env_destroy>
}
  800596:	c9                   	leave  
  800597:	c3                   	ret    

00800598 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800598:	55                   	push   %ebp
  800599:	89 e5                	mov    %esp,%ebp
  80059b:	53                   	push   %ebx
  80059c:	83 ec 14             	sub    $0x14,%esp
  80059f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8005a2:	8b 13                	mov    (%ebx),%edx
  8005a4:	8d 42 01             	lea    0x1(%edx),%eax
  8005a7:	89 03                	mov    %eax,(%ebx)
  8005a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005ac:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8005b0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005b5:	75 19                	jne    8005d0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8005b7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8005be:	00 
  8005bf:	8d 43 08             	lea    0x8(%ebx),%eax
  8005c2:	89 04 24             	mov    %eax,(%esp)
  8005c5:	e8 ec 09 00 00       	call   800fb6 <sys_cputs>
		b->idx = 0;
  8005ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8005d0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8005d4:	83 c4 14             	add    $0x14,%esp
  8005d7:	5b                   	pop    %ebx
  8005d8:	5d                   	pop    %ebp
  8005d9:	c3                   	ret    

008005da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8005e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005ea:	00 00 00 
	b.cnt = 0;
  8005ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800601:	89 44 24 08          	mov    %eax,0x8(%esp)
  800605:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060f:	c7 04 24 98 05 80 00 	movl   $0x800598,(%esp)
  800616:	e8 b3 01 00 00       	call   8007ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80061b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800621:	89 44 24 04          	mov    %eax,0x4(%esp)
  800625:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80062b:	89 04 24             	mov    %eax,(%esp)
  80062e:	e8 83 09 00 00       	call   800fb6 <sys_cputs>

	return b.cnt;
}
  800633:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800641:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800644:	89 44 24 04          	mov    %eax,0x4(%esp)
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	89 04 24             	mov    %eax,(%esp)
  80064e:	e8 87 ff ff ff       	call   8005da <vcprintf>
	va_end(ap);

	return cnt;
}
  800653:	c9                   	leave  
  800654:	c3                   	ret    
  800655:	66 90                	xchg   %ax,%ax
  800657:	66 90                	xchg   %ax,%ax
  800659:	66 90                	xchg   %ax,%ax
  80065b:	66 90                	xchg   %ax,%ax
  80065d:	66 90                	xchg   %ax,%ax
  80065f:	90                   	nop

00800660 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	57                   	push   %edi
  800664:	56                   	push   %esi
  800665:	53                   	push   %ebx
  800666:	83 ec 3c             	sub    $0x3c,%esp
  800669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80066c:	89 d7                	mov    %edx,%edi
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800674:	8b 45 0c             	mov    0xc(%ebp),%eax
  800677:	89 c3                	mov    %eax,%ebx
  800679:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80067c:	8b 45 10             	mov    0x10(%ebp),%eax
  80067f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800682:	b9 00 00 00 00       	mov    $0x0,%ecx
  800687:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80068d:	39 d9                	cmp    %ebx,%ecx
  80068f:	72 05                	jb     800696 <printnum+0x36>
  800691:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800694:	77 69                	ja     8006ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800696:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800699:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80069d:	83 ee 01             	sub    $0x1,%esi
  8006a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8006ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8006b0:	89 c3                	mov    %eax,%ebx
  8006b2:	89 d6                	mov    %edx,%esi
  8006b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8006be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8006c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c5:	89 04 24             	mov    %eax,(%esp)
  8006c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006cf:	e8 2c 21 00 00       	call   802800 <__udivdi3>
  8006d4:	89 d9                	mov    %ebx,%ecx
  8006d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006de:	89 04 24             	mov    %eax,(%esp)
  8006e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006e5:	89 fa                	mov    %edi,%edx
  8006e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ea:	e8 71 ff ff ff       	call   800660 <printnum>
  8006ef:	eb 1b                	jmp    80070c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f8:	89 04 24             	mov    %eax,(%esp)
  8006fb:	ff d3                	call   *%ebx
  8006fd:	eb 03                	jmp    800702 <printnum+0xa2>
  8006ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800702:	83 ee 01             	sub    $0x1,%esi
  800705:	85 f6                	test   %esi,%esi
  800707:	7f e8                	jg     8006f1 <printnum+0x91>
  800709:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800710:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800714:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800717:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80071e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800725:	89 04 24             	mov    %eax,(%esp)
  800728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072f:	e8 fc 21 00 00       	call   802930 <__umoddi3>
  800734:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800738:	0f be 80 e5 2b 80 00 	movsbl 0x802be5(%eax),%eax
  80073f:	89 04 24             	mov    %eax,(%esp)
  800742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800745:	ff d0                	call   *%eax
}
  800747:	83 c4 3c             	add    $0x3c,%esp
  80074a:	5b                   	pop    %ebx
  80074b:	5e                   	pop    %esi
  80074c:	5f                   	pop    %edi
  80074d:	5d                   	pop    %ebp
  80074e:	c3                   	ret    

0080074f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800752:	83 fa 01             	cmp    $0x1,%edx
  800755:	7e 0e                	jle    800765 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800757:	8b 10                	mov    (%eax),%edx
  800759:	8d 4a 08             	lea    0x8(%edx),%ecx
  80075c:	89 08                	mov    %ecx,(%eax)
  80075e:	8b 02                	mov    (%edx),%eax
  800760:	8b 52 04             	mov    0x4(%edx),%edx
  800763:	eb 22                	jmp    800787 <getuint+0x38>
	else if (lflag)
  800765:	85 d2                	test   %edx,%edx
  800767:	74 10                	je     800779 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800769:	8b 10                	mov    (%eax),%edx
  80076b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80076e:	89 08                	mov    %ecx,(%eax)
  800770:	8b 02                	mov    (%edx),%eax
  800772:	ba 00 00 00 00       	mov    $0x0,%edx
  800777:	eb 0e                	jmp    800787 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800779:	8b 10                	mov    (%eax),%edx
  80077b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80077e:	89 08                	mov    %ecx,(%eax)
  800780:	8b 02                	mov    (%edx),%eax
  800782:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800787:	5d                   	pop    %ebp
  800788:	c3                   	ret    

00800789 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800789:	55                   	push   %ebp
  80078a:	89 e5                	mov    %esp,%ebp
  80078c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80078f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800793:	8b 10                	mov    (%eax),%edx
  800795:	3b 50 04             	cmp    0x4(%eax),%edx
  800798:	73 0a                	jae    8007a4 <sprintputch+0x1b>
		*b->buf++ = ch;
  80079a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80079d:	89 08                	mov    %ecx,(%eax)
  80079f:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a2:	88 02                	mov    %al,(%edx)
}
  8007a4:	5d                   	pop    %ebp
  8007a5:	c3                   	ret    

008007a6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8007ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8007af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	89 04 24             	mov    %eax,(%esp)
  8007c7:	e8 02 00 00 00       	call   8007ce <vprintfmt>
	va_end(ap);
}
  8007cc:	c9                   	leave  
  8007cd:	c3                   	ret    

008007ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	57                   	push   %edi
  8007d2:	56                   	push   %esi
  8007d3:	53                   	push   %ebx
  8007d4:	83 ec 3c             	sub    $0x3c,%esp
  8007d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007dd:	eb 14                	jmp    8007f3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8007df:	85 c0                	test   %eax,%eax
  8007e1:	0f 84 b3 03 00 00    	je     800b9a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8007e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007eb:	89 04 24             	mov    %eax,(%esp)
  8007ee:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007f1:	89 f3                	mov    %esi,%ebx
  8007f3:	8d 73 01             	lea    0x1(%ebx),%esi
  8007f6:	0f b6 03             	movzbl (%ebx),%eax
  8007f9:	83 f8 25             	cmp    $0x25,%eax
  8007fc:	75 e1                	jne    8007df <vprintfmt+0x11>
  8007fe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800802:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800809:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800810:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800817:	ba 00 00 00 00       	mov    $0x0,%edx
  80081c:	eb 1d                	jmp    80083b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80081e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800820:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800824:	eb 15                	jmp    80083b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800826:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800828:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80082c:	eb 0d                	jmp    80083b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80082e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800831:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800834:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80083b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80083e:	0f b6 0e             	movzbl (%esi),%ecx
  800841:	0f b6 c1             	movzbl %cl,%eax
  800844:	83 e9 23             	sub    $0x23,%ecx
  800847:	80 f9 55             	cmp    $0x55,%cl
  80084a:	0f 87 2a 03 00 00    	ja     800b7a <vprintfmt+0x3ac>
  800850:	0f b6 c9             	movzbl %cl,%ecx
  800853:	ff 24 8d 20 2d 80 00 	jmp    *0x802d20(,%ecx,4)
  80085a:	89 de                	mov    %ebx,%esi
  80085c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800861:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800864:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800868:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80086b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80086e:	83 fb 09             	cmp    $0x9,%ebx
  800871:	77 36                	ja     8008a9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb e9                	jmp    800861 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	8d 48 04             	lea    0x4(%eax),%ecx
  80087e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800881:	8b 00                	mov    (%eax),%eax
  800883:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800886:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800888:	eb 22                	jmp    8008ac <vprintfmt+0xde>
  80088a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80088d:	85 c9                	test   %ecx,%ecx
  80088f:	b8 00 00 00 00       	mov    $0x0,%eax
  800894:	0f 49 c1             	cmovns %ecx,%eax
  800897:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089a:	89 de                	mov    %ebx,%esi
  80089c:	eb 9d                	jmp    80083b <vprintfmt+0x6d>
  80089e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8008a0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8008a7:	eb 92                	jmp    80083b <vprintfmt+0x6d>
  8008a9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8008ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008b0:	79 89                	jns    80083b <vprintfmt+0x6d>
  8008b2:	e9 77 ff ff ff       	jmp    80082e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008b7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008ba:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8008bc:	e9 7a ff ff ff       	jmp    80083b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	8d 50 04             	lea    0x4(%eax),%edx
  8008c7:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ce:	8b 00                	mov    (%eax),%eax
  8008d0:	89 04 24             	mov    %eax,(%esp)
  8008d3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008d6:	e9 18 ff ff ff       	jmp    8007f3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008db:	8b 45 14             	mov    0x14(%ebp),%eax
  8008de:	8d 50 04             	lea    0x4(%eax),%edx
  8008e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e4:	8b 00                	mov    (%eax),%eax
  8008e6:	99                   	cltd   
  8008e7:	31 d0                	xor    %edx,%eax
  8008e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8008eb:	83 f8 0f             	cmp    $0xf,%eax
  8008ee:	7f 0b                	jg     8008fb <vprintfmt+0x12d>
  8008f0:	8b 14 85 80 2e 80 00 	mov    0x802e80(,%eax,4),%edx
  8008f7:	85 d2                	test   %edx,%edx
  8008f9:	75 20                	jne    80091b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8008fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ff:	c7 44 24 08 fd 2b 80 	movl   $0x802bfd,0x8(%esp)
  800906:	00 
  800907:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 04 24             	mov    %eax,(%esp)
  800911:	e8 90 fe ff ff       	call   8007a6 <printfmt>
  800916:	e9 d8 fe ff ff       	jmp    8007f3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80091b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80091f:	c7 44 24 08 b5 2f 80 	movl   $0x802fb5,0x8(%esp)
  800926:	00 
  800927:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	89 04 24             	mov    %eax,(%esp)
  800931:	e8 70 fe ff ff       	call   8007a6 <printfmt>
  800936:	e9 b8 fe ff ff       	jmp    8007f3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80093b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80093e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800941:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800944:	8b 45 14             	mov    0x14(%ebp),%eax
  800947:	8d 50 04             	lea    0x4(%eax),%edx
  80094a:	89 55 14             	mov    %edx,0x14(%ebp)
  80094d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80094f:	85 f6                	test   %esi,%esi
  800951:	b8 f6 2b 80 00       	mov    $0x802bf6,%eax
  800956:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800959:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80095d:	0f 84 97 00 00 00    	je     8009fa <vprintfmt+0x22c>
  800963:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800967:	0f 8e 9b 00 00 00    	jle    800a08 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80096d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800971:	89 34 24             	mov    %esi,(%esp)
  800974:	e8 cf 02 00 00       	call   800c48 <strnlen>
  800979:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80097c:	29 c2                	sub    %eax,%edx
  80097e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800981:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800985:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800988:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80098b:	8b 75 08             	mov    0x8(%ebp),%esi
  80098e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800991:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800993:	eb 0f                	jmp    8009a4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800995:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800999:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80099c:	89 04 24             	mov    %eax,(%esp)
  80099f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009a1:	83 eb 01             	sub    $0x1,%ebx
  8009a4:	85 db                	test   %ebx,%ebx
  8009a6:	7f ed                	jg     800995 <vprintfmt+0x1c7>
  8009a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8009ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8009ae:	85 d2                	test   %edx,%edx
  8009b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b5:	0f 49 c2             	cmovns %edx,%eax
  8009b8:	29 c2                	sub    %eax,%edx
  8009ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009bd:	89 d7                	mov    %edx,%edi
  8009bf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009c2:	eb 50                	jmp    800a14 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8009c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009c8:	74 1e                	je     8009e8 <vprintfmt+0x21a>
  8009ca:	0f be d2             	movsbl %dl,%edx
  8009cd:	83 ea 20             	sub    $0x20,%edx
  8009d0:	83 fa 5e             	cmp    $0x5e,%edx
  8009d3:	76 13                	jbe    8009e8 <vprintfmt+0x21a>
					putch('?', putdat);
  8009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009dc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8009e3:	ff 55 08             	call   *0x8(%ebp)
  8009e6:	eb 0d                	jmp    8009f5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8009e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ef:	89 04 24             	mov    %eax,(%esp)
  8009f2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009f5:	83 ef 01             	sub    $0x1,%edi
  8009f8:	eb 1a                	jmp    800a14 <vprintfmt+0x246>
  8009fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8009fd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a00:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a03:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a06:	eb 0c                	jmp    800a14 <vprintfmt+0x246>
  800a08:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a0b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a0e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a11:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a14:	83 c6 01             	add    $0x1,%esi
  800a17:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800a1b:	0f be c2             	movsbl %dl,%eax
  800a1e:	85 c0                	test   %eax,%eax
  800a20:	74 27                	je     800a49 <vprintfmt+0x27b>
  800a22:	85 db                	test   %ebx,%ebx
  800a24:	78 9e                	js     8009c4 <vprintfmt+0x1f6>
  800a26:	83 eb 01             	sub    $0x1,%ebx
  800a29:	79 99                	jns    8009c4 <vprintfmt+0x1f6>
  800a2b:	89 f8                	mov    %edi,%eax
  800a2d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a30:	8b 75 08             	mov    0x8(%ebp),%esi
  800a33:	89 c3                	mov    %eax,%ebx
  800a35:	eb 1a                	jmp    800a51 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a3b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800a42:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	83 eb 01             	sub    $0x1,%ebx
  800a47:	eb 08                	jmp    800a51 <vprintfmt+0x283>
  800a49:	89 fb                	mov    %edi,%ebx
  800a4b:	8b 75 08             	mov    0x8(%ebp),%esi
  800a4e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a51:	85 db                	test   %ebx,%ebx
  800a53:	7f e2                	jg     800a37 <vprintfmt+0x269>
  800a55:	89 75 08             	mov    %esi,0x8(%ebp)
  800a58:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a5b:	e9 93 fd ff ff       	jmp    8007f3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800a60:	83 fa 01             	cmp    $0x1,%edx
  800a63:	7e 16                	jle    800a7b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800a65:	8b 45 14             	mov    0x14(%ebp),%eax
  800a68:	8d 50 08             	lea    0x8(%eax),%edx
  800a6b:	89 55 14             	mov    %edx,0x14(%ebp)
  800a6e:	8b 50 04             	mov    0x4(%eax),%edx
  800a71:	8b 00                	mov    (%eax),%eax
  800a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a76:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a79:	eb 32                	jmp    800aad <vprintfmt+0x2df>
	else if (lflag)
  800a7b:	85 d2                	test   %edx,%edx
  800a7d:	74 18                	je     800a97 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	8d 50 04             	lea    0x4(%eax),%edx
  800a85:	89 55 14             	mov    %edx,0x14(%ebp)
  800a88:	8b 30                	mov    (%eax),%esi
  800a8a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800a8d:	89 f0                	mov    %esi,%eax
  800a8f:	c1 f8 1f             	sar    $0x1f,%eax
  800a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a95:	eb 16                	jmp    800aad <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	8d 50 04             	lea    0x4(%eax),%edx
  800a9d:	89 55 14             	mov    %edx,0x14(%ebp)
  800aa0:	8b 30                	mov    (%eax),%esi
  800aa2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800aa5:	89 f0                	mov    %esi,%eax
  800aa7:	c1 f8 1f             	sar    $0x1f,%eax
  800aaa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800ab3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800ab8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800abc:	0f 89 80 00 00 00    	jns    800b42 <vprintfmt+0x374>
				putch('-', putdat);
  800ac2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ac6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800acd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ad6:	f7 d8                	neg    %eax
  800ad8:	83 d2 00             	adc    $0x0,%edx
  800adb:	f7 da                	neg    %edx
			}
			base = 10;
  800add:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ae2:	eb 5e                	jmp    800b42 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ae4:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae7:	e8 63 fc ff ff       	call   80074f <getuint>
			base = 10;
  800aec:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800af1:	eb 4f                	jmp    800b42 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800af3:	8d 45 14             	lea    0x14(%ebp),%eax
  800af6:	e8 54 fc ff ff       	call   80074f <getuint>
			base =8;
  800afb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800b00:	eb 40                	jmp    800b42 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800b02:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b06:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b0d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b10:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b14:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b1b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	8d 50 04             	lea    0x4(%eax),%edx
  800b24:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b27:	8b 00                	mov    (%eax),%eax
  800b29:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b2e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b33:	eb 0d                	jmp    800b42 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b35:	8d 45 14             	lea    0x14(%ebp),%eax
  800b38:	e8 12 fc ff ff       	call   80074f <getuint>
			base = 16;
  800b3d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b42:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800b46:	89 74 24 10          	mov    %esi,0x10(%esp)
  800b4a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800b4d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800b55:	89 04 24             	mov    %eax,(%esp)
  800b58:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b5c:	89 fa                	mov    %edi,%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	e8 fa fa ff ff       	call   800660 <printnum>
			break;
  800b66:	e9 88 fc ff ff       	jmp    8007f3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b6b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b6f:	89 04 24             	mov    %eax,(%esp)
  800b72:	ff 55 08             	call   *0x8(%ebp)
			break;
  800b75:	e9 79 fc ff ff       	jmp    8007f3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b7a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b7e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800b85:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b88:	89 f3                	mov    %esi,%ebx
  800b8a:	eb 03                	jmp    800b8f <vprintfmt+0x3c1>
  800b8c:	83 eb 01             	sub    $0x1,%ebx
  800b8f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800b93:	75 f7                	jne    800b8c <vprintfmt+0x3be>
  800b95:	e9 59 fc ff ff       	jmp    8007f3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800b9a:	83 c4 3c             	add    $0x3c,%esp
  800b9d:	5b                   	pop    %ebx
  800b9e:	5e                   	pop    %esi
  800b9f:	5f                   	pop    %edi
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 28             	sub    $0x28,%esp
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bb1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800bb5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800bb8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbf:	85 c0                	test   %eax,%eax
  800bc1:	74 30                	je     800bf3 <vsnprintf+0x51>
  800bc3:	85 d2                	test   %edx,%edx
  800bc5:	7e 2c                	jle    800bf3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  800bca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bce:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bd5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bdc:	c7 04 24 89 07 80 00 	movl   $0x800789,(%esp)
  800be3:	e8 e6 fb ff ff       	call   8007ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bf1:	eb 05                	jmp    800bf8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800bf3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800bf8:	c9                   	leave  
  800bf9:	c3                   	ret    

00800bfa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bfa:	55                   	push   %ebp
  800bfb:	89 e5                	mov    %esp,%ebp
  800bfd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c00:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c07:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	89 04 24             	mov    %eax,(%esp)
  800c1b:	e8 82 ff ff ff       	call   800ba2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    
  800c22:	66 90                	xchg   %ax,%ax
  800c24:	66 90                	xchg   %ax,%ax
  800c26:	66 90                	xchg   %ax,%ax
  800c28:	66 90                	xchg   %ax,%ax
  800c2a:	66 90                	xchg   %ax,%ax
  800c2c:	66 90                	xchg   %ax,%ax
  800c2e:	66 90                	xchg   %ax,%ax

00800c30 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c36:	b8 00 00 00 00       	mov    $0x0,%eax
  800c3b:	eb 03                	jmp    800c40 <strlen+0x10>
		n++;
  800c3d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c40:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c44:	75 f7                	jne    800c3d <strlen+0xd>
		n++;
	return n;
}
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	eb 03                	jmp    800c5b <strnlen+0x13>
		n++;
  800c58:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5b:	39 d0                	cmp    %edx,%eax
  800c5d:	74 06                	je     800c65 <strnlen+0x1d>
  800c5f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c63:	75 f3                	jne    800c58 <strnlen+0x10>
		n++;
	return n;
}
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    

00800c67 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	53                   	push   %ebx
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c71:	89 c2                	mov    %eax,%edx
  800c73:	83 c2 01             	add    $0x1,%edx
  800c76:	83 c1 01             	add    $0x1,%ecx
  800c79:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800c7d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c80:	84 db                	test   %bl,%bl
  800c82:	75 ef                	jne    800c73 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c84:	5b                   	pop    %ebx
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	53                   	push   %ebx
  800c8b:	83 ec 08             	sub    $0x8,%esp
  800c8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c91:	89 1c 24             	mov    %ebx,(%esp)
  800c94:	e8 97 ff ff ff       	call   800c30 <strlen>
	strcpy(dst + len, src);
  800c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ca0:	01 d8                	add    %ebx,%eax
  800ca2:	89 04 24             	mov    %eax,(%esp)
  800ca5:	e8 bd ff ff ff       	call   800c67 <strcpy>
	return dst;
}
  800caa:	89 d8                	mov    %ebx,%eax
  800cac:	83 c4 08             	add    $0x8,%esp
  800caf:	5b                   	pop    %ebx
  800cb0:	5d                   	pop    %ebp
  800cb1:	c3                   	ret    

00800cb2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800cb2:	55                   	push   %ebp
  800cb3:	89 e5                	mov    %esp,%ebp
  800cb5:	56                   	push   %esi
  800cb6:	53                   	push   %ebx
  800cb7:	8b 75 08             	mov    0x8(%ebp),%esi
  800cba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cbd:	89 f3                	mov    %esi,%ebx
  800cbf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cc2:	89 f2                	mov    %esi,%edx
  800cc4:	eb 0f                	jmp    800cd5 <strncpy+0x23>
		*dst++ = *src;
  800cc6:	83 c2 01             	add    $0x1,%edx
  800cc9:	0f b6 01             	movzbl (%ecx),%eax
  800ccc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ccf:	80 39 01             	cmpb   $0x1,(%ecx)
  800cd2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cd5:	39 da                	cmp    %ebx,%edx
  800cd7:	75 ed                	jne    800cc6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800cd9:	89 f0                	mov    %esi,%eax
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
  800ce4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ced:	89 f0                	mov    %esi,%eax
  800cef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800cf3:	85 c9                	test   %ecx,%ecx
  800cf5:	75 0b                	jne    800d02 <strlcpy+0x23>
  800cf7:	eb 1d                	jmp    800d16 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800cf9:	83 c0 01             	add    $0x1,%eax
  800cfc:	83 c2 01             	add    $0x1,%edx
  800cff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d02:	39 d8                	cmp    %ebx,%eax
  800d04:	74 0b                	je     800d11 <strlcpy+0x32>
  800d06:	0f b6 0a             	movzbl (%edx),%ecx
  800d09:	84 c9                	test   %cl,%cl
  800d0b:	75 ec                	jne    800cf9 <strlcpy+0x1a>
  800d0d:	89 c2                	mov    %eax,%edx
  800d0f:	eb 02                	jmp    800d13 <strlcpy+0x34>
  800d11:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d13:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d16:	29 f0                	sub    %esi,%eax
}
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d22:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d25:	eb 06                	jmp    800d2d <strcmp+0x11>
		p++, q++;
  800d27:	83 c1 01             	add    $0x1,%ecx
  800d2a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d2d:	0f b6 01             	movzbl (%ecx),%eax
  800d30:	84 c0                	test   %al,%al
  800d32:	74 04                	je     800d38 <strcmp+0x1c>
  800d34:	3a 02                	cmp    (%edx),%al
  800d36:	74 ef                	je     800d27 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d38:	0f b6 c0             	movzbl %al,%eax
  800d3b:	0f b6 12             	movzbl (%edx),%edx
  800d3e:	29 d0                	sub    %edx,%eax
}
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	53                   	push   %ebx
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4c:	89 c3                	mov    %eax,%ebx
  800d4e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800d51:	eb 06                	jmp    800d59 <strncmp+0x17>
		n--, p++, q++;
  800d53:	83 c0 01             	add    $0x1,%eax
  800d56:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800d59:	39 d8                	cmp    %ebx,%eax
  800d5b:	74 15                	je     800d72 <strncmp+0x30>
  800d5d:	0f b6 08             	movzbl (%eax),%ecx
  800d60:	84 c9                	test   %cl,%cl
  800d62:	74 04                	je     800d68 <strncmp+0x26>
  800d64:	3a 0a                	cmp    (%edx),%cl
  800d66:	74 eb                	je     800d53 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	0f b6 00             	movzbl (%eax),%eax
  800d6b:	0f b6 12             	movzbl (%edx),%edx
  800d6e:	29 d0                	sub    %edx,%eax
  800d70:	eb 05                	jmp    800d77 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800d72:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d77:	5b                   	pop    %ebx
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d84:	eb 07                	jmp    800d8d <strchr+0x13>
		if (*s == c)
  800d86:	38 ca                	cmp    %cl,%dl
  800d88:	74 0f                	je     800d99 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d8a:	83 c0 01             	add    $0x1,%eax
  800d8d:	0f b6 10             	movzbl (%eax),%edx
  800d90:	84 d2                	test   %dl,%dl
  800d92:	75 f2                	jne    800d86 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800da5:	eb 07                	jmp    800dae <strfind+0x13>
		if (*s == c)
  800da7:	38 ca                	cmp    %cl,%dl
  800da9:	74 0a                	je     800db5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dab:	83 c0 01             	add    $0x1,%eax
  800dae:	0f b6 10             	movzbl (%eax),%edx
  800db1:	84 d2                	test   %dl,%dl
  800db3:	75 f2                	jne    800da7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dc0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800dc3:	85 c9                	test   %ecx,%ecx
  800dc5:	74 36                	je     800dfd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800dc7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dcd:	75 28                	jne    800df7 <memset+0x40>
  800dcf:	f6 c1 03             	test   $0x3,%cl
  800dd2:	75 23                	jne    800df7 <memset+0x40>
		c &= 0xFF;
  800dd4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800dd8:	89 d3                	mov    %edx,%ebx
  800dda:	c1 e3 08             	shl    $0x8,%ebx
  800ddd:	89 d6                	mov    %edx,%esi
  800ddf:	c1 e6 18             	shl    $0x18,%esi
  800de2:	89 d0                	mov    %edx,%eax
  800de4:	c1 e0 10             	shl    $0x10,%eax
  800de7:	09 f0                	or     %esi,%eax
  800de9:	09 c2                	or     %eax,%edx
  800deb:	89 d0                	mov    %edx,%eax
  800ded:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800def:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800df2:	fc                   	cld    
  800df3:	f3 ab                	rep stos %eax,%es:(%edi)
  800df5:	eb 06                	jmp    800dfd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfa:	fc                   	cld    
  800dfb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800dfd:	89 f8                	mov    %edi,%eax
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e12:	39 c6                	cmp    %eax,%esi
  800e14:	73 35                	jae    800e4b <memmove+0x47>
  800e16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e19:	39 d0                	cmp    %edx,%eax
  800e1b:	73 2e                	jae    800e4b <memmove+0x47>
		s += n;
		d += n;
  800e1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e20:	89 d6                	mov    %edx,%esi
  800e22:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e2a:	75 13                	jne    800e3f <memmove+0x3b>
  800e2c:	f6 c1 03             	test   $0x3,%cl
  800e2f:	75 0e                	jne    800e3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e31:	83 ef 04             	sub    $0x4,%edi
  800e34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e37:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e3a:	fd                   	std    
  800e3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e3d:	eb 09                	jmp    800e48 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e3f:	83 ef 01             	sub    $0x1,%edi
  800e42:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e45:	fd                   	std    
  800e46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e48:	fc                   	cld    
  800e49:	eb 1d                	jmp    800e68 <memmove+0x64>
  800e4b:	89 f2                	mov    %esi,%edx
  800e4d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e4f:	f6 c2 03             	test   $0x3,%dl
  800e52:	75 0f                	jne    800e63 <memmove+0x5f>
  800e54:	f6 c1 03             	test   $0x3,%cl
  800e57:	75 0a                	jne    800e63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800e59:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800e5c:	89 c7                	mov    %eax,%edi
  800e5e:	fc                   	cld    
  800e5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e61:	eb 05                	jmp    800e68 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e63:	89 c7                	mov    %eax,%edi
  800e65:	fc                   	cld    
  800e66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
  800e75:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	89 04 24             	mov    %eax,(%esp)
  800e86:	e8 79 ff ff ff       	call   800e04 <memmove>
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e98:	89 d6                	mov    %edx,%esi
  800e9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e9d:	eb 1a                	jmp    800eb9 <memcmp+0x2c>
		if (*s1 != *s2)
  800e9f:	0f b6 02             	movzbl (%edx),%eax
  800ea2:	0f b6 19             	movzbl (%ecx),%ebx
  800ea5:	38 d8                	cmp    %bl,%al
  800ea7:	74 0a                	je     800eb3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ea9:	0f b6 c0             	movzbl %al,%eax
  800eac:	0f b6 db             	movzbl %bl,%ebx
  800eaf:	29 d8                	sub    %ebx,%eax
  800eb1:	eb 0f                	jmp    800ec2 <memcmp+0x35>
		s1++, s2++;
  800eb3:	83 c2 01             	add    $0x1,%edx
  800eb6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800eb9:	39 f2                	cmp    %esi,%edx
  800ebb:	75 e2                	jne    800e9f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec2:	5b                   	pop    %ebx
  800ec3:	5e                   	pop    %esi
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    

00800ec6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ecf:	89 c2                	mov    %eax,%edx
  800ed1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ed4:	eb 07                	jmp    800edd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ed6:	38 08                	cmp    %cl,(%eax)
  800ed8:	74 07                	je     800ee1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eda:	83 c0 01             	add    $0x1,%eax
  800edd:	39 d0                	cmp    %edx,%eax
  800edf:	72 f5                	jb     800ed6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eef:	eb 03                	jmp    800ef4 <strtol+0x11>
		s++;
  800ef1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef4:	0f b6 0a             	movzbl (%edx),%ecx
  800ef7:	80 f9 09             	cmp    $0x9,%cl
  800efa:	74 f5                	je     800ef1 <strtol+0xe>
  800efc:	80 f9 20             	cmp    $0x20,%cl
  800eff:	74 f0                	je     800ef1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f01:	80 f9 2b             	cmp    $0x2b,%cl
  800f04:	75 0a                	jne    800f10 <strtol+0x2d>
		s++;
  800f06:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f09:	bf 00 00 00 00       	mov    $0x0,%edi
  800f0e:	eb 11                	jmp    800f21 <strtol+0x3e>
  800f10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f15:	80 f9 2d             	cmp    $0x2d,%cl
  800f18:	75 07                	jne    800f21 <strtol+0x3e>
		s++, neg = 1;
  800f1a:	8d 52 01             	lea    0x1(%edx),%edx
  800f1d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f21:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f26:	75 15                	jne    800f3d <strtol+0x5a>
  800f28:	80 3a 30             	cmpb   $0x30,(%edx)
  800f2b:	75 10                	jne    800f3d <strtol+0x5a>
  800f2d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f31:	75 0a                	jne    800f3d <strtol+0x5a>
		s += 2, base = 16;
  800f33:	83 c2 02             	add    $0x2,%edx
  800f36:	b8 10 00 00 00       	mov    $0x10,%eax
  800f3b:	eb 10                	jmp    800f4d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	75 0c                	jne    800f4d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f41:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f43:	80 3a 30             	cmpb   $0x30,(%edx)
  800f46:	75 05                	jne    800f4d <strtol+0x6a>
		s++, base = 8;
  800f48:	83 c2 01             	add    $0x1,%edx
  800f4b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800f4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f52:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f55:	0f b6 0a             	movzbl (%edx),%ecx
  800f58:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800f5b:	89 f0                	mov    %esi,%eax
  800f5d:	3c 09                	cmp    $0x9,%al
  800f5f:	77 08                	ja     800f69 <strtol+0x86>
			dig = *s - '0';
  800f61:	0f be c9             	movsbl %cl,%ecx
  800f64:	83 e9 30             	sub    $0x30,%ecx
  800f67:	eb 20                	jmp    800f89 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800f69:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800f6c:	89 f0                	mov    %esi,%eax
  800f6e:	3c 19                	cmp    $0x19,%al
  800f70:	77 08                	ja     800f7a <strtol+0x97>
			dig = *s - 'a' + 10;
  800f72:	0f be c9             	movsbl %cl,%ecx
  800f75:	83 e9 57             	sub    $0x57,%ecx
  800f78:	eb 0f                	jmp    800f89 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800f7a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800f7d:	89 f0                	mov    %esi,%eax
  800f7f:	3c 19                	cmp    $0x19,%al
  800f81:	77 16                	ja     800f99 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800f83:	0f be c9             	movsbl %cl,%ecx
  800f86:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f89:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800f8c:	7d 0f                	jge    800f9d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800f8e:	83 c2 01             	add    $0x1,%edx
  800f91:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800f95:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800f97:	eb bc                	jmp    800f55 <strtol+0x72>
  800f99:	89 d8                	mov    %ebx,%eax
  800f9b:	eb 02                	jmp    800f9f <strtol+0xbc>
  800f9d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800f9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fa3:	74 05                	je     800faa <strtol+0xc7>
		*endptr = (char *) s;
  800fa5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fa8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800faa:	f7 d8                	neg    %eax
  800fac:	85 ff                	test   %edi,%edi
  800fae:	0f 44 c3             	cmove  %ebx,%eax
}
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc7:	89 c3                	mov    %eax,%ebx
  800fc9:	89 c7                	mov    %eax,%edi
  800fcb:	89 c6                	mov    %eax,%esi
  800fcd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fcf:	5b                   	pop    %ebx
  800fd0:	5e                   	pop    %esi
  800fd1:	5f                   	pop    %edi
  800fd2:	5d                   	pop    %ebp
  800fd3:	c3                   	ret    

00800fd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fda:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdf:	b8 01 00 00 00       	mov    $0x1,%eax
  800fe4:	89 d1                	mov    %edx,%ecx
  800fe6:	89 d3                	mov    %edx,%ebx
  800fe8:	89 d7                	mov    %edx,%edi
  800fea:	89 d6                	mov    %edx,%esi
  800fec:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5f                   	pop    %edi
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    

00800ff3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	57                   	push   %edi
  800ff7:	56                   	push   %esi
  800ff8:	53                   	push   %ebx
  800ff9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801001:	b8 03 00 00 00       	mov    $0x3,%eax
  801006:	8b 55 08             	mov    0x8(%ebp),%edx
  801009:	89 cb                	mov    %ecx,%ebx
  80100b:	89 cf                	mov    %ecx,%edi
  80100d:	89 ce                	mov    %ecx,%esi
  80100f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801011:	85 c0                	test   %eax,%eax
  801013:	7e 28                	jle    80103d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801015:	89 44 24 10          	mov    %eax,0x10(%esp)
  801019:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801020:	00 
  801021:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  801028:	00 
  801029:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801030:	00 
  801031:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  801038:	e8 29 16 00 00       	call   802666 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80103d:	83 c4 2c             	add    $0x2c,%esp
  801040:	5b                   	pop    %ebx
  801041:	5e                   	pop    %esi
  801042:	5f                   	pop    %edi
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	57                   	push   %edi
  801049:	56                   	push   %esi
  80104a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104b:	ba 00 00 00 00       	mov    $0x0,%edx
  801050:	b8 02 00 00 00       	mov    $0x2,%eax
  801055:	89 d1                	mov    %edx,%ecx
  801057:	89 d3                	mov    %edx,%ebx
  801059:	89 d7                	mov    %edx,%edi
  80105b:	89 d6                	mov    %edx,%esi
  80105d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80105f:	5b                   	pop    %ebx
  801060:	5e                   	pop    %esi
  801061:	5f                   	pop    %edi
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    

00801064 <sys_yield>:

void
sys_yield(void)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	57                   	push   %edi
  801068:	56                   	push   %esi
  801069:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106a:	ba 00 00 00 00       	mov    $0x0,%edx
  80106f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801074:	89 d1                	mov    %edx,%ecx
  801076:	89 d3                	mov    %edx,%ebx
  801078:	89 d7                	mov    %edx,%edi
  80107a:	89 d6                	mov    %edx,%esi
  80107c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	57                   	push   %edi
  801087:	56                   	push   %esi
  801088:	53                   	push   %ebx
  801089:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108c:	be 00 00 00 00       	mov    $0x0,%esi
  801091:	b8 04 00 00 00       	mov    $0x4,%eax
  801096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80109f:	89 f7                	mov    %esi,%edi
  8010a1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	7e 28                	jle    8010cf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010b2:	00 
  8010b3:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  8010ba:	00 
  8010bb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c2:	00 
  8010c3:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  8010ca:	e8 97 15 00 00       	call   802666 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8010cf:	83 c4 2c             	add    $0x2c,%esp
  8010d2:	5b                   	pop    %ebx
  8010d3:	5e                   	pop    %esi
  8010d4:	5f                   	pop    %edi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	57                   	push   %edi
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
  8010dd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8010e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ee:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010f4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	7e 28                	jle    801122 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010fa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010fe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801105:	00 
  801106:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  80110d:	00 
  80110e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801115:	00 
  801116:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  80111d:	e8 44 15 00 00       	call   802666 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801122:	83 c4 2c             	add    $0x2c,%esp
  801125:	5b                   	pop    %ebx
  801126:	5e                   	pop    %esi
  801127:	5f                   	pop    %edi
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	57                   	push   %edi
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801133:	bb 00 00 00 00       	mov    $0x0,%ebx
  801138:	b8 06 00 00 00       	mov    $0x6,%eax
  80113d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801140:	8b 55 08             	mov    0x8(%ebp),%edx
  801143:	89 df                	mov    %ebx,%edi
  801145:	89 de                	mov    %ebx,%esi
  801147:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801149:	85 c0                	test   %eax,%eax
  80114b:	7e 28                	jle    801175 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80114d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801151:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801158:	00 
  801159:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  801160:	00 
  801161:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801168:	00 
  801169:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  801170:	e8 f1 14 00 00       	call   802666 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801175:	83 c4 2c             	add    $0x2c,%esp
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	57                   	push   %edi
  801181:	56                   	push   %esi
  801182:	53                   	push   %ebx
  801183:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801186:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118b:	b8 08 00 00 00       	mov    $0x8,%eax
  801190:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801193:	8b 55 08             	mov    0x8(%ebp),%edx
  801196:	89 df                	mov    %ebx,%edi
  801198:	89 de                	mov    %ebx,%esi
  80119a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80119c:	85 c0                	test   %eax,%eax
  80119e:	7e 28                	jle    8011c8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8011ab:	00 
  8011ac:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  8011b3:	00 
  8011b4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011bb:	00 
  8011bc:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  8011c3:	e8 9e 14 00 00       	call   802666 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011c8:	83 c4 2c             	add    $0x2c,%esp
  8011cb:	5b                   	pop    %ebx
  8011cc:	5e                   	pop    %esi
  8011cd:	5f                   	pop    %edi
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011de:	b8 09 00 00 00       	mov    $0x9,%eax
  8011e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	89 df                	mov    %ebx,%edi
  8011eb:	89 de                	mov    %ebx,%esi
  8011ed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	7e 28                	jle    80121b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011fe:	00 
  8011ff:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  801206:	00 
  801207:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80120e:	00 
  80120f:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  801216:	e8 4b 14 00 00       	call   802666 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80121b:	83 c4 2c             	add    $0x2c,%esp
  80121e:	5b                   	pop    %ebx
  80121f:	5e                   	pop    %esi
  801220:	5f                   	pop    %edi
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	57                   	push   %edi
  801227:	56                   	push   %esi
  801228:	53                   	push   %ebx
  801229:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80122c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801231:	b8 0a 00 00 00       	mov    $0xa,%eax
  801236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801239:	8b 55 08             	mov    0x8(%ebp),%edx
  80123c:	89 df                	mov    %ebx,%edi
  80123e:	89 de                	mov    %ebx,%esi
  801240:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801242:	85 c0                	test   %eax,%eax
  801244:	7e 28                	jle    80126e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801246:	89 44 24 10          	mov    %eax,0x10(%esp)
  80124a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801251:	00 
  801252:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  801259:	00 
  80125a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801261:	00 
  801262:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  801269:	e8 f8 13 00 00       	call   802666 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80126e:	83 c4 2c             	add    $0x2c,%esp
  801271:	5b                   	pop    %ebx
  801272:	5e                   	pop    %esi
  801273:	5f                   	pop    %edi
  801274:	5d                   	pop    %ebp
  801275:	c3                   	ret    

00801276 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801276:	55                   	push   %ebp
  801277:	89 e5                	mov    %esp,%ebp
  801279:	57                   	push   %edi
  80127a:	56                   	push   %esi
  80127b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80127c:	be 00 00 00 00       	mov    $0x0,%esi
  801281:	b8 0c 00 00 00       	mov    $0xc,%eax
  801286:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801289:	8b 55 08             	mov    0x8(%ebp),%edx
  80128c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80128f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801292:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801294:	5b                   	pop    %ebx
  801295:	5e                   	pop    %esi
  801296:	5f                   	pop    %edi
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    

00801299 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	57                   	push   %edi
  80129d:	56                   	push   %esi
  80129e:	53                   	push   %ebx
  80129f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012a7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8012af:	89 cb                	mov    %ecx,%ebx
  8012b1:	89 cf                	mov    %ecx,%edi
  8012b3:	89 ce                	mov    %ecx,%esi
  8012b5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	7e 28                	jle    8012e3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012bb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012bf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8012c6:	00 
  8012c7:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  8012ce:	00 
  8012cf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012d6:	00 
  8012d7:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  8012de:	e8 83 13 00 00       	call   802666 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012e3:	83 c4 2c             	add    $0x2c,%esp
  8012e6:	5b                   	pop    %ebx
  8012e7:	5e                   	pop    %esi
  8012e8:	5f                   	pop    %edi
  8012e9:	5d                   	pop    %ebp
  8012ea:	c3                   	ret    

008012eb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	57                   	push   %edi
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8012f6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012fb:	89 d1                	mov    %edx,%ecx
  8012fd:	89 d3                	mov    %edx,%ebx
  8012ff:	89 d7                	mov    %edx,%edi
  801301:	89 d6                	mov    %edx,%esi
  801303:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801305:	5b                   	pop    %ebx
  801306:	5e                   	pop    %esi
  801307:	5f                   	pop    %edi
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    

0080130a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	57                   	push   %edi
  80130e:	56                   	push   %esi
  80130f:	53                   	push   %ebx
  801310:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801313:	bb 00 00 00 00       	mov    $0x0,%ebx
  801318:	b8 0f 00 00 00       	mov    $0xf,%eax
  80131d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801320:	8b 55 08             	mov    0x8(%ebp),%edx
  801323:	89 df                	mov    %ebx,%edi
  801325:	89 de                	mov    %ebx,%esi
  801327:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801329:	85 c0                	test   %eax,%eax
  80132b:	7e 28                	jle    801355 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80132d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801331:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801338:	00 
  801339:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  801340:	00 
  801341:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801348:	00 
  801349:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  801350:	e8 11 13 00 00       	call   802666 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801355:	83 c4 2c             	add    $0x2c,%esp
  801358:	5b                   	pop    %ebx
  801359:	5e                   	pop    %esi
  80135a:	5f                   	pop    %edi
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	57                   	push   %edi
  801361:	56                   	push   %esi
  801362:	53                   	push   %ebx
  801363:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801366:	bb 00 00 00 00       	mov    $0x0,%ebx
  80136b:	b8 10 00 00 00       	mov    $0x10,%eax
  801370:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801373:	8b 55 08             	mov    0x8(%ebp),%edx
  801376:	89 df                	mov    %ebx,%edi
  801378:	89 de                	mov    %ebx,%esi
  80137a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80137c:	85 c0                	test   %eax,%eax
  80137e:	7e 28                	jle    8013a8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801380:	89 44 24 10          	mov    %eax,0x10(%esp)
  801384:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80138b:	00 
  80138c:	c7 44 24 08 df 2e 80 	movl   $0x802edf,0x8(%esp)
  801393:	00 
  801394:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80139b:	00 
  80139c:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  8013a3:	e8 be 12 00 00       	call   802666 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8013a8:	83 c4 2c             	add    $0x2c,%esp
  8013ab:	5b                   	pop    %ebx
  8013ac:	5e                   	pop    %esi
  8013ad:	5f                   	pop    %edi
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    

008013b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8013be:	5d                   	pop    %ebp
  8013bf:	c3                   	ret    

008013c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013d5:	5d                   	pop    %ebp
  8013d6:	c3                   	ret    

008013d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013dd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013e2:	89 c2                	mov    %eax,%edx
  8013e4:	c1 ea 16             	shr    $0x16,%edx
  8013e7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ee:	f6 c2 01             	test   $0x1,%dl
  8013f1:	74 11                	je     801404 <fd_alloc+0x2d>
  8013f3:	89 c2                	mov    %eax,%edx
  8013f5:	c1 ea 0c             	shr    $0xc,%edx
  8013f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013ff:	f6 c2 01             	test   $0x1,%dl
  801402:	75 09                	jne    80140d <fd_alloc+0x36>
			*fd_store = fd;
  801404:	89 01                	mov    %eax,(%ecx)
			return 0;
  801406:	b8 00 00 00 00       	mov    $0x0,%eax
  80140b:	eb 17                	jmp    801424 <fd_alloc+0x4d>
  80140d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801412:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801417:	75 c9                	jne    8013e2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801419:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80141f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801424:	5d                   	pop    %ebp
  801425:	c3                   	ret    

00801426 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80142c:	83 f8 1f             	cmp    $0x1f,%eax
  80142f:	77 36                	ja     801467 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801431:	c1 e0 0c             	shl    $0xc,%eax
  801434:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801439:	89 c2                	mov    %eax,%edx
  80143b:	c1 ea 16             	shr    $0x16,%edx
  80143e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801445:	f6 c2 01             	test   $0x1,%dl
  801448:	74 24                	je     80146e <fd_lookup+0x48>
  80144a:	89 c2                	mov    %eax,%edx
  80144c:	c1 ea 0c             	shr    $0xc,%edx
  80144f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801456:	f6 c2 01             	test   $0x1,%dl
  801459:	74 1a                	je     801475 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80145b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145e:	89 02                	mov    %eax,(%edx)
	return 0;
  801460:	b8 00 00 00 00       	mov    $0x0,%eax
  801465:	eb 13                	jmp    80147a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801467:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146c:	eb 0c                	jmp    80147a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80146e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801473:	eb 05                	jmp    80147a <fd_lookup+0x54>
  801475:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 18             	sub    $0x18,%esp
  801482:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801485:	ba 00 00 00 00       	mov    $0x0,%edx
  80148a:	eb 13                	jmp    80149f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80148c:	39 08                	cmp    %ecx,(%eax)
  80148e:	75 0c                	jne    80149c <dev_lookup+0x20>
			*dev = devtab[i];
  801490:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801493:	89 01                	mov    %eax,(%ecx)
			return 0;
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
  80149a:	eb 38                	jmp    8014d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80149c:	83 c2 01             	add    $0x1,%edx
  80149f:	8b 04 95 88 2f 80 00 	mov    0x802f88(,%edx,4),%eax
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	75 e2                	jne    80148c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014aa:	a1 18 50 80 00       	mov    0x805018,%eax
  8014af:	8b 40 48             	mov    0x48(%eax),%eax
  8014b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ba:	c7 04 24 0c 2f 80 00 	movl   $0x802f0c,(%esp)
  8014c1:	e8 75 f1 ff ff       	call   80063b <cprintf>
	*dev = 0;
  8014c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	56                   	push   %esi
  8014da:	53                   	push   %ebx
  8014db:	83 ec 20             	sub    $0x20,%esp
  8014de:	8b 75 08             	mov    0x8(%ebp),%esi
  8014e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014f1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014f4:	89 04 24             	mov    %eax,(%esp)
  8014f7:	e8 2a ff ff ff       	call   801426 <fd_lookup>
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 05                	js     801505 <fd_close+0x2f>
	    || fd != fd2)
  801500:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801503:	74 0c                	je     801511 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801505:	84 db                	test   %bl,%bl
  801507:	ba 00 00 00 00       	mov    $0x0,%edx
  80150c:	0f 44 c2             	cmove  %edx,%eax
  80150f:	eb 3f                	jmp    801550 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801511:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801514:	89 44 24 04          	mov    %eax,0x4(%esp)
  801518:	8b 06                	mov    (%esi),%eax
  80151a:	89 04 24             	mov    %eax,(%esp)
  80151d:	e8 5a ff ff ff       	call   80147c <dev_lookup>
  801522:	89 c3                	mov    %eax,%ebx
  801524:	85 c0                	test   %eax,%eax
  801526:	78 16                	js     80153e <fd_close+0x68>
		if (dev->dev_close)
  801528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80152e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801533:	85 c0                	test   %eax,%eax
  801535:	74 07                	je     80153e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801537:	89 34 24             	mov    %esi,(%esp)
  80153a:	ff d0                	call   *%eax
  80153c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80153e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801542:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801549:	e8 dc fb ff ff       	call   80112a <sys_page_unmap>
	return r;
  80154e:	89 d8                	mov    %ebx,%eax
}
  801550:	83 c4 20             	add    $0x20,%esp
  801553:	5b                   	pop    %ebx
  801554:	5e                   	pop    %esi
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
  80155a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80155d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801560:	89 44 24 04          	mov    %eax,0x4(%esp)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	89 04 24             	mov    %eax,(%esp)
  80156a:	e8 b7 fe ff ff       	call   801426 <fd_lookup>
  80156f:	89 c2                	mov    %eax,%edx
  801571:	85 d2                	test   %edx,%edx
  801573:	78 13                	js     801588 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801575:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80157c:	00 
  80157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801580:	89 04 24             	mov    %eax,(%esp)
  801583:	e8 4e ff ff ff       	call   8014d6 <fd_close>
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <close_all>:

void
close_all(void)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	53                   	push   %ebx
  80158e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801591:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801596:	89 1c 24             	mov    %ebx,(%esp)
  801599:	e8 b9 ff ff ff       	call   801557 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80159e:	83 c3 01             	add    $0x1,%ebx
  8015a1:	83 fb 20             	cmp    $0x20,%ebx
  8015a4:	75 f0                	jne    801596 <close_all+0xc>
		close(i);
}
  8015a6:	83 c4 14             	add    $0x14,%esp
  8015a9:	5b                   	pop    %ebx
  8015aa:	5d                   	pop    %ebp
  8015ab:	c3                   	ret    

008015ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	57                   	push   %edi
  8015b0:	56                   	push   %esi
  8015b1:	53                   	push   %ebx
  8015b2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	89 04 24             	mov    %eax,(%esp)
  8015c2:	e8 5f fe ff ff       	call   801426 <fd_lookup>
  8015c7:	89 c2                	mov    %eax,%edx
  8015c9:	85 d2                	test   %edx,%edx
  8015cb:	0f 88 e1 00 00 00    	js     8016b2 <dup+0x106>
		return r;
	close(newfdnum);
  8015d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d4:	89 04 24             	mov    %eax,(%esp)
  8015d7:	e8 7b ff ff ff       	call   801557 <close>

	newfd = INDEX2FD(newfdnum);
  8015dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015df:	c1 e3 0c             	shl    $0xc,%ebx
  8015e2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015eb:	89 04 24             	mov    %eax,(%esp)
  8015ee:	e8 cd fd ff ff       	call   8013c0 <fd2data>
  8015f3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8015f5:	89 1c 24             	mov    %ebx,(%esp)
  8015f8:	e8 c3 fd ff ff       	call   8013c0 <fd2data>
  8015fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015ff:	89 f0                	mov    %esi,%eax
  801601:	c1 e8 16             	shr    $0x16,%eax
  801604:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80160b:	a8 01                	test   $0x1,%al
  80160d:	74 43                	je     801652 <dup+0xa6>
  80160f:	89 f0                	mov    %esi,%eax
  801611:	c1 e8 0c             	shr    $0xc,%eax
  801614:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80161b:	f6 c2 01             	test   $0x1,%dl
  80161e:	74 32                	je     801652 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801620:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801627:	25 07 0e 00 00       	and    $0xe07,%eax
  80162c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801630:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801634:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80163b:	00 
  80163c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801640:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801647:	e8 8b fa ff ff       	call   8010d7 <sys_page_map>
  80164c:	89 c6                	mov    %eax,%esi
  80164e:	85 c0                	test   %eax,%eax
  801650:	78 3e                	js     801690 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801655:	89 c2                	mov    %eax,%edx
  801657:	c1 ea 0c             	shr    $0xc,%edx
  80165a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801661:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801667:	89 54 24 10          	mov    %edx,0x10(%esp)
  80166b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80166f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801676:	00 
  801677:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801682:	e8 50 fa ff ff       	call   8010d7 <sys_page_map>
  801687:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801689:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80168c:	85 f6                	test   %esi,%esi
  80168e:	79 22                	jns    8016b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801690:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801694:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80169b:	e8 8a fa ff ff       	call   80112a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016ab:	e8 7a fa ff ff       	call   80112a <sys_page_unmap>
	return r;
  8016b0:	89 f0                	mov    %esi,%eax
}
  8016b2:	83 c4 3c             	add    $0x3c,%esp
  8016b5:	5b                   	pop    %ebx
  8016b6:	5e                   	pop    %esi
  8016b7:	5f                   	pop    %edi
  8016b8:	5d                   	pop    %ebp
  8016b9:	c3                   	ret    

008016ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	53                   	push   %ebx
  8016be:	83 ec 24             	sub    $0x24,%esp
  8016c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	89 1c 24             	mov    %ebx,(%esp)
  8016ce:	e8 53 fd ff ff       	call   801426 <fd_lookup>
  8016d3:	89 c2                	mov    %eax,%edx
  8016d5:	85 d2                	test   %edx,%edx
  8016d7:	78 6d                	js     801746 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e3:	8b 00                	mov    (%eax),%eax
  8016e5:	89 04 24             	mov    %eax,(%esp)
  8016e8:	e8 8f fd ff ff       	call   80147c <dev_lookup>
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 55                	js     801746 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f4:	8b 50 08             	mov    0x8(%eax),%edx
  8016f7:	83 e2 03             	and    $0x3,%edx
  8016fa:	83 fa 01             	cmp    $0x1,%edx
  8016fd:	75 23                	jne    801722 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016ff:	a1 18 50 80 00       	mov    0x805018,%eax
  801704:	8b 40 48             	mov    0x48(%eax),%eax
  801707:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80170b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170f:	c7 04 24 4d 2f 80 00 	movl   $0x802f4d,(%esp)
  801716:	e8 20 ef ff ff       	call   80063b <cprintf>
		return -E_INVAL;
  80171b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801720:	eb 24                	jmp    801746 <read+0x8c>
	}
	if (!dev->dev_read)
  801722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801725:	8b 52 08             	mov    0x8(%edx),%edx
  801728:	85 d2                	test   %edx,%edx
  80172a:	74 15                	je     801741 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80172c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80172f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801733:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801736:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80173a:	89 04 24             	mov    %eax,(%esp)
  80173d:	ff d2                	call   *%edx
  80173f:	eb 05                	jmp    801746 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801741:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801746:	83 c4 24             	add    $0x24,%esp
  801749:	5b                   	pop    %ebx
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    

0080174c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	57                   	push   %edi
  801750:	56                   	push   %esi
  801751:	53                   	push   %ebx
  801752:	83 ec 1c             	sub    $0x1c,%esp
  801755:	8b 7d 08             	mov    0x8(%ebp),%edi
  801758:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80175b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801760:	eb 23                	jmp    801785 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801762:	89 f0                	mov    %esi,%eax
  801764:	29 d8                	sub    %ebx,%eax
  801766:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176a:	89 d8                	mov    %ebx,%eax
  80176c:	03 45 0c             	add    0xc(%ebp),%eax
  80176f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801773:	89 3c 24             	mov    %edi,(%esp)
  801776:	e8 3f ff ff ff       	call   8016ba <read>
		if (m < 0)
  80177b:	85 c0                	test   %eax,%eax
  80177d:	78 10                	js     80178f <readn+0x43>
			return m;
		if (m == 0)
  80177f:	85 c0                	test   %eax,%eax
  801781:	74 0a                	je     80178d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801783:	01 c3                	add    %eax,%ebx
  801785:	39 f3                	cmp    %esi,%ebx
  801787:	72 d9                	jb     801762 <readn+0x16>
  801789:	89 d8                	mov    %ebx,%eax
  80178b:	eb 02                	jmp    80178f <readn+0x43>
  80178d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80178f:	83 c4 1c             	add    $0x1c,%esp
  801792:	5b                   	pop    %ebx
  801793:	5e                   	pop    %esi
  801794:	5f                   	pop    %edi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    

00801797 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	53                   	push   %ebx
  80179b:	83 ec 24             	sub    $0x24,%esp
  80179e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a8:	89 1c 24             	mov    %ebx,(%esp)
  8017ab:	e8 76 fc ff ff       	call   801426 <fd_lookup>
  8017b0:	89 c2                	mov    %eax,%edx
  8017b2:	85 d2                	test   %edx,%edx
  8017b4:	78 68                	js     80181e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c0:	8b 00                	mov    (%eax),%eax
  8017c2:	89 04 24             	mov    %eax,(%esp)
  8017c5:	e8 b2 fc ff ff       	call   80147c <dev_lookup>
  8017ca:	85 c0                	test   %eax,%eax
  8017cc:	78 50                	js     80181e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017d5:	75 23                	jne    8017fa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017d7:	a1 18 50 80 00       	mov    0x805018,%eax
  8017dc:	8b 40 48             	mov    0x48(%eax),%eax
  8017df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e7:	c7 04 24 69 2f 80 00 	movl   $0x802f69,(%esp)
  8017ee:	e8 48 ee ff ff       	call   80063b <cprintf>
		return -E_INVAL;
  8017f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f8:	eb 24                	jmp    80181e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fd:	8b 52 0c             	mov    0xc(%edx),%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	74 15                	je     801819 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801804:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801807:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80180b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80180e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801812:	89 04 24             	mov    %eax,(%esp)
  801815:	ff d2                	call   *%edx
  801817:	eb 05                	jmp    80181e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801819:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80181e:	83 c4 24             	add    $0x24,%esp
  801821:	5b                   	pop    %ebx
  801822:	5d                   	pop    %ebp
  801823:	c3                   	ret    

00801824 <seek>:

int
seek(int fdnum, off_t offset)
{
  801824:	55                   	push   %ebp
  801825:	89 e5                	mov    %esp,%ebp
  801827:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80182a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80182d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	89 04 24             	mov    %eax,(%esp)
  801837:	e8 ea fb ff ff       	call   801426 <fd_lookup>
  80183c:	85 c0                	test   %eax,%eax
  80183e:	78 0e                	js     80184e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801840:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	53                   	push   %ebx
  801854:	83 ec 24             	sub    $0x24,%esp
  801857:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80185d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801861:	89 1c 24             	mov    %ebx,(%esp)
  801864:	e8 bd fb ff ff       	call   801426 <fd_lookup>
  801869:	89 c2                	mov    %eax,%edx
  80186b:	85 d2                	test   %edx,%edx
  80186d:	78 61                	js     8018d0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80186f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801872:	89 44 24 04          	mov    %eax,0x4(%esp)
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	89 04 24             	mov    %eax,(%esp)
  80187e:	e8 f9 fb ff ff       	call   80147c <dev_lookup>
  801883:	85 c0                	test   %eax,%eax
  801885:	78 49                	js     8018d0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80188e:	75 23                	jne    8018b3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801890:	a1 18 50 80 00       	mov    0x805018,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801895:	8b 40 48             	mov    0x48(%eax),%eax
  801898:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80189c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a0:	c7 04 24 2c 2f 80 00 	movl   $0x802f2c,(%esp)
  8018a7:	e8 8f ed ff ff       	call   80063b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018b1:	eb 1d                	jmp    8018d0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b6:	8b 52 18             	mov    0x18(%edx),%edx
  8018b9:	85 d2                	test   %edx,%edx
  8018bb:	74 0e                	je     8018cb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018c4:	89 04 24             	mov    %eax,(%esp)
  8018c7:	ff d2                	call   *%edx
  8018c9:	eb 05                	jmp    8018d0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018d0:	83 c4 24             	add    $0x24,%esp
  8018d3:	5b                   	pop    %ebx
  8018d4:	5d                   	pop    %ebp
  8018d5:	c3                   	ret    

008018d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 24             	sub    $0x24,%esp
  8018dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	89 04 24             	mov    %eax,(%esp)
  8018ed:	e8 34 fb ff ff       	call   801426 <fd_lookup>
  8018f2:	89 c2                	mov    %eax,%edx
  8018f4:	85 d2                	test   %edx,%edx
  8018f6:	78 52                	js     80194a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801902:	8b 00                	mov    (%eax),%eax
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	e8 70 fb ff ff       	call   80147c <dev_lookup>
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 3a                	js     80194a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801913:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801917:	74 2c                	je     801945 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801919:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80191c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801923:	00 00 00 
	stat->st_isdir = 0;
  801926:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80192d:	00 00 00 
	stat->st_dev = dev;
  801930:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801936:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80193a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80193d:	89 14 24             	mov    %edx,(%esp)
  801940:	ff 50 14             	call   *0x14(%eax)
  801943:	eb 05                	jmp    80194a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801945:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80194a:	83 c4 24             	add    $0x24,%esp
  80194d:	5b                   	pop    %ebx
  80194e:	5d                   	pop    %ebp
  80194f:	c3                   	ret    

00801950 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	56                   	push   %esi
  801954:	53                   	push   %ebx
  801955:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801958:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80195f:	00 
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	89 04 24             	mov    %eax,(%esp)
  801966:	e8 28 02 00 00       	call   801b93 <open>
  80196b:	89 c3                	mov    %eax,%ebx
  80196d:	85 db                	test   %ebx,%ebx
  80196f:	78 1b                	js     80198c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801971:	8b 45 0c             	mov    0xc(%ebp),%eax
  801974:	89 44 24 04          	mov    %eax,0x4(%esp)
  801978:	89 1c 24             	mov    %ebx,(%esp)
  80197b:	e8 56 ff ff ff       	call   8018d6 <fstat>
  801980:	89 c6                	mov    %eax,%esi
	close(fd);
  801982:	89 1c 24             	mov    %ebx,(%esp)
  801985:	e8 cd fb ff ff       	call   801557 <close>
	return r;
  80198a:	89 f0                	mov    %esi,%eax
}
  80198c:	83 c4 10             	add    $0x10,%esp
  80198f:	5b                   	pop    %ebx
  801990:	5e                   	pop    %esi
  801991:	5d                   	pop    %ebp
  801992:	c3                   	ret    

00801993 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	56                   	push   %esi
  801997:	53                   	push   %ebx
  801998:	83 ec 10             	sub    $0x10,%esp
  80199b:	89 c6                	mov    %eax,%esi
  80199d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80199f:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  8019a6:	75 11                	jne    8019b9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019af:	e8 d0 0d 00 00       	call   802784 <ipc_find_env>
  8019b4:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019b9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019c0:	00 
  8019c1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8019c8:	00 
  8019c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019cd:	a1 10 50 80 00       	mov    0x805010,%eax
  8019d2:	89 04 24             	mov    %eax,(%esp)
  8019d5:	e8 4c 0d 00 00       	call   802726 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019e1:	00 
  8019e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ed:	e8 ca 0c 00 00       	call   8026bc <ipc_recv>
}
  8019f2:	83 c4 10             	add    $0x10,%esp
  8019f5:	5b                   	pop    %ebx
  8019f6:	5e                   	pop    %esi
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    

008019f9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	8b 40 0c             	mov    0xc(%eax),%eax
  801a05:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a12:	ba 00 00 00 00       	mov    $0x0,%edx
  801a17:	b8 02 00 00 00       	mov    $0x2,%eax
  801a1c:	e8 72 ff ff ff       	call   801993 <fsipc>
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a34:	ba 00 00 00 00       	mov    $0x0,%edx
  801a39:	b8 06 00 00 00       	mov    $0x6,%eax
  801a3e:	e8 50 ff ff ff       	call   801993 <fsipc>
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	53                   	push   %ebx
  801a49:	83 ec 14             	sub    $0x14,%esp
  801a4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 40 0c             	mov    0xc(%eax),%eax
  801a55:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a64:	e8 2a ff ff ff       	call   801993 <fsipc>
  801a69:	89 c2                	mov    %eax,%edx
  801a6b:	85 d2                	test   %edx,%edx
  801a6d:	78 2b                	js     801a9a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a6f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a76:	00 
  801a77:	89 1c 24             	mov    %ebx,(%esp)
  801a7a:	e8 e8 f1 ff ff       	call   800c67 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a7f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a84:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a8a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a8f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9a:	83 c4 14             	add    $0x14,%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 18             	sub    $0x18,%esp
  801aa6:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801aae:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801ab3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801ab6:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801abb:	8b 55 08             	mov    0x8(%ebp),%edx
  801abe:	8b 52 0c             	mov    0xc(%edx),%edx
  801ac1:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801ac7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ace:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad2:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ad9:	e8 26 f3 ff ff       	call   800e04 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801ade:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae3:	b8 04 00 00 00       	mov    $0x4,%eax
  801ae8:	e8 a6 fe ff ff       	call   801993 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
  801af4:	83 ec 10             	sub    $0x10,%esp
  801af7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	8b 40 0c             	mov    0xc(%eax),%eax
  801b00:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b05:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b10:	b8 03 00 00 00       	mov    $0x3,%eax
  801b15:	e8 79 fe ff ff       	call   801993 <fsipc>
  801b1a:	89 c3                	mov    %eax,%ebx
  801b1c:	85 c0                	test   %eax,%eax
  801b1e:	78 6a                	js     801b8a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b20:	39 c6                	cmp    %eax,%esi
  801b22:	73 24                	jae    801b48 <devfile_read+0x59>
  801b24:	c7 44 24 0c 9c 2f 80 	movl   $0x802f9c,0xc(%esp)
  801b2b:	00 
  801b2c:	c7 44 24 08 a3 2f 80 	movl   $0x802fa3,0x8(%esp)
  801b33:	00 
  801b34:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b3b:	00 
  801b3c:	c7 04 24 b8 2f 80 00 	movl   $0x802fb8,(%esp)
  801b43:	e8 1e 0b 00 00       	call   802666 <_panic>
	assert(r <= PGSIZE);
  801b48:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b4d:	7e 24                	jle    801b73 <devfile_read+0x84>
  801b4f:	c7 44 24 0c c3 2f 80 	movl   $0x802fc3,0xc(%esp)
  801b56:	00 
  801b57:	c7 44 24 08 a3 2f 80 	movl   $0x802fa3,0x8(%esp)
  801b5e:	00 
  801b5f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b66:	00 
  801b67:	c7 04 24 b8 2f 80 00 	movl   $0x802fb8,(%esp)
  801b6e:	e8 f3 0a 00 00       	call   802666 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b77:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b7e:	00 
  801b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b82:	89 04 24             	mov    %eax,(%esp)
  801b85:	e8 7a f2 ff ff       	call   800e04 <memmove>
	return r;
}
  801b8a:	89 d8                	mov    %ebx,%eax
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5d                   	pop    %ebp
  801b92:	c3                   	ret    

00801b93 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	53                   	push   %ebx
  801b97:	83 ec 24             	sub    $0x24,%esp
  801b9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b9d:	89 1c 24             	mov    %ebx,(%esp)
  801ba0:	e8 8b f0 ff ff       	call   800c30 <strlen>
  801ba5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801baa:	7f 60                	jg     801c0c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801baf:	89 04 24             	mov    %eax,(%esp)
  801bb2:	e8 20 f8 ff ff       	call   8013d7 <fd_alloc>
  801bb7:	89 c2                	mov    %eax,%edx
  801bb9:	85 d2                	test   %edx,%edx
  801bbb:	78 54                	js     801c11 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bbd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bc1:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801bc8:	e8 9a f0 ff ff       	call   800c67 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd0:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdd:	e8 b1 fd ff ff       	call   801993 <fsipc>
  801be2:	89 c3                	mov    %eax,%ebx
  801be4:	85 c0                	test   %eax,%eax
  801be6:	79 17                	jns    801bff <open+0x6c>
		fd_close(fd, 0);
  801be8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bef:	00 
  801bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf3:	89 04 24             	mov    %eax,(%esp)
  801bf6:	e8 db f8 ff ff       	call   8014d6 <fd_close>
		return r;
  801bfb:	89 d8                	mov    %ebx,%eax
  801bfd:	eb 12                	jmp    801c11 <open+0x7e>
	}

	return fd2num(fd);
  801bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c02:	89 04 24             	mov    %eax,(%esp)
  801c05:	e8 a6 f7 ff ff       	call   8013b0 <fd2num>
  801c0a:	eb 05                	jmp    801c11 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c0c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c11:	83 c4 24             	add    $0x24,%esp
  801c14:	5b                   	pop    %ebx
  801c15:	5d                   	pop    %ebp
  801c16:	c3                   	ret    

00801c17 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c22:	b8 08 00 00 00       	mov    $0x8,%eax
  801c27:	e8 67 fd ff ff       	call   801993 <fsipc>
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    
  801c2e:	66 90                	xchg   %ax,%ax

00801c30 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c36:	c7 44 24 04 cf 2f 80 	movl   $0x802fcf,0x4(%esp)
  801c3d:	00 
  801c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c41:	89 04 24             	mov    %eax,(%esp)
  801c44:	e8 1e f0 ff ff       	call   800c67 <strcpy>
	return 0;
}
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	53                   	push   %ebx
  801c54:	83 ec 14             	sub    $0x14,%esp
  801c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c5a:	89 1c 24             	mov    %ebx,(%esp)
  801c5d:	e8 5a 0b 00 00       	call   8027bc <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801c67:	83 f8 01             	cmp    $0x1,%eax
  801c6a:	75 0d                	jne    801c79 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801c6c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c6f:	89 04 24             	mov    %eax,(%esp)
  801c72:	e8 29 03 00 00       	call   801fa0 <nsipc_close>
  801c77:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801c79:	89 d0                	mov    %edx,%eax
  801c7b:	83 c4 14             	add    $0x14,%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    

00801c81 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c87:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c8e:	00 
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca3:	89 04 24             	mov    %eax,(%esp)
  801ca6:	e8 f0 03 00 00       	call   80209b <nsipc_send>
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cba:	00 
  801cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccf:	89 04 24             	mov    %eax,(%esp)
  801cd2:	e8 44 03 00 00       	call   80201b <nsipc_recv>
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801cdf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ce2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ce6:	89 04 24             	mov    %eax,(%esp)
  801ce9:	e8 38 f7 ff ff       	call   801426 <fd_lookup>
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 17                	js     801d09 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801cfb:	39 08                	cmp    %ecx,(%eax)
  801cfd:	75 05                	jne    801d04 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801cff:	8b 40 0c             	mov    0xc(%eax),%eax
  801d02:	eb 05                	jmp    801d09 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d04:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	83 ec 20             	sub    $0x20,%esp
  801d13:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d18:	89 04 24             	mov    %eax,(%esp)
  801d1b:	e8 b7 f6 ff ff       	call   8013d7 <fd_alloc>
  801d20:	89 c3                	mov    %eax,%ebx
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 21                	js     801d47 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d26:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d2d:	00 
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3c:	e8 42 f3 ff ff       	call   801083 <sys_page_alloc>
  801d41:	89 c3                	mov    %eax,%ebx
  801d43:	85 c0                	test   %eax,%eax
  801d45:	79 0c                	jns    801d53 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801d47:	89 34 24             	mov    %esi,(%esp)
  801d4a:	e8 51 02 00 00       	call   801fa0 <nsipc_close>
		return r;
  801d4f:	89 d8                	mov    %ebx,%eax
  801d51:	eb 20                	jmp    801d73 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d53:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d61:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801d68:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801d6b:	89 14 24             	mov    %edx,(%esp)
  801d6e:	e8 3d f6 ff ff       	call   8013b0 <fd2num>
}
  801d73:	83 c4 20             	add    $0x20,%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5e                   	pop    %esi
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    

00801d7a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	e8 51 ff ff ff       	call   801cd9 <fd2sockid>
		return r;
  801d88:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 23                	js     801db1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d8e:	8b 55 10             	mov    0x10(%ebp),%edx
  801d91:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d9c:	89 04 24             	mov    %eax,(%esp)
  801d9f:	e8 45 01 00 00       	call   801ee9 <nsipc_accept>
		return r;
  801da4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801da6:	85 c0                	test   %eax,%eax
  801da8:	78 07                	js     801db1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801daa:	e8 5c ff ff ff       	call   801d0b <alloc_sockfd>
  801daf:	89 c1                	mov    %eax,%ecx
}
  801db1:	89 c8                	mov    %ecx,%eax
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	e8 16 ff ff ff       	call   801cd9 <fd2sockid>
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	85 d2                	test   %edx,%edx
  801dc7:	78 16                	js     801ddf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd7:	89 14 24             	mov    %edx,(%esp)
  801dda:	e8 60 01 00 00       	call   801f3f <nsipc_bind>
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <shutdown>:

int
shutdown(int s, int how)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	e8 ea fe ff ff       	call   801cd9 <fd2sockid>
  801def:	89 c2                	mov    %eax,%edx
  801df1:	85 d2                	test   %edx,%edx
  801df3:	78 0f                	js     801e04 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfc:	89 14 24             	mov    %edx,(%esp)
  801dff:	e8 7a 01 00 00       	call   801f7e <nsipc_shutdown>
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	e8 c5 fe ff ff       	call   801cd9 <fd2sockid>
  801e14:	89 c2                	mov    %eax,%edx
  801e16:	85 d2                	test   %edx,%edx
  801e18:	78 16                	js     801e30 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e28:	89 14 24             	mov    %edx,(%esp)
  801e2b:	e8 8a 01 00 00       	call   801fba <nsipc_connect>
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <listen>:

int
listen(int s, int backlog)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	e8 99 fe ff ff       	call   801cd9 <fd2sockid>
  801e40:	89 c2                	mov    %eax,%edx
  801e42:	85 d2                	test   %edx,%edx
  801e44:	78 0f                	js     801e55 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	89 14 24             	mov    %edx,(%esp)
  801e50:	e8 a4 01 00 00       	call   801ff9 <nsipc_listen>
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e60:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	89 04 24             	mov    %eax,(%esp)
  801e71:	e8 98 02 00 00       	call   80210e <nsipc_socket>
  801e76:	89 c2                	mov    %eax,%edx
  801e78:	85 d2                	test   %edx,%edx
  801e7a:	78 05                	js     801e81 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801e7c:	e8 8a fe ff ff       	call   801d0b <alloc_sockfd>
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	53                   	push   %ebx
  801e87:	83 ec 14             	sub    $0x14,%esp
  801e8a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e8c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  801e93:	75 11                	jne    801ea6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e95:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801e9c:	e8 e3 08 00 00       	call   802784 <ipc_find_env>
  801ea1:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ea6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ead:	00 
  801eae:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801eb5:	00 
  801eb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eba:	a1 14 50 80 00       	mov    0x805014,%eax
  801ebf:	89 04 24             	mov    %eax,(%esp)
  801ec2:	e8 5f 08 00 00       	call   802726 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ec7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ece:	00 
  801ecf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ed6:	00 
  801ed7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ede:	e8 d9 07 00 00       	call   8026bc <ipc_recv>
}
  801ee3:	83 c4 14             	add    $0x14,%esp
  801ee6:	5b                   	pop    %ebx
  801ee7:	5d                   	pop    %ebp
  801ee8:	c3                   	ret    

00801ee9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	56                   	push   %esi
  801eed:	53                   	push   %ebx
  801eee:	83 ec 10             	sub    $0x10,%esp
  801ef1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801efc:	8b 06                	mov    (%esi),%eax
  801efe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f03:	b8 01 00 00 00       	mov    $0x1,%eax
  801f08:	e8 76 ff ff ff       	call   801e83 <nsipc>
  801f0d:	89 c3                	mov    %eax,%ebx
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 23                	js     801f36 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f13:	a1 10 70 80 00       	mov    0x807010,%eax
  801f18:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f23:	00 
  801f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f27:	89 04 24             	mov    %eax,(%esp)
  801f2a:	e8 d5 ee ff ff       	call   800e04 <memmove>
		*addrlen = ret->ret_addrlen;
  801f2f:	a1 10 70 80 00       	mov    0x807010,%eax
  801f34:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801f36:	89 d8                	mov    %ebx,%eax
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5d                   	pop    %ebp
  801f3e:	c3                   	ret    

00801f3f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	53                   	push   %ebx
  801f43:	83 ec 14             	sub    $0x14,%esp
  801f46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f51:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801f63:	e8 9c ee ff ff       	call   800e04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f68:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f6e:	b8 02 00 00 00       	mov    $0x2,%eax
  801f73:	e8 0b ff ff ff       	call   801e83 <nsipc>
}
  801f78:	83 c4 14             	add    $0x14,%esp
  801f7b:	5b                   	pop    %ebx
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    

00801f7e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f94:	b8 03 00 00 00       	mov    $0x3,%eax
  801f99:	e8 e5 fe ff ff       	call   801e83 <nsipc>
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <nsipc_close>:

int
nsipc_close(int s)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fae:	b8 04 00 00 00       	mov    $0x4,%eax
  801fb3:	e8 cb fe ff ff       	call   801e83 <nsipc>
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	53                   	push   %ebx
  801fbe:	83 ec 14             	sub    $0x14,%esp
  801fc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fcc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801fde:	e8 21 ee ff ff       	call   800e04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fe3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801fe9:	b8 05 00 00 00       	mov    $0x5,%eax
  801fee:	e8 90 fe ff ff       	call   801e83 <nsipc>
}
  801ff3:	83 c4 14             	add    $0x14,%esp
  801ff6:	5b                   	pop    %ebx
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    

00801ff9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80200f:	b8 06 00 00 00       	mov    $0x6,%eax
  802014:	e8 6a fe ff ff       	call   801e83 <nsipc>
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	56                   	push   %esi
  80201f:	53                   	push   %ebx
  802020:	83 ec 10             	sub    $0x10,%esp
  802023:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80202e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802034:	8b 45 14             	mov    0x14(%ebp),%eax
  802037:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80203c:	b8 07 00 00 00       	mov    $0x7,%eax
  802041:	e8 3d fe ff ff       	call   801e83 <nsipc>
  802046:	89 c3                	mov    %eax,%ebx
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 46                	js     802092 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80204c:	39 f0                	cmp    %esi,%eax
  80204e:	7f 07                	jg     802057 <nsipc_recv+0x3c>
  802050:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802055:	7e 24                	jle    80207b <nsipc_recv+0x60>
  802057:	c7 44 24 0c db 2f 80 	movl   $0x802fdb,0xc(%esp)
  80205e:	00 
  80205f:	c7 44 24 08 a3 2f 80 	movl   $0x802fa3,0x8(%esp)
  802066:	00 
  802067:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80206e:	00 
  80206f:	c7 04 24 f0 2f 80 00 	movl   $0x802ff0,(%esp)
  802076:	e8 eb 05 00 00       	call   802666 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80207b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80207f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802086:	00 
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	89 04 24             	mov    %eax,(%esp)
  80208d:	e8 72 ed ff ff       	call   800e04 <memmove>
	}

	return r;
}
  802092:	89 d8                	mov    %ebx,%eax
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    

0080209b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	53                   	push   %ebx
  80209f:	83 ec 14             	sub    $0x14,%esp
  8020a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020b3:	7e 24                	jle    8020d9 <nsipc_send+0x3e>
  8020b5:	c7 44 24 0c fc 2f 80 	movl   $0x802ffc,0xc(%esp)
  8020bc:	00 
  8020bd:	c7 44 24 08 a3 2f 80 	movl   $0x802fa3,0x8(%esp)
  8020c4:	00 
  8020c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8020cc:	00 
  8020cd:	c7 04 24 f0 2f 80 00 	movl   $0x802ff0,(%esp)
  8020d4:	e8 8d 05 00 00       	call   802666 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8020eb:	e8 14 ed ff ff       	call   800e04 <memmove>
	nsipcbuf.send.req_size = size;
  8020f0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020fe:	b8 08 00 00 00       	mov    $0x8,%eax
  802103:	e8 7b fd ff ff       	call   801e83 <nsipc>
}
  802108:	83 c4 14             	add    $0x14,%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    

0080210e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80211c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802124:	8b 45 10             	mov    0x10(%ebp),%eax
  802127:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80212c:	b8 09 00 00 00       	mov    $0x9,%eax
  802131:	e8 4d fd ff ff       	call   801e83 <nsipc>
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	56                   	push   %esi
  80213c:	53                   	push   %ebx
  80213d:	83 ec 10             	sub    $0x10,%esp
  802140:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	89 04 24             	mov    %eax,(%esp)
  802149:	e8 72 f2 ff ff       	call   8013c0 <fd2data>
  80214e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802150:	c7 44 24 04 08 30 80 	movl   $0x803008,0x4(%esp)
  802157:	00 
  802158:	89 1c 24             	mov    %ebx,(%esp)
  80215b:	e8 07 eb ff ff       	call   800c67 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802160:	8b 46 04             	mov    0x4(%esi),%eax
  802163:	2b 06                	sub    (%esi),%eax
  802165:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80216b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802172:	00 00 00 
	stat->st_dev = &devpipe;
  802175:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80217c:	40 80 00 
	return 0;
}
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    

0080218b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	53                   	push   %ebx
  80218f:	83 ec 14             	sub    $0x14,%esp
  802192:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802195:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a0:	e8 85 ef ff ff       	call   80112a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021a5:	89 1c 24             	mov    %ebx,(%esp)
  8021a8:	e8 13 f2 ff ff       	call   8013c0 <fd2data>
  8021ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b8:	e8 6d ef ff ff       	call   80112a <sys_page_unmap>
}
  8021bd:	83 c4 14             	add    $0x14,%esp
  8021c0:	5b                   	pop    %ebx
  8021c1:	5d                   	pop    %ebp
  8021c2:	c3                   	ret    

008021c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	57                   	push   %edi
  8021c7:	56                   	push   %esi
  8021c8:	53                   	push   %ebx
  8021c9:	83 ec 2c             	sub    $0x2c,%esp
  8021cc:	89 c6                	mov    %eax,%esi
  8021ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8021d1:	a1 18 50 80 00       	mov    0x805018,%eax
  8021d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021d9:	89 34 24             	mov    %esi,(%esp)
  8021dc:	e8 db 05 00 00       	call   8027bc <pageref>
  8021e1:	89 c7                	mov    %eax,%edi
  8021e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e6:	89 04 24             	mov    %eax,(%esp)
  8021e9:	e8 ce 05 00 00       	call   8027bc <pageref>
  8021ee:	39 c7                	cmp    %eax,%edi
  8021f0:	0f 94 c2             	sete   %dl
  8021f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8021f6:	8b 0d 18 50 80 00    	mov    0x805018,%ecx
  8021fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8021ff:	39 fb                	cmp    %edi,%ebx
  802201:	74 21                	je     802224 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802203:	84 d2                	test   %dl,%dl
  802205:	74 ca                	je     8021d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802207:	8b 51 58             	mov    0x58(%ecx),%edx
  80220a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80220e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802212:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802216:	c7 04 24 0f 30 80 00 	movl   $0x80300f,(%esp)
  80221d:	e8 19 e4 ff ff       	call   80063b <cprintf>
  802222:	eb ad                	jmp    8021d1 <_pipeisclosed+0xe>
	}
}
  802224:	83 c4 2c             	add    $0x2c,%esp
  802227:	5b                   	pop    %ebx
  802228:	5e                   	pop    %esi
  802229:	5f                   	pop    %edi
  80222a:	5d                   	pop    %ebp
  80222b:	c3                   	ret    

0080222c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	57                   	push   %edi
  802230:	56                   	push   %esi
  802231:	53                   	push   %ebx
  802232:	83 ec 1c             	sub    $0x1c,%esp
  802235:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802238:	89 34 24             	mov    %esi,(%esp)
  80223b:	e8 80 f1 ff ff       	call   8013c0 <fd2data>
  802240:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802242:	bf 00 00 00 00       	mov    $0x0,%edi
  802247:	eb 45                	jmp    80228e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802249:	89 da                	mov    %ebx,%edx
  80224b:	89 f0                	mov    %esi,%eax
  80224d:	e8 71 ff ff ff       	call   8021c3 <_pipeisclosed>
  802252:	85 c0                	test   %eax,%eax
  802254:	75 41                	jne    802297 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802256:	e8 09 ee ff ff       	call   801064 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80225b:	8b 43 04             	mov    0x4(%ebx),%eax
  80225e:	8b 0b                	mov    (%ebx),%ecx
  802260:	8d 51 20             	lea    0x20(%ecx),%edx
  802263:	39 d0                	cmp    %edx,%eax
  802265:	73 e2                	jae    802249 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80226a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80226e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802271:	99                   	cltd   
  802272:	c1 ea 1b             	shr    $0x1b,%edx
  802275:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802278:	83 e1 1f             	and    $0x1f,%ecx
  80227b:	29 d1                	sub    %edx,%ecx
  80227d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802281:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802285:	83 c0 01             	add    $0x1,%eax
  802288:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80228b:	83 c7 01             	add    $0x1,%edi
  80228e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802291:	75 c8                	jne    80225b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802293:	89 f8                	mov    %edi,%eax
  802295:	eb 05                	jmp    80229c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80229c:	83 c4 1c             	add    $0x1c,%esp
  80229f:	5b                   	pop    %ebx
  8022a0:	5e                   	pop    %esi
  8022a1:	5f                   	pop    %edi
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    

008022a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	57                   	push   %edi
  8022a8:	56                   	push   %esi
  8022a9:	53                   	push   %ebx
  8022aa:	83 ec 1c             	sub    $0x1c,%esp
  8022ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022b0:	89 3c 24             	mov    %edi,(%esp)
  8022b3:	e8 08 f1 ff ff       	call   8013c0 <fd2data>
  8022b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022ba:	be 00 00 00 00       	mov    $0x0,%esi
  8022bf:	eb 3d                	jmp    8022fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8022c1:	85 f6                	test   %esi,%esi
  8022c3:	74 04                	je     8022c9 <devpipe_read+0x25>
				return i;
  8022c5:	89 f0                	mov    %esi,%eax
  8022c7:	eb 43                	jmp    80230c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8022c9:	89 da                	mov    %ebx,%edx
  8022cb:	89 f8                	mov    %edi,%eax
  8022cd:	e8 f1 fe ff ff       	call   8021c3 <_pipeisclosed>
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	75 31                	jne    802307 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8022d6:	e8 89 ed ff ff       	call   801064 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8022db:	8b 03                	mov    (%ebx),%eax
  8022dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022e0:	74 df                	je     8022c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022e2:	99                   	cltd   
  8022e3:	c1 ea 1b             	shr    $0x1b,%edx
  8022e6:	01 d0                	add    %edx,%eax
  8022e8:	83 e0 1f             	and    $0x1f,%eax
  8022eb:	29 d0                	sub    %edx,%eax
  8022ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022fb:	83 c6 01             	add    $0x1,%esi
  8022fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802301:	75 d8                	jne    8022db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802303:	89 f0                	mov    %esi,%eax
  802305:	eb 05                	jmp    80230c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802307:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80230c:	83 c4 1c             	add    $0x1c,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5f                   	pop    %edi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    

00802314 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	56                   	push   %esi
  802318:	53                   	push   %ebx
  802319:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80231c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80231f:	89 04 24             	mov    %eax,(%esp)
  802322:	e8 b0 f0 ff ff       	call   8013d7 <fd_alloc>
  802327:	89 c2                	mov    %eax,%edx
  802329:	85 d2                	test   %edx,%edx
  80232b:	0f 88 4d 01 00 00    	js     80247e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802331:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802338:	00 
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802347:	e8 37 ed ff ff       	call   801083 <sys_page_alloc>
  80234c:	89 c2                	mov    %eax,%edx
  80234e:	85 d2                	test   %edx,%edx
  802350:	0f 88 28 01 00 00    	js     80247e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802356:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802359:	89 04 24             	mov    %eax,(%esp)
  80235c:	e8 76 f0 ff ff       	call   8013d7 <fd_alloc>
  802361:	89 c3                	mov    %eax,%ebx
  802363:	85 c0                	test   %eax,%eax
  802365:	0f 88 fe 00 00 00    	js     802469 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80236b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802372:	00 
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802381:	e8 fd ec ff ff       	call   801083 <sys_page_alloc>
  802386:	89 c3                	mov    %eax,%ebx
  802388:	85 c0                	test   %eax,%eax
  80238a:	0f 88 d9 00 00 00    	js     802469 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	89 04 24             	mov    %eax,(%esp)
  802396:	e8 25 f0 ff ff       	call   8013c0 <fd2data>
  80239b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023a4:	00 
  8023a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b0:	e8 ce ec ff ff       	call   801083 <sys_page_alloc>
  8023b5:	89 c3                	mov    %eax,%ebx
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	0f 88 97 00 00 00    	js     802456 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c2:	89 04 24             	mov    %eax,(%esp)
  8023c5:	e8 f6 ef ff ff       	call   8013c0 <fd2data>
  8023ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8023d1:	00 
  8023d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023dd:	00 
  8023de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e9:	e8 e9 ec ff ff       	call   8010d7 <sys_page_map>
  8023ee:	89 c3                	mov    %eax,%ebx
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	78 52                	js     802446 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8023f4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802409:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80240f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802412:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	89 04 24             	mov    %eax,(%esp)
  802424:	e8 87 ef ff ff       	call   8013b0 <fd2num>
  802429:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80242c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80242e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802431:	89 04 24             	mov    %eax,(%esp)
  802434:	e8 77 ef ff ff       	call   8013b0 <fd2num>
  802439:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80243f:	b8 00 00 00 00       	mov    $0x0,%eax
  802444:	eb 38                	jmp    80247e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802446:	89 74 24 04          	mov    %esi,0x4(%esp)
  80244a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802451:	e8 d4 ec ff ff       	call   80112a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802464:	e8 c1 ec ff ff       	call   80112a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802470:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802477:	e8 ae ec ff ff       	call   80112a <sys_page_unmap>
  80247c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80247e:	83 c4 30             	add    $0x30,%esp
  802481:	5b                   	pop    %ebx
  802482:	5e                   	pop    %esi
  802483:	5d                   	pop    %ebp
  802484:	c3                   	ret    

00802485 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	89 04 24             	mov    %eax,(%esp)
  802498:	e8 89 ef ff ff       	call   801426 <fd_lookup>
  80249d:	89 c2                	mov    %eax,%edx
  80249f:	85 d2                	test   %edx,%edx
  8024a1:	78 15                	js     8024b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	89 04 24             	mov    %eax,(%esp)
  8024a9:	e8 12 ef ff ff       	call   8013c0 <fd2data>
	return _pipeisclosed(fd, p);
  8024ae:	89 c2                	mov    %eax,%edx
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	e8 0b fd ff ff       	call   8021c3 <_pipeisclosed>
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c8:	5d                   	pop    %ebp
  8024c9:	c3                   	ret    

008024ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8024d0:	c7 44 24 04 27 30 80 	movl   $0x803027,0x4(%esp)
  8024d7:	00 
  8024d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024db:	89 04 24             	mov    %eax,(%esp)
  8024de:	e8 84 e7 ff ff       	call   800c67 <strcpy>
	return 0;
}
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	57                   	push   %edi
  8024ee:	56                   	push   %esi
  8024ef:	53                   	push   %ebx
  8024f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802501:	eb 31                	jmp    802534 <devcons_write+0x4a>
		m = n - tot;
  802503:	8b 75 10             	mov    0x10(%ebp),%esi
  802506:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802508:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80250b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802510:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802513:	89 74 24 08          	mov    %esi,0x8(%esp)
  802517:	03 45 0c             	add    0xc(%ebp),%eax
  80251a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80251e:	89 3c 24             	mov    %edi,(%esp)
  802521:	e8 de e8 ff ff       	call   800e04 <memmove>
		sys_cputs(buf, m);
  802526:	89 74 24 04          	mov    %esi,0x4(%esp)
  80252a:	89 3c 24             	mov    %edi,(%esp)
  80252d:	e8 84 ea ff ff       	call   800fb6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802532:	01 f3                	add    %esi,%ebx
  802534:	89 d8                	mov    %ebx,%eax
  802536:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802539:	72 c8                	jb     802503 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80253b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    

00802546 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802551:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802555:	75 07                	jne    80255e <devcons_read+0x18>
  802557:	eb 2a                	jmp    802583 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802559:	e8 06 eb ff ff       	call   801064 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80255e:	66 90                	xchg   %ax,%ax
  802560:	e8 6f ea ff ff       	call   800fd4 <sys_cgetc>
  802565:	85 c0                	test   %eax,%eax
  802567:	74 f0                	je     802559 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802569:	85 c0                	test   %eax,%eax
  80256b:	78 16                	js     802583 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80256d:	83 f8 04             	cmp    $0x4,%eax
  802570:	74 0c                	je     80257e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802572:	8b 55 0c             	mov    0xc(%ebp),%edx
  802575:	88 02                	mov    %al,(%edx)
	return 1;
  802577:	b8 01 00 00 00       	mov    $0x1,%eax
  80257c:	eb 05                	jmp    802583 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802591:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802598:	00 
  802599:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80259c:	89 04 24             	mov    %eax,(%esp)
  80259f:	e8 12 ea ff ff       	call   800fb6 <sys_cputs>
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <getchar>:

int
getchar(void)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8025ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8025b3:	00 
  8025b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c2:	e8 f3 f0 ff ff       	call   8016ba <read>
	if (r < 0)
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	78 0f                	js     8025da <getchar+0x34>
		return r;
	if (r < 1)
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	7e 06                	jle    8025d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8025cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8025d3:	eb 05                	jmp    8025da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8025d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	89 04 24             	mov    %eax,(%esp)
  8025ef:	e8 32 ee ff ff       	call   801426 <fd_lookup>
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	78 11                	js     802609 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802601:	39 10                	cmp    %edx,(%eax)
  802603:	0f 94 c0             	sete   %al
  802606:	0f b6 c0             	movzbl %al,%eax
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <opencons>:

int
opencons(void)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802611:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802614:	89 04 24             	mov    %eax,(%esp)
  802617:	e8 bb ed ff ff       	call   8013d7 <fd_alloc>
		return r;
  80261c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80261e:	85 c0                	test   %eax,%eax
  802620:	78 40                	js     802662 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802622:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802629:	00 
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802631:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802638:	e8 46 ea ff ff       	call   801083 <sys_page_alloc>
		return r;
  80263d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80263f:	85 c0                	test   %eax,%eax
  802641:	78 1f                	js     802662 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802643:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802658:	89 04 24             	mov    %eax,(%esp)
  80265b:	e8 50 ed ff ff       	call   8013b0 <fd2num>
  802660:	89 c2                	mov    %eax,%edx
}
  802662:	89 d0                	mov    %edx,%eax
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	56                   	push   %esi
  80266a:	53                   	push   %ebx
  80266b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80266e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802671:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802677:	e8 c9 e9 ff ff       	call   801045 <sys_getenvid>
  80267c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802683:	8b 55 08             	mov    0x8(%ebp),%edx
  802686:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80268a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80268e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802692:	c7 04 24 34 30 80 00 	movl   $0x803034,(%esp)
  802699:	e8 9d df ff ff       	call   80063b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80269e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8026a5:	89 04 24             	mov    %eax,(%esp)
  8026a8:	e8 2d df ff ff       	call   8005da <vcprintf>
	cprintf("\n");
  8026ad:	c7 04 24 20 30 80 00 	movl   $0x803020,(%esp)
  8026b4:	e8 82 df ff ff       	call   80063b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026b9:	cc                   	int3   
  8026ba:	eb fd                	jmp    8026b9 <_panic+0x53>

008026bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
  8026bf:	56                   	push   %esi
  8026c0:	53                   	push   %ebx
  8026c1:	83 ec 10             	sub    $0x10,%esp
  8026c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8026c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ca:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8026cd:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8026cf:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8026d4:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8026d7:	89 04 24             	mov    %eax,(%esp)
  8026da:	e8 ba eb ff ff       	call   801299 <sys_ipc_recv>
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	75 1e                	jne    802701 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8026e3:	85 db                	test   %ebx,%ebx
  8026e5:	74 0a                	je     8026f1 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8026e7:	a1 18 50 80 00       	mov    0x805018,%eax
  8026ec:	8b 40 74             	mov    0x74(%eax),%eax
  8026ef:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8026f1:	85 f6                	test   %esi,%esi
  8026f3:	74 22                	je     802717 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8026f5:	a1 18 50 80 00       	mov    0x805018,%eax
  8026fa:	8b 40 78             	mov    0x78(%eax),%eax
  8026fd:	89 06                	mov    %eax,(%esi)
  8026ff:	eb 16                	jmp    802717 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802701:	85 f6                	test   %esi,%esi
  802703:	74 06                	je     80270b <ipc_recv+0x4f>
				*perm_store = 0;
  802705:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  80270b:	85 db                	test   %ebx,%ebx
  80270d:	74 10                	je     80271f <ipc_recv+0x63>
				*from_env_store=0;
  80270f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802715:	eb 08                	jmp    80271f <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802717:	a1 18 50 80 00       	mov    0x805018,%eax
  80271c:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  80271f:	83 c4 10             	add    $0x10,%esp
  802722:	5b                   	pop    %ebx
  802723:	5e                   	pop    %esi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	57                   	push   %edi
  80272a:	56                   	push   %esi
  80272b:	53                   	push   %ebx
  80272c:	83 ec 1c             	sub    $0x1c,%esp
  80272f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802732:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802735:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802738:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  80273a:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  80273f:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802742:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802746:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80274a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80274e:	8b 45 08             	mov    0x8(%ebp),%eax
  802751:	89 04 24             	mov    %eax,(%esp)
  802754:	e8 1d eb ff ff       	call   801276 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802759:	eb 1c                	jmp    802777 <ipc_send+0x51>
	{
		sys_yield();
  80275b:	e8 04 e9 ff ff       	call   801064 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802760:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802764:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802768:	89 74 24 04          	mov    %esi,0x4(%esp)
  80276c:	8b 45 08             	mov    0x8(%ebp),%eax
  80276f:	89 04 24             	mov    %eax,(%esp)
  802772:	e8 ff ea ff ff       	call   801276 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802777:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80277a:	74 df                	je     80275b <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  80277c:	83 c4 1c             	add    $0x1c,%esp
  80277f:	5b                   	pop    %ebx
  802780:	5e                   	pop    %esi
  802781:	5f                   	pop    %edi
  802782:	5d                   	pop    %ebp
  802783:	c3                   	ret    

00802784 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80278a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80278f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802792:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802798:	8b 52 50             	mov    0x50(%edx),%edx
  80279b:	39 ca                	cmp    %ecx,%edx
  80279d:	75 0d                	jne    8027ac <ipc_find_env+0x28>
			return envs[i].env_id;
  80279f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8027a2:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8027a7:	8b 40 40             	mov    0x40(%eax),%eax
  8027aa:	eb 0e                	jmp    8027ba <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8027ac:	83 c0 01             	add    $0x1,%eax
  8027af:	3d 00 04 00 00       	cmp    $0x400,%eax
  8027b4:	75 d9                	jne    80278f <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8027b6:	66 b8 00 00          	mov    $0x0,%ax
}
  8027ba:	5d                   	pop    %ebp
  8027bb:	c3                   	ret    

008027bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027c2:	89 d0                	mov    %edx,%eax
  8027c4:	c1 e8 16             	shr    $0x16,%eax
  8027c7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027d3:	f6 c1 01             	test   $0x1,%cl
  8027d6:	74 1d                	je     8027f5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8027d8:	c1 ea 0c             	shr    $0xc,%edx
  8027db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027e2:	f6 c2 01             	test   $0x1,%dl
  8027e5:	74 0e                	je     8027f5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027e7:	c1 ea 0c             	shr    $0xc,%edx
  8027ea:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027f1:	ef 
  8027f2:	0f b7 c0             	movzwl %ax,%eax
}
  8027f5:	5d                   	pop    %ebp
  8027f6:	c3                   	ret    
  8027f7:	66 90                	xchg   %ax,%ax
  8027f9:	66 90                	xchg   %ax,%ax
  8027fb:	66 90                	xchg   %ax,%ax
  8027fd:	66 90                	xchg   %ax,%ax
  8027ff:	90                   	nop

00802800 <__udivdi3>:
  802800:	55                   	push   %ebp
  802801:	57                   	push   %edi
  802802:	56                   	push   %esi
  802803:	83 ec 0c             	sub    $0xc,%esp
  802806:	8b 44 24 28          	mov    0x28(%esp),%eax
  80280a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80280e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802812:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802816:	85 c0                	test   %eax,%eax
  802818:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80281c:	89 ea                	mov    %ebp,%edx
  80281e:	89 0c 24             	mov    %ecx,(%esp)
  802821:	75 2d                	jne    802850 <__udivdi3+0x50>
  802823:	39 e9                	cmp    %ebp,%ecx
  802825:	77 61                	ja     802888 <__udivdi3+0x88>
  802827:	85 c9                	test   %ecx,%ecx
  802829:	89 ce                	mov    %ecx,%esi
  80282b:	75 0b                	jne    802838 <__udivdi3+0x38>
  80282d:	b8 01 00 00 00       	mov    $0x1,%eax
  802832:	31 d2                	xor    %edx,%edx
  802834:	f7 f1                	div    %ecx
  802836:	89 c6                	mov    %eax,%esi
  802838:	31 d2                	xor    %edx,%edx
  80283a:	89 e8                	mov    %ebp,%eax
  80283c:	f7 f6                	div    %esi
  80283e:	89 c5                	mov    %eax,%ebp
  802840:	89 f8                	mov    %edi,%eax
  802842:	f7 f6                	div    %esi
  802844:	89 ea                	mov    %ebp,%edx
  802846:	83 c4 0c             	add    $0xc,%esp
  802849:	5e                   	pop    %esi
  80284a:	5f                   	pop    %edi
  80284b:	5d                   	pop    %ebp
  80284c:	c3                   	ret    
  80284d:	8d 76 00             	lea    0x0(%esi),%esi
  802850:	39 e8                	cmp    %ebp,%eax
  802852:	77 24                	ja     802878 <__udivdi3+0x78>
  802854:	0f bd e8             	bsr    %eax,%ebp
  802857:	83 f5 1f             	xor    $0x1f,%ebp
  80285a:	75 3c                	jne    802898 <__udivdi3+0x98>
  80285c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802860:	39 34 24             	cmp    %esi,(%esp)
  802863:	0f 86 9f 00 00 00    	jbe    802908 <__udivdi3+0x108>
  802869:	39 d0                	cmp    %edx,%eax
  80286b:	0f 82 97 00 00 00    	jb     802908 <__udivdi3+0x108>
  802871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802878:	31 d2                	xor    %edx,%edx
  80287a:	31 c0                	xor    %eax,%eax
  80287c:	83 c4 0c             	add    $0xc,%esp
  80287f:	5e                   	pop    %esi
  802880:	5f                   	pop    %edi
  802881:	5d                   	pop    %ebp
  802882:	c3                   	ret    
  802883:	90                   	nop
  802884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802888:	89 f8                	mov    %edi,%eax
  80288a:	f7 f1                	div    %ecx
  80288c:	31 d2                	xor    %edx,%edx
  80288e:	83 c4 0c             	add    $0xc,%esp
  802891:	5e                   	pop    %esi
  802892:	5f                   	pop    %edi
  802893:	5d                   	pop    %ebp
  802894:	c3                   	ret    
  802895:	8d 76 00             	lea    0x0(%esi),%esi
  802898:	89 e9                	mov    %ebp,%ecx
  80289a:	8b 3c 24             	mov    (%esp),%edi
  80289d:	d3 e0                	shl    %cl,%eax
  80289f:	89 c6                	mov    %eax,%esi
  8028a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8028a6:	29 e8                	sub    %ebp,%eax
  8028a8:	89 c1                	mov    %eax,%ecx
  8028aa:	d3 ef                	shr    %cl,%edi
  8028ac:	89 e9                	mov    %ebp,%ecx
  8028ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8028b2:	8b 3c 24             	mov    (%esp),%edi
  8028b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8028b9:	89 d6                	mov    %edx,%esi
  8028bb:	d3 e7                	shl    %cl,%edi
  8028bd:	89 c1                	mov    %eax,%ecx
  8028bf:	89 3c 24             	mov    %edi,(%esp)
  8028c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8028c6:	d3 ee                	shr    %cl,%esi
  8028c8:	89 e9                	mov    %ebp,%ecx
  8028ca:	d3 e2                	shl    %cl,%edx
  8028cc:	89 c1                	mov    %eax,%ecx
  8028ce:	d3 ef                	shr    %cl,%edi
  8028d0:	09 d7                	or     %edx,%edi
  8028d2:	89 f2                	mov    %esi,%edx
  8028d4:	89 f8                	mov    %edi,%eax
  8028d6:	f7 74 24 08          	divl   0x8(%esp)
  8028da:	89 d6                	mov    %edx,%esi
  8028dc:	89 c7                	mov    %eax,%edi
  8028de:	f7 24 24             	mull   (%esp)
  8028e1:	39 d6                	cmp    %edx,%esi
  8028e3:	89 14 24             	mov    %edx,(%esp)
  8028e6:	72 30                	jb     802918 <__udivdi3+0x118>
  8028e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028ec:	89 e9                	mov    %ebp,%ecx
  8028ee:	d3 e2                	shl    %cl,%edx
  8028f0:	39 c2                	cmp    %eax,%edx
  8028f2:	73 05                	jae    8028f9 <__udivdi3+0xf9>
  8028f4:	3b 34 24             	cmp    (%esp),%esi
  8028f7:	74 1f                	je     802918 <__udivdi3+0x118>
  8028f9:	89 f8                	mov    %edi,%eax
  8028fb:	31 d2                	xor    %edx,%edx
  8028fd:	e9 7a ff ff ff       	jmp    80287c <__udivdi3+0x7c>
  802902:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802908:	31 d2                	xor    %edx,%edx
  80290a:	b8 01 00 00 00       	mov    $0x1,%eax
  80290f:	e9 68 ff ff ff       	jmp    80287c <__udivdi3+0x7c>
  802914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802918:	8d 47 ff             	lea    -0x1(%edi),%eax
  80291b:	31 d2                	xor    %edx,%edx
  80291d:	83 c4 0c             	add    $0xc,%esp
  802920:	5e                   	pop    %esi
  802921:	5f                   	pop    %edi
  802922:	5d                   	pop    %ebp
  802923:	c3                   	ret    
  802924:	66 90                	xchg   %ax,%ax
  802926:	66 90                	xchg   %ax,%ax
  802928:	66 90                	xchg   %ax,%ax
  80292a:	66 90                	xchg   %ax,%ax
  80292c:	66 90                	xchg   %ax,%ax
  80292e:	66 90                	xchg   %ax,%ax

00802930 <__umoddi3>:
  802930:	55                   	push   %ebp
  802931:	57                   	push   %edi
  802932:	56                   	push   %esi
  802933:	83 ec 14             	sub    $0x14,%esp
  802936:	8b 44 24 28          	mov    0x28(%esp),%eax
  80293a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80293e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802942:	89 c7                	mov    %eax,%edi
  802944:	89 44 24 04          	mov    %eax,0x4(%esp)
  802948:	8b 44 24 30          	mov    0x30(%esp),%eax
  80294c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802950:	89 34 24             	mov    %esi,(%esp)
  802953:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802957:	85 c0                	test   %eax,%eax
  802959:	89 c2                	mov    %eax,%edx
  80295b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80295f:	75 17                	jne    802978 <__umoddi3+0x48>
  802961:	39 fe                	cmp    %edi,%esi
  802963:	76 4b                	jbe    8029b0 <__umoddi3+0x80>
  802965:	89 c8                	mov    %ecx,%eax
  802967:	89 fa                	mov    %edi,%edx
  802969:	f7 f6                	div    %esi
  80296b:	89 d0                	mov    %edx,%eax
  80296d:	31 d2                	xor    %edx,%edx
  80296f:	83 c4 14             	add    $0x14,%esp
  802972:	5e                   	pop    %esi
  802973:	5f                   	pop    %edi
  802974:	5d                   	pop    %ebp
  802975:	c3                   	ret    
  802976:	66 90                	xchg   %ax,%ax
  802978:	39 f8                	cmp    %edi,%eax
  80297a:	77 54                	ja     8029d0 <__umoddi3+0xa0>
  80297c:	0f bd e8             	bsr    %eax,%ebp
  80297f:	83 f5 1f             	xor    $0x1f,%ebp
  802982:	75 5c                	jne    8029e0 <__umoddi3+0xb0>
  802984:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802988:	39 3c 24             	cmp    %edi,(%esp)
  80298b:	0f 87 e7 00 00 00    	ja     802a78 <__umoddi3+0x148>
  802991:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802995:	29 f1                	sub    %esi,%ecx
  802997:	19 c7                	sbb    %eax,%edi
  802999:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80299d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8029a9:	83 c4 14             	add    $0x14,%esp
  8029ac:	5e                   	pop    %esi
  8029ad:	5f                   	pop    %edi
  8029ae:	5d                   	pop    %ebp
  8029af:	c3                   	ret    
  8029b0:	85 f6                	test   %esi,%esi
  8029b2:	89 f5                	mov    %esi,%ebp
  8029b4:	75 0b                	jne    8029c1 <__umoddi3+0x91>
  8029b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bb:	31 d2                	xor    %edx,%edx
  8029bd:	f7 f6                	div    %esi
  8029bf:	89 c5                	mov    %eax,%ebp
  8029c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029c5:	31 d2                	xor    %edx,%edx
  8029c7:	f7 f5                	div    %ebp
  8029c9:	89 c8                	mov    %ecx,%eax
  8029cb:	f7 f5                	div    %ebp
  8029cd:	eb 9c                	jmp    80296b <__umoddi3+0x3b>
  8029cf:	90                   	nop
  8029d0:	89 c8                	mov    %ecx,%eax
  8029d2:	89 fa                	mov    %edi,%edx
  8029d4:	83 c4 14             	add    $0x14,%esp
  8029d7:	5e                   	pop    %esi
  8029d8:	5f                   	pop    %edi
  8029d9:	5d                   	pop    %ebp
  8029da:	c3                   	ret    
  8029db:	90                   	nop
  8029dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029e0:	8b 04 24             	mov    (%esp),%eax
  8029e3:	be 20 00 00 00       	mov    $0x20,%esi
  8029e8:	89 e9                	mov    %ebp,%ecx
  8029ea:	29 ee                	sub    %ebp,%esi
  8029ec:	d3 e2                	shl    %cl,%edx
  8029ee:	89 f1                	mov    %esi,%ecx
  8029f0:	d3 e8                	shr    %cl,%eax
  8029f2:	89 e9                	mov    %ebp,%ecx
  8029f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f8:	8b 04 24             	mov    (%esp),%eax
  8029fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8029ff:	89 fa                	mov    %edi,%edx
  802a01:	d3 e0                	shl    %cl,%eax
  802a03:	89 f1                	mov    %esi,%ecx
  802a05:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a09:	8b 44 24 10          	mov    0x10(%esp),%eax
  802a0d:	d3 ea                	shr    %cl,%edx
  802a0f:	89 e9                	mov    %ebp,%ecx
  802a11:	d3 e7                	shl    %cl,%edi
  802a13:	89 f1                	mov    %esi,%ecx
  802a15:	d3 e8                	shr    %cl,%eax
  802a17:	89 e9                	mov    %ebp,%ecx
  802a19:	09 f8                	or     %edi,%eax
  802a1b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802a1f:	f7 74 24 04          	divl   0x4(%esp)
  802a23:	d3 e7                	shl    %cl,%edi
  802a25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a29:	89 d7                	mov    %edx,%edi
  802a2b:	f7 64 24 08          	mull   0x8(%esp)
  802a2f:	39 d7                	cmp    %edx,%edi
  802a31:	89 c1                	mov    %eax,%ecx
  802a33:	89 14 24             	mov    %edx,(%esp)
  802a36:	72 2c                	jb     802a64 <__umoddi3+0x134>
  802a38:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802a3c:	72 22                	jb     802a60 <__umoddi3+0x130>
  802a3e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802a42:	29 c8                	sub    %ecx,%eax
  802a44:	19 d7                	sbb    %edx,%edi
  802a46:	89 e9                	mov    %ebp,%ecx
  802a48:	89 fa                	mov    %edi,%edx
  802a4a:	d3 e8                	shr    %cl,%eax
  802a4c:	89 f1                	mov    %esi,%ecx
  802a4e:	d3 e2                	shl    %cl,%edx
  802a50:	89 e9                	mov    %ebp,%ecx
  802a52:	d3 ef                	shr    %cl,%edi
  802a54:	09 d0                	or     %edx,%eax
  802a56:	89 fa                	mov    %edi,%edx
  802a58:	83 c4 14             	add    $0x14,%esp
  802a5b:	5e                   	pop    %esi
  802a5c:	5f                   	pop    %edi
  802a5d:	5d                   	pop    %ebp
  802a5e:	c3                   	ret    
  802a5f:	90                   	nop
  802a60:	39 d7                	cmp    %edx,%edi
  802a62:	75 da                	jne    802a3e <__umoddi3+0x10e>
  802a64:	8b 14 24             	mov    (%esp),%edx
  802a67:	89 c1                	mov    %eax,%ecx
  802a69:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802a6d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802a71:	eb cb                	jmp    802a3e <__umoddi3+0x10e>
  802a73:	90                   	nop
  802a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a78:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802a7c:	0f 82 0f ff ff ff    	jb     802991 <__umoddi3+0x61>
  802a82:	e9 1a ff ff ff       	jmp    8029a1 <__umoddi3+0x71>
