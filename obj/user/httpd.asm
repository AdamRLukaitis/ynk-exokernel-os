
obj/user/httpd.debug:     file format elf32-i386


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
  80002c:	e8 4c 08 00 00       	call   80087d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <die>:
	{404, "Not Found"},
};

static void
die(char *m)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("%s\n", m);
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  800051:	e8 8b 09 00 00       	call   8009e1 <cprintf>
	exit();
  800056:	e8 74 08 00 00       	call   8008cf <exit>
}
  80005b:	c9                   	leave  
  80005c:	c3                   	ret    

0080005d <send_error>:
	return 0;
}

static int
send_error(struct http_request *req, int code)
{
  80005d:	55                   	push   %ebp
  80005e:	89 e5                	mov    %esp,%ebp
  800060:	57                   	push   %edi
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	81 ec 2c 02 00 00    	sub    $0x22c,%esp
  800069:	89 c6                	mov    %eax,%esi
	char buf[512];
	int r;

	struct error_messages *e = errors;
  80006b:	b9 00 40 80 00       	mov    $0x804000,%ecx
	while (e->code != 0 && e->msg != 0) {
  800070:	eb 07                	jmp    800079 <send_error+0x1c>
		if (e->code == code)
  800072:	39 d3                	cmp    %edx,%ebx
  800074:	74 11                	je     800087 <send_error+0x2a>
			break;
		e++;
  800076:	83 c1 08             	add    $0x8,%ecx
{
	char buf[512];
	int r;

	struct error_messages *e = errors;
	while (e->code != 0 && e->msg != 0) {
  800079:	8b 19                	mov    (%ecx),%ebx
  80007b:	85 db                	test   %ebx,%ebx
  80007d:	74 5d                	je     8000dc <send_error+0x7f>
  80007f:	83 79 04 00          	cmpl   $0x0,0x4(%ecx)
  800083:	75 ed                	jne    800072 <send_error+0x15>
  800085:	eb 04                	jmp    80008b <send_error+0x2e>
		if (e->code == code)
			break;
		e++;
	}

	if (e->code == 0)
  800087:	85 db                	test   %ebx,%ebx
  800089:	74 58                	je     8000e3 <send_error+0x86>
		return -1;

	r = snprintf(buf, 512, "HTTP/" HTTP_VERSION" %d %s\r\n"
  80008b:	8b 41 04             	mov    0x4(%ecx),%eax
  80008e:	89 44 24 18          	mov    %eax,0x18(%esp)
  800092:	89 5c 24 14          	mov    %ebx,0x14(%esp)
  800096:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009e:	c7 44 24 08 2c 31 80 	movl   $0x80312c,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  8000ad:	00 
  8000ae:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
  8000b4:	89 3c 24             	mov    %edi,(%esp)
  8000b7:	e8 de 0e 00 00       	call   800f9a <snprintf>
  8000bc:	89 c3                	mov    %eax,%ebx
			       "Content-type: text/html\r\n"
			       "\r\n"
			       "<html><body><p>%d - %s</p></body></html>\r\n",
			       e->code, e->msg, e->code, e->msg);

	if (write(req->sock, buf, r) != r)
  8000be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000c6:	8b 06                	mov    (%esi),%eax
  8000c8:	89 04 24             	mov    %eax,(%esp)
  8000cb:	e8 67 1a 00 00       	call   801b37 <write>
  8000d0:	39 c3                	cmp    %eax,%ebx
  8000d2:	0f 95 c0             	setne  %al
  8000d5:	0f b6 c0             	movzbl %al,%eax
  8000d8:	f7 d8                	neg    %eax
  8000da:	eb 0c                	jmp    8000e8 <send_error+0x8b>
			break;
		e++;
	}

	if (e->code == 0)
		return -1;
  8000dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8000e1:	eb 05                	jmp    8000e8 <send_error+0x8b>
  8000e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

	if (write(req->sock, buf, r) != r)
		return -1;

	return 0;
}
  8000e8:	81 c4 2c 02 00 00    	add    $0x22c,%esp
  8000ee:	5b                   	pop    %ebx
  8000ef:	5e                   	pop    %esi
  8000f0:	5f                   	pop    %edi
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <handle_client>:
	return r;
}

static void
handle_client(int sock)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	57                   	push   %edi
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	81 ec cc 0a 00 00    	sub    $0xacc,%esp
  8000ff:	89 c6                	mov    %eax,%esi
	struct http_request *req = &con_d;

	while (1)
	{
		// Receive message
		if ((received = read(sock, buffer, BUFFSIZE)) < 0)
  800101:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800108:	00 
  800109:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80010f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800113:	89 34 24             	mov    %esi,(%esp)
  800116:	e8 3f 19 00 00       	call   801a5a <read>
  80011b:	85 c0                	test   %eax,%eax
  80011d:	79 1c                	jns    80013b <handle_client+0x48>
			panic("failed to read");
  80011f:	c7 44 24 08 84 30 80 	movl   $0x803084,0x8(%esp)
  800126:	00 
  800127:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  80012e:	00 
  80012f:	c7 04 24 93 30 80 00 	movl   $0x803093,(%esp)
  800136:	e8 ad 07 00 00       	call   8008e8 <_panic>

		memset(req, 0, sizeof(req));
  80013b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80014a:	00 
  80014b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80014e:	89 04 24             	mov    %eax,(%esp)
  800151:	e8 01 10 00 00       	call   801157 <memset>

		req->sock = sock;
  800156:	89 75 dc             	mov    %esi,-0x24(%ebp)
	int url_len, version_len;

	if (!req)
		return -1;

	if (strncmp(request, "GET ", 4) != 0)
  800159:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800160:	00 
  800161:	c7 44 24 04 a0 30 80 	movl   $0x8030a0,0x4(%esp)
  800168:	00 
  800169:	8d 85 dc fd ff ff    	lea    -0x224(%ebp),%eax
  80016f:	89 04 24             	mov    %eax,(%esp)
  800172:	e8 6b 0f 00 00       	call   8010e2 <strncmp>
  800177:	85 c0                	test   %eax,%eax
  800179:	0f 85 81 02 00 00    	jne    800400 <handle_client+0x30d>
		return -E_BAD_REQ;

	// skip GET
	request += 4;
  80017f:	8d 9d e0 fd ff ff    	lea    -0x220(%ebp),%ebx
  800185:	eb 03                	jmp    80018a <handle_client+0x97>

	// get the url
	url = request;
	while (*request && *request != ' ')
		request++;
  800187:	83 c3 01             	add    $0x1,%ebx
	// skip GET
	request += 4;

	// get the url
	url = request;
	while (*request && *request != ' ')
  80018a:	f6 03 df             	testb  $0xdf,(%ebx)
  80018d:	75 f8                	jne    800187 <handle_client+0x94>
		request++;
	url_len = request - url;
  80018f:	89 df                	mov    %ebx,%edi
  800191:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
  800197:	29 c7                	sub    %eax,%edi

	req->url = malloc(url_len + 1);
  800199:	8d 47 01             	lea    0x1(%edi),%eax
  80019c:	89 04 24             	mov    %eax,(%esp)
  80019f:	e8 0e 24 00 00       	call   8025b2 <malloc>
  8001a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	memmove(req->url, url, url_len);
  8001a7:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001ab:	8d 8d e0 fd ff ff    	lea    -0x220(%ebp),%ecx
  8001b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8001b5:	89 04 24             	mov    %eax,(%esp)
  8001b8:	e8 e7 0f 00 00       	call   8011a4 <memmove>
	req->url[url_len] = '\0';
  8001bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c0:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)

	// skip space
	request++;
  8001c4:	83 c3 01             	add    $0x1,%ebx
  8001c7:	89 d8                	mov    %ebx,%eax
  8001c9:	eb 03                	jmp    8001ce <handle_client+0xdb>

	version = request;
	while (*request && *request != '\n')
		request++;
  8001cb:	83 c0 01             	add    $0x1,%eax

	// skip space
	request++;

	version = request;
	while (*request && *request != '\n')
  8001ce:	0f b6 10             	movzbl (%eax),%edx
  8001d1:	80 fa 0a             	cmp    $0xa,%dl
  8001d4:	74 04                	je     8001da <handle_client+0xe7>
  8001d6:	84 d2                	test   %dl,%dl
  8001d8:	75 f1                	jne    8001cb <handle_client+0xd8>
		request++;
	version_len = request - version;
  8001da:	29 d8                	sub    %ebx,%eax
  8001dc:	89 c7                	mov    %eax,%edi

	req->version = malloc(version_len + 1);
  8001de:	8d 40 01             	lea    0x1(%eax),%eax
  8001e1:	89 04 24             	mov    %eax,(%esp)
  8001e4:	e8 c9 23 00 00       	call   8025b2 <malloc>
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	memmove(req->version, version, version_len);
  8001ec:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8001f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 a8 0f 00 00       	call   8011a4 <memmove>
	req->version[version_len] = '\0';
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	c6 04 38 00          	movb   $0x0,(%eax,%edi,1)
	// set file_size to the size of the file

	// LAB 6: Your code here.

	//panic("send_file not implemented");
	if((r = stat(req->url,&file_stats))<0)
  800203:	8d 85 50 f5 ff ff    	lea    -0xab0(%ebp),%eax
  800209:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800210:	89 04 24             	mov    %eax,(%esp)
  800213:	e8 d8 1a 00 00       	call   801cf0 <stat>
  800218:	85 c0                	test   %eax,%eax
  80021a:	79 12                	jns    80022e <handle_client+0x13b>
	{
		send_error(req,404);
  80021c:	ba 94 01 00 00       	mov    $0x194,%edx
  800221:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800224:	e8 34 fe ff ff       	call   80005d <send_error>
  800229:	e9 b2 01 00 00       	jmp    8003e0 <handle_client+0x2ed>
		goto end;
	}
	if(file_stats.st_isdir)
  80022e:	83 bd d4 f5 ff ff 00 	cmpl   $0x0,-0xa2c(%ebp)
  800235:	74 12                	je     800249 <handle_client+0x156>
	{
		send_error(req,404);
  800237:	ba 94 01 00 00       	mov    $0x194,%edx
  80023c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80023f:	e8 19 fe ff ff       	call   80005d <send_error>
  800244:	e9 97 01 00 00       	jmp    8003e0 <handle_client+0x2ed>
		goto end;
	}
	file_size = file_stats.st_size;
  800249:	8b 85 d0 f5 ff ff    	mov    -0xa30(%ebp),%eax
  80024f:	89 85 44 f5 ff ff    	mov    %eax,-0xabc(%ebp)
}

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
  800255:	bb 10 40 80 00       	mov    $0x804010,%ebx
  80025a:	eb 0a                	jmp    800266 <handle_client+0x173>
	while (h->code != 0 && h->header!= 0) {
		if (h->code == code)
  80025c:	3d c8 00 00 00       	cmp    $0xc8,%eax
  800261:	74 13                	je     800276 <handle_client+0x183>
			break;
		h++;
  800263:	83 c3 08             	add    $0x8,%ebx

static int
send_header(struct http_request *req, int code)
{
	struct responce_header *h = headers;
	while (h->code != 0 && h->header!= 0) {
  800266:	8b 03                	mov    (%ebx),%eax
  800268:	85 c0                	test   %eax,%eax
  80026a:	0f 84 70 01 00 00    	je     8003e0 <handle_client+0x2ed>
  800270:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
  800274:	75 e6                	jne    80025c <handle_client+0x169>
	}

	if (h->code == 0)
		return -1;

	int len = strlen(h->header);
  800276:	8b 43 04             	mov    0x4(%ebx),%eax
  800279:	89 04 24             	mov    %eax,(%esp)
  80027c:	e8 4f 0d 00 00       	call   800fd0 <strlen>
  800281:	89 c7                	mov    %eax,%edi
	if (write(req->sock, h->header, len) != len) {
  800283:	89 44 24 08          	mov    %eax,0x8(%esp)
  800287:	8b 43 04             	mov    0x4(%ebx),%eax
  80028a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800291:	89 04 24             	mov    %eax,(%esp)
  800294:	e8 9e 18 00 00       	call   801b37 <write>
  800299:	39 c7                	cmp    %eax,%edi
  80029b:	0f 84 6e 01 00 00    	je     80040f <handle_client+0x31c>
		die("Failed to send bytes to client");
  8002a1:	b8 a8 31 80 00       	mov    $0x8031a8,%eax
  8002a6:	e8 95 fd ff ff       	call   800040 <die>
  8002ab:	e9 5f 01 00 00       	jmp    80040f <handle_client+0x31c>
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
	if (r > 63)
		panic("buffer too small!");
  8002b0:	c7 44 24 08 a5 30 80 	movl   $0x8030a5,0x8(%esp)
  8002b7:	00 
  8002b8:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8002bf:	00 
  8002c0:	c7 04 24 93 30 80 00 	movl   $0x803093,(%esp)
  8002c7:	e8 1c 06 00 00       	call   8008e8 <_panic>

	if (write(req->sock, buf, r) != r)
  8002cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002d0:	8d 85 dc f5 ff ff    	lea    -0xa24(%ebp),%eax
  8002d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002dd:	89 04 24             	mov    %eax,(%esp)
  8002e0:	e8 52 18 00 00       	call   801b37 <write>
	}
	file_size = file_stats.st_size;
	if ((r = send_header(req, 200)) < 0)
		goto end;

	if ((r = send_size(req, file_size)) < 0)
  8002e5:	39 c3                	cmp    %eax,%ebx
  8002e7:	0f 85 f3 00 00 00    	jne    8003e0 <handle_client+0x2ed>

	type = mime_type(req->url);
	if (!type)
		return -1;

	r = snprintf(buf, 128, "Content-Type: %s\r\n", type);
  8002ed:	c7 44 24 0c b7 30 80 	movl   $0x8030b7,0xc(%esp)
  8002f4:	00 
  8002f5:	c7 44 24 08 c1 30 80 	movl   $0x8030c1,0x8(%esp)
  8002fc:	00 
  8002fd:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
  800304:	00 
  800305:	8d 85 dc f5 ff ff    	lea    -0xa24(%ebp),%eax
  80030b:	89 04 24             	mov    %eax,(%esp)
  80030e:	e8 87 0c 00 00       	call   800f9a <snprintf>
  800313:	89 c3                	mov    %eax,%ebx
	if (r > 127)
  800315:	83 f8 7f             	cmp    $0x7f,%eax
  800318:	7e 1c                	jle    800336 <handle_client+0x243>
		panic("buffer too small!");
  80031a:	c7 44 24 08 a5 30 80 	movl   $0x8030a5,0x8(%esp)
  800321:	00 
  800322:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
  800329:	00 
  80032a:	c7 04 24 93 30 80 00 	movl   $0x803093,(%esp)
  800331:	e8 b2 05 00 00       	call   8008e8 <_panic>

	if (write(req->sock, buf, r) != r)
  800336:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033a:	8d 85 dc f5 ff ff    	lea    -0xa24(%ebp),%eax
  800340:	89 44 24 04          	mov    %eax,0x4(%esp)
  800344:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800347:	89 04 24             	mov    %eax,(%esp)
  80034a:	e8 e8 17 00 00       	call   801b37 <write>
		goto end;

	if ((r = send_size(req, file_size)) < 0)
		goto end;

	if ((r = send_content_type(req)) < 0)
  80034f:	39 c3                	cmp    %eax,%ebx
  800351:	0f 85 89 00 00 00    	jne    8003e0 <handle_client+0x2ed>

static int
send_header_fin(struct http_request *req)
{
	const char *fin = "\r\n";
	int fin_len = strlen(fin);
  800357:	c7 04 24 f1 30 80 00 	movl   $0x8030f1,(%esp)
  80035e:	e8 6d 0c 00 00       	call   800fd0 <strlen>
  800363:	89 c3                	mov    %eax,%ebx

	if (write(req->sock, fin, fin_len) != fin_len)
  800365:	89 44 24 08          	mov    %eax,0x8(%esp)
  800369:	c7 44 24 04 f1 30 80 	movl   $0x8030f1,0x4(%esp)
  800370:	00 
  800371:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800374:	89 04 24             	mov    %eax,(%esp)
  800377:	e8 bb 17 00 00       	call   801b37 <write>
		goto end;

	if ((r = send_content_type(req)) < 0)
		goto end;

	if ((r = send_header_fin(req)) < 0)
  80037c:	39 c3                	cmp    %eax,%ebx
  80037e:	75 60                	jne    8003e0 <handle_client+0x2ed>
{
	// LAB 6: Your code here.
	//panic("send_data not implemented");
	
	char buf[2048];
	int fd = open(req->url,O_RDONLY);
  800380:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800387:	00 
  800388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80038b:	89 04 24             	mov    %eax,(%esp)
  80038e:	e8 a0 1b 00 00       	call   801f33 <open>
  800393:	89 c7                	mov    %eax,%edi
	cprintf("fd is %d\n",fd);
  800395:	89 44 24 04          	mov    %eax,0x4(%esp)
  800399:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  8003a0:	e8 3c 06 00 00       	call   8009e1 <cprintf>
	int  l;
	while( (l = (read(fd,buf,1518)))>0)
  8003a5:	8d 9d dc f5 ff ff    	lea    -0xa24(%ebp),%ebx
  8003ab:	eb 13                	jmp    8003c0 <handle_client+0x2cd>
	{
		write(req->sock,buf,l);
  8003ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003b8:	89 04 24             	mov    %eax,(%esp)
  8003bb:	e8 77 17 00 00       	call   801b37 <write>
	
	char buf[2048];
	int fd = open(req->url,O_RDONLY);
	cprintf("fd is %d\n",fd);
	int  l;
	while( (l = (read(fd,buf,1518)))>0)
  8003c0:	c7 44 24 08 ee 05 00 	movl   $0x5ee,0x8(%esp)
  8003c7:	00 
  8003c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003cc:	89 3c 24             	mov    %edi,(%esp)
  8003cf:	e8 86 16 00 00       	call   801a5a <read>
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	7f d5                	jg     8003ad <handle_client+0x2ba>
	{
		write(req->sock,buf,l);
		
	}
	close(fd);
  8003d8:	89 3c 24             	mov    %edi,(%esp)
  8003db:	e8 17 15 00 00       	call   8018f7 <close>
}

static void
req_free(struct http_request *req)
{
	free(req->url);
  8003e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e3:	89 04 24             	mov    %eax,(%esp)
  8003e6:	e8 f5 20 00 00       	call   8024e0 <free>
	free(req->version);
  8003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ee:	89 04 24             	mov    %eax,(%esp)
  8003f1:	e8 ea 20 00 00       	call   8024e0 <free>

		// no keep alive
		break;
	}

	close(sock);
  8003f6:	89 34 24             	mov    %esi,(%esp)
  8003f9:	e8 f9 14 00 00       	call   8018f7 <close>
  8003fe:	eb 47                	jmp    800447 <handle_client+0x354>

		req->sock = sock;

		r = http_request_parse(req, buffer);
		if (r == -E_BAD_REQ)
			send_error(req, 400);
  800400:	ba 90 01 00 00       	mov    $0x190,%edx
  800405:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800408:	e8 50 fc ff ff       	call   80005d <send_error>
  80040d:	eb d1                	jmp    8003e0 <handle_client+0x2ed>
send_size(struct http_request *req, off_t size)
{
	char buf[64];
	int r;

	r = snprintf(buf, 64, "Content-Length: %ld\r\n", (long)size);
  80040f:	8b 85 44 f5 ff ff    	mov    -0xabc(%ebp),%eax
  800415:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800419:	c7 44 24 08 de 30 80 	movl   $0x8030de,0x8(%esp)
  800420:	00 
  800421:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800428:	00 
  800429:	8d 85 dc f5 ff ff    	lea    -0xa24(%ebp),%eax
  80042f:	89 04 24             	mov    %eax,(%esp)
  800432:	e8 63 0b 00 00       	call   800f9a <snprintf>
  800437:	89 c3                	mov    %eax,%ebx
	if (r > 63)
  800439:	83 f8 3f             	cmp    $0x3f,%eax
  80043c:	0f 8e 8a fe ff ff    	jle    8002cc <handle_client+0x1d9>
  800442:	e9 69 fe ff ff       	jmp    8002b0 <handle_client+0x1bd>
		// no keep alive
		break;
	}

	close(sock);
}
  800447:	81 c4 cc 0a 00 00    	add    $0xacc,%esp
  80044d:	5b                   	pop    %ebx
  80044e:	5e                   	pop    %esi
  80044f:	5f                   	pop    %edi
  800450:	5d                   	pop    %ebp
  800451:	c3                   	ret    

00800452 <umain>:

void
umain(int argc, char **argv)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
  800455:	57                   	push   %edi
  800456:	56                   	push   %esi
  800457:	53                   	push   %ebx
  800458:	83 ec 4c             	sub    $0x4c,%esp
	int serversock, clientsock;
	struct sockaddr_in server, client;

	binaryname = "jhttpd";
  80045b:	c7 05 20 40 80 00 f4 	movl   $0x8030f4,0x804020
  800462:	30 80 00 

	// Create the TCP socket
	if ((serversock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
  800465:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80046c:	00 
  80046d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800474:	00 
  800475:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80047c:	e8 76 1d 00 00       	call   8021f7 <socket>
  800481:	89 c6                	mov    %eax,%esi
  800483:	85 c0                	test   %eax,%eax
  800485:	79 0a                	jns    800491 <umain+0x3f>
		die("Failed to create socket");
  800487:	b8 fb 30 80 00       	mov    $0x8030fb,%eax
  80048c:	e8 af fb ff ff       	call   800040 <die>

	// Construct the server sockaddr_in structure
	memset(&server, 0, sizeof(server));		// Clear struct
  800491:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  800498:	00 
  800499:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004a0:	00 
  8004a1:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8004a4:	89 1c 24             	mov    %ebx,(%esp)
  8004a7:	e8 ab 0c 00 00       	call   801157 <memset>
	server.sin_family = AF_INET;			// Internet/IP
  8004ac:	c6 45 d9 02          	movb   $0x2,-0x27(%ebp)
	server.sin_addr.s_addr = htonl(INADDR_ANY);	// IP address
  8004b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004b7:	e8 74 01 00 00       	call   800630 <htonl>
  8004bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
	server.sin_port = htons(PORT);			// server port
  8004bf:	c7 04 24 50 00 00 00 	movl   $0x50,(%esp)
  8004c6:	e8 4b 01 00 00       	call   800616 <htons>
  8004cb:	66 89 45 da          	mov    %ax,-0x26(%ebp)

	// Bind the server socket
	if (bind(serversock, (struct sockaddr *) &server,
  8004cf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
  8004d6:	00 
  8004d7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004db:	89 34 24             	mov    %esi,(%esp)
  8004de:	e8 72 1c 00 00       	call   802155 <bind>
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	79 0a                	jns    8004f1 <umain+0x9f>
		 sizeof(server)) < 0)
	{
		die("Failed to bind the server socket");
  8004e7:	b8 c8 31 80 00       	mov    $0x8031c8,%eax
  8004ec:	e8 4f fb ff ff       	call   800040 <die>
	}

	// Listen on the server socket
	if (listen(serversock, MAXPENDING) < 0)
  8004f1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  8004f8:	00 
  8004f9:	89 34 24             	mov    %esi,(%esp)
  8004fc:	e8 d1 1c 00 00       	call   8021d2 <listen>
  800501:	85 c0                	test   %eax,%eax
  800503:	79 0a                	jns    80050f <umain+0xbd>
		die("Failed to listen on server socket");
  800505:	b8 ec 31 80 00       	mov    $0x8031ec,%eax
  80050a:	e8 31 fb ff ff       	call   800040 <die>

	cprintf("Waiting for http connections...\n");
  80050f:	c7 04 24 10 32 80 00 	movl   $0x803210,(%esp)
  800516:	e8 c6 04 00 00       	call   8009e1 <cprintf>

	while (1) {
		unsigned int clientlen = sizeof(client);
		// Wait for client connection
		if ((clientsock = accept(serversock,
  80051b:	8d 7d c4             	lea    -0x3c(%ebp),%edi
		die("Failed to listen on server socket");

	cprintf("Waiting for http connections...\n");

	while (1) {
		unsigned int clientlen = sizeof(client);
  80051e:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
		// Wait for client connection
		if ((clientsock = accept(serversock,
  800525:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800529:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80052c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800530:	89 34 24             	mov    %esi,(%esp)
  800533:	e8 e2 1b 00 00       	call   80211a <accept>
  800538:	89 c3                	mov    %eax,%ebx
  80053a:	85 c0                	test   %eax,%eax
  80053c:	79 0a                	jns    800548 <umain+0xf6>
					 (struct sockaddr *) &client,
					 &clientlen)) < 0)
		{
			die("Failed to accept client connection");
  80053e:	b8 34 32 80 00       	mov    $0x803234,%eax
  800543:	e8 f8 fa ff ff       	call   800040 <die>
		}
		handle_client(clientsock);
  800548:	89 d8                	mov    %ebx,%eax
  80054a:	e8 a4 fb ff ff       	call   8000f3 <handle_client>
	}
  80054f:	eb cd                	jmp    80051e <umain+0xcc>
  800551:	66 90                	xchg   %ax,%ax
  800553:	66 90                	xchg   %ax,%ax
  800555:	66 90                	xchg   %ax,%ax
  800557:	66 90                	xchg   %ax,%ax
  800559:	66 90                	xchg   %ax,%ax
  80055b:	66 90                	xchg   %ax,%ax
  80055d:	66 90                	xchg   %ax,%ax
  80055f:	90                   	nop

00800560 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	57                   	push   %edi
  800564:	56                   	push   %esi
  800565:	53                   	push   %ebx
  800566:	83 ec 19             	sub    $0x19,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  80056f:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  800573:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  u8_t *ap;
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  800576:	c7 45 dc 00 50 80 00 	movl   $0x805000,-0x24(%ebp)
 */
char *
inet_ntoa(struct in_addr addr)
{
  static char str[16];
  u32_t s_addr = addr.s_addr;
  80057d:	be 00 00 00 00       	mov    $0x0,%esi
  800582:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800585:	eb 02                	jmp    800589 <inet_ntoa+0x29>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  800587:	89 ce                	mov    %ecx,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  800589:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80058c:	0f b6 17             	movzbl (%edi),%edx
      *ap /= (u8_t)10;
  80058f:	0f b6 c2             	movzbl %dl,%eax
  800592:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
  800595:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
  800598:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80059b:	66 c1 e8 0b          	shr    $0xb,%ax
  80059f:	88 07                	mov    %al,(%edi)
      inv[i++] = '0' + rem;
  8005a1:	8d 4e 01             	lea    0x1(%esi),%ecx
  8005a4:	89 f3                	mov    %esi,%ebx
  8005a6:	0f b6 f3             	movzbl %bl,%esi
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  8005a9:	8d 3c 80             	lea    (%eax,%eax,4),%edi
  8005ac:	01 ff                	add    %edi,%edi
  8005ae:	89 fb                	mov    %edi,%ebx
  8005b0:	29 da                	sub    %ebx,%edx
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
  8005b2:	83 c2 30             	add    $0x30,%edx
  8005b5:	88 54 35 ed          	mov    %dl,-0x13(%ebp,%esi,1)
    } while(*ap);
  8005b9:	84 c0                	test   %al,%al
  8005bb:	75 ca                	jne    800587 <inet_ntoa+0x27>
  8005bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005c0:	89 c8                	mov    %ecx,%eax
  8005c2:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005c5:	89 cf                	mov    %ecx,%edi
  8005c7:	eb 0d                	jmp    8005d6 <inet_ntoa+0x76>
    while(i--)
      *rp++ = inv[i];
  8005c9:	0f b6 f0             	movzbl %al,%esi
  8005cc:	0f b6 4c 35 ed       	movzbl -0x13(%ebp,%esi,1),%ecx
  8005d1:	88 0a                	mov    %cl,(%edx)
  8005d3:	83 c2 01             	add    $0x1,%edx
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  8005d6:	83 e8 01             	sub    $0x1,%eax
  8005d9:	3c ff                	cmp    $0xff,%al
  8005db:	75 ec                	jne    8005c9 <inet_ntoa+0x69>
  8005dd:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  8005e0:	89 f9                	mov    %edi,%ecx
  8005e2:	0f b6 c9             	movzbl %cl,%ecx
  8005e5:	03 4d dc             	add    -0x24(%ebp),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  8005e8:	8d 41 01             	lea    0x1(%ecx),%eax
  8005eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
    ap++;
  8005ee:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  8005f2:	80 45 db 01          	addb   $0x1,-0x25(%ebp)
  8005f6:	80 7d db 03          	cmpb   $0x3,-0x25(%ebp)
  8005fa:	77 0a                	ja     800606 <inet_ntoa+0xa6>
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
  8005fc:	c6 01 2e             	movb   $0x2e,(%ecx)
  8005ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  800604:	eb 81                	jmp    800587 <inet_ntoa+0x27>
    ap++;
  }
  *--rp = 0;
  800606:	c6 01 00             	movb   $0x0,(%ecx)
  return str;
}
  800609:	b8 00 50 80 00       	mov    $0x805000,%eax
  80060e:	83 c4 19             	add    $0x19,%esp
  800611:	5b                   	pop    %ebx
  800612:	5e                   	pop    %esi
  800613:	5f                   	pop    %edi
  800614:	5d                   	pop    %ebp
  800615:	c3                   	ret    

00800616 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800619:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80061d:	66 c1 c0 08          	rol    $0x8,%ax
}
  800621:	5d                   	pop    %ebp
  800622:	c3                   	ret    

00800623 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
  800626:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80062a:	66 c1 c0 08          	rol    $0x8,%ax
 */
u16_t
ntohs(u16_t n)
{
  return htons(n);
}
  80062e:	5d                   	pop    %ebp
  80062f:	c3                   	ret    

00800630 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	8b 55 08             	mov    0x8(%ebp),%edx
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
  800636:	89 d1                	mov    %edx,%ecx
  800638:	c1 e9 18             	shr    $0x18,%ecx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  80063b:	89 d0                	mov    %edx,%eax
  80063d:	c1 e0 18             	shl    $0x18,%eax
  800640:	09 c8                	or     %ecx,%eax
    ((n & 0xff00) << 8) |
  800642:	89 d1                	mov    %edx,%ecx
  800644:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80064a:	c1 e1 08             	shl    $0x8,%ecx
  80064d:	09 c8                	or     %ecx,%eax
    ((n & 0xff0000UL) >> 8) |
  80064f:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  800655:	c1 ea 08             	shr    $0x8,%edx
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  return ((n & 0xff) << 24) |
  800658:	09 d0                	or     %edx,%eax
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80065a:	5d                   	pop    %ebp
  80065b:	c3                   	ret    

0080065c <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  80065c:	55                   	push   %ebp
  80065d:	89 e5                	mov    %esp,%ebp
  80065f:	57                   	push   %edi
  800660:	56                   	push   %esi
  800661:	53                   	push   %ebx
  800662:	83 ec 20             	sub    $0x20,%esp
  800665:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  800668:	0f be 10             	movsbl (%eax),%edx
inet_aton(const char *cp, struct in_addr *addr)
{
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;
  80066b:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80066e:	89 75 d8             	mov    %esi,-0x28(%ebp)
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  800671:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800674:	80 f9 09             	cmp    $0x9,%cl
  800677:	0f 87 a6 01 00 00    	ja     800823 <inet_aton+0x1c7>
      return (0);
    val = 0;
    base = 10;
  80067d:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
    if (c == '0') {
  800684:	83 fa 30             	cmp    $0x30,%edx
  800687:	75 2b                	jne    8006b4 <inet_aton+0x58>
      c = *++cp;
  800689:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      if (c == 'x' || c == 'X') {
  80068d:	89 d1                	mov    %edx,%ecx
  80068f:	83 e1 df             	and    $0xffffffdf,%ecx
  800692:	80 f9 58             	cmp    $0x58,%cl
  800695:	74 0f                	je     8006a6 <inet_aton+0x4a>
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
  800697:	83 c0 01             	add    $0x1,%eax
  80069a:	0f be d2             	movsbl %dl,%edx
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
      } else
        base = 8;
  80069d:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  8006a4:	eb 0e                	jmp    8006b4 <inet_aton+0x58>
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
        c = *++cp;
  8006a6:	0f be 50 02          	movsbl 0x2(%eax),%edx
  8006aa:	8d 40 02             	lea    0x2(%eax),%eax
    val = 0;
    base = 10;
    if (c == '0') {
      c = *++cp;
      if (c == 'x' || c == 'X') {
        base = 16;
  8006ad:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  8006b4:	83 c0 01             	add    $0x1,%eax
  8006b7:	bf 00 00 00 00       	mov    $0x0,%edi
  8006bc:	eb 03                	jmp    8006c1 <inet_aton+0x65>
  8006be:	83 c0 01             	add    $0x1,%eax
  8006c1:	8d 70 ff             	lea    -0x1(%eax),%esi
        c = *++cp;
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8006c4:	89 d3                	mov    %edx,%ebx
  8006c6:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8006c9:	80 f9 09             	cmp    $0x9,%cl
  8006cc:	77 0d                	ja     8006db <inet_aton+0x7f>
        val = (val * base) + (int)(c - '0');
  8006ce:	0f af 7d e0          	imul   -0x20(%ebp),%edi
  8006d2:	8d 7c 3a d0          	lea    -0x30(%edx,%edi,1),%edi
        c = *++cp;
  8006d6:	0f be 10             	movsbl (%eax),%edx
  8006d9:	eb e3                	jmp    8006be <inet_aton+0x62>
      } else if (base == 16 && isxdigit(c)) {
  8006db:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  8006df:	75 30                	jne    800711 <inet_aton+0xb5>
  8006e1:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
  8006e4:	88 4d df             	mov    %cl,-0x21(%ebp)
  8006e7:	89 d1                	mov    %edx,%ecx
  8006e9:	83 e1 df             	and    $0xffffffdf,%ecx
  8006ec:	83 e9 41             	sub    $0x41,%ecx
  8006ef:	80 f9 05             	cmp    $0x5,%cl
  8006f2:	77 23                	ja     800717 <inet_aton+0xbb>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8006f4:	89 fb                	mov    %edi,%ebx
  8006f6:	c1 e3 04             	shl    $0x4,%ebx
  8006f9:	8d 7a 0a             	lea    0xa(%edx),%edi
  8006fc:	80 7d df 1a          	cmpb   $0x1a,-0x21(%ebp)
  800700:	19 c9                	sbb    %ecx,%ecx
  800702:	83 e1 20             	and    $0x20,%ecx
  800705:	83 c1 41             	add    $0x41,%ecx
  800708:	29 cf                	sub    %ecx,%edi
  80070a:	09 df                	or     %ebx,%edi
        c = *++cp;
  80070c:	0f be 10             	movsbl (%eax),%edx
  80070f:	eb ad                	jmp    8006be <inet_aton+0x62>
  800711:	89 d0                	mov    %edx,%eax
  800713:	89 f9                	mov    %edi,%ecx
  800715:	eb 04                	jmp    80071b <inet_aton+0xbf>
  800717:	89 d0                	mov    %edx,%eax
  800719:	89 f9                	mov    %edi,%ecx
      } else
        break;
    }
    if (c == '.') {
  80071b:	83 f8 2e             	cmp    $0x2e,%eax
  80071e:	75 22                	jne    800742 <inet_aton+0xe6>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  800720:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800723:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  800726:	0f 84 fe 00 00 00    	je     80082a <inet_aton+0x1ce>
        return (0);
      *pp++ = val;
  80072c:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  800730:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800733:	89 48 fc             	mov    %ecx,-0x4(%eax)
      c = *++cp;
  800736:	8d 46 01             	lea    0x1(%esi),%eax
  800739:	0f be 56 01          	movsbl 0x1(%esi),%edx
    } else
      break;
  }
  80073d:	e9 2f ff ff ff       	jmp    800671 <inet_aton+0x15>
  800742:	89 f9                	mov    %edi,%ecx
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  800744:	85 d2                	test   %edx,%edx
  800746:	74 27                	je     80076f <inet_aton+0x113>
    return (0);
  800748:	b8 00 00 00 00       	mov    $0x0,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  80074d:	80 fb 1f             	cmp    $0x1f,%bl
  800750:	0f 86 e7 00 00 00    	jbe    80083d <inet_aton+0x1e1>
  800756:	84 d2                	test   %dl,%dl
  800758:	0f 88 d3 00 00 00    	js     800831 <inet_aton+0x1d5>
  80075e:	83 fa 20             	cmp    $0x20,%edx
  800761:	74 0c                	je     80076f <inet_aton+0x113>
  800763:	83 ea 09             	sub    $0x9,%edx
  800766:	83 fa 04             	cmp    $0x4,%edx
  800769:	0f 87 ce 00 00 00    	ja     80083d <inet_aton+0x1e1>
    return (0);
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  80076f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800772:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800775:	29 c2                	sub    %eax,%edx
  800777:	c1 fa 02             	sar    $0x2,%edx
  80077a:	83 c2 01             	add    $0x1,%edx
  switch (n) {
  80077d:	83 fa 02             	cmp    $0x2,%edx
  800780:	74 22                	je     8007a4 <inet_aton+0x148>
  800782:	83 fa 02             	cmp    $0x2,%edx
  800785:	7f 0f                	jg     800796 <inet_aton+0x13a>

  case 0:
    return (0);       /* initial nondigit */
  800787:	b8 00 00 00 00       	mov    $0x0,%eax
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  80078c:	85 d2                	test   %edx,%edx
  80078e:	0f 84 a9 00 00 00    	je     80083d <inet_aton+0x1e1>
  800794:	eb 73                	jmp    800809 <inet_aton+0x1ad>
  800796:	83 fa 03             	cmp    $0x3,%edx
  800799:	74 26                	je     8007c1 <inet_aton+0x165>
  80079b:	83 fa 04             	cmp    $0x4,%edx
  80079e:	66 90                	xchg   %ax,%ax
  8007a0:	74 40                	je     8007e2 <inet_aton+0x186>
  8007a2:	eb 65                	jmp    800809 <inet_aton+0x1ad>
  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
      return (0);
  8007a4:	b8 00 00 00 00       	mov    $0x0,%eax

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8007a9:	81 f9 ff ff ff 00    	cmp    $0xffffff,%ecx
  8007af:	0f 87 88 00 00 00    	ja     80083d <inet_aton+0x1e1>
      return (0);
    val |= parts[0] << 24;
  8007b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007b8:	c1 e0 18             	shl    $0x18,%eax
  8007bb:	89 cf                	mov    %ecx,%edi
  8007bd:	09 c7                	or     %eax,%edi
    break;
  8007bf:	eb 48                	jmp    800809 <inet_aton+0x1ad>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
      return (0);
  8007c1:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= parts[0] << 24;
    break;

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8007c6:	81 f9 ff ff 00 00    	cmp    $0xffff,%ecx
  8007cc:	77 6f                	ja     80083d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8007ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d1:	c1 e2 10             	shl    $0x10,%edx
  8007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007d7:	c1 e0 18             	shl    $0x18,%eax
  8007da:	09 d0                	or     %edx,%eax
  8007dc:	09 c8                	or     %ecx,%eax
  8007de:	89 c7                	mov    %eax,%edi
    break;
  8007e0:	eb 27                	jmp    800809 <inet_aton+0x1ad>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
      return (0);
  8007e2:	b8 00 00 00 00       	mov    $0x0,%eax
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
    break;

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8007e7:	81 f9 ff 00 00 00    	cmp    $0xff,%ecx
  8007ed:	77 4e                	ja     80083d <inet_aton+0x1e1>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8007ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f2:	c1 e2 10             	shl    $0x10,%edx
  8007f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f8:	c1 e0 18             	shl    $0x18,%eax
  8007fb:	09 c2                	or     %eax,%edx
  8007fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800800:	c1 e0 08             	shl    $0x8,%eax
  800803:	09 d0                	or     %edx,%eax
  800805:	09 c8                	or     %ecx,%eax
  800807:	89 c7                	mov    %eax,%edi
    break;
  }
  if (addr)
  800809:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80080d:	74 29                	je     800838 <inet_aton+0x1dc>
    addr->s_addr = htonl(val);
  80080f:	89 3c 24             	mov    %edi,(%esp)
  800812:	e8 19 fe ff ff       	call   800630 <htonl>
  800817:	8b 75 0c             	mov    0xc(%ebp),%esi
  80081a:	89 06                	mov    %eax,(%esi)
  return (1);
  80081c:	b8 01 00 00 00       	mov    $0x1,%eax
  800821:	eb 1a                	jmp    80083d <inet_aton+0x1e1>
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
      return (0);
  800823:	b8 00 00 00 00       	mov    $0x0,%eax
  800828:	eb 13                	jmp    80083d <inet_aton+0x1e1>
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
  80082a:	b8 00 00 00 00       	mov    $0x0,%eax
  80082f:	eb 0c                	jmp    80083d <inet_aton+0x1e1>
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
    return (0);
  800831:	b8 00 00 00 00       	mov    $0x0,%eax
  800836:	eb 05                	jmp    80083d <inet_aton+0x1e1>
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
    break;
  }
  if (addr)
    addr->s_addr = htonl(val);
  return (1);
  800838:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80083d:	83 c4 20             	add    $0x20,%esp
  800840:	5b                   	pop    %ebx
  800841:	5e                   	pop    %esi
  800842:	5f                   	pop    %edi
  800843:	5d                   	pop    %ebp
  800844:	c3                   	ret    

00800845 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80084b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80084e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800852:	8b 45 08             	mov    0x8(%ebp),%eax
  800855:	89 04 24             	mov    %eax,(%esp)
  800858:	e8 ff fd ff ff       	call   80065c <inet_aton>
  80085d:	85 c0                	test   %eax,%eax
    return (val.s_addr);
  80085f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800864:	0f 45 45 fc          	cmovne -0x4(%ebp),%eax
  }
  return (INADDR_NONE);
}
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 04 24             	mov    %eax,(%esp)
  800876:	e8 b5 fd ff ff       	call   800630 <htonl>
}
  80087b:	c9                   	leave  
  80087c:	c3                   	ret    

0080087d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	56                   	push   %esi
  800881:	53                   	push   %ebx
  800882:	83 ec 10             	sub    $0x10,%esp
  800885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800888:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80088b:	c7 05 1c 50 80 00 00 	movl   $0x0,0x80501c
  800892:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800895:	e8 4b 0b 00 00       	call   8013e5 <sys_getenvid>
  80089a:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80089f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8008a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8008a7:	a3 1c 50 80 00       	mov    %eax,0x80501c


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008ac:	85 db                	test   %ebx,%ebx
  8008ae:	7e 07                	jle    8008b7 <libmain+0x3a>
		binaryname = argv[0];
  8008b0:	8b 06                	mov    (%esi),%eax
  8008b2:	a3 20 40 80 00       	mov    %eax,0x804020

	// call user main routine
	umain(argc, argv);
  8008b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008bb:	89 1c 24             	mov    %ebx,(%esp)
  8008be:	e8 8f fb ff ff       	call   800452 <umain>

	// exit gracefully
	exit();
  8008c3:	e8 07 00 00 00       	call   8008cf <exit>
}
  8008c8:	83 c4 10             	add    $0x10,%esp
  8008cb:	5b                   	pop    %ebx
  8008cc:	5e                   	pop    %esi
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8008d5:	e8 50 10 00 00       	call   80192a <close_all>
	sys_env_destroy(0);
  8008da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008e1:	e8 ad 0a 00 00       	call   801393 <sys_env_destroy>
}
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	56                   	push   %esi
  8008ec:	53                   	push   %ebx
  8008ed:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8008f0:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8008f3:	8b 35 20 40 80 00    	mov    0x804020,%esi
  8008f9:	e8 e7 0a 00 00       	call   8013e5 <sys_getenvid>
  8008fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800901:	89 54 24 10          	mov    %edx,0x10(%esp)
  800905:	8b 55 08             	mov    0x8(%ebp),%edx
  800908:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80090c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800910:	89 44 24 04          	mov    %eax,0x4(%esp)
  800914:	c7 04 24 88 32 80 00 	movl   $0x803288,(%esp)
  80091b:	e8 c1 00 00 00       	call   8009e1 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800920:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800924:	8b 45 10             	mov    0x10(%ebp),%eax
  800927:	89 04 24             	mov    %eax,(%esp)
  80092a:	e8 51 00 00 00       	call   800980 <vcprintf>
	cprintf("\n");
  80092f:	c7 04 24 f2 30 80 00 	movl   $0x8030f2,(%esp)
  800936:	e8 a6 00 00 00       	call   8009e1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80093b:	cc                   	int3   
  80093c:	eb fd                	jmp    80093b <_panic+0x53>

0080093e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	53                   	push   %ebx
  800942:	83 ec 14             	sub    $0x14,%esp
  800945:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800948:	8b 13                	mov    (%ebx),%edx
  80094a:	8d 42 01             	lea    0x1(%edx),%eax
  80094d:	89 03                	mov    %eax,(%ebx)
  80094f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800952:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800956:	3d ff 00 00 00       	cmp    $0xff,%eax
  80095b:	75 19                	jne    800976 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80095d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800964:	00 
  800965:	8d 43 08             	lea    0x8(%ebx),%eax
  800968:	89 04 24             	mov    %eax,(%esp)
  80096b:	e8 e6 09 00 00       	call   801356 <sys_cputs>
		b->idx = 0;
  800970:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800976:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80097a:	83 c4 14             	add    $0x14,%esp
  80097d:	5b                   	pop    %ebx
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800989:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800990:	00 00 00 
	b.cnt = 0;
  800993:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80099a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80099d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b5:	c7 04 24 3e 09 80 00 	movl   $0x80093e,(%esp)
  8009bc:	e8 ad 01 00 00       	call   800b6e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8009c1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8009c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8009d1:	89 04 24             	mov    %eax,(%esp)
  8009d4:	e8 7d 09 00 00       	call   801356 <sys_cputs>

	return b.cnt;
}
  8009d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8009df:	c9                   	leave  
  8009e0:	c3                   	ret    

008009e1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8009ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	89 04 24             	mov    %eax,(%esp)
  8009f4:	e8 87 ff ff ff       	call   800980 <vcprintf>
	va_end(ap);

	return cnt;
}
  8009f9:	c9                   	leave  
  8009fa:	c3                   	ret    
  8009fb:	66 90                	xchg   %ax,%ax
  8009fd:	66 90                	xchg   %ax,%ax
  8009ff:	90                   	nop

00800a00 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	57                   	push   %edi
  800a04:	56                   	push   %esi
  800a05:	53                   	push   %ebx
  800a06:	83 ec 3c             	sub    $0x3c,%esp
  800a09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a0c:	89 d7                	mov    %edx,%edi
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a17:	89 c3                	mov    %eax,%ebx
  800a19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800a1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a27:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a2a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a2d:	39 d9                	cmp    %ebx,%ecx
  800a2f:	72 05                	jb     800a36 <printnum+0x36>
  800a31:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800a34:	77 69                	ja     800a9f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a36:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a39:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800a3d:	83 ee 01             	sub    $0x1,%esi
  800a40:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a44:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a48:	8b 44 24 08          	mov    0x8(%esp),%eax
  800a4c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800a50:	89 c3                	mov    %eax,%ebx
  800a52:	89 d6                	mov    %edx,%esi
  800a54:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800a57:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800a5a:	89 54 24 08          	mov    %edx,0x8(%esp)
  800a5e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800a62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a65:	89 04 24             	mov    %eax,(%esp)
  800a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6f:	e8 7c 23 00 00       	call   802df0 <__udivdi3>
  800a74:	89 d9                	mov    %ebx,%ecx
  800a76:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a7a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a7e:	89 04 24             	mov    %eax,(%esp)
  800a81:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a85:	89 fa                	mov    %edi,%edx
  800a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a8a:	e8 71 ff ff ff       	call   800a00 <printnum>
  800a8f:	eb 1b                	jmp    800aac <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a91:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a95:	8b 45 18             	mov    0x18(%ebp),%eax
  800a98:	89 04 24             	mov    %eax,(%esp)
  800a9b:	ff d3                	call   *%ebx
  800a9d:	eb 03                	jmp    800aa2 <printnum+0xa2>
  800a9f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa2:	83 ee 01             	sub    $0x1,%esi
  800aa5:	85 f6                	test   %esi,%esi
  800aa7:	7f e8                	jg     800a91 <printnum+0x91>
  800aa9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ab4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800ab7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800aba:	89 44 24 08          	mov    %eax,0x8(%esp)
  800abe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac5:	89 04 24             	mov    %eax,(%esp)
  800ac8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800acf:	e8 4c 24 00 00       	call   802f20 <__umoddi3>
  800ad4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ad8:	0f be 80 ab 32 80 00 	movsbl 0x8032ab(%eax),%eax
  800adf:	89 04 24             	mov    %eax,(%esp)
  800ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae5:	ff d0                	call   *%eax
}
  800ae7:	83 c4 3c             	add    $0x3c,%esp
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5f                   	pop    %edi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af2:	83 fa 01             	cmp    $0x1,%edx
  800af5:	7e 0e                	jle    800b05 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800af7:	8b 10                	mov    (%eax),%edx
  800af9:	8d 4a 08             	lea    0x8(%edx),%ecx
  800afc:	89 08                	mov    %ecx,(%eax)
  800afe:	8b 02                	mov    (%edx),%eax
  800b00:	8b 52 04             	mov    0x4(%edx),%edx
  800b03:	eb 22                	jmp    800b27 <getuint+0x38>
	else if (lflag)
  800b05:	85 d2                	test   %edx,%edx
  800b07:	74 10                	je     800b19 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800b09:	8b 10                	mov    (%eax),%edx
  800b0b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800b0e:	89 08                	mov    %ecx,(%eax)
  800b10:	8b 02                	mov    (%edx),%eax
  800b12:	ba 00 00 00 00       	mov    $0x0,%edx
  800b17:	eb 0e                	jmp    800b27 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800b19:	8b 10                	mov    (%eax),%edx
  800b1b:	8d 4a 04             	lea    0x4(%edx),%ecx
  800b1e:	89 08                	mov    %ecx,(%eax)
  800b20:	8b 02                	mov    (%edx),%eax
  800b22:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b27:	5d                   	pop    %ebp
  800b28:	c3                   	ret    

00800b29 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b29:	55                   	push   %ebp
  800b2a:	89 e5                	mov    %esp,%ebp
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800b2f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800b33:	8b 10                	mov    (%eax),%edx
  800b35:	3b 50 04             	cmp    0x4(%eax),%edx
  800b38:	73 0a                	jae    800b44 <sprintputch+0x1b>
		*b->buf++ = ch;
  800b3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3d:	89 08                	mov    %ecx,(%eax)
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	88 02                	mov    %al,(%edx)
}
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b4c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b53:	8b 45 10             	mov    0x10(%ebp),%eax
  800b56:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	89 04 24             	mov    %eax,(%esp)
  800b67:	e8 02 00 00 00       	call   800b6e <vprintfmt>
	va_end(ap);
}
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	57                   	push   %edi
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 3c             	sub    $0x3c,%esp
  800b77:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b7d:	eb 14                	jmp    800b93 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800b7f:	85 c0                	test   %eax,%eax
  800b81:	0f 84 b3 03 00 00    	je     800f3a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800b87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b8b:	89 04 24             	mov    %eax,(%esp)
  800b8e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b91:	89 f3                	mov    %esi,%ebx
  800b93:	8d 73 01             	lea    0x1(%ebx),%esi
  800b96:	0f b6 03             	movzbl (%ebx),%eax
  800b99:	83 f8 25             	cmp    $0x25,%eax
  800b9c:	75 e1                	jne    800b7f <vprintfmt+0x11>
  800b9e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800ba2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800ba9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800bb0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbc:	eb 1d                	jmp    800bdb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bbe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800bc0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800bc4:	eb 15                	jmp    800bdb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bc8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  800bcc:	eb 0d                	jmp    800bdb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800bce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bd1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bd4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bdb:	8d 5e 01             	lea    0x1(%esi),%ebx
  800bde:	0f b6 0e             	movzbl (%esi),%ecx
  800be1:	0f b6 c1             	movzbl %cl,%eax
  800be4:	83 e9 23             	sub    $0x23,%ecx
  800be7:	80 f9 55             	cmp    $0x55,%cl
  800bea:	0f 87 2a 03 00 00    	ja     800f1a <vprintfmt+0x3ac>
  800bf0:	0f b6 c9             	movzbl %cl,%ecx
  800bf3:	ff 24 8d e0 33 80 00 	jmp    *0x8033e0(,%ecx,4)
  800bfa:	89 de                	mov    %ebx,%esi
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800c01:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800c04:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800c08:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800c0b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800c0e:	83 fb 09             	cmp    $0x9,%ebx
  800c11:	77 36                	ja     800c49 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c13:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c16:	eb e9                	jmp    800c01 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c18:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1b:	8d 48 04             	lea    0x4(%eax),%ecx
  800c1e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c26:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800c28:	eb 22                	jmp    800c4c <vprintfmt+0xde>
  800c2a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800c2d:	85 c9                	test   %ecx,%ecx
  800c2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800c34:	0f 49 c1             	cmovns %ecx,%eax
  800c37:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3a:	89 de                	mov    %ebx,%esi
  800c3c:	eb 9d                	jmp    800bdb <vprintfmt+0x6d>
  800c3e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800c40:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800c47:	eb 92                	jmp    800bdb <vprintfmt+0x6d>
  800c49:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  800c4c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c50:	79 89                	jns    800bdb <vprintfmt+0x6d>
  800c52:	e9 77 ff ff ff       	jmp    800bce <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c57:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c5a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800c5c:	e9 7a ff ff ff       	jmp    800bdb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	8d 50 04             	lea    0x4(%eax),%edx
  800c67:	89 55 14             	mov    %edx,0x14(%ebp)
  800c6a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	89 04 24             	mov    %eax,(%esp)
  800c73:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c76:	e9 18 ff ff ff       	jmp    800b93 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c7e:	8d 50 04             	lea    0x4(%eax),%edx
  800c81:	89 55 14             	mov    %edx,0x14(%ebp)
  800c84:	8b 00                	mov    (%eax),%eax
  800c86:	99                   	cltd   
  800c87:	31 d0                	xor    %edx,%eax
  800c89:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 f8 0f             	cmp    $0xf,%eax
  800c8e:	7f 0b                	jg     800c9b <vprintfmt+0x12d>
  800c90:	8b 14 85 40 35 80 00 	mov    0x803540(,%eax,4),%edx
  800c97:	85 d2                	test   %edx,%edx
  800c99:	75 20                	jne    800cbb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c9f:	c7 44 24 08 c3 32 80 	movl   $0x8032c3,0x8(%esp)
  800ca6:	00 
  800ca7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	89 04 24             	mov    %eax,(%esp)
  800cb1:	e8 90 fe ff ff       	call   800b46 <printfmt>
  800cb6:	e9 d8 fe ff ff       	jmp    800b93 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  800cbb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800cbf:	c7 44 24 08 75 36 80 	movl   $0x803675,0x8(%esp)
  800cc6:	00 
  800cc7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 04 24             	mov    %eax,(%esp)
  800cd1:	e8 70 fe ff ff       	call   800b46 <printfmt>
  800cd6:	e9 b8 fe ff ff       	jmp    800b93 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800cdb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800cde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800ce1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce7:	8d 50 04             	lea    0x4(%eax),%edx
  800cea:	89 55 14             	mov    %edx,0x14(%ebp)
  800ced:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  800cef:	85 f6                	test   %esi,%esi
  800cf1:	b8 bc 32 80 00       	mov    $0x8032bc,%eax
  800cf6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800cf9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  800cfd:	0f 84 97 00 00 00    	je     800d9a <vprintfmt+0x22c>
  800d03:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800d07:	0f 8e 9b 00 00 00    	jle    800da8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800d11:	89 34 24             	mov    %esi,(%esp)
  800d14:	e8 cf 02 00 00       	call   800fe8 <strnlen>
  800d19:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800d1c:	29 c2                	sub    %eax,%edx
  800d1e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800d21:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800d25:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d28:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800d2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d31:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d33:	eb 0f                	jmp    800d44 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800d35:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d39:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d3c:	89 04 24             	mov    %eax,(%esp)
  800d3f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d41:	83 eb 01             	sub    $0x1,%ebx
  800d44:	85 db                	test   %ebx,%ebx
  800d46:	7f ed                	jg     800d35 <vprintfmt+0x1c7>
  800d48:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800d4b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800d4e:	85 d2                	test   %edx,%edx
  800d50:	b8 00 00 00 00       	mov    $0x0,%eax
  800d55:	0f 49 c2             	cmovns %edx,%eax
  800d58:	29 c2                	sub    %eax,%edx
  800d5a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800d5d:	89 d7                	mov    %edx,%edi
  800d5f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800d62:	eb 50                	jmp    800db4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800d64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d68:	74 1e                	je     800d88 <vprintfmt+0x21a>
  800d6a:	0f be d2             	movsbl %dl,%edx
  800d6d:	83 ea 20             	sub    $0x20,%edx
  800d70:	83 fa 5e             	cmp    $0x5e,%edx
  800d73:	76 13                	jbe    800d88 <vprintfmt+0x21a>
					putch('?', putdat);
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d7c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800d83:	ff 55 08             	call   *0x8(%ebp)
  800d86:	eb 0d                	jmp    800d95 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800d88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d8b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d8f:	89 04 24             	mov    %eax,(%esp)
  800d92:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d95:	83 ef 01             	sub    $0x1,%edi
  800d98:	eb 1a                	jmp    800db4 <vprintfmt+0x246>
  800d9a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800d9d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800da0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800da3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800da6:	eb 0c                	jmp    800db4 <vprintfmt+0x246>
  800da8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800dab:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800dae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800db1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800db4:	83 c6 01             	add    $0x1,%esi
  800db7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800dbb:	0f be c2             	movsbl %dl,%eax
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	74 27                	je     800de9 <vprintfmt+0x27b>
  800dc2:	85 db                	test   %ebx,%ebx
  800dc4:	78 9e                	js     800d64 <vprintfmt+0x1f6>
  800dc6:	83 eb 01             	sub    $0x1,%ebx
  800dc9:	79 99                	jns    800d64 <vprintfmt+0x1f6>
  800dcb:	89 f8                	mov    %edi,%eax
  800dcd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800dd0:	8b 75 08             	mov    0x8(%ebp),%esi
  800dd3:	89 c3                	mov    %eax,%ebx
  800dd5:	eb 1a                	jmp    800df1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800dd7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ddb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800de2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de4:	83 eb 01             	sub    $0x1,%ebx
  800de7:	eb 08                	jmp    800df1 <vprintfmt+0x283>
  800de9:	89 fb                	mov    %edi,%ebx
  800deb:	8b 75 08             	mov    0x8(%ebp),%esi
  800dee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800df1:	85 db                	test   %ebx,%ebx
  800df3:	7f e2                	jg     800dd7 <vprintfmt+0x269>
  800df5:	89 75 08             	mov    %esi,0x8(%ebp)
  800df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfb:	e9 93 fd ff ff       	jmp    800b93 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800e00:	83 fa 01             	cmp    $0x1,%edx
  800e03:	7e 16                	jle    800e1b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800e05:	8b 45 14             	mov    0x14(%ebp),%eax
  800e08:	8d 50 08             	lea    0x8(%eax),%edx
  800e0b:	89 55 14             	mov    %edx,0x14(%ebp)
  800e0e:	8b 50 04             	mov    0x4(%eax),%edx
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800e19:	eb 32                	jmp    800e4d <vprintfmt+0x2df>
	else if (lflag)
  800e1b:	85 d2                	test   %edx,%edx
  800e1d:	74 18                	je     800e37 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e22:	8d 50 04             	lea    0x4(%eax),%edx
  800e25:	89 55 14             	mov    %edx,0x14(%ebp)
  800e28:	8b 30                	mov    (%eax),%esi
  800e2a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800e2d:	89 f0                	mov    %esi,%eax
  800e2f:	c1 f8 1f             	sar    $0x1f,%eax
  800e32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e35:	eb 16                	jmp    800e4d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800e37:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3a:	8d 50 04             	lea    0x4(%eax),%edx
  800e3d:	89 55 14             	mov    %edx,0x14(%ebp)
  800e40:	8b 30                	mov    (%eax),%esi
  800e42:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800e45:	89 f0                	mov    %esi,%eax
  800e47:	c1 f8 1f             	sar    $0x1f,%eax
  800e4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800e53:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800e58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5c:	0f 89 80 00 00 00    	jns    800ee2 <vprintfmt+0x374>
				putch('-', putdat);
  800e62:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e66:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800e6d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800e70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e76:	f7 d8                	neg    %eax
  800e78:	83 d2 00             	adc    $0x0,%edx
  800e7b:	f7 da                	neg    %edx
			}
			base = 10;
  800e7d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e82:	eb 5e                	jmp    800ee2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e84:	8d 45 14             	lea    0x14(%ebp),%eax
  800e87:	e8 63 fc ff ff       	call   800aef <getuint>
			base = 10;
  800e8c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800e91:	eb 4f                	jmp    800ee2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800e93:	8d 45 14             	lea    0x14(%ebp),%eax
  800e96:	e8 54 fc ff ff       	call   800aef <getuint>
			base =8;
  800e9b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800ea0:	eb 40                	jmp    800ee2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800ea2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ea6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800ead:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800eb0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eb4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800ebb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800ebe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec1:	8d 50 04             	lea    0x4(%eax),%edx
  800ec4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ec7:	8b 00                	mov    (%eax),%eax
  800ec9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800ece:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800ed3:	eb 0d                	jmp    800ee2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ed5:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed8:	e8 12 fc ff ff       	call   800aef <getuint>
			base = 16;
  800edd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ee2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800ee6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800eea:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800eed:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800ef1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ef5:	89 04 24             	mov    %eax,(%esp)
  800ef8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800efc:	89 fa                	mov    %edi,%edx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	e8 fa fa ff ff       	call   800a00 <printnum>
			break;
  800f06:	e9 88 fc ff ff       	jmp    800b93 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f0b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f0f:	89 04 24             	mov    %eax,(%esp)
  800f12:	ff 55 08             	call   *0x8(%ebp)
			break;
  800f15:	e9 79 fc ff ff       	jmp    800b93 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f1a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f1e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800f25:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f28:	89 f3                	mov    %esi,%ebx
  800f2a:	eb 03                	jmp    800f2f <vprintfmt+0x3c1>
  800f2c:	83 eb 01             	sub    $0x1,%ebx
  800f2f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800f33:	75 f7                	jne    800f2c <vprintfmt+0x3be>
  800f35:	e9 59 fc ff ff       	jmp    800b93 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800f3a:	83 c4 3c             	add    $0x3c,%esp
  800f3d:	5b                   	pop    %ebx
  800f3e:	5e                   	pop    %esi
  800f3f:	5f                   	pop    %edi
  800f40:	5d                   	pop    %ebp
  800f41:	c3                   	ret    

00800f42 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	83 ec 28             	sub    $0x28,%esp
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f51:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800f55:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800f58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	74 30                	je     800f93 <vsnprintf+0x51>
  800f63:	85 d2                	test   %edx,%edx
  800f65:	7e 2c                	jle    800f93 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f67:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f71:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f75:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800f78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f7c:	c7 04 24 29 0b 80 00 	movl   $0x800b29,(%esp)
  800f83:	e8 e6 fb ff ff       	call   800b6e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f91:	eb 05                	jmp    800f98 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800f93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800f98:	c9                   	leave  
  800f99:	c3                   	ret    

00800f9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800f9a:	55                   	push   %ebp
  800f9b:	89 e5                	mov    %esp,%ebp
  800f9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fa0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800fa3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  800faa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	89 04 24             	mov    %eax,(%esp)
  800fbb:	e8 82 ff ff ff       	call   800f42 <vsnprintf>
	va_end(ap);

	return rc;
}
  800fc0:	c9                   	leave  
  800fc1:	c3                   	ret    
  800fc2:	66 90                	xchg   %ax,%ax
  800fc4:	66 90                	xchg   %ax,%ax
  800fc6:	66 90                	xchg   %ax,%ax
  800fc8:	66 90                	xchg   %ax,%ax
  800fca:	66 90                	xchg   %ax,%ax
  800fcc:	66 90                	xchg   %ax,%ax
  800fce:	66 90                	xchg   %ax,%ax

00800fd0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdb:	eb 03                	jmp    800fe0 <strlen+0x10>
		n++;
  800fdd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800fe0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800fe4:	75 f7                	jne    800fdd <strlen+0xd>
		n++;
	return n;
}
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fee:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff6:	eb 03                	jmp    800ffb <strnlen+0x13>
		n++;
  800ff8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ffb:	39 d0                	cmp    %edx,%eax
  800ffd:	74 06                	je     801005 <strnlen+0x1d>
  800fff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801003:	75 f3                	jne    800ff8 <strnlen+0x10>
		n++;
	return n;
}
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	53                   	push   %ebx
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801011:	89 c2                	mov    %eax,%edx
  801013:	83 c2 01             	add    $0x1,%edx
  801016:	83 c1 01             	add    $0x1,%ecx
  801019:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80101d:	88 5a ff             	mov    %bl,-0x1(%edx)
  801020:	84 db                	test   %bl,%bl
  801022:	75 ef                	jne    801013 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801024:	5b                   	pop    %ebx
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	53                   	push   %ebx
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801031:	89 1c 24             	mov    %ebx,(%esp)
  801034:	e8 97 ff ff ff       	call   800fd0 <strlen>
	strcpy(dst + len, src);
  801039:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103c:	89 54 24 04          	mov    %edx,0x4(%esp)
  801040:	01 d8                	add    %ebx,%eax
  801042:	89 04 24             	mov    %eax,(%esp)
  801045:	e8 bd ff ff ff       	call   801007 <strcpy>
	return dst;
}
  80104a:	89 d8                	mov    %ebx,%eax
  80104c:	83 c4 08             	add    $0x8,%esp
  80104f:	5b                   	pop    %ebx
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	56                   	push   %esi
  801056:	53                   	push   %ebx
  801057:	8b 75 08             	mov    0x8(%ebp),%esi
  80105a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105d:	89 f3                	mov    %esi,%ebx
  80105f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801062:	89 f2                	mov    %esi,%edx
  801064:	eb 0f                	jmp    801075 <strncpy+0x23>
		*dst++ = *src;
  801066:	83 c2 01             	add    $0x1,%edx
  801069:	0f b6 01             	movzbl (%ecx),%eax
  80106c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80106f:	80 39 01             	cmpb   $0x1,(%ecx)
  801072:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801075:	39 da                	cmp    %ebx,%edx
  801077:	75 ed                	jne    801066 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801079:	89 f0                	mov    %esi,%eax
  80107b:	5b                   	pop    %ebx
  80107c:	5e                   	pop    %esi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	8b 75 08             	mov    0x8(%ebp),%esi
  801087:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80108d:	89 f0                	mov    %esi,%eax
  80108f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801093:	85 c9                	test   %ecx,%ecx
  801095:	75 0b                	jne    8010a2 <strlcpy+0x23>
  801097:	eb 1d                	jmp    8010b6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801099:	83 c0 01             	add    $0x1,%eax
  80109c:	83 c2 01             	add    $0x1,%edx
  80109f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010a2:	39 d8                	cmp    %ebx,%eax
  8010a4:	74 0b                	je     8010b1 <strlcpy+0x32>
  8010a6:	0f b6 0a             	movzbl (%edx),%ecx
  8010a9:	84 c9                	test   %cl,%cl
  8010ab:	75 ec                	jne    801099 <strlcpy+0x1a>
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	eb 02                	jmp    8010b3 <strlcpy+0x34>
  8010b1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8010b3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8010b6:	29 f0                	sub    %esi,%eax
}
  8010b8:	5b                   	pop    %ebx
  8010b9:	5e                   	pop    %esi
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8010c5:	eb 06                	jmp    8010cd <strcmp+0x11>
		p++, q++;
  8010c7:	83 c1 01             	add    $0x1,%ecx
  8010ca:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8010cd:	0f b6 01             	movzbl (%ecx),%eax
  8010d0:	84 c0                	test   %al,%al
  8010d2:	74 04                	je     8010d8 <strcmp+0x1c>
  8010d4:	3a 02                	cmp    (%edx),%al
  8010d6:	74 ef                	je     8010c7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8010d8:	0f b6 c0             	movzbl %al,%eax
  8010db:	0f b6 12             	movzbl (%edx),%edx
  8010de:	29 d0                	sub    %edx,%eax
}
  8010e0:	5d                   	pop    %ebp
  8010e1:	c3                   	ret    

008010e2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	53                   	push   %ebx
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ec:	89 c3                	mov    %eax,%ebx
  8010ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8010f1:	eb 06                	jmp    8010f9 <strncmp+0x17>
		n--, p++, q++;
  8010f3:	83 c0 01             	add    $0x1,%eax
  8010f6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8010f9:	39 d8                	cmp    %ebx,%eax
  8010fb:	74 15                	je     801112 <strncmp+0x30>
  8010fd:	0f b6 08             	movzbl (%eax),%ecx
  801100:	84 c9                	test   %cl,%cl
  801102:	74 04                	je     801108 <strncmp+0x26>
  801104:	3a 0a                	cmp    (%edx),%cl
  801106:	74 eb                	je     8010f3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801108:	0f b6 00             	movzbl (%eax),%eax
  80110b:	0f b6 12             	movzbl (%edx),%edx
  80110e:	29 d0                	sub    %edx,%eax
  801110:	eb 05                	jmp    801117 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801117:	5b                   	pop    %ebx
  801118:	5d                   	pop    %ebp
  801119:	c3                   	ret    

0080111a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80111a:	55                   	push   %ebp
  80111b:	89 e5                	mov    %esp,%ebp
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801124:	eb 07                	jmp    80112d <strchr+0x13>
		if (*s == c)
  801126:	38 ca                	cmp    %cl,%dl
  801128:	74 0f                	je     801139 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80112a:	83 c0 01             	add    $0x1,%eax
  80112d:	0f b6 10             	movzbl (%eax),%edx
  801130:	84 d2                	test   %dl,%dl
  801132:	75 f2                	jne    801126 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801134:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801145:	eb 07                	jmp    80114e <strfind+0x13>
		if (*s == c)
  801147:	38 ca                	cmp    %cl,%dl
  801149:	74 0a                	je     801155 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80114b:	83 c0 01             	add    $0x1,%eax
  80114e:	0f b6 10             	movzbl (%eax),%edx
  801151:	84 d2                	test   %dl,%dl
  801153:	75 f2                	jne    801147 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	57                   	push   %edi
  80115b:	56                   	push   %esi
  80115c:	53                   	push   %ebx
  80115d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801160:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801163:	85 c9                	test   %ecx,%ecx
  801165:	74 36                	je     80119d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801167:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80116d:	75 28                	jne    801197 <memset+0x40>
  80116f:	f6 c1 03             	test   $0x3,%cl
  801172:	75 23                	jne    801197 <memset+0x40>
		c &= 0xFF;
  801174:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801178:	89 d3                	mov    %edx,%ebx
  80117a:	c1 e3 08             	shl    $0x8,%ebx
  80117d:	89 d6                	mov    %edx,%esi
  80117f:	c1 e6 18             	shl    $0x18,%esi
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e0 10             	shl    $0x10,%eax
  801187:	09 f0                	or     %esi,%eax
  801189:	09 c2                	or     %eax,%edx
  80118b:	89 d0                	mov    %edx,%eax
  80118d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80118f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801192:	fc                   	cld    
  801193:	f3 ab                	rep stos %eax,%es:(%edi)
  801195:	eb 06                	jmp    80119d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	fc                   	cld    
  80119b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80119d:	89 f8                	mov    %edi,%eax
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5f                   	pop    %edi
  8011a2:	5d                   	pop    %ebp
  8011a3:	c3                   	ret    

008011a4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	57                   	push   %edi
  8011a8:	56                   	push   %esi
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011af:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8011b2:	39 c6                	cmp    %eax,%esi
  8011b4:	73 35                	jae    8011eb <memmove+0x47>
  8011b6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8011b9:	39 d0                	cmp    %edx,%eax
  8011bb:	73 2e                	jae    8011eb <memmove+0x47>
		s += n;
		d += n;
  8011bd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8011c0:	89 d6                	mov    %edx,%esi
  8011c2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011c4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8011ca:	75 13                	jne    8011df <memmove+0x3b>
  8011cc:	f6 c1 03             	test   $0x3,%cl
  8011cf:	75 0e                	jne    8011df <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8011d1:	83 ef 04             	sub    $0x4,%edi
  8011d4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8011d7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8011da:	fd                   	std    
  8011db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011dd:	eb 09                	jmp    8011e8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011df:	83 ef 01             	sub    $0x1,%edi
  8011e2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011e5:	fd                   	std    
  8011e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011e8:	fc                   	cld    
  8011e9:	eb 1d                	jmp    801208 <memmove+0x64>
  8011eb:	89 f2                	mov    %esi,%edx
  8011ed:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011ef:	f6 c2 03             	test   $0x3,%dl
  8011f2:	75 0f                	jne    801203 <memmove+0x5f>
  8011f4:	f6 c1 03             	test   $0x3,%cl
  8011f7:	75 0a                	jne    801203 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011f9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8011fc:	89 c7                	mov    %eax,%edi
  8011fe:	fc                   	cld    
  8011ff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801201:	eb 05                	jmp    801208 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801203:	89 c7                	mov    %eax,%edi
  801205:	fc                   	cld    
  801206:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	89 44 24 08          	mov    %eax,0x8(%esp)
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	89 04 24             	mov    %eax,(%esp)
  801226:	e8 79 ff ff ff       	call   8011a4 <memmove>
}
  80122b:	c9                   	leave  
  80122c:	c3                   	ret    

0080122d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80122d:	55                   	push   %ebp
  80122e:	89 e5                	mov    %esp,%ebp
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
  801232:	8b 55 08             	mov    0x8(%ebp),%edx
  801235:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801238:	89 d6                	mov    %edx,%esi
  80123a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80123d:	eb 1a                	jmp    801259 <memcmp+0x2c>
		if (*s1 != *s2)
  80123f:	0f b6 02             	movzbl (%edx),%eax
  801242:	0f b6 19             	movzbl (%ecx),%ebx
  801245:	38 d8                	cmp    %bl,%al
  801247:	74 0a                	je     801253 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  801249:	0f b6 c0             	movzbl %al,%eax
  80124c:	0f b6 db             	movzbl %bl,%ebx
  80124f:	29 d8                	sub    %ebx,%eax
  801251:	eb 0f                	jmp    801262 <memcmp+0x35>
		s1++, s2++;
  801253:	83 c2 01             	add    $0x1,%edx
  801256:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801259:	39 f2                	cmp    %esi,%edx
  80125b:	75 e2                	jne    80123f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80125d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801262:	5b                   	pop    %ebx
  801263:	5e                   	pop    %esi
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    

00801266 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80126f:	89 c2                	mov    %eax,%edx
  801271:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801274:	eb 07                	jmp    80127d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  801276:	38 08                	cmp    %cl,(%eax)
  801278:	74 07                	je     801281 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80127a:	83 c0 01             	add    $0x1,%eax
  80127d:	39 d0                	cmp    %edx,%eax
  80127f:	72 f5                	jb     801276 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801281:	5d                   	pop    %ebp
  801282:	c3                   	ret    

00801283 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	57                   	push   %edi
  801287:	56                   	push   %esi
  801288:	53                   	push   %ebx
  801289:	8b 55 08             	mov    0x8(%ebp),%edx
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80128f:	eb 03                	jmp    801294 <strtol+0x11>
		s++;
  801291:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801294:	0f b6 0a             	movzbl (%edx),%ecx
  801297:	80 f9 09             	cmp    $0x9,%cl
  80129a:	74 f5                	je     801291 <strtol+0xe>
  80129c:	80 f9 20             	cmp    $0x20,%cl
  80129f:	74 f0                	je     801291 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  8012a1:	80 f9 2b             	cmp    $0x2b,%cl
  8012a4:	75 0a                	jne    8012b0 <strtol+0x2d>
		s++;
  8012a6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8012a9:	bf 00 00 00 00       	mov    $0x0,%edi
  8012ae:	eb 11                	jmp    8012c1 <strtol+0x3e>
  8012b0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8012b5:	80 f9 2d             	cmp    $0x2d,%cl
  8012b8:	75 07                	jne    8012c1 <strtol+0x3e>
		s++, neg = 1;
  8012ba:	8d 52 01             	lea    0x1(%edx),%edx
  8012bd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012c1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8012c6:	75 15                	jne    8012dd <strtol+0x5a>
  8012c8:	80 3a 30             	cmpb   $0x30,(%edx)
  8012cb:	75 10                	jne    8012dd <strtol+0x5a>
  8012cd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8012d1:	75 0a                	jne    8012dd <strtol+0x5a>
		s += 2, base = 16;
  8012d3:	83 c2 02             	add    $0x2,%edx
  8012d6:	b8 10 00 00 00       	mov    $0x10,%eax
  8012db:	eb 10                	jmp    8012ed <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	75 0c                	jne    8012ed <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8012e1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8012e3:	80 3a 30             	cmpb   $0x30,(%edx)
  8012e6:	75 05                	jne    8012ed <strtol+0x6a>
		s++, base = 8;
  8012e8:	83 c2 01             	add    $0x1,%edx
  8012eb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8012ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012f5:	0f b6 0a             	movzbl (%edx),%ecx
  8012f8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8012fb:	89 f0                	mov    %esi,%eax
  8012fd:	3c 09                	cmp    $0x9,%al
  8012ff:	77 08                	ja     801309 <strtol+0x86>
			dig = *s - '0';
  801301:	0f be c9             	movsbl %cl,%ecx
  801304:	83 e9 30             	sub    $0x30,%ecx
  801307:	eb 20                	jmp    801329 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  801309:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80130c:	89 f0                	mov    %esi,%eax
  80130e:	3c 19                	cmp    $0x19,%al
  801310:	77 08                	ja     80131a <strtol+0x97>
			dig = *s - 'a' + 10;
  801312:	0f be c9             	movsbl %cl,%ecx
  801315:	83 e9 57             	sub    $0x57,%ecx
  801318:	eb 0f                	jmp    801329 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80131a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80131d:	89 f0                	mov    %esi,%eax
  80131f:	3c 19                	cmp    $0x19,%al
  801321:	77 16                	ja     801339 <strtol+0xb6>
			dig = *s - 'A' + 10;
  801323:	0f be c9             	movsbl %cl,%ecx
  801326:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801329:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80132c:	7d 0f                	jge    80133d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80132e:	83 c2 01             	add    $0x1,%edx
  801331:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801335:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801337:	eb bc                	jmp    8012f5 <strtol+0x72>
  801339:	89 d8                	mov    %ebx,%eax
  80133b:	eb 02                	jmp    80133f <strtol+0xbc>
  80133d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80133f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801343:	74 05                	je     80134a <strtol+0xc7>
		*endptr = (char *) s;
  801345:	8b 75 0c             	mov    0xc(%ebp),%esi
  801348:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80134a:	f7 d8                	neg    %eax
  80134c:	85 ff                	test   %edi,%edi
  80134e:	0f 44 c3             	cmove  %ebx,%eax
}
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5f                   	pop    %edi
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    

00801356 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	57                   	push   %edi
  80135a:	56                   	push   %esi
  80135b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80135c:	b8 00 00 00 00       	mov    $0x0,%eax
  801361:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801364:	8b 55 08             	mov    0x8(%ebp),%edx
  801367:	89 c3                	mov    %eax,%ebx
  801369:	89 c7                	mov    %eax,%edi
  80136b:	89 c6                	mov    %eax,%esi
  80136d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80136f:	5b                   	pop    %ebx
  801370:	5e                   	pop    %esi
  801371:	5f                   	pop    %edi
  801372:	5d                   	pop    %ebp
  801373:	c3                   	ret    

00801374 <sys_cgetc>:

int
sys_cgetc(void)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	57                   	push   %edi
  801378:	56                   	push   %esi
  801379:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80137a:	ba 00 00 00 00       	mov    $0x0,%edx
  80137f:	b8 01 00 00 00       	mov    $0x1,%eax
  801384:	89 d1                	mov    %edx,%ecx
  801386:	89 d3                	mov    %edx,%ebx
  801388:	89 d7                	mov    %edx,%edi
  80138a:	89 d6                	mov    %edx,%esi
  80138c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80138e:	5b                   	pop    %ebx
  80138f:	5e                   	pop    %esi
  801390:	5f                   	pop    %edi
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    

00801393 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801393:	55                   	push   %ebp
  801394:	89 e5                	mov    %esp,%ebp
  801396:	57                   	push   %edi
  801397:	56                   	push   %esi
  801398:	53                   	push   %ebx
  801399:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80139c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8013a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a9:	89 cb                	mov    %ecx,%ebx
  8013ab:	89 cf                	mov    %ecx,%edi
  8013ad:	89 ce                	mov    %ecx,%esi
  8013af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	7e 28                	jle    8013dd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013b9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8013c0:	00 
  8013c1:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  8013c8:	00 
  8013c9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013d0:	00 
  8013d1:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  8013d8:	e8 0b f5 ff ff       	call   8008e8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013dd:	83 c4 2c             	add    $0x2c,%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5f                   	pop    %edi
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    

008013e5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	57                   	push   %edi
  8013e9:	56                   	push   %esi
  8013ea:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f0:	b8 02 00 00 00       	mov    $0x2,%eax
  8013f5:	89 d1                	mov    %edx,%ecx
  8013f7:	89 d3                	mov    %edx,%ebx
  8013f9:	89 d7                	mov    %edx,%edi
  8013fb:	89 d6                	mov    %edx,%esi
  8013fd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013ff:	5b                   	pop    %ebx
  801400:	5e                   	pop    %esi
  801401:	5f                   	pop    %edi
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <sys_yield>:

void
sys_yield(void)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	57                   	push   %edi
  801408:	56                   	push   %esi
  801409:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140a:	ba 00 00 00 00       	mov    $0x0,%edx
  80140f:	b8 0b 00 00 00       	mov    $0xb,%eax
  801414:	89 d1                	mov    %edx,%ecx
  801416:	89 d3                	mov    %edx,%ebx
  801418:	89 d7                	mov    %edx,%edi
  80141a:	89 d6                	mov    %edx,%esi
  80141c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80141e:	5b                   	pop    %ebx
  80141f:	5e                   	pop    %esi
  801420:	5f                   	pop    %edi
  801421:	5d                   	pop    %ebp
  801422:	c3                   	ret    

00801423 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	57                   	push   %edi
  801427:	56                   	push   %esi
  801428:	53                   	push   %ebx
  801429:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80142c:	be 00 00 00 00       	mov    $0x0,%esi
  801431:	b8 04 00 00 00       	mov    $0x4,%eax
  801436:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801439:	8b 55 08             	mov    0x8(%ebp),%edx
  80143c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80143f:	89 f7                	mov    %esi,%edi
  801441:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801443:	85 c0                	test   %eax,%eax
  801445:	7e 28                	jle    80146f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801447:	89 44 24 10          	mov    %eax,0x10(%esp)
  80144b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801452:	00 
  801453:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  80145a:	00 
  80145b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801462:	00 
  801463:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  80146a:	e8 79 f4 ff ff       	call   8008e8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80146f:	83 c4 2c             	add    $0x2c,%esp
  801472:	5b                   	pop    %ebx
  801473:	5e                   	pop    %esi
  801474:	5f                   	pop    %edi
  801475:	5d                   	pop    %ebp
  801476:	c3                   	ret    

00801477 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	57                   	push   %edi
  80147b:	56                   	push   %esi
  80147c:	53                   	push   %ebx
  80147d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801480:	b8 05 00 00 00       	mov    $0x5,%eax
  801485:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801488:	8b 55 08             	mov    0x8(%ebp),%edx
  80148b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80148e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801491:	8b 75 18             	mov    0x18(%ebp),%esi
  801494:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801496:	85 c0                	test   %eax,%eax
  801498:	7e 28                	jle    8014c2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80149a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80149e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8014a5:	00 
  8014a6:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  8014ad:	00 
  8014ae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014b5:	00 
  8014b6:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  8014bd:	e8 26 f4 ff ff       	call   8008e8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8014c2:	83 c4 2c             	add    $0x2c,%esp
  8014c5:	5b                   	pop    %ebx
  8014c6:	5e                   	pop    %esi
  8014c7:	5f                   	pop    %edi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    

008014ca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	57                   	push   %edi
  8014ce:	56                   	push   %esi
  8014cf:	53                   	push   %ebx
  8014d0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8014dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e3:	89 df                	mov    %ebx,%edi
  8014e5:	89 de                	mov    %ebx,%esi
  8014e7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	7e 28                	jle    801515 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014f1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8014f8:	00 
  8014f9:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  801500:	00 
  801501:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801508:	00 
  801509:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  801510:	e8 d3 f3 ff ff       	call   8008e8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801515:	83 c4 2c             	add    $0x2c,%esp
  801518:	5b                   	pop    %ebx
  801519:	5e                   	pop    %esi
  80151a:	5f                   	pop    %edi
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	57                   	push   %edi
  801521:	56                   	push   %esi
  801522:	53                   	push   %ebx
  801523:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801526:	bb 00 00 00 00       	mov    $0x0,%ebx
  80152b:	b8 08 00 00 00       	mov    $0x8,%eax
  801530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	89 df                	mov    %ebx,%edi
  801538:	89 de                	mov    %ebx,%esi
  80153a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80153c:	85 c0                	test   %eax,%eax
  80153e:	7e 28                	jle    801568 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801540:	89 44 24 10          	mov    %eax,0x10(%esp)
  801544:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80154b:	00 
  80154c:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  801553:	00 
  801554:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80155b:	00 
  80155c:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  801563:	e8 80 f3 ff ff       	call   8008e8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801568:	83 c4 2c             	add    $0x2c,%esp
  80156b:	5b                   	pop    %ebx
  80156c:	5e                   	pop    %esi
  80156d:	5f                   	pop    %edi
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	57                   	push   %edi
  801574:	56                   	push   %esi
  801575:	53                   	push   %ebx
  801576:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801579:	bb 00 00 00 00       	mov    $0x0,%ebx
  80157e:	b8 09 00 00 00       	mov    $0x9,%eax
  801583:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801586:	8b 55 08             	mov    0x8(%ebp),%edx
  801589:	89 df                	mov    %ebx,%edi
  80158b:	89 de                	mov    %ebx,%esi
  80158d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80158f:	85 c0                	test   %eax,%eax
  801591:	7e 28                	jle    8015bb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801593:	89 44 24 10          	mov    %eax,0x10(%esp)
  801597:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80159e:	00 
  80159f:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  8015a6:	00 
  8015a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015ae:	00 
  8015af:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  8015b6:	e8 2d f3 ff ff       	call   8008e8 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8015bb:	83 c4 2c             	add    $0x2c,%esp
  8015be:	5b                   	pop    %ebx
  8015bf:	5e                   	pop    %esi
  8015c0:	5f                   	pop    %edi
  8015c1:	5d                   	pop    %ebp
  8015c2:	c3                   	ret    

008015c3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
  8015c6:	57                   	push   %edi
  8015c7:	56                   	push   %esi
  8015c8:	53                   	push   %ebx
  8015c9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015dc:	89 df                	mov    %ebx,%edi
  8015de:	89 de                	mov    %ebx,%esi
  8015e0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	7e 28                	jle    80160e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015ea:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8015f1:	00 
  8015f2:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  8015f9:	00 
  8015fa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801601:	00 
  801602:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  801609:	e8 da f2 ff ff       	call   8008e8 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80160e:	83 c4 2c             	add    $0x2c,%esp
  801611:	5b                   	pop    %ebx
  801612:	5e                   	pop    %esi
  801613:	5f                   	pop    %edi
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	57                   	push   %edi
  80161a:	56                   	push   %esi
  80161b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161c:	be 00 00 00 00       	mov    $0x0,%esi
  801621:	b8 0c 00 00 00       	mov    $0xc,%eax
  801626:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801629:	8b 55 08             	mov    0x8(%ebp),%edx
  80162c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80162f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801632:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801634:	5b                   	pop    %ebx
  801635:	5e                   	pop    %esi
  801636:	5f                   	pop    %edi
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    

00801639 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	57                   	push   %edi
  80163d:	56                   	push   %esi
  80163e:	53                   	push   %ebx
  80163f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801642:	b9 00 00 00 00       	mov    $0x0,%ecx
  801647:	b8 0d 00 00 00       	mov    $0xd,%eax
  80164c:	8b 55 08             	mov    0x8(%ebp),%edx
  80164f:	89 cb                	mov    %ecx,%ebx
  801651:	89 cf                	mov    %ecx,%edi
  801653:	89 ce                	mov    %ecx,%esi
  801655:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801657:	85 c0                	test   %eax,%eax
  801659:	7e 28                	jle    801683 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80165b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80165f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801666:	00 
  801667:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  80166e:	00 
  80166f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801676:	00 
  801677:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  80167e:	e8 65 f2 ff ff       	call   8008e8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801683:	83 c4 2c             	add    $0x2c,%esp
  801686:	5b                   	pop    %ebx
  801687:	5e                   	pop    %esi
  801688:	5f                   	pop    %edi
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    

0080168b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	57                   	push   %edi
  80168f:	56                   	push   %esi
  801690:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801691:	ba 00 00 00 00       	mov    $0x0,%edx
  801696:	b8 0e 00 00 00       	mov    $0xe,%eax
  80169b:	89 d1                	mov    %edx,%ecx
  80169d:	89 d3                	mov    %edx,%ebx
  80169f:	89 d7                	mov    %edx,%edi
  8016a1:	89 d6                	mov    %edx,%esi
  8016a3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8016a5:	5b                   	pop    %ebx
  8016a6:	5e                   	pop    %esi
  8016a7:	5f                   	pop    %edi
  8016a8:	5d                   	pop    %ebp
  8016a9:	c3                   	ret    

008016aa <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	57                   	push   %edi
  8016ae:	56                   	push   %esi
  8016af:	53                   	push   %ebx
  8016b0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b8:	b8 0f 00 00 00       	mov    $0xf,%eax
  8016bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c3:	89 df                	mov    %ebx,%edi
  8016c5:	89 de                	mov    %ebx,%esi
  8016c7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	7e 28                	jle    8016f5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8016cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016d1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8016d8:	00 
  8016d9:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  8016e0:	00 
  8016e1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8016e8:	00 
  8016e9:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  8016f0:	e8 f3 f1 ff ff       	call   8008e8 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  8016f5:	83 c4 2c             	add    $0x2c,%esp
  8016f8:	5b                   	pop    %ebx
  8016f9:	5e                   	pop    %esi
  8016fa:	5f                   	pop    %edi
  8016fb:	5d                   	pop    %ebp
  8016fc:	c3                   	ret    

008016fd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	57                   	push   %edi
  801701:	56                   	push   %esi
  801702:	53                   	push   %ebx
  801703:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801706:	bb 00 00 00 00       	mov    $0x0,%ebx
  80170b:	b8 10 00 00 00       	mov    $0x10,%eax
  801710:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801713:	8b 55 08             	mov    0x8(%ebp),%edx
  801716:	89 df                	mov    %ebx,%edi
  801718:	89 de                	mov    %ebx,%esi
  80171a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80171c:	85 c0                	test   %eax,%eax
  80171e:	7e 28                	jle    801748 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801720:	89 44 24 10          	mov    %eax,0x10(%esp)
  801724:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80172b:	00 
  80172c:	c7 44 24 08 9f 35 80 	movl   $0x80359f,0x8(%esp)
  801733:	00 
  801734:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80173b:	00 
  80173c:	c7 04 24 bc 35 80 00 	movl   $0x8035bc,(%esp)
  801743:	e8 a0 f1 ff ff       	call   8008e8 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801748:	83 c4 2c             	add    $0x2c,%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5e                   	pop    %esi
  80174d:	5f                   	pop    %edi
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	05 00 00 00 30       	add    $0x30000000,%eax
  80175b:	c1 e8 0c             	shr    $0xc,%eax
}
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    

00801760 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80176b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801770:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80177d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801782:	89 c2                	mov    %eax,%edx
  801784:	c1 ea 16             	shr    $0x16,%edx
  801787:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80178e:	f6 c2 01             	test   $0x1,%dl
  801791:	74 11                	je     8017a4 <fd_alloc+0x2d>
  801793:	89 c2                	mov    %eax,%edx
  801795:	c1 ea 0c             	shr    $0xc,%edx
  801798:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80179f:	f6 c2 01             	test   $0x1,%dl
  8017a2:	75 09                	jne    8017ad <fd_alloc+0x36>
			*fd_store = fd;
  8017a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ab:	eb 17                	jmp    8017c4 <fd_alloc+0x4d>
  8017ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017b7:	75 c9                	jne    801782 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8017bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017cc:	83 f8 1f             	cmp    $0x1f,%eax
  8017cf:	77 36                	ja     801807 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017d1:	c1 e0 0c             	shl    $0xc,%eax
  8017d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8017d9:	89 c2                	mov    %eax,%edx
  8017db:	c1 ea 16             	shr    $0x16,%edx
  8017de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017e5:	f6 c2 01             	test   $0x1,%dl
  8017e8:	74 24                	je     80180e <fd_lookup+0x48>
  8017ea:	89 c2                	mov    %eax,%edx
  8017ec:	c1 ea 0c             	shr    $0xc,%edx
  8017ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017f6:	f6 c2 01             	test   $0x1,%dl
  8017f9:	74 1a                	je     801815 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801800:	b8 00 00 00 00       	mov    $0x0,%eax
  801805:	eb 13                	jmp    80181a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80180c:	eb 0c                	jmp    80181a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80180e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801813:	eb 05                	jmp    80181a <fd_lookup+0x54>
  801815:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	83 ec 18             	sub    $0x18,%esp
  801822:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801825:	ba 00 00 00 00       	mov    $0x0,%edx
  80182a:	eb 13                	jmp    80183f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80182c:	39 08                	cmp    %ecx,(%eax)
  80182e:	75 0c                	jne    80183c <dev_lookup+0x20>
			*dev = devtab[i];
  801830:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801833:	89 01                	mov    %eax,(%ecx)
			return 0;
  801835:	b8 00 00 00 00       	mov    $0x0,%eax
  80183a:	eb 38                	jmp    801874 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80183c:	83 c2 01             	add    $0x1,%edx
  80183f:	8b 04 95 48 36 80 00 	mov    0x803648(,%edx,4),%eax
  801846:	85 c0                	test   %eax,%eax
  801848:	75 e2                	jne    80182c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80184a:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80184f:	8b 40 48             	mov    0x48(%eax),%eax
  801852:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801856:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185a:	c7 04 24 cc 35 80 00 	movl   $0x8035cc,(%esp)
  801861:	e8 7b f1 ff ff       	call   8009e1 <cprintf>
	*dev = 0;
  801866:	8b 45 0c             	mov    0xc(%ebp),%eax
  801869:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80186f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
  80187b:	83 ec 20             	sub    $0x20,%esp
  80187e:	8b 75 08             	mov    0x8(%ebp),%esi
  801881:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801884:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801887:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80188b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801891:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801894:	89 04 24             	mov    %eax,(%esp)
  801897:	e8 2a ff ff ff       	call   8017c6 <fd_lookup>
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 05                	js     8018a5 <fd_close+0x2f>
	    || fd != fd2)
  8018a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018a3:	74 0c                	je     8018b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8018a5:	84 db                	test   %bl,%bl
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	0f 44 c2             	cmove  %edx,%eax
  8018af:	eb 3f                	jmp    8018f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b8:	8b 06                	mov    (%esi),%eax
  8018ba:	89 04 24             	mov    %eax,(%esp)
  8018bd:	e8 5a ff ff ff       	call   80181c <dev_lookup>
  8018c2:	89 c3                	mov    %eax,%ebx
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	78 16                	js     8018de <fd_close+0x68>
		if (dev->dev_close)
  8018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8018ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	74 07                	je     8018de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8018d7:	89 34 24             	mov    %esi,(%esp)
  8018da:	ff d0                	call   *%eax
  8018dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e9:	e8 dc fb ff ff       	call   8014ca <sys_page_unmap>
	return r;
  8018ee:	89 d8                	mov    %ebx,%eax
}
  8018f0:	83 c4 20             	add    $0x20,%esp
  8018f3:	5b                   	pop    %ebx
  8018f4:	5e                   	pop    %esi
  8018f5:	5d                   	pop    %ebp
  8018f6:	c3                   	ret    

008018f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801900:	89 44 24 04          	mov    %eax,0x4(%esp)
  801904:	8b 45 08             	mov    0x8(%ebp),%eax
  801907:	89 04 24             	mov    %eax,(%esp)
  80190a:	e8 b7 fe ff ff       	call   8017c6 <fd_lookup>
  80190f:	89 c2                	mov    %eax,%edx
  801911:	85 d2                	test   %edx,%edx
  801913:	78 13                	js     801928 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801915:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80191c:	00 
  80191d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801920:	89 04 24             	mov    %eax,(%esp)
  801923:	e8 4e ff ff ff       	call   801876 <fd_close>
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <close_all>:

void
close_all(void)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	53                   	push   %ebx
  80192e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801931:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801936:	89 1c 24             	mov    %ebx,(%esp)
  801939:	e8 b9 ff ff ff       	call   8018f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80193e:	83 c3 01             	add    $0x1,%ebx
  801941:	83 fb 20             	cmp    $0x20,%ebx
  801944:	75 f0                	jne    801936 <close_all+0xc>
		close(i);
}
  801946:	83 c4 14             	add    $0x14,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    

0080194c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	57                   	push   %edi
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801955:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195c:	8b 45 08             	mov    0x8(%ebp),%eax
  80195f:	89 04 24             	mov    %eax,(%esp)
  801962:	e8 5f fe ff ff       	call   8017c6 <fd_lookup>
  801967:	89 c2                	mov    %eax,%edx
  801969:	85 d2                	test   %edx,%edx
  80196b:	0f 88 e1 00 00 00    	js     801a52 <dup+0x106>
		return r;
	close(newfdnum);
  801971:	8b 45 0c             	mov    0xc(%ebp),%eax
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	e8 7b ff ff ff       	call   8018f7 <close>

	newfd = INDEX2FD(newfdnum);
  80197c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80197f:	c1 e3 0c             	shl    $0xc,%ebx
  801982:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801988:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80198b:	89 04 24             	mov    %eax,(%esp)
  80198e:	e8 cd fd ff ff       	call   801760 <fd2data>
  801993:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801995:	89 1c 24             	mov    %ebx,(%esp)
  801998:	e8 c3 fd ff ff       	call   801760 <fd2data>
  80199d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80199f:	89 f0                	mov    %esi,%eax
  8019a1:	c1 e8 16             	shr    $0x16,%eax
  8019a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019ab:	a8 01                	test   $0x1,%al
  8019ad:	74 43                	je     8019f2 <dup+0xa6>
  8019af:	89 f0                	mov    %esi,%eax
  8019b1:	c1 e8 0c             	shr    $0xc,%eax
  8019b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019bb:	f6 c2 01             	test   $0x1,%dl
  8019be:	74 32                	je     8019f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8019c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8019cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019db:	00 
  8019dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019e7:	e8 8b fa ff ff       	call   801477 <sys_page_map>
  8019ec:	89 c6                	mov    %eax,%esi
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 3e                	js     801a30 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8019f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019f5:	89 c2                	mov    %eax,%edx
  8019f7:	c1 ea 0c             	shr    $0xc,%edx
  8019fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a01:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a07:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a0b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a16:	00 
  801a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a22:	e8 50 fa ff ff       	call   801477 <sys_page_map>
  801a27:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a29:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a2c:	85 f6                	test   %esi,%esi
  801a2e:	79 22                	jns    801a52 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a30:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3b:	e8 8a fa ff ff       	call   8014ca <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a4b:	e8 7a fa ff ff       	call   8014ca <sys_page_unmap>
	return r;
  801a50:	89 f0                	mov    %esi,%eax
}
  801a52:	83 c4 3c             	add    $0x3c,%esp
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5f                   	pop    %edi
  801a58:	5d                   	pop    %ebp
  801a59:	c3                   	ret    

00801a5a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	53                   	push   %ebx
  801a5e:	83 ec 24             	sub    $0x24,%esp
  801a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6b:	89 1c 24             	mov    %ebx,(%esp)
  801a6e:	e8 53 fd ff ff       	call   8017c6 <fd_lookup>
  801a73:	89 c2                	mov    %eax,%edx
  801a75:	85 d2                	test   %edx,%edx
  801a77:	78 6d                	js     801ae6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a83:	8b 00                	mov    (%eax),%eax
  801a85:	89 04 24             	mov    %eax,(%esp)
  801a88:	e8 8f fd ff ff       	call   80181c <dev_lookup>
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	78 55                	js     801ae6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a94:	8b 50 08             	mov    0x8(%eax),%edx
  801a97:	83 e2 03             	and    $0x3,%edx
  801a9a:	83 fa 01             	cmp    $0x1,%edx
  801a9d:	75 23                	jne    801ac2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801a9f:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801aa4:	8b 40 48             	mov    0x48(%eax),%eax
  801aa7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aaf:	c7 04 24 0d 36 80 00 	movl   $0x80360d,(%esp)
  801ab6:	e8 26 ef ff ff       	call   8009e1 <cprintf>
		return -E_INVAL;
  801abb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ac0:	eb 24                	jmp    801ae6 <read+0x8c>
	}
	if (!dev->dev_read)
  801ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ac5:	8b 52 08             	mov    0x8(%edx),%edx
  801ac8:	85 d2                	test   %edx,%edx
  801aca:	74 15                	je     801ae1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801acc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801acf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ad3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ad6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ada:	89 04 24             	mov    %eax,(%esp)
  801add:	ff d2                	call   *%edx
  801adf:	eb 05                	jmp    801ae6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801ae1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801ae6:	83 c4 24             	add    $0x24,%esp
  801ae9:	5b                   	pop    %ebx
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    

00801aec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	57                   	push   %edi
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	83 ec 1c             	sub    $0x1c,%esp
  801af5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801af8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801afb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b00:	eb 23                	jmp    801b25 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b02:	89 f0                	mov    %esi,%eax
  801b04:	29 d8                	sub    %ebx,%eax
  801b06:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b0a:	89 d8                	mov    %ebx,%eax
  801b0c:	03 45 0c             	add    0xc(%ebp),%eax
  801b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b13:	89 3c 24             	mov    %edi,(%esp)
  801b16:	e8 3f ff ff ff       	call   801a5a <read>
		if (m < 0)
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 10                	js     801b2f <readn+0x43>
			return m;
		if (m == 0)
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	74 0a                	je     801b2d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b23:	01 c3                	add    %eax,%ebx
  801b25:	39 f3                	cmp    %esi,%ebx
  801b27:	72 d9                	jb     801b02 <readn+0x16>
  801b29:	89 d8                	mov    %ebx,%eax
  801b2b:	eb 02                	jmp    801b2f <readn+0x43>
  801b2d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b2f:	83 c4 1c             	add    $0x1c,%esp
  801b32:	5b                   	pop    %ebx
  801b33:	5e                   	pop    %esi
  801b34:	5f                   	pop    %edi
  801b35:	5d                   	pop    %ebp
  801b36:	c3                   	ret    

00801b37 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	53                   	push   %ebx
  801b3b:	83 ec 24             	sub    $0x24,%esp
  801b3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b41:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b48:	89 1c 24             	mov    %ebx,(%esp)
  801b4b:	e8 76 fc ff ff       	call   8017c6 <fd_lookup>
  801b50:	89 c2                	mov    %eax,%edx
  801b52:	85 d2                	test   %edx,%edx
  801b54:	78 68                	js     801bbe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b60:	8b 00                	mov    (%eax),%eax
  801b62:	89 04 24             	mov    %eax,(%esp)
  801b65:	e8 b2 fc ff ff       	call   80181c <dev_lookup>
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 50                	js     801bbe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b71:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b75:	75 23                	jne    801b9a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801b77:	a1 1c 50 80 00       	mov    0x80501c,%eax
  801b7c:	8b 40 48             	mov    0x48(%eax),%eax
  801b7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b87:	c7 04 24 29 36 80 00 	movl   $0x803629,(%esp)
  801b8e:	e8 4e ee ff ff       	call   8009e1 <cprintf>
		return -E_INVAL;
  801b93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b98:	eb 24                	jmp    801bbe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9d:	8b 52 0c             	mov    0xc(%edx),%edx
  801ba0:	85 d2                	test   %edx,%edx
  801ba2:	74 15                	je     801bb9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ba4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bb2:	89 04 24             	mov    %eax,(%esp)
  801bb5:	ff d2                	call   *%edx
  801bb7:	eb 05                	jmp    801bbe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801bb9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801bbe:	83 c4 24             	add    $0x24,%esp
  801bc1:	5b                   	pop    %ebx
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    

00801bc4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
  801bc7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	89 04 24             	mov    %eax,(%esp)
  801bd7:	e8 ea fb ff ff       	call   8017c6 <fd_lookup>
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	78 0e                	js     801bee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 24             	sub    $0x24,%esp
  801bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bfa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c01:	89 1c 24             	mov    %ebx,(%esp)
  801c04:	e8 bd fb ff ff       	call   8017c6 <fd_lookup>
  801c09:	89 c2                	mov    %eax,%edx
  801c0b:	85 d2                	test   %edx,%edx
  801c0d:	78 61                	js     801c70 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c19:	8b 00                	mov    (%eax),%eax
  801c1b:	89 04 24             	mov    %eax,(%esp)
  801c1e:	e8 f9 fb ff ff       	call   80181c <dev_lookup>
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 49                	js     801c70 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c2e:	75 23                	jne    801c53 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801c30:	a1 1c 50 80 00       	mov    0x80501c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c35:	8b 40 48             	mov    0x48(%eax),%eax
  801c38:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c40:	c7 04 24 ec 35 80 00 	movl   $0x8035ec,(%esp)
  801c47:	e8 95 ed ff ff       	call   8009e1 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c51:	eb 1d                	jmp    801c70 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c56:	8b 52 18             	mov    0x18(%edx),%edx
  801c59:	85 d2                	test   %edx,%edx
  801c5b:	74 0e                	je     801c6b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	ff d2                	call   *%edx
  801c69:	eb 05                	jmp    801c70 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801c6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801c70:	83 c4 24             	add    $0x24,%esp
  801c73:	5b                   	pop    %ebx
  801c74:	5d                   	pop    %ebp
  801c75:	c3                   	ret    

00801c76 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	53                   	push   %ebx
  801c7a:	83 ec 24             	sub    $0x24,%esp
  801c7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	89 04 24             	mov    %eax,(%esp)
  801c8d:	e8 34 fb ff ff       	call   8017c6 <fd_lookup>
  801c92:	89 c2                	mov    %eax,%edx
  801c94:	85 d2                	test   %edx,%edx
  801c96:	78 52                	js     801cea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca2:	8b 00                	mov    (%eax),%eax
  801ca4:	89 04 24             	mov    %eax,(%esp)
  801ca7:	e8 70 fb ff ff       	call   80181c <dev_lookup>
  801cac:	85 c0                	test   %eax,%eax
  801cae:	78 3a                	js     801cea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cb7:	74 2c                	je     801ce5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cb9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cbc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801cc3:	00 00 00 
	stat->st_isdir = 0;
  801cc6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ccd:	00 00 00 
	stat->st_dev = dev;
  801cd0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cdd:	89 14 24             	mov    %edx,(%esp)
  801ce0:	ff 50 14             	call   *0x14(%eax)
  801ce3:	eb 05                	jmp    801cea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ce5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801cea:	83 c4 24             	add    $0x24,%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	56                   	push   %esi
  801cf4:	53                   	push   %ebx
  801cf5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cf8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cff:	00 
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	89 04 24             	mov    %eax,(%esp)
  801d06:	e8 28 02 00 00       	call   801f33 <open>
  801d0b:	89 c3                	mov    %eax,%ebx
  801d0d:	85 db                	test   %ebx,%ebx
  801d0f:	78 1b                	js     801d2c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d18:	89 1c 24             	mov    %ebx,(%esp)
  801d1b:	e8 56 ff ff ff       	call   801c76 <fstat>
  801d20:	89 c6                	mov    %eax,%esi
	close(fd);
  801d22:	89 1c 24             	mov    %ebx,(%esp)
  801d25:	e8 cd fb ff ff       	call   8018f7 <close>
	return r;
  801d2a:	89 f0                	mov    %esi,%eax
}
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	56                   	push   %esi
  801d37:	53                   	push   %ebx
  801d38:	83 ec 10             	sub    $0x10,%esp
  801d3b:	89 c6                	mov    %eax,%esi
  801d3d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d3f:	83 3d 10 50 80 00 00 	cmpl   $0x0,0x805010
  801d46:	75 11                	jne    801d59 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d4f:	e8 1a 10 00 00       	call   802d6e <ipc_find_env>
  801d54:	a3 10 50 80 00       	mov    %eax,0x805010
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d59:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d60:	00 
  801d61:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d68:	00 
  801d69:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d6d:	a1 10 50 80 00       	mov    0x805010,%eax
  801d72:	89 04 24             	mov    %eax,(%esp)
  801d75:	e8 96 0f 00 00       	call   802d10 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d81:	00 
  801d82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d8d:	e8 14 0f 00 00       	call   802ca6 <ipc_recv>
}
  801d92:	83 c4 10             	add    $0x10,%esp
  801d95:	5b                   	pop    %ebx
  801d96:	5e                   	pop    %esi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    

00801d99 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	8b 40 0c             	mov    0xc(%eax),%eax
  801da5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dad:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801db2:	ba 00 00 00 00       	mov    $0x0,%edx
  801db7:	b8 02 00 00 00       	mov    $0x2,%eax
  801dbc:	e8 72 ff ff ff       	call   801d33 <fsipc>
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801dcf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801dd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd9:	b8 06 00 00 00       	mov    $0x6,%eax
  801dde:	e8 50 ff ff ff       	call   801d33 <fsipc>
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	53                   	push   %ebx
  801de9:	83 ec 14             	sub    $0x14,%esp
  801dec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	8b 40 0c             	mov    0xc(%eax),%eax
  801df5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801dff:	b8 05 00 00 00       	mov    $0x5,%eax
  801e04:	e8 2a ff ff ff       	call   801d33 <fsipc>
  801e09:	89 c2                	mov    %eax,%edx
  801e0b:	85 d2                	test   %edx,%edx
  801e0d:	78 2b                	js     801e3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e16:	00 
  801e17:	89 1c 24             	mov    %ebx,(%esp)
  801e1a:	e8 e8 f1 ff ff       	call   801007 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e1f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e2a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3a:	83 c4 14             	add    $0x14,%esp
  801e3d:	5b                   	pop    %ebx
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    

00801e40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 18             	sub    $0x18,%esp
  801e46:	8b 45 10             	mov    0x10(%ebp),%eax
  801e49:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801e4e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801e53:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801e56:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e5e:	8b 52 0c             	mov    0xc(%edx),%edx
  801e61:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801e67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e72:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801e79:	e8 26 f3 ff ff       	call   8011a4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801e7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e83:	b8 04 00 00 00       	mov    $0x4,%eax
  801e88:	e8 a6 fe ff ff       	call   801d33 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	56                   	push   %esi
  801e93:	53                   	push   %ebx
  801e94:	83 ec 10             	sub    $0x10,%esp
  801e97:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ea5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801eab:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb0:	b8 03 00 00 00       	mov    $0x3,%eax
  801eb5:	e8 79 fe ff ff       	call   801d33 <fsipc>
  801eba:	89 c3                	mov    %eax,%ebx
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	78 6a                	js     801f2a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ec0:	39 c6                	cmp    %eax,%esi
  801ec2:	73 24                	jae    801ee8 <devfile_read+0x59>
  801ec4:	c7 44 24 0c 5c 36 80 	movl   $0x80365c,0xc(%esp)
  801ecb:	00 
  801ecc:	c7 44 24 08 63 36 80 	movl   $0x803663,0x8(%esp)
  801ed3:	00 
  801ed4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801edb:	00 
  801edc:	c7 04 24 78 36 80 00 	movl   $0x803678,(%esp)
  801ee3:	e8 00 ea ff ff       	call   8008e8 <_panic>
	assert(r <= PGSIZE);
  801ee8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eed:	7e 24                	jle    801f13 <devfile_read+0x84>
  801eef:	c7 44 24 0c 83 36 80 	movl   $0x803683,0xc(%esp)
  801ef6:	00 
  801ef7:	c7 44 24 08 63 36 80 	movl   $0x803663,0x8(%esp)
  801efe:	00 
  801eff:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801f06:	00 
  801f07:	c7 04 24 78 36 80 00 	movl   $0x803678,(%esp)
  801f0e:	e8 d5 e9 ff ff       	call   8008e8 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801f13:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f17:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f1e:	00 
  801f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f22:	89 04 24             	mov    %eax,(%esp)
  801f25:	e8 7a f2 ff ff       	call   8011a4 <memmove>
	return r;
}
  801f2a:	89 d8                	mov    %ebx,%eax
  801f2c:	83 c4 10             	add    $0x10,%esp
  801f2f:	5b                   	pop    %ebx
  801f30:	5e                   	pop    %esi
  801f31:	5d                   	pop    %ebp
  801f32:	c3                   	ret    

00801f33 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	53                   	push   %ebx
  801f37:	83 ec 24             	sub    $0x24,%esp
  801f3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801f3d:	89 1c 24             	mov    %ebx,(%esp)
  801f40:	e8 8b f0 ff ff       	call   800fd0 <strlen>
  801f45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f4a:	7f 60                	jg     801fac <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801f4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4f:	89 04 24             	mov    %eax,(%esp)
  801f52:	e8 20 f8 ff ff       	call   801777 <fd_alloc>
  801f57:	89 c2                	mov    %eax,%edx
  801f59:	85 d2                	test   %edx,%edx
  801f5b:	78 54                	js     801fb1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801f5d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f61:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801f68:	e8 9a f0 ff ff       	call   801007 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f70:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f78:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7d:	e8 b1 fd ff ff       	call   801d33 <fsipc>
  801f82:	89 c3                	mov    %eax,%ebx
  801f84:	85 c0                	test   %eax,%eax
  801f86:	79 17                	jns    801f9f <open+0x6c>
		fd_close(fd, 0);
  801f88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f8f:	00 
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	89 04 24             	mov    %eax,(%esp)
  801f96:	e8 db f8 ff ff       	call   801876 <fd_close>
		return r;
  801f9b:	89 d8                	mov    %ebx,%eax
  801f9d:	eb 12                	jmp    801fb1 <open+0x7e>
	}

	return fd2num(fd);
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	89 04 24             	mov    %eax,(%esp)
  801fa5:	e8 a6 f7 ff ff       	call   801750 <fd2num>
  801faa:	eb 05                	jmp    801fb1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801fac:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801fb1:	83 c4 24             	add    $0x24,%esp
  801fb4:	5b                   	pop    %ebx
  801fb5:	5d                   	pop    %ebp
  801fb6:	c3                   	ret    

00801fb7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp
  801fba:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801fc2:	b8 08 00 00 00       	mov    $0x8,%eax
  801fc7:	e8 67 fd ff ff       	call   801d33 <fsipc>
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    
  801fce:	66 90                	xchg   %ax,%ax

00801fd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801fd6:	c7 44 24 04 8f 36 80 	movl   $0x80368f,0x4(%esp)
  801fdd:	00 
  801fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe1:	89 04 24             	mov    %eax,(%esp)
  801fe4:	e8 1e f0 ff ff       	call   801007 <strcpy>
	return 0;
}
  801fe9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	53                   	push   %ebx
  801ff4:	83 ec 14             	sub    $0x14,%esp
  801ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801ffa:	89 1c 24             	mov    %ebx,(%esp)
  801ffd:	e8 a4 0d 00 00       	call   802da6 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802002:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802007:	83 f8 01             	cmp    $0x1,%eax
  80200a:	75 0d                	jne    802019 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80200c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80200f:	89 04 24             	mov    %eax,(%esp)
  802012:	e8 29 03 00 00       	call   802340 <nsipc_close>
  802017:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802019:	89 d0                	mov    %edx,%eax
  80201b:	83 c4 14             	add    $0x14,%esp
  80201e:	5b                   	pop    %ebx
  80201f:	5d                   	pop    %ebp
  802020:	c3                   	ret    

00802021 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802027:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80202e:	00 
  80202f:	8b 45 10             	mov    0x10(%ebp),%eax
  802032:	89 44 24 08          	mov    %eax,0x8(%esp)
  802036:	8b 45 0c             	mov    0xc(%ebp),%eax
  802039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203d:	8b 45 08             	mov    0x8(%ebp),%eax
  802040:	8b 40 0c             	mov    0xc(%eax),%eax
  802043:	89 04 24             	mov    %eax,(%esp)
  802046:	e8 f0 03 00 00       	call   80243b <nsipc_send>
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802053:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80205a:	00 
  80205b:	8b 45 10             	mov    0x10(%ebp),%eax
  80205e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802062:	8b 45 0c             	mov    0xc(%ebp),%eax
  802065:	89 44 24 04          	mov    %eax,0x4(%esp)
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	8b 40 0c             	mov    0xc(%eax),%eax
  80206f:	89 04 24             	mov    %eax,(%esp)
  802072:	e8 44 03 00 00       	call   8023bb <nsipc_recv>
}
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80207f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802082:	89 54 24 04          	mov    %edx,0x4(%esp)
  802086:	89 04 24             	mov    %eax,(%esp)
  802089:	e8 38 f7 ff ff       	call   8017c6 <fd_lookup>
  80208e:	85 c0                	test   %eax,%eax
  802090:	78 17                	js     8020a9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 0d 40 40 80 00    	mov    0x804040,%ecx
  80209b:	39 08                	cmp    %ecx,(%eax)
  80209d:	75 05                	jne    8020a4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80209f:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a2:	eb 05                	jmp    8020a9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8020a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	56                   	push   %esi
  8020af:	53                   	push   %ebx
  8020b0:	83 ec 20             	sub    $0x20,%esp
  8020b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b8:	89 04 24             	mov    %eax,(%esp)
  8020bb:	e8 b7 f6 ff ff       	call   801777 <fd_alloc>
  8020c0:	89 c3                	mov    %eax,%ebx
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	78 21                	js     8020e7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8020c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020cd:	00 
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020dc:	e8 42 f3 ff ff       	call   801423 <sys_page_alloc>
  8020e1:	89 c3                	mov    %eax,%ebx
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	79 0c                	jns    8020f3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8020e7:	89 34 24             	mov    %esi,(%esp)
  8020ea:	e8 51 02 00 00       	call   802340 <nsipc_close>
		return r;
  8020ef:	89 d8                	mov    %ebx,%eax
  8020f1:	eb 20                	jmp    802113 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8020f3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802101:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802108:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80210b:	89 14 24             	mov    %edx,(%esp)
  80210e:	e8 3d f6 ff ff       	call   801750 <fd2num>
}
  802113:	83 c4 20             	add    $0x20,%esp
  802116:	5b                   	pop    %ebx
  802117:	5e                   	pop    %esi
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    

0080211a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	e8 51 ff ff ff       	call   802079 <fd2sockid>
		return r;
  802128:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80212a:	85 c0                	test   %eax,%eax
  80212c:	78 23                	js     802151 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80212e:	8b 55 10             	mov    0x10(%ebp),%edx
  802131:	89 54 24 08          	mov    %edx,0x8(%esp)
  802135:	8b 55 0c             	mov    0xc(%ebp),%edx
  802138:	89 54 24 04          	mov    %edx,0x4(%esp)
  80213c:	89 04 24             	mov    %eax,(%esp)
  80213f:	e8 45 01 00 00       	call   802289 <nsipc_accept>
		return r;
  802144:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802146:	85 c0                	test   %eax,%eax
  802148:	78 07                	js     802151 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80214a:	e8 5c ff ff ff       	call   8020ab <alloc_sockfd>
  80214f:	89 c1                	mov    %eax,%ecx
}
  802151:	89 c8                	mov    %ecx,%eax
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	e8 16 ff ff ff       	call   802079 <fd2sockid>
  802163:	89 c2                	mov    %eax,%edx
  802165:	85 d2                	test   %edx,%edx
  802167:	78 16                	js     80217f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802169:	8b 45 10             	mov    0x10(%ebp),%eax
  80216c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802170:	8b 45 0c             	mov    0xc(%ebp),%eax
  802173:	89 44 24 04          	mov    %eax,0x4(%esp)
  802177:	89 14 24             	mov    %edx,(%esp)
  80217a:	e8 60 01 00 00       	call   8022df <nsipc_bind>
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <shutdown>:

int
shutdown(int s, int how)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	e8 ea fe ff ff       	call   802079 <fd2sockid>
  80218f:	89 c2                	mov    %eax,%edx
  802191:	85 d2                	test   %edx,%edx
  802193:	78 0f                	js     8021a4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802195:	8b 45 0c             	mov    0xc(%ebp),%eax
  802198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219c:	89 14 24             	mov    %edx,(%esp)
  80219f:	e8 7a 01 00 00       	call   80231e <nsipc_shutdown>
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	e8 c5 fe ff ff       	call   802079 <fd2sockid>
  8021b4:	89 c2                	mov    %eax,%edx
  8021b6:	85 d2                	test   %edx,%edx
  8021b8:	78 16                	js     8021d0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8021ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8021bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c8:	89 14 24             	mov    %edx,(%esp)
  8021cb:	e8 8a 01 00 00       	call   80235a <nsipc_connect>
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <listen>:

int
listen(int s, int backlog)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	e8 99 fe ff ff       	call   802079 <fd2sockid>
  8021e0:	89 c2                	mov    %eax,%edx
  8021e2:	85 d2                	test   %edx,%edx
  8021e4:	78 0f                	js     8021f5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ed:	89 14 24             	mov    %edx,(%esp)
  8021f0:	e8 a4 01 00 00       	call   802399 <nsipc_listen>
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
  8021fa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8021fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802200:	89 44 24 08          	mov    %eax,0x8(%esp)
  802204:	8b 45 0c             	mov    0xc(%ebp),%eax
  802207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	89 04 24             	mov    %eax,(%esp)
  802211:	e8 98 02 00 00       	call   8024ae <nsipc_socket>
  802216:	89 c2                	mov    %eax,%edx
  802218:	85 d2                	test   %edx,%edx
  80221a:	78 05                	js     802221 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80221c:	e8 8a fe ff ff       	call   8020ab <alloc_sockfd>
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	53                   	push   %ebx
  802227:	83 ec 14             	sub    $0x14,%esp
  80222a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80222c:	83 3d 14 50 80 00 00 	cmpl   $0x0,0x805014
  802233:	75 11                	jne    802246 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802235:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80223c:	e8 2d 0b 00 00       	call   802d6e <ipc_find_env>
  802241:	a3 14 50 80 00       	mov    %eax,0x805014
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802246:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80224d:	00 
  80224e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802255:	00 
  802256:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80225a:	a1 14 50 80 00       	mov    0x805014,%eax
  80225f:	89 04 24             	mov    %eax,(%esp)
  802262:	e8 a9 0a 00 00       	call   802d10 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802267:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80226e:	00 
  80226f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802276:	00 
  802277:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80227e:	e8 23 0a 00 00       	call   802ca6 <ipc_recv>
}
  802283:	83 c4 14             	add    $0x14,%esp
  802286:	5b                   	pop    %ebx
  802287:	5d                   	pop    %ebp
  802288:	c3                   	ret    

00802289 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	56                   	push   %esi
  80228d:	53                   	push   %ebx
  80228e:	83 ec 10             	sub    $0x10,%esp
  802291:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80229c:	8b 06                	mov    (%esi),%eax
  80229e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8022a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a8:	e8 76 ff ff ff       	call   802223 <nsipc>
  8022ad:	89 c3                	mov    %eax,%ebx
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	78 23                	js     8022d6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8022b3:	a1 10 70 80 00       	mov    0x807010,%eax
  8022b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022bc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022c3:	00 
  8022c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c7:	89 04 24             	mov    %eax,(%esp)
  8022ca:	e8 d5 ee ff ff       	call   8011a4 <memmove>
		*addrlen = ret->ret_addrlen;
  8022cf:	a1 10 70 80 00       	mov    0x807010,%eax
  8022d4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8022d6:	89 d8                	mov    %ebx,%eax
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	5b                   	pop    %ebx
  8022dc:	5e                   	pop    %esi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    

008022df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	53                   	push   %ebx
  8022e3:	83 ec 14             	sub    $0x14,%esp
  8022e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802303:	e8 9c ee ff ff       	call   8011a4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802308:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80230e:	b8 02 00 00 00       	mov    $0x2,%eax
  802313:	e8 0b ff ff ff       	call   802223 <nsipc>
}
  802318:	83 c4 14             	add    $0x14,%esp
  80231b:	5b                   	pop    %ebx
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    

0080231e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80232c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802334:	b8 03 00 00 00       	mov    $0x3,%eax
  802339:	e8 e5 fe ff ff       	call   802223 <nsipc>
}
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <nsipc_close>:

int
nsipc_close(int s)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80234e:	b8 04 00 00 00       	mov    $0x4,%eax
  802353:	e8 cb fe ff ff       	call   802223 <nsipc>
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	53                   	push   %ebx
  80235e:	83 ec 14             	sub    $0x14,%esp
  802361:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80236c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802370:	8b 45 0c             	mov    0xc(%ebp),%eax
  802373:	89 44 24 04          	mov    %eax,0x4(%esp)
  802377:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80237e:	e8 21 ee ff ff       	call   8011a4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802383:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802389:	b8 05 00 00 00       	mov    $0x5,%eax
  80238e:	e8 90 fe ff ff       	call   802223 <nsipc>
}
  802393:	83 c4 14             	add    $0x14,%esp
  802396:	5b                   	pop    %ebx
  802397:	5d                   	pop    %ebp
  802398:	c3                   	ret    

00802399 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802399:	55                   	push   %ebp
  80239a:	89 e5                	mov    %esp,%ebp
  80239c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8023a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023aa:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8023af:	b8 06 00 00 00       	mov    $0x6,%eax
  8023b4:	e8 6a fe ff ff       	call   802223 <nsipc>
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	83 ec 10             	sub    $0x10,%esp
  8023c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8023ce:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8023d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8023e1:	e8 3d fe ff ff       	call   802223 <nsipc>
  8023e6:	89 c3                	mov    %eax,%ebx
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	78 46                	js     802432 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8023ec:	39 f0                	cmp    %esi,%eax
  8023ee:	7f 07                	jg     8023f7 <nsipc_recv+0x3c>
  8023f0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023f5:	7e 24                	jle    80241b <nsipc_recv+0x60>
  8023f7:	c7 44 24 0c 9b 36 80 	movl   $0x80369b,0xc(%esp)
  8023fe:	00 
  8023ff:	c7 44 24 08 63 36 80 	movl   $0x803663,0x8(%esp)
  802406:	00 
  802407:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80240e:	00 
  80240f:	c7 04 24 b0 36 80 00 	movl   $0x8036b0,(%esp)
  802416:	e8 cd e4 ff ff       	call   8008e8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80241b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80241f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802426:	00 
  802427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242a:	89 04 24             	mov    %eax,(%esp)
  80242d:	e8 72 ed ff ff       	call   8011a4 <memmove>
	}

	return r;
}
  802432:	89 d8                	mov    %ebx,%eax
  802434:	83 c4 10             	add    $0x10,%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    

0080243b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	53                   	push   %ebx
  80243f:	83 ec 14             	sub    $0x14,%esp
  802442:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802445:	8b 45 08             	mov    0x8(%ebp),%eax
  802448:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80244d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802453:	7e 24                	jle    802479 <nsipc_send+0x3e>
  802455:	c7 44 24 0c bc 36 80 	movl   $0x8036bc,0xc(%esp)
  80245c:	00 
  80245d:	c7 44 24 08 63 36 80 	movl   $0x803663,0x8(%esp)
  802464:	00 
  802465:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80246c:	00 
  80246d:	c7 04 24 b0 36 80 00 	movl   $0x8036b0,(%esp)
  802474:	e8 6f e4 ff ff       	call   8008e8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802479:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80247d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802480:	89 44 24 04          	mov    %eax,0x4(%esp)
  802484:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80248b:	e8 14 ed ff ff       	call   8011a4 <memmove>
	nsipcbuf.send.req_size = size;
  802490:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802496:	8b 45 14             	mov    0x14(%ebp),%eax
  802499:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80249e:	b8 08 00 00 00       	mov    $0x8,%eax
  8024a3:	e8 7b fd ff ff       	call   802223 <nsipc>
}
  8024a8:	83 c4 14             	add    $0x14,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5d                   	pop    %ebp
  8024ad:	c3                   	ret    

008024ae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
  8024b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8024b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8024bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8024c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8024cc:	b8 09 00 00 00       	mov    $0x9,%eax
  8024d1:	e8 4d fd ff ff       	call   802223 <nsipc>
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    
  8024d8:	66 90                	xchg   %ax,%ax
  8024da:	66 90                	xchg   %ax,%ax
  8024dc:	66 90                	xchg   %ax,%ax
  8024de:	66 90                	xchg   %ax,%ax

008024e0 <free>:
	return v;
}

void
free(void *v)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
  8024e3:	53                   	push   %ebx
  8024e4:	83 ec 14             	sub    $0x14,%esp
  8024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  8024ea:	85 db                	test   %ebx,%ebx
  8024ec:	0f 84 ba 00 00 00    	je     8025ac <free+0xcc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  8024f2:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  8024f8:	76 08                	jbe    802502 <free+0x22>
  8024fa:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  802500:	76 24                	jbe    802526 <free+0x46>
  802502:	c7 44 24 0c c8 36 80 	movl   $0x8036c8,0xc(%esp)
  802509:	00 
  80250a:	c7 44 24 08 63 36 80 	movl   $0x803663,0x8(%esp)
  802511:	00 
  802512:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  802519:	00 
  80251a:	c7 04 24 f8 36 80 00 	movl   $0x8036f8,(%esp)
  802521:	e8 c2 e3 ff ff       	call   8008e8 <_panic>

	c = ROUNDDOWN(v, PGSIZE);
  802526:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  80252c:	eb 4a                	jmp    802578 <free+0x98>
		sys_page_unmap(0, c);
  80252e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802532:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802539:	e8 8c ef ff ff       	call   8014ca <sys_page_unmap>
		c += PGSIZE;
  80253e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  802544:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  80254a:	76 08                	jbe    802554 <free+0x74>
  80254c:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  802552:	76 24                	jbe    802578 <free+0x98>
  802554:	c7 44 24 0c 05 37 80 	movl   $0x803705,0xc(%esp)
  80255b:	00 
  80255c:	c7 44 24 08 63 36 80 	movl   $0x803663,0x8(%esp)
  802563:	00 
  802564:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  80256b:	00 
  80256c:	c7 04 24 f8 36 80 00 	movl   $0x8036f8,(%esp)
  802573:	e8 70 e3 ff ff       	call   8008e8 <_panic>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (uvpt[PGNUM(c)] & PTE_CONTINUED) {
  802578:	89 d8                	mov    %ebx,%eax
  80257a:	c1 e8 0c             	shr    $0xc,%eax
  80257d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802584:	f6 c4 02             	test   $0x2,%ah
  802587:	75 a5                	jne    80252e <free+0x4e>
	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
	if (--(*ref) == 0)
  802589:	8b 83 fc 0f 00 00    	mov    0xffc(%ebx),%eax
  80258f:	83 e8 01             	sub    $0x1,%eax
  802592:	89 83 fc 0f 00 00    	mov    %eax,0xffc(%ebx)
  802598:	85 c0                	test   %eax,%eax
  80259a:	75 10                	jne    8025ac <free+0xcc>
		sys_page_unmap(0, c);
  80259c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a7:	e8 1e ef ff ff       	call   8014ca <sys_page_unmap>
}
  8025ac:	83 c4 14             	add    $0x14,%esp
  8025af:	5b                   	pop    %ebx
  8025b0:	5d                   	pop    %ebp
  8025b1:	c3                   	ret    

008025b2 <malloc>:
	return 1;
}

void*
malloc(size_t n)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
  8025b5:	57                   	push   %edi
  8025b6:	56                   	push   %esi
  8025b7:	53                   	push   %ebx
  8025b8:	83 ec 2c             	sub    $0x2c,%esp
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  8025bb:	83 3d 18 50 80 00 00 	cmpl   $0x0,0x805018
  8025c2:	75 0a                	jne    8025ce <malloc+0x1c>
		mptr = mbegin;
  8025c4:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8025cb:	00 00 08 

	n = ROUNDUP(n, 4);
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	83 c0 03             	add    $0x3,%eax
  8025d4:	83 e0 fc             	and    $0xfffffffc,%eax
  8025d7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if (n >= MAXMALLOC)
  8025da:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  8025df:	0f 87 64 01 00 00    	ja     802749 <malloc+0x197>
		return 0;

	if ((uintptr_t) mptr % PGSIZE){
  8025e5:	a1 18 50 80 00       	mov    0x805018,%eax
  8025ea:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8025ef:	75 15                	jne    802606 <malloc+0x54>
  8025f1:	8b 35 18 50 80 00    	mov    0x805018,%esi
	return 1;
}

void*
malloc(size_t n)
{
  8025f7:	c7 45 dc 02 00 00 00 	movl   $0x2,-0x24(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  8025fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802601:	8d 78 04             	lea    0x4(%eax),%edi
  802604:	eb 50                	jmp    802656 <malloc+0xa4>
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  802606:	89 c1                	mov    %eax,%ecx
  802608:	c1 e9 0c             	shr    $0xc,%ecx
  80260b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80260e:	8d 54 18 03          	lea    0x3(%eax,%ebx,1),%edx
  802612:	c1 ea 0c             	shr    $0xc,%edx
  802615:	39 d1                	cmp    %edx,%ecx
  802617:	75 1f                	jne    802638 <malloc+0x86>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  802619:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80261f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
			(*ref)++;
  802625:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			v = mptr;
			mptr += n;
  802629:	89 da                	mov    %ebx,%edx
  80262b:	01 c2                	add    %eax,%edx
  80262d:	89 15 18 50 80 00    	mov    %edx,0x805018
			return v;
  802633:	e9 2f 01 00 00       	jmp    802767 <malloc+0x1b5>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  802638:	89 04 24             	mov    %eax,(%esp)
  80263b:	e8 a0 fe ff ff       	call   8024e0 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  802640:	a1 18 50 80 00       	mov    0x805018,%eax
  802645:	05 00 10 00 00       	add    $0x1000,%eax
  80264a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80264f:	a3 18 50 80 00       	mov    %eax,0x805018
  802654:	eb 9b                	jmp    8025f1 <malloc+0x3f>
  802656:	89 75 e4             	mov    %esi,-0x1c(%ebp)
	 * runs of more than a page can't have ref counts so we
	 * flag the PTE entries instead.
	 */
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
  802659:	89 fb                	mov    %edi,%ebx
  80265b:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  80265e:	89 f0                	mov    %esi,%eax
  802660:	eb 36                	jmp    802698 <malloc+0xe6>
		if (va >= (uintptr_t) mend
  802662:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  802667:	0f 87 e3 00 00 00    	ja     802750 <malloc+0x19e>
		    || ((uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P)))
  80266d:	89 c2                	mov    %eax,%edx
  80266f:	c1 ea 16             	shr    $0x16,%edx
  802672:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802679:	f6 c2 01             	test   $0x1,%dl
  80267c:	74 15                	je     802693 <malloc+0xe1>
  80267e:	89 c2                	mov    %eax,%edx
  802680:	c1 ea 0c             	shr    $0xc,%edx
  802683:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80268a:	f6 c2 01             	test   $0x1,%dl
  80268d:	0f 85 bd 00 00 00    	jne    802750 <malloc+0x19e>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802693:	05 00 10 00 00       	add    $0x1000,%eax
  802698:	39 c1                	cmp    %eax,%ecx
  80269a:	77 c6                	ja     802662 <malloc+0xb0>
  80269c:	eb 7e                	jmp    80271c <malloc+0x16a>
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
			if (++nwrap == 2)
  80269e:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
  8026a2:	74 07                	je     8026ab <malloc+0xf9>
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
			mptr = mbegin;
  8026a4:	be 00 00 00 08       	mov    $0x8000000,%esi
  8026a9:	eb ab                	jmp    802656 <malloc+0xa4>
  8026ab:	c7 05 18 50 80 00 00 	movl   $0x8000000,0x805018
  8026b2:	00 00 08 
			if (++nwrap == 2)
				return 0;	/* out of address space */
  8026b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ba:	e9 a8 00 00 00       	jmp    802767 <malloc+0x1b5>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  8026bf:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
  8026c5:	39 df                	cmp    %ebx,%edi
  8026c7:	19 c0                	sbb    %eax,%eax
  8026c9:	25 00 02 00 00       	and    $0x200,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  8026ce:	83 c8 07             	or     $0x7,%eax
  8026d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d5:	03 15 18 50 80 00    	add    0x805018,%edx
  8026db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e6:	e8 38 ed ff ff       	call   801423 <sys_page_alloc>
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	78 22                	js     802711 <malloc+0x15f>
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  8026ef:	89 fe                	mov    %edi,%esi
  8026f1:	eb 36                	jmp    802729 <malloc+0x177>
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
				sys_page_unmap(0, mptr + i);
  8026f3:	89 f0                	mov    %esi,%eax
  8026f5:	03 05 18 50 80 00    	add    0x805018,%eax
  8026fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802706:	e8 bf ed ff ff       	call   8014ca <sys_page_unmap>
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  80270b:	81 ee 00 10 00 00    	sub    $0x1000,%esi
  802711:	85 f6                	test   %esi,%esi
  802713:	79 de                	jns    8026f3 <malloc+0x141>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
  802715:	b8 00 00 00 00       	mov    $0x0,%eax
  80271a:	eb 4b                	jmp    802767 <malloc+0x1b5>
  80271c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271f:	a3 18 50 80 00       	mov    %eax,0x805018
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  802724:	be 00 00 00 00       	mov    $0x0,%esi
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  802729:	89 f2                	mov    %esi,%edx
  80272b:	39 de                	cmp    %ebx,%esi
  80272d:	72 90                	jb     8026bf <malloc+0x10d>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  80272f:	a1 18 50 80 00       	mov    0x805018,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  802734:	c7 44 30 fc 02 00 00 	movl   $0x2,-0x4(%eax,%esi,1)
  80273b:	00 
	v = mptr;
	mptr += n;
  80273c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80273f:	01 c2                	add    %eax,%edx
  802741:	89 15 18 50 80 00    	mov    %edx,0x805018
	return v;
  802747:	eb 1e                	jmp    802767 <malloc+0x1b5>
		mptr = mbegin;

	n = ROUNDUP(n, 4);

	if (n >= MAXMALLOC)
		return 0;
  802749:	b8 00 00 00 00       	mov    $0x0,%eax
  80274e:	eb 17                	jmp    802767 <malloc+0x1b5>
  802750:	81 c6 00 10 00 00    	add    $0x1000,%esi
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
  802756:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
  80275c:	0f 84 3c ff ff ff    	je     80269e <malloc+0xec>
  802762:	e9 ef fe ff ff       	jmp    802656 <malloc+0xa4>
	ref = (uint32_t*) (mptr + i - 4);
	*ref = 2;	/* reference for mptr, reference for returned block */
	v = mptr;
	mptr += n;
	return v;
}
  802767:	83 c4 2c             	add    $0x2c,%esp
  80276a:	5b                   	pop    %ebx
  80276b:	5e                   	pop    %esi
  80276c:	5f                   	pop    %edi
  80276d:	5d                   	pop    %ebp
  80276e:	c3                   	ret    

0080276f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	56                   	push   %esi
  802773:	53                   	push   %ebx
  802774:	83 ec 10             	sub    $0x10,%esp
  802777:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80277a:	8b 45 08             	mov    0x8(%ebp),%eax
  80277d:	89 04 24             	mov    %eax,(%esp)
  802780:	e8 db ef ff ff       	call   801760 <fd2data>
  802785:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802787:	c7 44 24 04 1d 37 80 	movl   $0x80371d,0x4(%esp)
  80278e:	00 
  80278f:	89 1c 24             	mov    %ebx,(%esp)
  802792:	e8 70 e8 ff ff       	call   801007 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802797:	8b 46 04             	mov    0x4(%esi),%eax
  80279a:	2b 06                	sub    (%esi),%eax
  80279c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8027a2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8027a9:	00 00 00 
	stat->st_dev = &devpipe;
  8027ac:	c7 83 88 00 00 00 5c 	movl   $0x80405c,0x88(%ebx)
  8027b3:	40 80 00 
	return 0;
}
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	83 c4 10             	add    $0x10,%esp
  8027be:	5b                   	pop    %ebx
  8027bf:	5e                   	pop    %esi
  8027c0:	5d                   	pop    %ebp
  8027c1:	c3                   	ret    

008027c2 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
  8027c5:	53                   	push   %ebx
  8027c6:	83 ec 14             	sub    $0x14,%esp
  8027c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d7:	e8 ee ec ff ff       	call   8014ca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8027dc:	89 1c 24             	mov    %ebx,(%esp)
  8027df:	e8 7c ef ff ff       	call   801760 <fd2data>
  8027e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027ef:	e8 d6 ec ff ff       	call   8014ca <sys_page_unmap>
}
  8027f4:	83 c4 14             	add    $0x14,%esp
  8027f7:	5b                   	pop    %ebx
  8027f8:	5d                   	pop    %ebp
  8027f9:	c3                   	ret    

008027fa <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	57                   	push   %edi
  8027fe:	56                   	push   %esi
  8027ff:	53                   	push   %ebx
  802800:	83 ec 2c             	sub    $0x2c,%esp
  802803:	89 c6                	mov    %eax,%esi
  802805:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802808:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80280d:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802810:	89 34 24             	mov    %esi,(%esp)
  802813:	e8 8e 05 00 00       	call   802da6 <pageref>
  802818:	89 c7                	mov    %eax,%edi
  80281a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80281d:	89 04 24             	mov    %eax,(%esp)
  802820:	e8 81 05 00 00       	call   802da6 <pageref>
  802825:	39 c7                	cmp    %eax,%edi
  802827:	0f 94 c2             	sete   %dl
  80282a:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80282d:	8b 0d 1c 50 80 00    	mov    0x80501c,%ecx
  802833:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802836:	39 fb                	cmp    %edi,%ebx
  802838:	74 21                	je     80285b <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80283a:	84 d2                	test   %dl,%dl
  80283c:	74 ca                	je     802808 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80283e:	8b 51 58             	mov    0x58(%ecx),%edx
  802841:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802845:	89 54 24 08          	mov    %edx,0x8(%esp)
  802849:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80284d:	c7 04 24 24 37 80 00 	movl   $0x803724,(%esp)
  802854:	e8 88 e1 ff ff       	call   8009e1 <cprintf>
  802859:	eb ad                	jmp    802808 <_pipeisclosed+0xe>
	}
}
  80285b:	83 c4 2c             	add    $0x2c,%esp
  80285e:	5b                   	pop    %ebx
  80285f:	5e                   	pop    %esi
  802860:	5f                   	pop    %edi
  802861:	5d                   	pop    %ebp
  802862:	c3                   	ret    

00802863 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802863:	55                   	push   %ebp
  802864:	89 e5                	mov    %esp,%ebp
  802866:	57                   	push   %edi
  802867:	56                   	push   %esi
  802868:	53                   	push   %ebx
  802869:	83 ec 1c             	sub    $0x1c,%esp
  80286c:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  80286f:	89 34 24             	mov    %esi,(%esp)
  802872:	e8 e9 ee ff ff       	call   801760 <fd2data>
  802877:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802879:	bf 00 00 00 00       	mov    $0x0,%edi
  80287e:	eb 45                	jmp    8028c5 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802880:	89 da                	mov    %ebx,%edx
  802882:	89 f0                	mov    %esi,%eax
  802884:	e8 71 ff ff ff       	call   8027fa <_pipeisclosed>
  802889:	85 c0                	test   %eax,%eax
  80288b:	75 41                	jne    8028ce <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  80288d:	e8 72 eb ff ff       	call   801404 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802892:	8b 43 04             	mov    0x4(%ebx),%eax
  802895:	8b 0b                	mov    (%ebx),%ecx
  802897:	8d 51 20             	lea    0x20(%ecx),%edx
  80289a:	39 d0                	cmp    %edx,%eax
  80289c:	73 e2                	jae    802880 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80289e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028a1:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8028a5:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8028a8:	99                   	cltd   
  8028a9:	c1 ea 1b             	shr    $0x1b,%edx
  8028ac:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8028af:	83 e1 1f             	and    $0x1f,%ecx
  8028b2:	29 d1                	sub    %edx,%ecx
  8028b4:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8028b8:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8028bc:	83 c0 01             	add    $0x1,%eax
  8028bf:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028c2:	83 c7 01             	add    $0x1,%edi
  8028c5:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8028c8:	75 c8                	jne    802892 <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8028ca:	89 f8                	mov    %edi,%eax
  8028cc:	eb 05                	jmp    8028d3 <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8028ce:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8028d3:	83 c4 1c             	add    $0x1c,%esp
  8028d6:	5b                   	pop    %ebx
  8028d7:	5e                   	pop    %esi
  8028d8:	5f                   	pop    %edi
  8028d9:	5d                   	pop    %ebp
  8028da:	c3                   	ret    

008028db <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028db:	55                   	push   %ebp
  8028dc:	89 e5                	mov    %esp,%ebp
  8028de:	57                   	push   %edi
  8028df:	56                   	push   %esi
  8028e0:	53                   	push   %ebx
  8028e1:	83 ec 1c             	sub    $0x1c,%esp
  8028e4:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8028e7:	89 3c 24             	mov    %edi,(%esp)
  8028ea:	e8 71 ee ff ff       	call   801760 <fd2data>
  8028ef:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028f1:	be 00 00 00 00       	mov    $0x0,%esi
  8028f6:	eb 3d                	jmp    802935 <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8028f8:	85 f6                	test   %esi,%esi
  8028fa:	74 04                	je     802900 <devpipe_read+0x25>
				return i;
  8028fc:	89 f0                	mov    %esi,%eax
  8028fe:	eb 43                	jmp    802943 <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802900:	89 da                	mov    %ebx,%edx
  802902:	89 f8                	mov    %edi,%eax
  802904:	e8 f1 fe ff ff       	call   8027fa <_pipeisclosed>
  802909:	85 c0                	test   %eax,%eax
  80290b:	75 31                	jne    80293e <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  80290d:	e8 f2 ea ff ff       	call   801404 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802912:	8b 03                	mov    (%ebx),%eax
  802914:	3b 43 04             	cmp    0x4(%ebx),%eax
  802917:	74 df                	je     8028f8 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802919:	99                   	cltd   
  80291a:	c1 ea 1b             	shr    $0x1b,%edx
  80291d:	01 d0                	add    %edx,%eax
  80291f:	83 e0 1f             	and    $0x1f,%eax
  802922:	29 d0                	sub    %edx,%eax
  802924:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80292c:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80292f:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802932:	83 c6 01             	add    $0x1,%esi
  802935:	3b 75 10             	cmp    0x10(%ebp),%esi
  802938:	75 d8                	jne    802912 <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  80293a:	89 f0                	mov    %esi,%eax
  80293c:	eb 05                	jmp    802943 <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80293e:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802943:	83 c4 1c             	add    $0x1c,%esp
  802946:	5b                   	pop    %ebx
  802947:	5e                   	pop    %esi
  802948:	5f                   	pop    %edi
  802949:	5d                   	pop    %ebp
  80294a:	c3                   	ret    

0080294b <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  80294b:	55                   	push   %ebp
  80294c:	89 e5                	mov    %esp,%ebp
  80294e:	56                   	push   %esi
  80294f:	53                   	push   %ebx
  802950:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802953:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802956:	89 04 24             	mov    %eax,(%esp)
  802959:	e8 19 ee ff ff       	call   801777 <fd_alloc>
  80295e:	89 c2                	mov    %eax,%edx
  802960:	85 d2                	test   %edx,%edx
  802962:	0f 88 4d 01 00 00    	js     802ab5 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802968:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80296f:	00 
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	89 44 24 04          	mov    %eax,0x4(%esp)
  802977:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80297e:	e8 a0 ea ff ff       	call   801423 <sys_page_alloc>
  802983:	89 c2                	mov    %eax,%edx
  802985:	85 d2                	test   %edx,%edx
  802987:	0f 88 28 01 00 00    	js     802ab5 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80298d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802990:	89 04 24             	mov    %eax,(%esp)
  802993:	e8 df ed ff ff       	call   801777 <fd_alloc>
  802998:	89 c3                	mov    %eax,%ebx
  80299a:	85 c0                	test   %eax,%eax
  80299c:	0f 88 fe 00 00 00    	js     802aa0 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029a9:	00 
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b8:	e8 66 ea ff ff       	call   801423 <sys_page_alloc>
  8029bd:	89 c3                	mov    %eax,%ebx
  8029bf:	85 c0                	test   %eax,%eax
  8029c1:	0f 88 d9 00 00 00    	js     802aa0 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ca:	89 04 24             	mov    %eax,(%esp)
  8029cd:	e8 8e ed ff ff       	call   801760 <fd2data>
  8029d2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029d4:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029db:	00 
  8029dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029e7:	e8 37 ea ff ff       	call   801423 <sys_page_alloc>
  8029ec:	89 c3                	mov    %eax,%ebx
  8029ee:	85 c0                	test   %eax,%eax
  8029f0:	0f 88 97 00 00 00    	js     802a8d <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	89 04 24             	mov    %eax,(%esp)
  8029fc:	e8 5f ed ff ff       	call   801760 <fd2data>
  802a01:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802a08:	00 
  802a09:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a0d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a14:	00 
  802a15:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a20:	e8 52 ea ff ff       	call   801477 <sys_page_map>
  802a25:	89 c3                	mov    %eax,%ebx
  802a27:	85 c0                	test   %eax,%eax
  802a29:	78 52                	js     802a7d <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802a2b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a40:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a49:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	89 04 24             	mov    %eax,(%esp)
  802a5b:	e8 f0 ec ff ff       	call   801750 <fd2num>
  802a60:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a63:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	89 04 24             	mov    %eax,(%esp)
  802a6b:	e8 e0 ec ff ff       	call   801750 <fd2num>
  802a70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a73:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802a76:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7b:	eb 38                	jmp    802ab5 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802a7d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a88:	e8 3d ea ff ff       	call   8014ca <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a94:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a9b:	e8 2a ea ff ff       	call   8014ca <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aae:	e8 17 ea ff ff       	call   8014ca <sys_page_unmap>
  802ab3:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802ab5:	83 c4 30             	add    $0x30,%esp
  802ab8:	5b                   	pop    %ebx
  802ab9:	5e                   	pop    %esi
  802aba:	5d                   	pop    %ebp
  802abb:	c3                   	ret    

00802abc <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802abc:	55                   	push   %ebp
  802abd:	89 e5                	mov    %esp,%ebp
  802abf:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802ac2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	89 04 24             	mov    %eax,(%esp)
  802acf:	e8 f2 ec ff ff       	call   8017c6 <fd_lookup>
  802ad4:	89 c2                	mov    %eax,%edx
  802ad6:	85 d2                	test   %edx,%edx
  802ad8:	78 15                	js     802aef <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	89 04 24             	mov    %eax,(%esp)
  802ae0:	e8 7b ec ff ff       	call   801760 <fd2data>
	return _pipeisclosed(fd, p);
  802ae5:	89 c2                	mov    %eax,%edx
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	e8 0b fd ff ff       	call   8027fa <_pipeisclosed>
}
  802aef:	c9                   	leave  
  802af0:	c3                   	ret    
  802af1:	66 90                	xchg   %ax,%ax
  802af3:	66 90                	xchg   %ax,%ax
  802af5:	66 90                	xchg   %ax,%ax
  802af7:	66 90                	xchg   %ax,%ax
  802af9:	66 90                	xchg   %ax,%ax
  802afb:	66 90                	xchg   %ax,%ax
  802afd:	66 90                	xchg   %ax,%ax
  802aff:	90                   	nop

00802b00 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802b00:	55                   	push   %ebp
  802b01:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802b03:	b8 00 00 00 00       	mov    $0x0,%eax
  802b08:	5d                   	pop    %ebp
  802b09:	c3                   	ret    

00802b0a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802b10:	c7 44 24 04 3c 37 80 	movl   $0x80373c,0x4(%esp)
  802b17:	00 
  802b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b1b:	89 04 24             	mov    %eax,(%esp)
  802b1e:	e8 e4 e4 ff ff       	call   801007 <strcpy>
	return 0;
}
  802b23:	b8 00 00 00 00       	mov    $0x0,%eax
  802b28:	c9                   	leave  
  802b29:	c3                   	ret    

00802b2a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
  802b2d:	57                   	push   %edi
  802b2e:	56                   	push   %esi
  802b2f:	53                   	push   %ebx
  802b30:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b36:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802b3b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b41:	eb 31                	jmp    802b74 <devcons_write+0x4a>
		m = n - tot;
  802b43:	8b 75 10             	mov    0x10(%ebp),%esi
  802b46:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802b48:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802b4b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802b50:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802b53:	89 74 24 08          	mov    %esi,0x8(%esp)
  802b57:	03 45 0c             	add    0xc(%ebp),%eax
  802b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b5e:	89 3c 24             	mov    %edi,(%esp)
  802b61:	e8 3e e6 ff ff       	call   8011a4 <memmove>
		sys_cputs(buf, m);
  802b66:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b6a:	89 3c 24             	mov    %edi,(%esp)
  802b6d:	e8 e4 e7 ff ff       	call   801356 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b72:	01 f3                	add    %esi,%ebx
  802b74:	89 d8                	mov    %ebx,%eax
  802b76:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802b79:	72 c8                	jb     802b43 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802b7b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802b81:	5b                   	pop    %ebx
  802b82:	5e                   	pop    %esi
  802b83:	5f                   	pop    %edi
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    

00802b86 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b86:	55                   	push   %ebp
  802b87:	89 e5                	mov    %esp,%ebp
  802b89:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802b8c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802b91:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b95:	75 07                	jne    802b9e <devcons_read+0x18>
  802b97:	eb 2a                	jmp    802bc3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802b99:	e8 66 e8 ff ff       	call   801404 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802b9e:	66 90                	xchg   %ax,%ax
  802ba0:	e8 cf e7 ff ff       	call   801374 <sys_cgetc>
  802ba5:	85 c0                	test   %eax,%eax
  802ba7:	74 f0                	je     802b99 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	78 16                	js     802bc3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802bad:	83 f8 04             	cmp    $0x4,%eax
  802bb0:	74 0c                	je     802bbe <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb5:	88 02                	mov    %al,(%edx)
	return 1;
  802bb7:	b8 01 00 00 00       	mov    $0x1,%eax
  802bbc:	eb 05                	jmp    802bc3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802bbe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802bc3:	c9                   	leave  
  802bc4:	c3                   	ret    

00802bc5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802bc5:	55                   	push   %ebp
  802bc6:	89 e5                	mov    %esp,%ebp
  802bc8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802bd1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802bd8:	00 
  802bd9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bdc:	89 04 24             	mov    %eax,(%esp)
  802bdf:	e8 72 e7 ff ff       	call   801356 <sys_cputs>
}
  802be4:	c9                   	leave  
  802be5:	c3                   	ret    

00802be6 <getchar>:

int
getchar(void)
{
  802be6:	55                   	push   %ebp
  802be7:	89 e5                	mov    %esp,%ebp
  802be9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802bec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802bf3:	00 
  802bf4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c02:	e8 53 ee ff ff       	call   801a5a <read>
	if (r < 0)
  802c07:	85 c0                	test   %eax,%eax
  802c09:	78 0f                	js     802c1a <getchar+0x34>
		return r;
	if (r < 1)
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	7e 06                	jle    802c15 <getchar+0x2f>
		return -E_EOF;
	return c;
  802c0f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802c13:	eb 05                	jmp    802c1a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802c15:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802c1a:	c9                   	leave  
  802c1b:	c3                   	ret    

00802c1c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
  802c1f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	89 04 24             	mov    %eax,(%esp)
  802c2f:	e8 92 eb ff ff       	call   8017c6 <fd_lookup>
  802c34:	85 c0                	test   %eax,%eax
  802c36:	78 11                	js     802c49 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802c41:	39 10                	cmp    %edx,(%eax)
  802c43:	0f 94 c0             	sete   %al
  802c46:	0f b6 c0             	movzbl %al,%eax
}
  802c49:	c9                   	leave  
  802c4a:	c3                   	ret    

00802c4b <opencons>:

int
opencons(void)
{
  802c4b:	55                   	push   %ebp
  802c4c:	89 e5                	mov    %esp,%ebp
  802c4e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802c51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c54:	89 04 24             	mov    %eax,(%esp)
  802c57:	e8 1b eb ff ff       	call   801777 <fd_alloc>
		return r;
  802c5c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	78 40                	js     802ca2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c62:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c69:	00 
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c78:	e8 a6 e7 ff ff       	call   801423 <sys_page_alloc>
		return r;
  802c7d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	78 1f                	js     802ca2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802c83:	8b 15 78 40 80 00    	mov    0x804078,%edx
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802c98:	89 04 24             	mov    %eax,(%esp)
  802c9b:	e8 b0 ea ff ff       	call   801750 <fd2num>
  802ca0:	89 c2                	mov    %eax,%edx
}
  802ca2:	89 d0                	mov    %edx,%eax
  802ca4:	c9                   	leave  
  802ca5:	c3                   	ret    

00802ca6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
  802ca9:	56                   	push   %esi
  802caa:	53                   	push   %ebx
  802cab:	83 ec 10             	sub    $0x10,%esp
  802cae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802cb7:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802cb9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802cbe:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802cc1:	89 04 24             	mov    %eax,(%esp)
  802cc4:	e8 70 e9 ff ff       	call   801639 <sys_ipc_recv>
  802cc9:	85 c0                	test   %eax,%eax
  802ccb:	75 1e                	jne    802ceb <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802ccd:	85 db                	test   %ebx,%ebx
  802ccf:	74 0a                	je     802cdb <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802cd1:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802cd6:	8b 40 74             	mov    0x74(%eax),%eax
  802cd9:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802cdb:	85 f6                	test   %esi,%esi
  802cdd:	74 22                	je     802d01 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802cdf:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802ce4:	8b 40 78             	mov    0x78(%eax),%eax
  802ce7:	89 06                	mov    %eax,(%esi)
  802ce9:	eb 16                	jmp    802d01 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802ceb:	85 f6                	test   %esi,%esi
  802ced:	74 06                	je     802cf5 <ipc_recv+0x4f>
				*perm_store = 0;
  802cef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802cf5:	85 db                	test   %ebx,%ebx
  802cf7:	74 10                	je     802d09 <ipc_recv+0x63>
				*from_env_store=0;
  802cf9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802cff:	eb 08                	jmp    802d09 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802d01:	a1 1c 50 80 00       	mov    0x80501c,%eax
  802d06:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802d09:	83 c4 10             	add    $0x10,%esp
  802d0c:	5b                   	pop    %ebx
  802d0d:	5e                   	pop    %esi
  802d0e:	5d                   	pop    %ebp
  802d0f:	c3                   	ret    

00802d10 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802d10:	55                   	push   %ebp
  802d11:	89 e5                	mov    %esp,%ebp
  802d13:	57                   	push   %edi
  802d14:	56                   	push   %esi
  802d15:	53                   	push   %ebx
  802d16:	83 ec 1c             	sub    $0x1c,%esp
  802d19:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802d1f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802d22:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802d24:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802d29:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802d2c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d30:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d34:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	89 04 24             	mov    %eax,(%esp)
  802d3e:	e8 d3 e8 ff ff       	call   801616 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802d43:	eb 1c                	jmp    802d61 <ipc_send+0x51>
	{
		sys_yield();
  802d45:	e8 ba e6 ff ff       	call   801404 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802d4a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d4e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d52:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	89 04 24             	mov    %eax,(%esp)
  802d5c:	e8 b5 e8 ff ff       	call   801616 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802d61:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d64:	74 df                	je     802d45 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802d66:	83 c4 1c             	add    $0x1c,%esp
  802d69:	5b                   	pop    %ebx
  802d6a:	5e                   	pop    %esi
  802d6b:	5f                   	pop    %edi
  802d6c:	5d                   	pop    %ebp
  802d6d:	c3                   	ret    

00802d6e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d6e:	55                   	push   %ebp
  802d6f:	89 e5                	mov    %esp,%ebp
  802d71:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d74:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802d79:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802d7c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802d82:	8b 52 50             	mov    0x50(%edx),%edx
  802d85:	39 ca                	cmp    %ecx,%edx
  802d87:	75 0d                	jne    802d96 <ipc_find_env+0x28>
			return envs[i].env_id;
  802d89:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802d8c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802d91:	8b 40 40             	mov    0x40(%eax),%eax
  802d94:	eb 0e                	jmp    802da4 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802d96:	83 c0 01             	add    $0x1,%eax
  802d99:	3d 00 04 00 00       	cmp    $0x400,%eax
  802d9e:	75 d9                	jne    802d79 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802da0:	66 b8 00 00          	mov    $0x0,%ax
}
  802da4:	5d                   	pop    %ebp
  802da5:	c3                   	ret    

00802da6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802da6:	55                   	push   %ebp
  802da7:	89 e5                	mov    %esp,%ebp
  802da9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802dac:	89 d0                	mov    %edx,%eax
  802dae:	c1 e8 16             	shr    $0x16,%eax
  802db1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802db8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802dbd:	f6 c1 01             	test   $0x1,%cl
  802dc0:	74 1d                	je     802ddf <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802dc2:	c1 ea 0c             	shr    $0xc,%edx
  802dc5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802dcc:	f6 c2 01             	test   $0x1,%dl
  802dcf:	74 0e                	je     802ddf <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802dd1:	c1 ea 0c             	shr    $0xc,%edx
  802dd4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802ddb:	ef 
  802ddc:	0f b7 c0             	movzwl %ax,%eax
}
  802ddf:	5d                   	pop    %ebp
  802de0:	c3                   	ret    
  802de1:	66 90                	xchg   %ax,%ax
  802de3:	66 90                	xchg   %ax,%ax
  802de5:	66 90                	xchg   %ax,%ax
  802de7:	66 90                	xchg   %ax,%ax
  802de9:	66 90                	xchg   %ax,%ax
  802deb:	66 90                	xchg   %ax,%ax
  802ded:	66 90                	xchg   %ax,%ax
  802def:	90                   	nop

00802df0 <__udivdi3>:
  802df0:	55                   	push   %ebp
  802df1:	57                   	push   %edi
  802df2:	56                   	push   %esi
  802df3:	83 ec 0c             	sub    $0xc,%esp
  802df6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802dfa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802dfe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802e02:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802e06:	85 c0                	test   %eax,%eax
  802e08:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802e0c:	89 ea                	mov    %ebp,%edx
  802e0e:	89 0c 24             	mov    %ecx,(%esp)
  802e11:	75 2d                	jne    802e40 <__udivdi3+0x50>
  802e13:	39 e9                	cmp    %ebp,%ecx
  802e15:	77 61                	ja     802e78 <__udivdi3+0x88>
  802e17:	85 c9                	test   %ecx,%ecx
  802e19:	89 ce                	mov    %ecx,%esi
  802e1b:	75 0b                	jne    802e28 <__udivdi3+0x38>
  802e1d:	b8 01 00 00 00       	mov    $0x1,%eax
  802e22:	31 d2                	xor    %edx,%edx
  802e24:	f7 f1                	div    %ecx
  802e26:	89 c6                	mov    %eax,%esi
  802e28:	31 d2                	xor    %edx,%edx
  802e2a:	89 e8                	mov    %ebp,%eax
  802e2c:	f7 f6                	div    %esi
  802e2e:	89 c5                	mov    %eax,%ebp
  802e30:	89 f8                	mov    %edi,%eax
  802e32:	f7 f6                	div    %esi
  802e34:	89 ea                	mov    %ebp,%edx
  802e36:	83 c4 0c             	add    $0xc,%esp
  802e39:	5e                   	pop    %esi
  802e3a:	5f                   	pop    %edi
  802e3b:	5d                   	pop    %ebp
  802e3c:	c3                   	ret    
  802e3d:	8d 76 00             	lea    0x0(%esi),%esi
  802e40:	39 e8                	cmp    %ebp,%eax
  802e42:	77 24                	ja     802e68 <__udivdi3+0x78>
  802e44:	0f bd e8             	bsr    %eax,%ebp
  802e47:	83 f5 1f             	xor    $0x1f,%ebp
  802e4a:	75 3c                	jne    802e88 <__udivdi3+0x98>
  802e4c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802e50:	39 34 24             	cmp    %esi,(%esp)
  802e53:	0f 86 9f 00 00 00    	jbe    802ef8 <__udivdi3+0x108>
  802e59:	39 d0                	cmp    %edx,%eax
  802e5b:	0f 82 97 00 00 00    	jb     802ef8 <__udivdi3+0x108>
  802e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e68:	31 d2                	xor    %edx,%edx
  802e6a:	31 c0                	xor    %eax,%eax
  802e6c:	83 c4 0c             	add    $0xc,%esp
  802e6f:	5e                   	pop    %esi
  802e70:	5f                   	pop    %edi
  802e71:	5d                   	pop    %ebp
  802e72:	c3                   	ret    
  802e73:	90                   	nop
  802e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e78:	89 f8                	mov    %edi,%eax
  802e7a:	f7 f1                	div    %ecx
  802e7c:	31 d2                	xor    %edx,%edx
  802e7e:	83 c4 0c             	add    $0xc,%esp
  802e81:	5e                   	pop    %esi
  802e82:	5f                   	pop    %edi
  802e83:	5d                   	pop    %ebp
  802e84:	c3                   	ret    
  802e85:	8d 76 00             	lea    0x0(%esi),%esi
  802e88:	89 e9                	mov    %ebp,%ecx
  802e8a:	8b 3c 24             	mov    (%esp),%edi
  802e8d:	d3 e0                	shl    %cl,%eax
  802e8f:	89 c6                	mov    %eax,%esi
  802e91:	b8 20 00 00 00       	mov    $0x20,%eax
  802e96:	29 e8                	sub    %ebp,%eax
  802e98:	89 c1                	mov    %eax,%ecx
  802e9a:	d3 ef                	shr    %cl,%edi
  802e9c:	89 e9                	mov    %ebp,%ecx
  802e9e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ea2:	8b 3c 24             	mov    (%esp),%edi
  802ea5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ea9:	89 d6                	mov    %edx,%esi
  802eab:	d3 e7                	shl    %cl,%edi
  802ead:	89 c1                	mov    %eax,%ecx
  802eaf:	89 3c 24             	mov    %edi,(%esp)
  802eb2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802eb6:	d3 ee                	shr    %cl,%esi
  802eb8:	89 e9                	mov    %ebp,%ecx
  802eba:	d3 e2                	shl    %cl,%edx
  802ebc:	89 c1                	mov    %eax,%ecx
  802ebe:	d3 ef                	shr    %cl,%edi
  802ec0:	09 d7                	or     %edx,%edi
  802ec2:	89 f2                	mov    %esi,%edx
  802ec4:	89 f8                	mov    %edi,%eax
  802ec6:	f7 74 24 08          	divl   0x8(%esp)
  802eca:	89 d6                	mov    %edx,%esi
  802ecc:	89 c7                	mov    %eax,%edi
  802ece:	f7 24 24             	mull   (%esp)
  802ed1:	39 d6                	cmp    %edx,%esi
  802ed3:	89 14 24             	mov    %edx,(%esp)
  802ed6:	72 30                	jb     802f08 <__udivdi3+0x118>
  802ed8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802edc:	89 e9                	mov    %ebp,%ecx
  802ede:	d3 e2                	shl    %cl,%edx
  802ee0:	39 c2                	cmp    %eax,%edx
  802ee2:	73 05                	jae    802ee9 <__udivdi3+0xf9>
  802ee4:	3b 34 24             	cmp    (%esp),%esi
  802ee7:	74 1f                	je     802f08 <__udivdi3+0x118>
  802ee9:	89 f8                	mov    %edi,%eax
  802eeb:	31 d2                	xor    %edx,%edx
  802eed:	e9 7a ff ff ff       	jmp    802e6c <__udivdi3+0x7c>
  802ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ef8:	31 d2                	xor    %edx,%edx
  802efa:	b8 01 00 00 00       	mov    $0x1,%eax
  802eff:	e9 68 ff ff ff       	jmp    802e6c <__udivdi3+0x7c>
  802f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f08:	8d 47 ff             	lea    -0x1(%edi),%eax
  802f0b:	31 d2                	xor    %edx,%edx
  802f0d:	83 c4 0c             	add    $0xc,%esp
  802f10:	5e                   	pop    %esi
  802f11:	5f                   	pop    %edi
  802f12:	5d                   	pop    %ebp
  802f13:	c3                   	ret    
  802f14:	66 90                	xchg   %ax,%ax
  802f16:	66 90                	xchg   %ax,%ax
  802f18:	66 90                	xchg   %ax,%ax
  802f1a:	66 90                	xchg   %ax,%ax
  802f1c:	66 90                	xchg   %ax,%ax
  802f1e:	66 90                	xchg   %ax,%ax

00802f20 <__umoddi3>:
  802f20:	55                   	push   %ebp
  802f21:	57                   	push   %edi
  802f22:	56                   	push   %esi
  802f23:	83 ec 14             	sub    $0x14,%esp
  802f26:	8b 44 24 28          	mov    0x28(%esp),%eax
  802f2a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802f2e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802f32:	89 c7                	mov    %eax,%edi
  802f34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f38:	8b 44 24 30          	mov    0x30(%esp),%eax
  802f3c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802f40:	89 34 24             	mov    %esi,(%esp)
  802f43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f47:	85 c0                	test   %eax,%eax
  802f49:	89 c2                	mov    %eax,%edx
  802f4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f4f:	75 17                	jne    802f68 <__umoddi3+0x48>
  802f51:	39 fe                	cmp    %edi,%esi
  802f53:	76 4b                	jbe    802fa0 <__umoddi3+0x80>
  802f55:	89 c8                	mov    %ecx,%eax
  802f57:	89 fa                	mov    %edi,%edx
  802f59:	f7 f6                	div    %esi
  802f5b:	89 d0                	mov    %edx,%eax
  802f5d:	31 d2                	xor    %edx,%edx
  802f5f:	83 c4 14             	add    $0x14,%esp
  802f62:	5e                   	pop    %esi
  802f63:	5f                   	pop    %edi
  802f64:	5d                   	pop    %ebp
  802f65:	c3                   	ret    
  802f66:	66 90                	xchg   %ax,%ax
  802f68:	39 f8                	cmp    %edi,%eax
  802f6a:	77 54                	ja     802fc0 <__umoddi3+0xa0>
  802f6c:	0f bd e8             	bsr    %eax,%ebp
  802f6f:	83 f5 1f             	xor    $0x1f,%ebp
  802f72:	75 5c                	jne    802fd0 <__umoddi3+0xb0>
  802f74:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802f78:	39 3c 24             	cmp    %edi,(%esp)
  802f7b:	0f 87 e7 00 00 00    	ja     803068 <__umoddi3+0x148>
  802f81:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802f85:	29 f1                	sub    %esi,%ecx
  802f87:	19 c7                	sbb    %eax,%edi
  802f89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f91:	8b 44 24 08          	mov    0x8(%esp),%eax
  802f95:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802f99:	83 c4 14             	add    $0x14,%esp
  802f9c:	5e                   	pop    %esi
  802f9d:	5f                   	pop    %edi
  802f9e:	5d                   	pop    %ebp
  802f9f:	c3                   	ret    
  802fa0:	85 f6                	test   %esi,%esi
  802fa2:	89 f5                	mov    %esi,%ebp
  802fa4:	75 0b                	jne    802fb1 <__umoddi3+0x91>
  802fa6:	b8 01 00 00 00       	mov    $0x1,%eax
  802fab:	31 d2                	xor    %edx,%edx
  802fad:	f7 f6                	div    %esi
  802faf:	89 c5                	mov    %eax,%ebp
  802fb1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802fb5:	31 d2                	xor    %edx,%edx
  802fb7:	f7 f5                	div    %ebp
  802fb9:	89 c8                	mov    %ecx,%eax
  802fbb:	f7 f5                	div    %ebp
  802fbd:	eb 9c                	jmp    802f5b <__umoddi3+0x3b>
  802fbf:	90                   	nop
  802fc0:	89 c8                	mov    %ecx,%eax
  802fc2:	89 fa                	mov    %edi,%edx
  802fc4:	83 c4 14             	add    $0x14,%esp
  802fc7:	5e                   	pop    %esi
  802fc8:	5f                   	pop    %edi
  802fc9:	5d                   	pop    %ebp
  802fca:	c3                   	ret    
  802fcb:	90                   	nop
  802fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fd0:	8b 04 24             	mov    (%esp),%eax
  802fd3:	be 20 00 00 00       	mov    $0x20,%esi
  802fd8:	89 e9                	mov    %ebp,%ecx
  802fda:	29 ee                	sub    %ebp,%esi
  802fdc:	d3 e2                	shl    %cl,%edx
  802fde:	89 f1                	mov    %esi,%ecx
  802fe0:	d3 e8                	shr    %cl,%eax
  802fe2:	89 e9                	mov    %ebp,%ecx
  802fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fe8:	8b 04 24             	mov    (%esp),%eax
  802feb:	09 54 24 04          	or     %edx,0x4(%esp)
  802fef:	89 fa                	mov    %edi,%edx
  802ff1:	d3 e0                	shl    %cl,%eax
  802ff3:	89 f1                	mov    %esi,%ecx
  802ff5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ff9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802ffd:	d3 ea                	shr    %cl,%edx
  802fff:	89 e9                	mov    %ebp,%ecx
  803001:	d3 e7                	shl    %cl,%edi
  803003:	89 f1                	mov    %esi,%ecx
  803005:	d3 e8                	shr    %cl,%eax
  803007:	89 e9                	mov    %ebp,%ecx
  803009:	09 f8                	or     %edi,%eax
  80300b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80300f:	f7 74 24 04          	divl   0x4(%esp)
  803013:	d3 e7                	shl    %cl,%edi
  803015:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803019:	89 d7                	mov    %edx,%edi
  80301b:	f7 64 24 08          	mull   0x8(%esp)
  80301f:	39 d7                	cmp    %edx,%edi
  803021:	89 c1                	mov    %eax,%ecx
  803023:	89 14 24             	mov    %edx,(%esp)
  803026:	72 2c                	jb     803054 <__umoddi3+0x134>
  803028:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80302c:	72 22                	jb     803050 <__umoddi3+0x130>
  80302e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803032:	29 c8                	sub    %ecx,%eax
  803034:	19 d7                	sbb    %edx,%edi
  803036:	89 e9                	mov    %ebp,%ecx
  803038:	89 fa                	mov    %edi,%edx
  80303a:	d3 e8                	shr    %cl,%eax
  80303c:	89 f1                	mov    %esi,%ecx
  80303e:	d3 e2                	shl    %cl,%edx
  803040:	89 e9                	mov    %ebp,%ecx
  803042:	d3 ef                	shr    %cl,%edi
  803044:	09 d0                	or     %edx,%eax
  803046:	89 fa                	mov    %edi,%edx
  803048:	83 c4 14             	add    $0x14,%esp
  80304b:	5e                   	pop    %esi
  80304c:	5f                   	pop    %edi
  80304d:	5d                   	pop    %ebp
  80304e:	c3                   	ret    
  80304f:	90                   	nop
  803050:	39 d7                	cmp    %edx,%edi
  803052:	75 da                	jne    80302e <__umoddi3+0x10e>
  803054:	8b 14 24             	mov    (%esp),%edx
  803057:	89 c1                	mov    %eax,%ecx
  803059:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80305d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803061:	eb cb                	jmp    80302e <__umoddi3+0x10e>
  803063:	90                   	nop
  803064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803068:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80306c:	0f 82 0f ff ff ff    	jb     802f81 <__umoddi3+0x61>
  803072:	e9 1a ff ff ff       	jmp    802f91 <__umoddi3+0x71>
