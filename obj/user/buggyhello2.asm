
obj/user/buggyhello2.debug:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

const char *hello = "hello, world\n";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_cputs(hello, 1024*1024);
  800039:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  800040:	00 
  800041:	a1 00 30 80 00       	mov    0x803000,%eax
  800046:	89 04 24             	mov    %eax,(%esp)
  800049:	e8 6d 00 00 00       	call   8000bb <sys_cputs>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	56                   	push   %esi
  800054:	53                   	push   %ebx
  800055:	83 ec 10             	sub    $0x10,%esp
  800058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80005e:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800065:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800068:	e8 dd 00 00 00       	call   80014a <sys_getenvid>
  80006d:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800072:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800075:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007a:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007f:	85 db                	test   %ebx,%ebx
  800081:	7e 07                	jle    80008a <libmain+0x3a>
		binaryname = argv[0];
  800083:	8b 06                	mov    (%esi),%eax
  800085:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80008a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80008e:	89 1c 24             	mov    %ebx,(%esp)
  800091:	e8 9d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800096:	e8 07 00 00 00       	call   8000a2 <exit>
}
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	5b                   	pop    %ebx
  80009f:	5e                   	pop    %esi
  8000a0:	5d                   	pop    %ebp
  8000a1:	c3                   	ret    

008000a2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a2:	55                   	push   %ebp
  8000a3:	89 e5                	mov    %esp,%ebp
  8000a5:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000a8:	e8 ed 05 00 00       	call   80069a <close_all>
	sys_env_destroy(0);
  8000ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b4:	e8 3f 00 00 00       	call   8000f8 <sys_env_destroy>
}
  8000b9:	c9                   	leave  
  8000ba:	c3                   	ret    

008000bb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000bb:	55                   	push   %ebp
  8000bc:	89 e5                	mov    %esp,%ebp
  8000be:	57                   	push   %edi
  8000bf:	56                   	push   %esi
  8000c0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cc:	89 c3                	mov    %eax,%ebx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 c6                	mov    %eax,%esi
  8000d2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d4:	5b                   	pop    %ebx
  8000d5:	5e                   	pop    %esi
  8000d6:	5f                   	pop    %edi
  8000d7:	5d                   	pop    %ebp
  8000d8:	c3                   	ret    

008000d9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d9:	55                   	push   %ebp
  8000da:	89 e5                	mov    %esp,%ebp
  8000dc:	57                   	push   %edi
  8000dd:	56                   	push   %esi
  8000de:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000df:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e9:	89 d1                	mov    %edx,%ecx
  8000eb:	89 d3                	mov    %edx,%ebx
  8000ed:	89 d7                	mov    %edx,%edi
  8000ef:	89 d6                	mov    %edx,%esi
  8000f1:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	57                   	push   %edi
  8000fc:	56                   	push   %esi
  8000fd:	53                   	push   %ebx
  8000fe:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800101:	b9 00 00 00 00       	mov    $0x0,%ecx
  800106:	b8 03 00 00 00       	mov    $0x3,%eax
  80010b:	8b 55 08             	mov    0x8(%ebp),%edx
  80010e:	89 cb                	mov    %ecx,%ebx
  800110:	89 cf                	mov    %ecx,%edi
  800112:	89 ce                	mov    %ecx,%esi
  800114:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800116:	85 c0                	test   %eax,%eax
  800118:	7e 28                	jle    800142 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80011a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80011e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800125:	00 
  800126:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  80012d:	00 
  80012e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800135:	00 
  800136:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  80013d:	e8 34 16 00 00       	call   801776 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800142:	83 c4 2c             	add    $0x2c,%esp
  800145:	5b                   	pop    %ebx
  800146:	5e                   	pop    %esi
  800147:	5f                   	pop    %edi
  800148:	5d                   	pop    %ebp
  800149:	c3                   	ret    

0080014a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800150:	ba 00 00 00 00       	mov    $0x0,%edx
  800155:	b8 02 00 00 00       	mov    $0x2,%eax
  80015a:	89 d1                	mov    %edx,%ecx
  80015c:	89 d3                	mov    %edx,%ebx
  80015e:	89 d7                	mov    %edx,%edi
  800160:	89 d6                	mov    %edx,%esi
  800162:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5f                   	pop    %edi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    

00800169 <sys_yield>:

void
sys_yield(void)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	57                   	push   %edi
  80016d:	56                   	push   %esi
  80016e:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80016f:	ba 00 00 00 00       	mov    $0x0,%edx
  800174:	b8 0b 00 00 00       	mov    $0xb,%eax
  800179:	89 d1                	mov    %edx,%ecx
  80017b:	89 d3                	mov    %edx,%ebx
  80017d:	89 d7                	mov    %edx,%edi
  80017f:	89 d6                	mov    %edx,%esi
  800181:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800183:	5b                   	pop    %ebx
  800184:	5e                   	pop    %esi
  800185:	5f                   	pop    %edi
  800186:	5d                   	pop    %ebp
  800187:	c3                   	ret    

00800188 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	57                   	push   %edi
  80018c:	56                   	push   %esi
  80018d:	53                   	push   %ebx
  80018e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800191:	be 00 00 00 00       	mov    $0x0,%esi
  800196:	b8 04 00 00 00       	mov    $0x4,%eax
  80019b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a4:	89 f7                	mov    %esi,%edi
  8001a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	7e 28                	jle    8001d4 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001b0:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001b7:	00 
  8001b8:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  8001bf:	00 
  8001c0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001c7:	00 
  8001c8:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  8001cf:	e8 a2 15 00 00       	call   801776 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001d4:	83 c4 2c             	add    $0x2c,%esp
  8001d7:	5b                   	pop    %ebx
  8001d8:	5e                   	pop    %esi
  8001d9:	5f                   	pop    %edi
  8001da:	5d                   	pop    %ebp
  8001db:	c3                   	ret    

008001dc <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	57                   	push   %edi
  8001e0:	56                   	push   %esi
  8001e1:	53                   	push   %ebx
  8001e2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001e5:	b8 05 00 00 00       	mov    $0x5,%eax
  8001ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001f3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001f6:	8b 75 18             	mov    0x18(%ebp),%esi
  8001f9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001fb:	85 c0                	test   %eax,%eax
  8001fd:	7e 28                	jle    800227 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  800203:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80020a:	00 
  80020b:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  800212:	00 
  800213:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80021a:	00 
  80021b:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  800222:	e8 4f 15 00 00       	call   801776 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800227:	83 c4 2c             	add    $0x2c,%esp
  80022a:	5b                   	pop    %ebx
  80022b:	5e                   	pop    %esi
  80022c:	5f                   	pop    %edi
  80022d:	5d                   	pop    %ebp
  80022e:	c3                   	ret    

0080022f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	57                   	push   %edi
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
  800235:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800238:	bb 00 00 00 00       	mov    $0x0,%ebx
  80023d:	b8 06 00 00 00       	mov    $0x6,%eax
  800242:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800245:	8b 55 08             	mov    0x8(%ebp),%edx
  800248:	89 df                	mov    %ebx,%edi
  80024a:	89 de                	mov    %ebx,%esi
  80024c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80024e:	85 c0                	test   %eax,%eax
  800250:	7e 28                	jle    80027a <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800252:	89 44 24 10          	mov    %eax,0x10(%esp)
  800256:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80025d:	00 
  80025e:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  800265:	00 
  800266:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80026d:	00 
  80026e:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  800275:	e8 fc 14 00 00       	call   801776 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80027a:	83 c4 2c             	add    $0x2c,%esp
  80027d:	5b                   	pop    %ebx
  80027e:	5e                   	pop    %esi
  80027f:	5f                   	pop    %edi
  800280:	5d                   	pop    %ebp
  800281:	c3                   	ret    

00800282 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	57                   	push   %edi
  800286:	56                   	push   %esi
  800287:	53                   	push   %ebx
  800288:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80028b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800290:	b8 08 00 00 00       	mov    $0x8,%eax
  800295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800298:	8b 55 08             	mov    0x8(%ebp),%edx
  80029b:	89 df                	mov    %ebx,%edi
  80029d:	89 de                	mov    %ebx,%esi
  80029f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	7e 28                	jle    8002cd <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002a9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002b0:	00 
  8002b1:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  8002b8:	00 
  8002b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002c0:	00 
  8002c1:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  8002c8:	e8 a9 14 00 00       	call   801776 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002cd:	83 c4 2c             	add    $0x2c,%esp
  8002d0:	5b                   	pop    %ebx
  8002d1:	5e                   	pop    %esi
  8002d2:	5f                   	pop    %edi
  8002d3:	5d                   	pop    %ebp
  8002d4:	c3                   	ret    

008002d5 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002d5:	55                   	push   %ebp
  8002d6:	89 e5                	mov    %esp,%ebp
  8002d8:	57                   	push   %edi
  8002d9:	56                   	push   %esi
  8002da:	53                   	push   %ebx
  8002db:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002e3:	b8 09 00 00 00       	mov    $0x9,%eax
  8002e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ee:	89 df                	mov    %ebx,%edi
  8002f0:	89 de                	mov    %ebx,%esi
  8002f2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002f4:	85 c0                	test   %eax,%eax
  8002f6:	7e 28                	jle    800320 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002fc:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800303:	00 
  800304:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  80030b:	00 
  80030c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800313:	00 
  800314:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  80031b:	e8 56 14 00 00       	call   801776 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800320:	83 c4 2c             	add    $0x2c,%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    

00800328 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	57                   	push   %edi
  80032c:	56                   	push   %esi
  80032d:	53                   	push   %ebx
  80032e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800331:	bb 00 00 00 00       	mov    $0x0,%ebx
  800336:	b8 0a 00 00 00       	mov    $0xa,%eax
  80033b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033e:	8b 55 08             	mov    0x8(%ebp),%edx
  800341:	89 df                	mov    %ebx,%edi
  800343:	89 de                	mov    %ebx,%esi
  800345:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800347:	85 c0                	test   %eax,%eax
  800349:	7e 28                	jle    800373 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80034b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80034f:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800356:	00 
  800357:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  80035e:	00 
  80035f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800366:	00 
  800367:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  80036e:	e8 03 14 00 00       	call   801776 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800373:	83 c4 2c             	add    $0x2c,%esp
  800376:	5b                   	pop    %ebx
  800377:	5e                   	pop    %esi
  800378:	5f                   	pop    %edi
  800379:	5d                   	pop    %ebp
  80037a:	c3                   	ret    

0080037b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	57                   	push   %edi
  80037f:	56                   	push   %esi
  800380:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800381:	be 00 00 00 00       	mov    $0x0,%esi
  800386:	b8 0c 00 00 00       	mov    $0xc,%eax
  80038b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80038e:	8b 55 08             	mov    0x8(%ebp),%edx
  800391:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800394:	8b 7d 14             	mov    0x14(%ebp),%edi
  800397:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800399:	5b                   	pop    %ebx
  80039a:	5e                   	pop    %esi
  80039b:	5f                   	pop    %edi
  80039c:	5d                   	pop    %ebp
  80039d:	c3                   	ret    

0080039e <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	57                   	push   %edi
  8003a2:	56                   	push   %esi
  8003a3:	53                   	push   %ebx
  8003a4:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ac:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b4:	89 cb                	mov    %ecx,%ebx
  8003b6:	89 cf                	mov    %ecx,%edi
  8003b8:	89 ce                	mov    %ecx,%esi
  8003ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003bc:	85 c0                	test   %eax,%eax
  8003be:	7e 28                	jle    8003e8 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003c4:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003cb:	00 
  8003cc:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  8003d3:	00 
  8003d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003db:	00 
  8003dc:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  8003e3:	e8 8e 13 00 00       	call   801776 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003e8:	83 c4 2c             	add    $0x2c,%esp
  8003eb:	5b                   	pop    %ebx
  8003ec:	5e                   	pop    %esi
  8003ed:	5f                   	pop    %edi
  8003ee:	5d                   	pop    %ebp
  8003ef:	c3                   	ret    

008003f0 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	57                   	push   %edi
  8003f4:	56                   	push   %esi
  8003f5:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fb:	b8 0e 00 00 00       	mov    $0xe,%eax
  800400:	89 d1                	mov    %edx,%ecx
  800402:	89 d3                	mov    %edx,%ebx
  800404:	89 d7                	mov    %edx,%edi
  800406:	89 d6                	mov    %edx,%esi
  800408:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80040a:	5b                   	pop    %ebx
  80040b:	5e                   	pop    %esi
  80040c:	5f                   	pop    %edi
  80040d:	5d                   	pop    %ebp
  80040e:	c3                   	ret    

0080040f <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	57                   	push   %edi
  800413:	56                   	push   %esi
  800414:	53                   	push   %ebx
  800415:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800418:	bb 00 00 00 00       	mov    $0x0,%ebx
  80041d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800422:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800425:	8b 55 08             	mov    0x8(%ebp),%edx
  800428:	89 df                	mov    %ebx,%edi
  80042a:	89 de                	mov    %ebx,%esi
  80042c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80042e:	85 c0                	test   %eax,%eax
  800430:	7e 28                	jle    80045a <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800432:	89 44 24 10          	mov    %eax,0x10(%esp)
  800436:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80043d:	00 
  80043e:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  800445:	00 
  800446:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80044d:	00 
  80044e:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  800455:	e8 1c 13 00 00       	call   801776 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  80045a:	83 c4 2c             	add    $0x2c,%esp
  80045d:	5b                   	pop    %ebx
  80045e:	5e                   	pop    %esi
  80045f:	5f                   	pop    %edi
  800460:	5d                   	pop    %ebp
  800461:	c3                   	ret    

00800462 <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	57                   	push   %edi
  800466:	56                   	push   %esi
  800467:	53                   	push   %ebx
  800468:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80046b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800470:	b8 10 00 00 00       	mov    $0x10,%eax
  800475:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800478:	8b 55 08             	mov    0x8(%ebp),%edx
  80047b:	89 df                	mov    %ebx,%edi
  80047d:	89 de                	mov    %ebx,%esi
  80047f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800481:	85 c0                	test   %eax,%eax
  800483:	7e 28                	jle    8004ad <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800485:	89 44 24 10          	mov    %eax,0x10(%esp)
  800489:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800490:	00 
  800491:	c7 44 24 08 d8 25 80 	movl   $0x8025d8,0x8(%esp)
  800498:	00 
  800499:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004a0:	00 
  8004a1:	c7 04 24 f5 25 80 00 	movl   $0x8025f5,(%esp)
  8004a8:	e8 c9 12 00 00       	call   801776 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8004ad:	83 c4 2c             	add    $0x2c,%esp
  8004b0:	5b                   	pop    %ebx
  8004b1:	5e                   	pop    %esi
  8004b2:	5f                   	pop    %edi
  8004b3:	5d                   	pop    %ebp
  8004b4:	c3                   	ret    
  8004b5:	66 90                	xchg   %ax,%ax
  8004b7:	66 90                	xchg   %ax,%ax
  8004b9:	66 90                	xchg   %ax,%ax
  8004bb:	66 90                	xchg   %ax,%ax
  8004bd:	66 90                	xchg   %ax,%ax
  8004bf:	90                   	nop

008004c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004cb:	c1 e8 0c             	shr    $0xc,%eax
}
  8004ce:	5d                   	pop    %ebp
  8004cf:	c3                   	ret    

008004d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8004db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004e0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8004e5:	5d                   	pop    %ebp
  8004e6:	c3                   	ret    

008004e7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004ed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004f2:	89 c2                	mov    %eax,%edx
  8004f4:	c1 ea 16             	shr    $0x16,%edx
  8004f7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004fe:	f6 c2 01             	test   $0x1,%dl
  800501:	74 11                	je     800514 <fd_alloc+0x2d>
  800503:	89 c2                	mov    %eax,%edx
  800505:	c1 ea 0c             	shr    $0xc,%edx
  800508:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80050f:	f6 c2 01             	test   $0x1,%dl
  800512:	75 09                	jne    80051d <fd_alloc+0x36>
			*fd_store = fd;
  800514:	89 01                	mov    %eax,(%ecx)
			return 0;
  800516:	b8 00 00 00 00       	mov    $0x0,%eax
  80051b:	eb 17                	jmp    800534 <fd_alloc+0x4d>
  80051d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800522:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800527:	75 c9                	jne    8004f2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800529:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80052f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800534:	5d                   	pop    %ebp
  800535:	c3                   	ret    

00800536 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80053c:	83 f8 1f             	cmp    $0x1f,%eax
  80053f:	77 36                	ja     800577 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800541:	c1 e0 0c             	shl    $0xc,%eax
  800544:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800549:	89 c2                	mov    %eax,%edx
  80054b:	c1 ea 16             	shr    $0x16,%edx
  80054e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800555:	f6 c2 01             	test   $0x1,%dl
  800558:	74 24                	je     80057e <fd_lookup+0x48>
  80055a:	89 c2                	mov    %eax,%edx
  80055c:	c1 ea 0c             	shr    $0xc,%edx
  80055f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800566:	f6 c2 01             	test   $0x1,%dl
  800569:	74 1a                	je     800585 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80056b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056e:	89 02                	mov    %eax,(%edx)
	return 0;
  800570:	b8 00 00 00 00       	mov    $0x0,%eax
  800575:	eb 13                	jmp    80058a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80057c:	eb 0c                	jmp    80058a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80057e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800583:	eb 05                	jmp    80058a <fd_lookup+0x54>
  800585:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80058a:	5d                   	pop    %ebp
  80058b:	c3                   	ret    

0080058c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	83 ec 18             	sub    $0x18,%esp
  800592:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  800595:	ba 00 00 00 00       	mov    $0x0,%edx
  80059a:	eb 13                	jmp    8005af <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80059c:	39 08                	cmp    %ecx,(%eax)
  80059e:	75 0c                	jne    8005ac <dev_lookup+0x20>
			*dev = devtab[i];
  8005a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005aa:	eb 38                	jmp    8005e4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8005ac:	83 c2 01             	add    $0x1,%edx
  8005af:	8b 04 95 80 26 80 00 	mov    0x802680(,%edx,4),%eax
  8005b6:	85 c0                	test   %eax,%eax
  8005b8:	75 e2                	jne    80059c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8005bf:	8b 40 48             	mov    0x48(%eax),%eax
  8005c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ca:	c7 04 24 04 26 80 00 	movl   $0x802604,(%esp)
  8005d1:	e8 99 12 00 00       	call   80186f <cprintf>
	*dev = 0;
  8005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8005df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	56                   	push   %esi
  8005ea:	53                   	push   %ebx
  8005eb:	83 ec 20             	sub    $0x20,%esp
  8005ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800601:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800604:	89 04 24             	mov    %eax,(%esp)
  800607:	e8 2a ff ff ff       	call   800536 <fd_lookup>
  80060c:	85 c0                	test   %eax,%eax
  80060e:	78 05                	js     800615 <fd_close+0x2f>
	    || fd != fd2)
  800610:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800613:	74 0c                	je     800621 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800615:	84 db                	test   %bl,%bl
  800617:	ba 00 00 00 00       	mov    $0x0,%edx
  80061c:	0f 44 c2             	cmove  %edx,%eax
  80061f:	eb 3f                	jmp    800660 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800621:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800624:	89 44 24 04          	mov    %eax,0x4(%esp)
  800628:	8b 06                	mov    (%esi),%eax
  80062a:	89 04 24             	mov    %eax,(%esp)
  80062d:	e8 5a ff ff ff       	call   80058c <dev_lookup>
  800632:	89 c3                	mov    %eax,%ebx
  800634:	85 c0                	test   %eax,%eax
  800636:	78 16                	js     80064e <fd_close+0x68>
		if (dev->dev_close)
  800638:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80063b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80063e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800643:	85 c0                	test   %eax,%eax
  800645:	74 07                	je     80064e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800647:	89 34 24             	mov    %esi,(%esp)
  80064a:	ff d0                	call   *%eax
  80064c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80064e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800652:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800659:	e8 d1 fb ff ff       	call   80022f <sys_page_unmap>
	return r;
  80065e:	89 d8                	mov    %ebx,%eax
}
  800660:	83 c4 20             	add    $0x20,%esp
  800663:	5b                   	pop    %ebx
  800664:	5e                   	pop    %esi
  800665:	5d                   	pop    %ebp
  800666:	c3                   	ret    

00800667 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800667:	55                   	push   %ebp
  800668:	89 e5                	mov    %esp,%ebp
  80066a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80066d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800670:	89 44 24 04          	mov    %eax,0x4(%esp)
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 04 24             	mov    %eax,(%esp)
  80067a:	e8 b7 fe ff ff       	call   800536 <fd_lookup>
  80067f:	89 c2                	mov    %eax,%edx
  800681:	85 d2                	test   %edx,%edx
  800683:	78 13                	js     800698 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800685:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80068c:	00 
  80068d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800690:	89 04 24             	mov    %eax,(%esp)
  800693:	e8 4e ff ff ff       	call   8005e6 <fd_close>
}
  800698:	c9                   	leave  
  800699:	c3                   	ret    

0080069a <close_all>:

void
close_all(void)
{
  80069a:	55                   	push   %ebp
  80069b:	89 e5                	mov    %esp,%ebp
  80069d:	53                   	push   %ebx
  80069e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006a6:	89 1c 24             	mov    %ebx,(%esp)
  8006a9:	e8 b9 ff ff ff       	call   800667 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006ae:	83 c3 01             	add    $0x1,%ebx
  8006b1:	83 fb 20             	cmp    $0x20,%ebx
  8006b4:	75 f0                	jne    8006a6 <close_all+0xc>
		close(i);
}
  8006b6:	83 c4 14             	add    $0x14,%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5d                   	pop    %ebp
  8006bb:	c3                   	ret    

008006bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006bc:	55                   	push   %ebp
  8006bd:	89 e5                	mov    %esp,%ebp
  8006bf:	57                   	push   %edi
  8006c0:	56                   	push   %esi
  8006c1:	53                   	push   %ebx
  8006c2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	e8 5f fe ff ff       	call   800536 <fd_lookup>
  8006d7:	89 c2                	mov    %eax,%edx
  8006d9:	85 d2                	test   %edx,%edx
  8006db:	0f 88 e1 00 00 00    	js     8007c2 <dup+0x106>
		return r;
	close(newfdnum);
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	e8 7b ff ff ff       	call   800667 <close>

	newfd = INDEX2FD(newfdnum);
  8006ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ef:	c1 e3 0c             	shl    $0xc,%ebx
  8006f2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8006f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fb:	89 04 24             	mov    %eax,(%esp)
  8006fe:	e8 cd fd ff ff       	call   8004d0 <fd2data>
  800703:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800705:	89 1c 24             	mov    %ebx,(%esp)
  800708:	e8 c3 fd ff ff       	call   8004d0 <fd2data>
  80070d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80070f:	89 f0                	mov    %esi,%eax
  800711:	c1 e8 16             	shr    $0x16,%eax
  800714:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80071b:	a8 01                	test   $0x1,%al
  80071d:	74 43                	je     800762 <dup+0xa6>
  80071f:	89 f0                	mov    %esi,%eax
  800721:	c1 e8 0c             	shr    $0xc,%eax
  800724:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80072b:	f6 c2 01             	test   $0x1,%dl
  80072e:	74 32                	je     800762 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800730:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800737:	25 07 0e 00 00       	and    $0xe07,%eax
  80073c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800740:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800744:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80074b:	00 
  80074c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800750:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800757:	e8 80 fa ff ff       	call   8001dc <sys_page_map>
  80075c:	89 c6                	mov    %eax,%esi
  80075e:	85 c0                	test   %eax,%eax
  800760:	78 3e                	js     8007a0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800765:	89 c2                	mov    %eax,%edx
  800767:	c1 ea 0c             	shr    $0xc,%edx
  80076a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800771:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800777:	89 54 24 10          	mov    %edx,0x10(%esp)
  80077b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80077f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800786:	00 
  800787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800792:	e8 45 fa ff ff       	call   8001dc <sys_page_map>
  800797:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800799:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80079c:	85 f6                	test   %esi,%esi
  80079e:	79 22                	jns    8007c2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007ab:	e8 7f fa ff ff       	call   80022f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007bb:	e8 6f fa ff ff       	call   80022f <sys_page_unmap>
	return r;
  8007c0:	89 f0                	mov    %esi,%eax
}
  8007c2:	83 c4 3c             	add    $0x3c,%esp
  8007c5:	5b                   	pop    %ebx
  8007c6:	5e                   	pop    %esi
  8007c7:	5f                   	pop    %edi
  8007c8:	5d                   	pop    %ebp
  8007c9:	c3                   	ret    

008007ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	53                   	push   %ebx
  8007ce:	83 ec 24             	sub    $0x24,%esp
  8007d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007db:	89 1c 24             	mov    %ebx,(%esp)
  8007de:	e8 53 fd ff ff       	call   800536 <fd_lookup>
  8007e3:	89 c2                	mov    %eax,%edx
  8007e5:	85 d2                	test   %edx,%edx
  8007e7:	78 6d                	js     800856 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	89 04 24             	mov    %eax,(%esp)
  8007f8:	e8 8f fd ff ff       	call   80058c <dev_lookup>
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	78 55                	js     800856 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	8b 50 08             	mov    0x8(%eax),%edx
  800807:	83 e2 03             	and    $0x3,%edx
  80080a:	83 fa 01             	cmp    $0x1,%edx
  80080d:	75 23                	jne    800832 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80080f:	a1 08 40 80 00       	mov    0x804008,%eax
  800814:	8b 40 48             	mov    0x48(%eax),%eax
  800817:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80081b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081f:	c7 04 24 45 26 80 00 	movl   $0x802645,(%esp)
  800826:	e8 44 10 00 00       	call   80186f <cprintf>
		return -E_INVAL;
  80082b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800830:	eb 24                	jmp    800856 <read+0x8c>
	}
	if (!dev->dev_read)
  800832:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800835:	8b 52 08             	mov    0x8(%edx),%edx
  800838:	85 d2                	test   %edx,%edx
  80083a:	74 15                	je     800851 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80083c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80083f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800843:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800846:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80084a:	89 04 24             	mov    %eax,(%esp)
  80084d:	ff d2                	call   *%edx
  80084f:	eb 05                	jmp    800856 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800851:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800856:	83 c4 24             	add    $0x24,%esp
  800859:	5b                   	pop    %ebx
  80085a:	5d                   	pop    %ebp
  80085b:	c3                   	ret    

0080085c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
  80085f:	57                   	push   %edi
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 1c             	sub    $0x1c,%esp
  800865:	8b 7d 08             	mov    0x8(%ebp),%edi
  800868:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80086b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800870:	eb 23                	jmp    800895 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800872:	89 f0                	mov    %esi,%eax
  800874:	29 d8                	sub    %ebx,%eax
  800876:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087a:	89 d8                	mov    %ebx,%eax
  80087c:	03 45 0c             	add    0xc(%ebp),%eax
  80087f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800883:	89 3c 24             	mov    %edi,(%esp)
  800886:	e8 3f ff ff ff       	call   8007ca <read>
		if (m < 0)
  80088b:	85 c0                	test   %eax,%eax
  80088d:	78 10                	js     80089f <readn+0x43>
			return m;
		if (m == 0)
  80088f:	85 c0                	test   %eax,%eax
  800891:	74 0a                	je     80089d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800893:	01 c3                	add    %eax,%ebx
  800895:	39 f3                	cmp    %esi,%ebx
  800897:	72 d9                	jb     800872 <readn+0x16>
  800899:	89 d8                	mov    %ebx,%eax
  80089b:	eb 02                	jmp    80089f <readn+0x43>
  80089d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80089f:	83 c4 1c             	add    $0x1c,%esp
  8008a2:	5b                   	pop    %ebx
  8008a3:	5e                   	pop    %esi
  8008a4:	5f                   	pop    %edi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	53                   	push   %ebx
  8008ab:	83 ec 24             	sub    $0x24,%esp
  8008ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b8:	89 1c 24             	mov    %ebx,(%esp)
  8008bb:	e8 76 fc ff ff       	call   800536 <fd_lookup>
  8008c0:	89 c2                	mov    %eax,%edx
  8008c2:	85 d2                	test   %edx,%edx
  8008c4:	78 68                	js     80092e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 04 24             	mov    %eax,(%esp)
  8008d5:	e8 b2 fc ff ff       	call   80058c <dev_lookup>
  8008da:	85 c0                	test   %eax,%eax
  8008dc:	78 50                	js     80092e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008e5:	75 23                	jne    80090a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8008e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8008ec:	8b 40 48             	mov    0x48(%eax),%eax
  8008ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f7:	c7 04 24 61 26 80 00 	movl   $0x802661,(%esp)
  8008fe:	e8 6c 0f 00 00       	call   80186f <cprintf>
		return -E_INVAL;
  800903:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800908:	eb 24                	jmp    80092e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80090a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80090d:	8b 52 0c             	mov    0xc(%edx),%edx
  800910:	85 d2                	test   %edx,%edx
  800912:	74 15                	je     800929 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800914:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800917:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80091b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	ff d2                	call   *%edx
  800927:	eb 05                	jmp    80092e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800929:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80092e:	83 c4 24             	add    $0x24,%esp
  800931:	5b                   	pop    %ebx
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <seek>:

int
seek(int fdnum, off_t offset)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80093a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80093d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	89 04 24             	mov    %eax,(%esp)
  800947:	e8 ea fb ff ff       	call   800536 <fd_lookup>
  80094c:	85 c0                	test   %eax,%eax
  80094e:	78 0e                	js     80095e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800950:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800953:	8b 55 0c             	mov    0xc(%ebp),%edx
  800956:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	53                   	push   %ebx
  800964:	83 ec 24             	sub    $0x24,%esp
  800967:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80096a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800971:	89 1c 24             	mov    %ebx,(%esp)
  800974:	e8 bd fb ff ff       	call   800536 <fd_lookup>
  800979:	89 c2                	mov    %eax,%edx
  80097b:	85 d2                	test   %edx,%edx
  80097d:	78 61                	js     8009e0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80097f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800982:	89 44 24 04          	mov    %eax,0x4(%esp)
  800986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800989:	8b 00                	mov    (%eax),%eax
  80098b:	89 04 24             	mov    %eax,(%esp)
  80098e:	e8 f9 fb ff ff       	call   80058c <dev_lookup>
  800993:	85 c0                	test   %eax,%eax
  800995:	78 49                	js     8009e0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800997:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80099e:	75 23                	jne    8009c3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009a0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009a5:	8b 40 48             	mov    0x48(%eax),%eax
  8009a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b0:	c7 04 24 24 26 80 00 	movl   $0x802624,(%esp)
  8009b7:	e8 b3 0e 00 00       	call   80186f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009c1:	eb 1d                	jmp    8009e0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8009c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c6:	8b 52 18             	mov    0x18(%edx),%edx
  8009c9:	85 d2                	test   %edx,%edx
  8009cb:	74 0e                	je     8009db <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009d4:	89 04 24             	mov    %eax,(%esp)
  8009d7:	ff d2                	call   *%edx
  8009d9:	eb 05                	jmp    8009e0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8009db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8009e0:	83 c4 24             	add    $0x24,%esp
  8009e3:	5b                   	pop    %ebx
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	53                   	push   %ebx
  8009ea:	83 ec 24             	sub    $0x24,%esp
  8009ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	89 04 24             	mov    %eax,(%esp)
  8009fd:	e8 34 fb ff ff       	call   800536 <fd_lookup>
  800a02:	89 c2                	mov    %eax,%edx
  800a04:	85 d2                	test   %edx,%edx
  800a06:	78 52                	js     800a5a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a12:	8b 00                	mov    (%eax),%eax
  800a14:	89 04 24             	mov    %eax,(%esp)
  800a17:	e8 70 fb ff ff       	call   80058c <dev_lookup>
  800a1c:	85 c0                	test   %eax,%eax
  800a1e:	78 3a                	js     800a5a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a23:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a27:	74 2c                	je     800a55 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a29:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a2c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a33:	00 00 00 
	stat->st_isdir = 0;
  800a36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a3d:	00 00 00 
	stat->st_dev = dev;
  800a40:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a4d:	89 14 24             	mov    %edx,(%esp)
  800a50:	ff 50 14             	call   *0x14(%eax)
  800a53:	eb 05                	jmp    800a5a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a55:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a5a:	83 c4 24             	add    $0x24,%esp
  800a5d:	5b                   	pop    %ebx
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	56                   	push   %esi
  800a64:	53                   	push   %ebx
  800a65:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a68:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a6f:	00 
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	89 04 24             	mov    %eax,(%esp)
  800a76:	e8 28 02 00 00       	call   800ca3 <open>
  800a7b:	89 c3                	mov    %eax,%ebx
  800a7d:	85 db                	test   %ebx,%ebx
  800a7f:	78 1b                	js     800a9c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a88:	89 1c 24             	mov    %ebx,(%esp)
  800a8b:	e8 56 ff ff ff       	call   8009e6 <fstat>
  800a90:	89 c6                	mov    %eax,%esi
	close(fd);
  800a92:	89 1c 24             	mov    %ebx,(%esp)
  800a95:	e8 cd fb ff ff       	call   800667 <close>
	return r;
  800a9a:	89 f0                	mov    %esi,%eax
}
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	56                   	push   %esi
  800aa7:	53                   	push   %ebx
  800aa8:	83 ec 10             	sub    $0x10,%esp
  800aab:	89 c6                	mov    %eax,%esi
  800aad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800aaf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ab6:	75 11                	jne    800ac9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ab8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800abf:	e8 ea 17 00 00       	call   8022ae <ipc_find_env>
  800ac4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ac9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800ad0:	00 
  800ad1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800ad8:	00 
  800ad9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800add:	a1 00 40 80 00       	mov    0x804000,%eax
  800ae2:	89 04 24             	mov    %eax,(%esp)
  800ae5:	e8 66 17 00 00       	call   802250 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800aea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800af1:	00 
  800af2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800af6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800afd:	e8 e4 16 00 00       	call   8021e6 <ipc_recv>
}
  800b02:	83 c4 10             	add    $0x10,%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 40 0c             	mov    0xc(%eax),%eax
  800b15:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b22:	ba 00 00 00 00       	mov    $0x0,%edx
  800b27:	b8 02 00 00 00       	mov    $0x2,%eax
  800b2c:	e8 72 ff ff ff       	call   800aa3 <fsipc>
}
  800b31:	c9                   	leave  
  800b32:	c3                   	ret    

00800b33 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b3f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b44:	ba 00 00 00 00       	mov    $0x0,%edx
  800b49:	b8 06 00 00 00       	mov    $0x6,%eax
  800b4e:	e8 50 ff ff ff       	call   800aa3 <fsipc>
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	53                   	push   %ebx
  800b59:	83 ec 14             	sub    $0x14,%esp
  800b5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8b 40 0c             	mov    0xc(%eax),%eax
  800b65:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	b8 05 00 00 00       	mov    $0x5,%eax
  800b74:	e8 2a ff ff ff       	call   800aa3 <fsipc>
  800b79:	89 c2                	mov    %eax,%edx
  800b7b:	85 d2                	test   %edx,%edx
  800b7d:	78 2b                	js     800baa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b7f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b86:	00 
  800b87:	89 1c 24             	mov    %ebx,(%esp)
  800b8a:	e8 08 13 00 00       	call   801e97 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b8f:	a1 80 50 80 00       	mov    0x805080,%eax
  800b94:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b9a:	a1 84 50 80 00       	mov    0x805084,%eax
  800b9f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800ba5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800baa:	83 c4 14             	add    $0x14,%esp
  800bad:	5b                   	pop    %ebx
  800bae:	5d                   	pop    %ebp
  800baf:	c3                   	ret    

00800bb0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	83 ec 18             	sub    $0x18,%esp
  800bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800bbe:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800bc3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  800bc6:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bce:	8b 52 0c             	mov    0xc(%edx),%edx
  800bd1:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  800bd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be2:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800be9:	e8 46 14 00 00       	call   802034 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  800bee:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf3:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf8:	e8 a6 fe ff ff       	call   800aa3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  800bfd:	c9                   	leave  
  800bfe:	c3                   	ret    

00800bff <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	83 ec 10             	sub    $0x10,%esp
  800c07:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8b 40 0c             	mov    0xc(%eax),%eax
  800c10:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800c15:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	b8 03 00 00 00       	mov    $0x3,%eax
  800c25:	e8 79 fe ff ff       	call   800aa3 <fsipc>
  800c2a:	89 c3                	mov    %eax,%ebx
  800c2c:	85 c0                	test   %eax,%eax
  800c2e:	78 6a                	js     800c9a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800c30:	39 c6                	cmp    %eax,%esi
  800c32:	73 24                	jae    800c58 <devfile_read+0x59>
  800c34:	c7 44 24 0c 94 26 80 	movl   $0x802694,0xc(%esp)
  800c3b:	00 
  800c3c:	c7 44 24 08 9b 26 80 	movl   $0x80269b,0x8(%esp)
  800c43:	00 
  800c44:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800c4b:	00 
  800c4c:	c7 04 24 b0 26 80 00 	movl   $0x8026b0,(%esp)
  800c53:	e8 1e 0b 00 00       	call   801776 <_panic>
	assert(r <= PGSIZE);
  800c58:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c5d:	7e 24                	jle    800c83 <devfile_read+0x84>
  800c5f:	c7 44 24 0c bb 26 80 	movl   $0x8026bb,0xc(%esp)
  800c66:	00 
  800c67:	c7 44 24 08 9b 26 80 	movl   $0x80269b,0x8(%esp)
  800c6e:	00 
  800c6f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800c76:	00 
  800c77:	c7 04 24 b0 26 80 00 	movl   $0x8026b0,(%esp)
  800c7e:	e8 f3 0a 00 00       	call   801776 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800c83:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c87:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c8e:	00 
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	89 04 24             	mov    %eax,(%esp)
  800c95:	e8 9a 13 00 00       	call   802034 <memmove>
	return r;
}
  800c9a:	89 d8                	mov    %ebx,%eax
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 24             	sub    $0x24,%esp
  800caa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800cad:	89 1c 24             	mov    %ebx,(%esp)
  800cb0:	e8 ab 11 00 00       	call   801e60 <strlen>
  800cb5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800cba:	7f 60                	jg     800d1c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800cbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cbf:	89 04 24             	mov    %eax,(%esp)
  800cc2:	e8 20 f8 ff ff       	call   8004e7 <fd_alloc>
  800cc7:	89 c2                	mov    %eax,%edx
  800cc9:	85 d2                	test   %edx,%edx
  800ccb:	78 54                	js     800d21 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800ccd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cd1:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800cd8:	e8 ba 11 00 00       	call   801e97 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800ce5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ce8:	b8 01 00 00 00       	mov    $0x1,%eax
  800ced:	e8 b1 fd ff ff       	call   800aa3 <fsipc>
  800cf2:	89 c3                	mov    %eax,%ebx
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	79 17                	jns    800d0f <open+0x6c>
		fd_close(fd, 0);
  800cf8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800cff:	00 
  800d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d03:	89 04 24             	mov    %eax,(%esp)
  800d06:	e8 db f8 ff ff       	call   8005e6 <fd_close>
		return r;
  800d0b:	89 d8                	mov    %ebx,%eax
  800d0d:	eb 12                	jmp    800d21 <open+0x7e>
	}

	return fd2num(fd);
  800d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d12:	89 04 24             	mov    %eax,(%esp)
  800d15:	e8 a6 f7 ff ff       	call   8004c0 <fd2num>
  800d1a:	eb 05                	jmp    800d21 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800d1c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800d21:	83 c4 24             	add    $0x24,%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d32:	b8 08 00 00 00       	mov    $0x8,%eax
  800d37:	e8 67 fd ff ff       	call   800aa3 <fsipc>
}
  800d3c:	c9                   	leave  
  800d3d:	c3                   	ret    
  800d3e:	66 90                	xchg   %ax,%ax

00800d40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800d46:	c7 44 24 04 c7 26 80 	movl   $0x8026c7,0x4(%esp)
  800d4d:	00 
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	89 04 24             	mov    %eax,(%esp)
  800d54:	e8 3e 11 00 00       	call   801e97 <strcpy>
	return 0;
}
  800d59:	b8 00 00 00 00       	mov    $0x0,%eax
  800d5e:	c9                   	leave  
  800d5f:	c3                   	ret    

00800d60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	53                   	push   %ebx
  800d64:	83 ec 14             	sub    $0x14,%esp
  800d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800d6a:	89 1c 24             	mov    %ebx,(%esp)
  800d6d:	e8 74 15 00 00       	call   8022e6 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800d72:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800d77:	83 f8 01             	cmp    $0x1,%eax
  800d7a:	75 0d                	jne    800d89 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800d7c:	8b 43 0c             	mov    0xc(%ebx),%eax
  800d7f:	89 04 24             	mov    %eax,(%esp)
  800d82:	e8 29 03 00 00       	call   8010b0 <nsipc_close>
  800d87:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800d89:	89 d0                	mov    %edx,%eax
  800d8b:	83 c4 14             	add    $0x14,%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    

00800d91 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800d97:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800d9e:	00 
  800d9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800da2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8b 40 0c             	mov    0xc(%eax),%eax
  800db3:	89 04 24             	mov    %eax,(%esp)
  800db6:	e8 f0 03 00 00       	call   8011ab <nsipc_send>
}
  800dbb:	c9                   	leave  
  800dbc:	c3                   	ret    

00800dbd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800dc3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800dca:	00 
  800dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dce:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  800ddf:	89 04 24             	mov    %eax,(%esp)
  800de2:	e8 44 03 00 00       	call   80112b <nsipc_recv>
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800def:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800df2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800df6:	89 04 24             	mov    %eax,(%esp)
  800df9:	e8 38 f7 ff ff       	call   800536 <fd_lookup>
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	78 17                	js     800e19 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e05:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  800e0b:	39 08                	cmp    %ecx,(%eax)
  800e0d:	75 05                	jne    800e14 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800e0f:	8b 40 0c             	mov    0xc(%eax),%eax
  800e12:	eb 05                	jmp    800e19 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800e14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800e19:	c9                   	leave  
  800e1a:	c3                   	ret    

00800e1b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 20             	sub    $0x20,%esp
  800e23:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e28:	89 04 24             	mov    %eax,(%esp)
  800e2b:	e8 b7 f6 ff ff       	call   8004e7 <fd_alloc>
  800e30:	89 c3                	mov    %eax,%ebx
  800e32:	85 c0                	test   %eax,%eax
  800e34:	78 21                	js     800e57 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800e36:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800e3d:	00 
  800e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e4c:	e8 37 f3 ff ff       	call   800188 <sys_page_alloc>
  800e51:	89 c3                	mov    %eax,%ebx
  800e53:	85 c0                	test   %eax,%eax
  800e55:	79 0c                	jns    800e63 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800e57:	89 34 24             	mov    %esi,(%esp)
  800e5a:	e8 51 02 00 00       	call   8010b0 <nsipc_close>
		return r;
  800e5f:	89 d8                	mov    %ebx,%eax
  800e61:	eb 20                	jmp    800e83 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800e63:	8b 15 24 30 80 00    	mov    0x803024,%edx
  800e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800e6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e71:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800e78:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800e7b:	89 14 24             	mov    %edx,(%esp)
  800e7e:	e8 3d f6 ff ff       	call   8004c0 <fd2num>
}
  800e83:	83 c4 20             	add    $0x20,%esp
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    

00800e8a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	e8 51 ff ff ff       	call   800de9 <fd2sockid>
		return r;
  800e98:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800e9a:	85 c0                	test   %eax,%eax
  800e9c:	78 23                	js     800ec1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800e9e:	8b 55 10             	mov    0x10(%ebp),%edx
  800ea1:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ea5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800eac:	89 04 24             	mov    %eax,(%esp)
  800eaf:	e8 45 01 00 00       	call   800ff9 <nsipc_accept>
		return r;
  800eb4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800eb6:	85 c0                	test   %eax,%eax
  800eb8:	78 07                	js     800ec1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800eba:	e8 5c ff ff ff       	call   800e1b <alloc_sockfd>
  800ebf:	89 c1                	mov    %eax,%ecx
}
  800ec1:	89 c8                	mov    %ecx,%eax
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	e8 16 ff ff ff       	call   800de9 <fd2sockid>
  800ed3:	89 c2                	mov    %eax,%edx
  800ed5:	85 d2                	test   %edx,%edx
  800ed7:	78 16                	js     800eef <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee7:	89 14 24             	mov    %edx,(%esp)
  800eea:	e8 60 01 00 00       	call   80104f <nsipc_bind>
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <shutdown>:

int
shutdown(int s, int how)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	e8 ea fe ff ff       	call   800de9 <fd2sockid>
  800eff:	89 c2                	mov    %eax,%edx
  800f01:	85 d2                	test   %edx,%edx
  800f03:	78 0f                	js     800f14 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f0c:	89 14 24             	mov    %edx,(%esp)
  800f0f:	e8 7a 01 00 00       	call   80108e <nsipc_shutdown>
}
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	e8 c5 fe ff ff       	call   800de9 <fd2sockid>
  800f24:	89 c2                	mov    %eax,%edx
  800f26:	85 d2                	test   %edx,%edx
  800f28:	78 16                	js     800f40 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  800f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f38:	89 14 24             	mov    %edx,(%esp)
  800f3b:	e8 8a 01 00 00       	call   8010ca <nsipc_connect>
}
  800f40:	c9                   	leave  
  800f41:	c3                   	ret    

00800f42 <listen>:

int
listen(int s, int backlog)
{
  800f42:	55                   	push   %ebp
  800f43:	89 e5                	mov    %esp,%ebp
  800f45:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	e8 99 fe ff ff       	call   800de9 <fd2sockid>
  800f50:	89 c2                	mov    %eax,%edx
  800f52:	85 d2                	test   %edx,%edx
  800f54:	78 0f                	js     800f65 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f5d:	89 14 24             	mov    %edx,(%esp)
  800f60:	e8 a4 01 00 00       	call   801109 <nsipc_listen>
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800f6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f70:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	89 04 24             	mov    %eax,(%esp)
  800f81:	e8 98 02 00 00       	call   80121e <nsipc_socket>
  800f86:	89 c2                	mov    %eax,%edx
  800f88:	85 d2                	test   %edx,%edx
  800f8a:	78 05                	js     800f91 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  800f8c:	e8 8a fe ff ff       	call   800e1b <alloc_sockfd>
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	53                   	push   %ebx
  800f97:	83 ec 14             	sub    $0x14,%esp
  800f9a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800f9c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800fa3:	75 11                	jne    800fb6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800fa5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800fac:	e8 fd 12 00 00       	call   8022ae <ipc_find_env>
  800fb1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800fb6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800fbd:	00 
  800fbe:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  800fc5:	00 
  800fc6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800fca:	a1 04 40 80 00       	mov    0x804004,%eax
  800fcf:	89 04 24             	mov    %eax,(%esp)
  800fd2:	e8 79 12 00 00       	call   802250 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  800fd7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800fde:	00 
  800fdf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800fe6:	00 
  800fe7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fee:	e8 f3 11 00 00       	call   8021e6 <ipc_recv>
}
  800ff3:	83 c4 14             	add    $0x14,%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5d                   	pop    %ebp
  800ff8:	c3                   	ret    

00800ff9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
  800ffe:	83 ec 10             	sub    $0x10,%esp
  801001:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80100c:	8b 06                	mov    (%esi),%eax
  80100e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801013:	b8 01 00 00 00       	mov    $0x1,%eax
  801018:	e8 76 ff ff ff       	call   800f93 <nsipc>
  80101d:	89 c3                	mov    %eax,%ebx
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 23                	js     801046 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801023:	a1 10 60 80 00       	mov    0x806010,%eax
  801028:	89 44 24 08          	mov    %eax,0x8(%esp)
  80102c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801033:	00 
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	89 04 24             	mov    %eax,(%esp)
  80103a:	e8 f5 0f 00 00       	call   802034 <memmove>
		*addrlen = ret->ret_addrlen;
  80103f:	a1 10 60 80 00       	mov    0x806010,%eax
  801044:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801046:	89 d8                	mov    %ebx,%eax
  801048:	83 c4 10             	add    $0x10,%esp
  80104b:	5b                   	pop    %ebx
  80104c:	5e                   	pop    %esi
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	53                   	push   %ebx
  801053:	83 ec 14             	sub    $0x14,%esp
  801056:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801061:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80106c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801073:	e8 bc 0f 00 00       	call   802034 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801078:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80107e:	b8 02 00 00 00       	mov    $0x2,%eax
  801083:	e8 0b ff ff ff       	call   800f93 <nsipc>
}
  801088:	83 c4 14             	add    $0x14,%esp
  80108b:	5b                   	pop    %ebx
  80108c:	5d                   	pop    %ebp
  80108d:	c3                   	ret    

0080108e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80109c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8010a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8010a9:	e8 e5 fe ff ff       	call   800f93 <nsipc>
}
  8010ae:	c9                   	leave  
  8010af:	c3                   	ret    

008010b0 <nsipc_close>:

int
nsipc_close(int s)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8010be:	b8 04 00 00 00       	mov    $0x4,%eax
  8010c3:	e8 cb fe ff ff       	call   800f93 <nsipc>
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	53                   	push   %ebx
  8010ce:	83 ec 14             	sub    $0x14,%esp
  8010d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8010dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010e7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8010ee:	e8 41 0f 00 00       	call   802034 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8010f3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8010f9:	b8 05 00 00 00       	mov    $0x5,%eax
  8010fe:	e8 90 fe ff ff       	call   800f93 <nsipc>
}
  801103:	83 c4 14             	add    $0x14,%esp
  801106:	5b                   	pop    %ebx
  801107:	5d                   	pop    %ebp
  801108:	c3                   	ret    

00801109 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80111f:	b8 06 00 00 00       	mov    $0x6,%eax
  801124:	e8 6a fe ff ff       	call   800f93 <nsipc>
}
  801129:	c9                   	leave  
  80112a:	c3                   	ret    

0080112b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	56                   	push   %esi
  80112f:	53                   	push   %ebx
  801130:	83 ec 10             	sub    $0x10,%esp
  801133:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801136:	8b 45 08             	mov    0x8(%ebp),%eax
  801139:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80113e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801144:	8b 45 14             	mov    0x14(%ebp),%eax
  801147:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80114c:	b8 07 00 00 00       	mov    $0x7,%eax
  801151:	e8 3d fe ff ff       	call   800f93 <nsipc>
  801156:	89 c3                	mov    %eax,%ebx
  801158:	85 c0                	test   %eax,%eax
  80115a:	78 46                	js     8011a2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80115c:	39 f0                	cmp    %esi,%eax
  80115e:	7f 07                	jg     801167 <nsipc_recv+0x3c>
  801160:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801165:	7e 24                	jle    80118b <nsipc_recv+0x60>
  801167:	c7 44 24 0c d3 26 80 	movl   $0x8026d3,0xc(%esp)
  80116e:	00 
  80116f:	c7 44 24 08 9b 26 80 	movl   $0x80269b,0x8(%esp)
  801176:	00 
  801177:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80117e:	00 
  80117f:	c7 04 24 e8 26 80 00 	movl   $0x8026e8,(%esp)
  801186:	e8 eb 05 00 00       	call   801776 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80118b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80118f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801196:	00 
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	89 04 24             	mov    %eax,(%esp)
  80119d:	e8 92 0e 00 00       	call   802034 <memmove>
	}

	return r;
}
  8011a2:	89 d8                	mov    %ebx,%eax
  8011a4:	83 c4 10             	add    $0x10,%esp
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5d                   	pop    %ebp
  8011aa:	c3                   	ret    

008011ab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	53                   	push   %ebx
  8011af:	83 ec 14             	sub    $0x14,%esp
  8011b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8011bd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8011c3:	7e 24                	jle    8011e9 <nsipc_send+0x3e>
  8011c5:	c7 44 24 0c f4 26 80 	movl   $0x8026f4,0xc(%esp)
  8011cc:	00 
  8011cd:	c7 44 24 08 9b 26 80 	movl   $0x80269b,0x8(%esp)
  8011d4:	00 
  8011d5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8011dc:	00 
  8011dd:	c7 04 24 e8 26 80 00 	movl   $0x8026e8,(%esp)
  8011e4:	e8 8d 05 00 00       	call   801776 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8011e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8011fb:	e8 34 0e 00 00       	call   802034 <memmove>
	nsipcbuf.send.req_size = size;
  801200:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80120e:	b8 08 00 00 00       	mov    $0x8,%eax
  801213:	e8 7b fd ff ff       	call   800f93 <nsipc>
}
  801218:	83 c4 14             	add    $0x14,%esp
  80121b:	5b                   	pop    %ebx
  80121c:	5d                   	pop    %ebp
  80121d:	c3                   	ret    

0080121e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80121e:	55                   	push   %ebp
  80121f:	89 e5                	mov    %esp,%ebp
  801221:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80123c:	b8 09 00 00 00       	mov    $0x9,%eax
  801241:	e8 4d fd ff ff       	call   800f93 <nsipc>
}
  801246:	c9                   	leave  
  801247:	c3                   	ret    

00801248 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801248:	55                   	push   %ebp
  801249:	89 e5                	mov    %esp,%ebp
  80124b:	56                   	push   %esi
  80124c:	53                   	push   %ebx
  80124d:	83 ec 10             	sub    $0x10,%esp
  801250:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	89 04 24             	mov    %eax,(%esp)
  801259:	e8 72 f2 ff ff       	call   8004d0 <fd2data>
  80125e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801260:	c7 44 24 04 00 27 80 	movl   $0x802700,0x4(%esp)
  801267:	00 
  801268:	89 1c 24             	mov    %ebx,(%esp)
  80126b:	e8 27 0c 00 00       	call   801e97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801270:	8b 46 04             	mov    0x4(%esi),%eax
  801273:	2b 06                	sub    (%esi),%eax
  801275:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80127b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801282:	00 00 00 
	stat->st_dev = &devpipe;
  801285:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  80128c:	30 80 00 
	return 0;
}
  80128f:	b8 00 00 00 00       	mov    $0x0,%eax
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	5b                   	pop    %ebx
  801298:	5e                   	pop    %esi
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    

0080129b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	53                   	push   %ebx
  80129f:	83 ec 14             	sub    $0x14,%esp
  8012a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8012a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b0:	e8 7a ef ff ff       	call   80022f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8012b5:	89 1c 24             	mov    %ebx,(%esp)
  8012b8:	e8 13 f2 ff ff       	call   8004d0 <fd2data>
  8012bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c8:	e8 62 ef ff ff       	call   80022f <sys_page_unmap>
}
  8012cd:	83 c4 14             	add    $0x14,%esp
  8012d0:	5b                   	pop    %ebx
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	57                   	push   %edi
  8012d7:	56                   	push   %esi
  8012d8:	53                   	push   %ebx
  8012d9:	83 ec 2c             	sub    $0x2c,%esp
  8012dc:	89 c6                	mov    %eax,%esi
  8012de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8012e1:	a1 08 40 80 00       	mov    0x804008,%eax
  8012e6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8012e9:	89 34 24             	mov    %esi,(%esp)
  8012ec:	e8 f5 0f 00 00       	call   8022e6 <pageref>
  8012f1:	89 c7                	mov    %eax,%edi
  8012f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f6:	89 04 24             	mov    %eax,(%esp)
  8012f9:	e8 e8 0f 00 00       	call   8022e6 <pageref>
  8012fe:	39 c7                	cmp    %eax,%edi
  801300:	0f 94 c2             	sete   %dl
  801303:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801306:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80130c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80130f:	39 fb                	cmp    %edi,%ebx
  801311:	74 21                	je     801334 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801313:	84 d2                	test   %dl,%dl
  801315:	74 ca                	je     8012e1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801317:	8b 51 58             	mov    0x58(%ecx),%edx
  80131a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80131e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801322:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801326:	c7 04 24 07 27 80 00 	movl   $0x802707,(%esp)
  80132d:	e8 3d 05 00 00       	call   80186f <cprintf>
  801332:	eb ad                	jmp    8012e1 <_pipeisclosed+0xe>
	}
}
  801334:	83 c4 2c             	add    $0x2c,%esp
  801337:	5b                   	pop    %ebx
  801338:	5e                   	pop    %esi
  801339:	5f                   	pop    %edi
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    

0080133c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	57                   	push   %edi
  801340:	56                   	push   %esi
  801341:	53                   	push   %ebx
  801342:	83 ec 1c             	sub    $0x1c,%esp
  801345:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801348:	89 34 24             	mov    %esi,(%esp)
  80134b:	e8 80 f1 ff ff       	call   8004d0 <fd2data>
  801350:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801352:	bf 00 00 00 00       	mov    $0x0,%edi
  801357:	eb 45                	jmp    80139e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801359:	89 da                	mov    %ebx,%edx
  80135b:	89 f0                	mov    %esi,%eax
  80135d:	e8 71 ff ff ff       	call   8012d3 <_pipeisclosed>
  801362:	85 c0                	test   %eax,%eax
  801364:	75 41                	jne    8013a7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801366:	e8 fe ed ff ff       	call   800169 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80136b:	8b 43 04             	mov    0x4(%ebx),%eax
  80136e:	8b 0b                	mov    (%ebx),%ecx
  801370:	8d 51 20             	lea    0x20(%ecx),%edx
  801373:	39 d0                	cmp    %edx,%eax
  801375:	73 e2                	jae    801359 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80137a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80137e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801381:	99                   	cltd   
  801382:	c1 ea 1b             	shr    $0x1b,%edx
  801385:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801388:	83 e1 1f             	and    $0x1f,%ecx
  80138b:	29 d1                	sub    %edx,%ecx
  80138d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801391:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801395:	83 c0 01             	add    $0x1,%eax
  801398:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80139b:	83 c7 01             	add    $0x1,%edi
  80139e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8013a1:	75 c8                	jne    80136b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8013a3:	89 f8                	mov    %edi,%eax
  8013a5:	eb 05                	jmp    8013ac <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8013ac:	83 c4 1c             	add    $0x1c,%esp
  8013af:	5b                   	pop    %ebx
  8013b0:	5e                   	pop    %esi
  8013b1:	5f                   	pop    %edi
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    

008013b4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	57                   	push   %edi
  8013b8:	56                   	push   %esi
  8013b9:	53                   	push   %ebx
  8013ba:	83 ec 1c             	sub    $0x1c,%esp
  8013bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8013c0:	89 3c 24             	mov    %edi,(%esp)
  8013c3:	e8 08 f1 ff ff       	call   8004d0 <fd2data>
  8013c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013ca:	be 00 00 00 00       	mov    $0x0,%esi
  8013cf:	eb 3d                	jmp    80140e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8013d1:	85 f6                	test   %esi,%esi
  8013d3:	74 04                	je     8013d9 <devpipe_read+0x25>
				return i;
  8013d5:	89 f0                	mov    %esi,%eax
  8013d7:	eb 43                	jmp    80141c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8013d9:	89 da                	mov    %ebx,%edx
  8013db:	89 f8                	mov    %edi,%eax
  8013dd:	e8 f1 fe ff ff       	call   8012d3 <_pipeisclosed>
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	75 31                	jne    801417 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8013e6:	e8 7e ed ff ff       	call   800169 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8013eb:	8b 03                	mov    (%ebx),%eax
  8013ed:	3b 43 04             	cmp    0x4(%ebx),%eax
  8013f0:	74 df                	je     8013d1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8013f2:	99                   	cltd   
  8013f3:	c1 ea 1b             	shr    $0x1b,%edx
  8013f6:	01 d0                	add    %edx,%eax
  8013f8:	83 e0 1f             	and    $0x1f,%eax
  8013fb:	29 d0                	sub    %edx,%eax
  8013fd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801402:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801405:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801408:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80140b:	83 c6 01             	add    $0x1,%esi
  80140e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801411:	75 d8                	jne    8013eb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801413:	89 f0                	mov    %esi,%eax
  801415:	eb 05                	jmp    80141c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801417:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80141c:	83 c4 1c             	add    $0x1c,%esp
  80141f:	5b                   	pop    %ebx
  801420:	5e                   	pop    %esi
  801421:	5f                   	pop    %edi
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    

00801424 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	56                   	push   %esi
  801428:	53                   	push   %ebx
  801429:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80142c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142f:	89 04 24             	mov    %eax,(%esp)
  801432:	e8 b0 f0 ff ff       	call   8004e7 <fd_alloc>
  801437:	89 c2                	mov    %eax,%edx
  801439:	85 d2                	test   %edx,%edx
  80143b:	0f 88 4d 01 00 00    	js     80158e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801441:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801448:	00 
  801449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801450:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801457:	e8 2c ed ff ff       	call   800188 <sys_page_alloc>
  80145c:	89 c2                	mov    %eax,%edx
  80145e:	85 d2                	test   %edx,%edx
  801460:	0f 88 28 01 00 00    	js     80158e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801466:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801469:	89 04 24             	mov    %eax,(%esp)
  80146c:	e8 76 f0 ff ff       	call   8004e7 <fd_alloc>
  801471:	89 c3                	mov    %eax,%ebx
  801473:	85 c0                	test   %eax,%eax
  801475:	0f 88 fe 00 00 00    	js     801579 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80147b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801482:	00 
  801483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801486:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801491:	e8 f2 ec ff ff       	call   800188 <sys_page_alloc>
  801496:	89 c3                	mov    %eax,%ebx
  801498:	85 c0                	test   %eax,%eax
  80149a:	0f 88 d9 00 00 00    	js     801579 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8014a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a3:	89 04 24             	mov    %eax,(%esp)
  8014a6:	e8 25 f0 ff ff       	call   8004d0 <fd2data>
  8014ab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014ad:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014b4:	00 
  8014b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c0:	e8 c3 ec ff ff       	call   800188 <sys_page_alloc>
  8014c5:	89 c3                	mov    %eax,%ebx
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	0f 88 97 00 00 00    	js     801566 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d2:	89 04 24             	mov    %eax,(%esp)
  8014d5:	e8 f6 ef ff ff       	call   8004d0 <fd2data>
  8014da:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8014e1:	00 
  8014e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014ed:	00 
  8014ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f9:	e8 de ec ff ff       	call   8001dc <sys_page_map>
  8014fe:	89 c3                	mov    %eax,%ebx
  801500:	85 c0                	test   %eax,%eax
  801502:	78 52                	js     801556 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801504:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80150a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80150f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801512:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801519:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801527:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80152e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801531:	89 04 24             	mov    %eax,(%esp)
  801534:	e8 87 ef ff ff       	call   8004c0 <fd2num>
  801539:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80153e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801541:	89 04 24             	mov    %eax,(%esp)
  801544:	e8 77 ef ff ff       	call   8004c0 <fd2num>
  801549:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80154f:	b8 00 00 00 00       	mov    $0x0,%eax
  801554:	eb 38                	jmp    80158e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801556:	89 74 24 04          	mov    %esi,0x4(%esp)
  80155a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801561:	e8 c9 ec ff ff       	call   80022f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801574:	e8 b6 ec ff ff       	call   80022f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801587:	e8 a3 ec ff ff       	call   80022f <sys_page_unmap>
  80158c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80158e:	83 c4 30             	add    $0x30,%esp
  801591:	5b                   	pop    %ebx
  801592:	5e                   	pop    %esi
  801593:	5d                   	pop    %ebp
  801594:	c3                   	ret    

00801595 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80159b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 04 24             	mov    %eax,(%esp)
  8015a8:	e8 89 ef ff ff       	call   800536 <fd_lookup>
  8015ad:	89 c2                	mov    %eax,%edx
  8015af:	85 d2                	test   %edx,%edx
  8015b1:	78 15                	js     8015c8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8015b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b6:	89 04 24             	mov    %eax,(%esp)
  8015b9:	e8 12 ef ff ff       	call   8004d0 <fd2data>
	return _pipeisclosed(fd, p);
  8015be:	89 c2                	mov    %eax,%edx
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	e8 0b fd ff ff       	call   8012d3 <_pipeisclosed>
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    
  8015ca:	66 90                	xchg   %ax,%ax
  8015cc:	66 90                	xchg   %ax,%ax
  8015ce:	66 90                	xchg   %ax,%ax

008015d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8015d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8015e0:	c7 44 24 04 1f 27 80 	movl   $0x80271f,0x4(%esp)
  8015e7:	00 
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	89 04 24             	mov    %eax,(%esp)
  8015ee:	e8 a4 08 00 00       	call   801e97 <strcpy>
	return 0;
}
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	57                   	push   %edi
  8015fe:	56                   	push   %esi
  8015ff:	53                   	push   %ebx
  801600:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801606:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80160b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801611:	eb 31                	jmp    801644 <devcons_write+0x4a>
		m = n - tot;
  801613:	8b 75 10             	mov    0x10(%ebp),%esi
  801616:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801618:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80161b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801620:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801623:	89 74 24 08          	mov    %esi,0x8(%esp)
  801627:	03 45 0c             	add    0xc(%ebp),%eax
  80162a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162e:	89 3c 24             	mov    %edi,(%esp)
  801631:	e8 fe 09 00 00       	call   802034 <memmove>
		sys_cputs(buf, m);
  801636:	89 74 24 04          	mov    %esi,0x4(%esp)
  80163a:	89 3c 24             	mov    %edi,(%esp)
  80163d:	e8 79 ea ff ff       	call   8000bb <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801642:	01 f3                	add    %esi,%ebx
  801644:	89 d8                	mov    %ebx,%eax
  801646:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801649:	72 c8                	jb     801613 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80164b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801651:	5b                   	pop    %ebx
  801652:	5e                   	pop    %esi
  801653:	5f                   	pop    %edi
  801654:	5d                   	pop    %ebp
  801655:	c3                   	ret    

00801656 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80165c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801661:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801665:	75 07                	jne    80166e <devcons_read+0x18>
  801667:	eb 2a                	jmp    801693 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801669:	e8 fb ea ff ff       	call   800169 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80166e:	66 90                	xchg   %ax,%ax
  801670:	e8 64 ea ff ff       	call   8000d9 <sys_cgetc>
  801675:	85 c0                	test   %eax,%eax
  801677:	74 f0                	je     801669 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801679:	85 c0                	test   %eax,%eax
  80167b:	78 16                	js     801693 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80167d:	83 f8 04             	cmp    $0x4,%eax
  801680:	74 0c                	je     80168e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  801682:	8b 55 0c             	mov    0xc(%ebp),%edx
  801685:	88 02                	mov    %al,(%edx)
	return 1;
  801687:	b8 01 00 00 00       	mov    $0x1,%eax
  80168c:	eb 05                	jmp    801693 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8016a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016a8:	00 
  8016a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8016ac:	89 04 24             	mov    %eax,(%esp)
  8016af:	e8 07 ea ff ff       	call   8000bb <sys_cputs>
}
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <getchar>:

int
getchar(void)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8016bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016c3:	00 
  8016c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d2:	e8 f3 f0 ff ff       	call   8007ca <read>
	if (r < 0)
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 0f                	js     8016ea <getchar+0x34>
		return r;
	if (r < 1)
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	7e 06                	jle    8016e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8016df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8016e3:	eb 05                	jmp    8016ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8016e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	89 04 24             	mov    %eax,(%esp)
  8016ff:	e8 32 ee ff ff       	call   800536 <fd_lookup>
  801704:	85 c0                	test   %eax,%eax
  801706:	78 11                	js     801719 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170b:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  801711:	39 10                	cmp    %edx,(%eax)
  801713:	0f 94 c0             	sete   %al
  801716:	0f b6 c0             	movzbl %al,%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <opencons>:

int
opencons(void)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801721:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801724:	89 04 24             	mov    %eax,(%esp)
  801727:	e8 bb ed ff ff       	call   8004e7 <fd_alloc>
		return r;
  80172c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 40                	js     801772 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801732:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801739:	00 
  80173a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801741:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801748:	e8 3b ea ff ff       	call   800188 <sys_page_alloc>
		return r;
  80174d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80174f:	85 c0                	test   %eax,%eax
  801751:	78 1f                	js     801772 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801753:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  801759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80175e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801761:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801768:	89 04 24             	mov    %eax,(%esp)
  80176b:	e8 50 ed ff ff       	call   8004c0 <fd2num>
  801770:	89 c2                	mov    %eax,%edx
}
  801772:	89 d0                	mov    %edx,%eax
  801774:	c9                   	leave  
  801775:	c3                   	ret    

00801776 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	56                   	push   %esi
  80177a:	53                   	push   %ebx
  80177b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80177e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801781:	8b 35 04 30 80 00    	mov    0x803004,%esi
  801787:	e8 be e9 ff ff       	call   80014a <sys_getenvid>
  80178c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801793:	8b 55 08             	mov    0x8(%ebp),%edx
  801796:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80179a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80179e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a2:	c7 04 24 2c 27 80 00 	movl   $0x80272c,(%esp)
  8017a9:	e8 c1 00 00 00       	call   80186f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017b5:	89 04 24             	mov    %eax,(%esp)
  8017b8:	e8 51 00 00 00       	call   80180e <vcprintf>
	cprintf("\n");
  8017bd:	c7 04 24 18 27 80 00 	movl   $0x802718,(%esp)
  8017c4:	e8 a6 00 00 00       	call   80186f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8017c9:	cc                   	int3   
  8017ca:	eb fd                	jmp    8017c9 <_panic+0x53>

008017cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	53                   	push   %ebx
  8017d0:	83 ec 14             	sub    $0x14,%esp
  8017d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8017d6:	8b 13                	mov    (%ebx),%edx
  8017d8:	8d 42 01             	lea    0x1(%edx),%eax
  8017db:	89 03                	mov    %eax,(%ebx)
  8017dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8017e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8017e9:	75 19                	jne    801804 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8017eb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8017f2:	00 
  8017f3:	8d 43 08             	lea    0x8(%ebx),%eax
  8017f6:	89 04 24             	mov    %eax,(%esp)
  8017f9:	e8 bd e8 ff ff       	call   8000bb <sys_cputs>
		b->idx = 0;
  8017fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801804:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801808:	83 c4 14             	add    $0x14,%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801817:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80181e:	00 00 00 
	b.cnt = 0;
  801821:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801828:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	89 44 24 08          	mov    %eax,0x8(%esp)
  801839:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80183f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801843:	c7 04 24 cc 17 80 00 	movl   $0x8017cc,(%esp)
  80184a:	e8 af 01 00 00       	call   8019fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80184f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801855:	89 44 24 04          	mov    %eax,0x4(%esp)
  801859:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80185f:	89 04 24             	mov    %eax,(%esp)
  801862:	e8 54 e8 ff ff       	call   8000bb <sys_cputs>

	return b.cnt;
}
  801867:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801875:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801878:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	89 04 24             	mov    %eax,(%esp)
  801882:	e8 87 ff ff ff       	call   80180e <vcprintf>
	va_end(ap);

	return cnt;
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    
  801889:	66 90                	xchg   %ax,%ax
  80188b:	66 90                	xchg   %ax,%ax
  80188d:	66 90                	xchg   %ax,%ax
  80188f:	90                   	nop

00801890 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	57                   	push   %edi
  801894:	56                   	push   %esi
  801895:	53                   	push   %ebx
  801896:	83 ec 3c             	sub    $0x3c,%esp
  801899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80189c:	89 d7                	mov    %edx,%edi
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a7:	89 c3                	mov    %eax,%ebx
  8018a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8018ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8018af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8018bd:	39 d9                	cmp    %ebx,%ecx
  8018bf:	72 05                	jb     8018c6 <printnum+0x36>
  8018c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8018c4:	77 69                	ja     80192f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8018c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8018cd:	83 ee 01             	sub    $0x1,%esi
  8018d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8018d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8018dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8018e0:	89 c3                	mov    %eax,%ebx
  8018e2:	89 d6                	mov    %edx,%esi
  8018e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8018ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8018f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f5:	89 04 24             	mov    %eax,(%esp)
  8018f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	e8 2c 0a 00 00       	call   802330 <__udivdi3>
  801904:	89 d9                	mov    %ebx,%ecx
  801906:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80190a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80190e:	89 04 24             	mov    %eax,(%esp)
  801911:	89 54 24 04          	mov    %edx,0x4(%esp)
  801915:	89 fa                	mov    %edi,%edx
  801917:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80191a:	e8 71 ff ff ff       	call   801890 <printnum>
  80191f:	eb 1b                	jmp    80193c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801921:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801925:	8b 45 18             	mov    0x18(%ebp),%eax
  801928:	89 04 24             	mov    %eax,(%esp)
  80192b:	ff d3                	call   *%ebx
  80192d:	eb 03                	jmp    801932 <printnum+0xa2>
  80192f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801932:	83 ee 01             	sub    $0x1,%esi
  801935:	85 f6                	test   %esi,%esi
  801937:	7f e8                	jg     801921 <printnum+0x91>
  801939:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80193c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801940:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801944:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801947:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80194a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80194e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801952:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801955:	89 04 24             	mov    %eax,(%esp)
  801958:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80195b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195f:	e8 fc 0a 00 00       	call   802460 <__umoddi3>
  801964:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801968:	0f be 80 4f 27 80 00 	movsbl 0x80274f(%eax),%eax
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801975:	ff d0                	call   *%eax
}
  801977:	83 c4 3c             	add    $0x3c,%esp
  80197a:	5b                   	pop    %ebx
  80197b:	5e                   	pop    %esi
  80197c:	5f                   	pop    %edi
  80197d:	5d                   	pop    %ebp
  80197e:	c3                   	ret    

0080197f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801982:	83 fa 01             	cmp    $0x1,%edx
  801985:	7e 0e                	jle    801995 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801987:	8b 10                	mov    (%eax),%edx
  801989:	8d 4a 08             	lea    0x8(%edx),%ecx
  80198c:	89 08                	mov    %ecx,(%eax)
  80198e:	8b 02                	mov    (%edx),%eax
  801990:	8b 52 04             	mov    0x4(%edx),%edx
  801993:	eb 22                	jmp    8019b7 <getuint+0x38>
	else if (lflag)
  801995:	85 d2                	test   %edx,%edx
  801997:	74 10                	je     8019a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801999:	8b 10                	mov    (%eax),%edx
  80199b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80199e:	89 08                	mov    %ecx,(%eax)
  8019a0:	8b 02                	mov    (%edx),%eax
  8019a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a7:	eb 0e                	jmp    8019b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8019a9:	8b 10                	mov    (%eax),%edx
  8019ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8019ae:	89 08                	mov    %ecx,(%eax)
  8019b0:	8b 02                	mov    (%edx),%eax
  8019b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    

008019b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
  8019bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8019bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8019c3:	8b 10                	mov    (%eax),%edx
  8019c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8019c8:	73 0a                	jae    8019d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8019ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019cd:	89 08                	mov    %ecx,(%eax)
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	88 02                	mov    %al,(%edx)
}
  8019d4:	5d                   	pop    %ebp
  8019d5:	c3                   	ret    

008019d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8019dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8019df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	89 04 24             	mov    %eax,(%esp)
  8019f7:	e8 02 00 00 00       	call   8019fe <vprintfmt>
	va_end(ap);
}
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
  801a01:	57                   	push   %edi
  801a02:	56                   	push   %esi
  801a03:	53                   	push   %ebx
  801a04:	83 ec 3c             	sub    $0x3c,%esp
  801a07:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a0d:	eb 14                	jmp    801a23 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	0f 84 b3 03 00 00    	je     801dca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801a17:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a1b:	89 04 24             	mov    %eax,(%esp)
  801a1e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a21:	89 f3                	mov    %esi,%ebx
  801a23:	8d 73 01             	lea    0x1(%ebx),%esi
  801a26:	0f b6 03             	movzbl (%ebx),%eax
  801a29:	83 f8 25             	cmp    $0x25,%eax
  801a2c:	75 e1                	jne    801a0f <vprintfmt+0x11>
  801a2e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801a32:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a39:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801a40:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801a47:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4c:	eb 1d                	jmp    801a6b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a4e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801a50:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801a54:	eb 15                	jmp    801a6b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a56:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a58:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801a5c:	eb 0d                	jmp    801a6b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801a5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a61:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a64:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a6b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801a6e:	0f b6 0e             	movzbl (%esi),%ecx
  801a71:	0f b6 c1             	movzbl %cl,%eax
  801a74:	83 e9 23             	sub    $0x23,%ecx
  801a77:	80 f9 55             	cmp    $0x55,%cl
  801a7a:	0f 87 2a 03 00 00    	ja     801daa <vprintfmt+0x3ac>
  801a80:	0f b6 c9             	movzbl %cl,%ecx
  801a83:	ff 24 8d a0 28 80 00 	jmp    *0x8028a0(,%ecx,4)
  801a8a:	89 de                	mov    %ebx,%esi
  801a8c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801a91:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801a94:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801a98:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801a9b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801a9e:	83 fb 09             	cmp    $0x9,%ebx
  801aa1:	77 36                	ja     801ad9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801aa3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801aa6:	eb e9                	jmp    801a91 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801aa8:	8b 45 14             	mov    0x14(%ebp),%eax
  801aab:	8d 48 04             	lea    0x4(%eax),%ecx
  801aae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801ab1:	8b 00                	mov    (%eax),%eax
  801ab3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ab6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801ab8:	eb 22                	jmp    801adc <vprintfmt+0xde>
  801aba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801abd:	85 c9                	test   %ecx,%ecx
  801abf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac4:	0f 49 c1             	cmovns %ecx,%eax
  801ac7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aca:	89 de                	mov    %ebx,%esi
  801acc:	eb 9d                	jmp    801a6b <vprintfmt+0x6d>
  801ace:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801ad0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801ad7:	eb 92                	jmp    801a6b <vprintfmt+0x6d>
  801ad9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801adc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801ae0:	79 89                	jns    801a6b <vprintfmt+0x6d>
  801ae2:	e9 77 ff ff ff       	jmp    801a5e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801ae7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801aec:	e9 7a ff ff ff       	jmp    801a6b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801af1:	8b 45 14             	mov    0x14(%ebp),%eax
  801af4:	8d 50 04             	lea    0x4(%eax),%edx
  801af7:	89 55 14             	mov    %edx,0x14(%ebp)
  801afa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801afe:	8b 00                	mov    (%eax),%eax
  801b00:	89 04 24             	mov    %eax,(%esp)
  801b03:	ff 55 08             	call   *0x8(%ebp)
			break;
  801b06:	e9 18 ff ff ff       	jmp    801a23 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b0e:	8d 50 04             	lea    0x4(%eax),%edx
  801b11:	89 55 14             	mov    %edx,0x14(%ebp)
  801b14:	8b 00                	mov    (%eax),%eax
  801b16:	99                   	cltd   
  801b17:	31 d0                	xor    %edx,%eax
  801b19:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b1b:	83 f8 0f             	cmp    $0xf,%eax
  801b1e:	7f 0b                	jg     801b2b <vprintfmt+0x12d>
  801b20:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  801b27:	85 d2                	test   %edx,%edx
  801b29:	75 20                	jne    801b4b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801b2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b2f:	c7 44 24 08 67 27 80 	movl   $0x802767,0x8(%esp)
  801b36:	00 
  801b37:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	89 04 24             	mov    %eax,(%esp)
  801b41:	e8 90 fe ff ff       	call   8019d6 <printfmt>
  801b46:	e9 d8 fe ff ff       	jmp    801a23 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801b4b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801b4f:	c7 44 24 08 ad 26 80 	movl   $0x8026ad,0x8(%esp)
  801b56:	00 
  801b57:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	89 04 24             	mov    %eax,(%esp)
  801b61:	e8 70 fe ff ff       	call   8019d6 <printfmt>
  801b66:	e9 b8 fe ff ff       	jmp    801a23 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b6b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801b6e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b71:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801b74:	8b 45 14             	mov    0x14(%ebp),%eax
  801b77:	8d 50 04             	lea    0x4(%eax),%edx
  801b7a:	89 55 14             	mov    %edx,0x14(%ebp)
  801b7d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801b7f:	85 f6                	test   %esi,%esi
  801b81:	b8 60 27 80 00       	mov    $0x802760,%eax
  801b86:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801b89:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801b8d:	0f 84 97 00 00 00    	je     801c2a <vprintfmt+0x22c>
  801b93:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801b97:	0f 8e 9b 00 00 00    	jle    801c38 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801b9d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ba1:	89 34 24             	mov    %esi,(%esp)
  801ba4:	e8 cf 02 00 00       	call   801e78 <strnlen>
  801ba9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801bac:	29 c2                	sub    %eax,%edx
  801bae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801bb1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801bb5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801bb8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801bbb:	8b 75 08             	mov    0x8(%ebp),%esi
  801bbe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801bc1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bc3:	eb 0f                	jmp    801bd4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801bc5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bc9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bcc:	89 04 24             	mov    %eax,(%esp)
  801bcf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bd1:	83 eb 01             	sub    $0x1,%ebx
  801bd4:	85 db                	test   %ebx,%ebx
  801bd6:	7f ed                	jg     801bc5 <vprintfmt+0x1c7>
  801bd8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801bdb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801bde:	85 d2                	test   %edx,%edx
  801be0:	b8 00 00 00 00       	mov    $0x0,%eax
  801be5:	0f 49 c2             	cmovns %edx,%eax
  801be8:	29 c2                	sub    %eax,%edx
  801bea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801bed:	89 d7                	mov    %edx,%edi
  801bef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801bf2:	eb 50                	jmp    801c44 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801bf4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801bf8:	74 1e                	je     801c18 <vprintfmt+0x21a>
  801bfa:	0f be d2             	movsbl %dl,%edx
  801bfd:	83 ea 20             	sub    $0x20,%edx
  801c00:	83 fa 5e             	cmp    $0x5e,%edx
  801c03:	76 13                	jbe    801c18 <vprintfmt+0x21a>
					putch('?', putdat);
  801c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801c13:	ff 55 08             	call   *0x8(%ebp)
  801c16:	eb 0d                	jmp    801c25 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c1f:	89 04 24             	mov    %eax,(%esp)
  801c22:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c25:	83 ef 01             	sub    $0x1,%edi
  801c28:	eb 1a                	jmp    801c44 <vprintfmt+0x246>
  801c2a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c2d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c30:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c33:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c36:	eb 0c                	jmp    801c44 <vprintfmt+0x246>
  801c38:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c3b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c3e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c41:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c44:	83 c6 01             	add    $0x1,%esi
  801c47:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801c4b:	0f be c2             	movsbl %dl,%eax
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	74 27                	je     801c79 <vprintfmt+0x27b>
  801c52:	85 db                	test   %ebx,%ebx
  801c54:	78 9e                	js     801bf4 <vprintfmt+0x1f6>
  801c56:	83 eb 01             	sub    $0x1,%ebx
  801c59:	79 99                	jns    801bf4 <vprintfmt+0x1f6>
  801c5b:	89 f8                	mov    %edi,%eax
  801c5d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c60:	8b 75 08             	mov    0x8(%ebp),%esi
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	eb 1a                	jmp    801c81 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801c67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c6b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801c72:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c74:	83 eb 01             	sub    $0x1,%ebx
  801c77:	eb 08                	jmp    801c81 <vprintfmt+0x283>
  801c79:	89 fb                	mov    %edi,%ebx
  801c7b:	8b 75 08             	mov    0x8(%ebp),%esi
  801c7e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c81:	85 db                	test   %ebx,%ebx
  801c83:	7f e2                	jg     801c67 <vprintfmt+0x269>
  801c85:	89 75 08             	mov    %esi,0x8(%ebp)
  801c88:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c8b:	e9 93 fd ff ff       	jmp    801a23 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801c90:	83 fa 01             	cmp    $0x1,%edx
  801c93:	7e 16                	jle    801cab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801c95:	8b 45 14             	mov    0x14(%ebp),%eax
  801c98:	8d 50 08             	lea    0x8(%eax),%edx
  801c9b:	89 55 14             	mov    %edx,0x14(%ebp)
  801c9e:	8b 50 04             	mov    0x4(%eax),%edx
  801ca1:	8b 00                	mov    (%eax),%eax
  801ca3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ca6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801ca9:	eb 32                	jmp    801cdd <vprintfmt+0x2df>
	else if (lflag)
  801cab:	85 d2                	test   %edx,%edx
  801cad:	74 18                	je     801cc7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801caf:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb2:	8d 50 04             	lea    0x4(%eax),%edx
  801cb5:	89 55 14             	mov    %edx,0x14(%ebp)
  801cb8:	8b 30                	mov    (%eax),%esi
  801cba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801cbd:	89 f0                	mov    %esi,%eax
  801cbf:	c1 f8 1f             	sar    $0x1f,%eax
  801cc2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cc5:	eb 16                	jmp    801cdd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801cc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cca:	8d 50 04             	lea    0x4(%eax),%edx
  801ccd:	89 55 14             	mov    %edx,0x14(%ebp)
  801cd0:	8b 30                	mov    (%eax),%esi
  801cd2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801cd5:	89 f0                	mov    %esi,%eax
  801cd7:	c1 f8 1f             	sar    $0x1f,%eax
  801cda:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801cdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ce0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801ce3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801ce8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801cec:	0f 89 80 00 00 00    	jns    801d72 <vprintfmt+0x374>
				putch('-', putdat);
  801cf2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cf6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801cfd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d03:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d06:	f7 d8                	neg    %eax
  801d08:	83 d2 00             	adc    $0x0,%edx
  801d0b:	f7 da                	neg    %edx
			}
			base = 10;
  801d0d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d12:	eb 5e                	jmp    801d72 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d14:	8d 45 14             	lea    0x14(%ebp),%eax
  801d17:	e8 63 fc ff ff       	call   80197f <getuint>
			base = 10;
  801d1c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801d21:	eb 4f                	jmp    801d72 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  801d23:	8d 45 14             	lea    0x14(%ebp),%eax
  801d26:	e8 54 fc ff ff       	call   80197f <getuint>
			base =8;
  801d2b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801d30:	eb 40                	jmp    801d72 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  801d32:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d36:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801d3d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801d40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d44:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801d4b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801d4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d51:	8d 50 04             	lea    0x4(%eax),%edx
  801d54:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d57:	8b 00                	mov    (%eax),%eax
  801d59:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801d5e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801d63:	eb 0d                	jmp    801d72 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d65:	8d 45 14             	lea    0x14(%ebp),%eax
  801d68:	e8 12 fc ff ff       	call   80197f <getuint>
			base = 16;
  801d6d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d72:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801d76:	89 74 24 10          	mov    %esi,0x10(%esp)
  801d7a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801d7d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d81:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d85:	89 04 24             	mov    %eax,(%esp)
  801d88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d8c:	89 fa                	mov    %edi,%edx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	e8 fa fa ff ff       	call   801890 <printnum>
			break;
  801d96:	e9 88 fc ff ff       	jmp    801a23 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801d9b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d9f:	89 04 24             	mov    %eax,(%esp)
  801da2:	ff 55 08             	call   *0x8(%ebp)
			break;
  801da5:	e9 79 fc ff ff       	jmp    801a23 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801daa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801db5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801db8:	89 f3                	mov    %esi,%ebx
  801dba:	eb 03                	jmp    801dbf <vprintfmt+0x3c1>
  801dbc:	83 eb 01             	sub    $0x1,%ebx
  801dbf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801dc3:	75 f7                	jne    801dbc <vprintfmt+0x3be>
  801dc5:	e9 59 fc ff ff       	jmp    801a23 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801dca:	83 c4 3c             	add    $0x3c,%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5e                   	pop    %esi
  801dcf:	5f                   	pop    %edi
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    

00801dd2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 28             	sub    $0x28,%esp
  801dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801dde:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801de1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801de5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801de8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801def:	85 c0                	test   %eax,%eax
  801df1:	74 30                	je     801e23 <vsnprintf+0x51>
  801df3:	85 d2                	test   %edx,%edx
  801df5:	7e 2c                	jle    801e23 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801df7:	8b 45 14             	mov    0x14(%ebp),%eax
  801dfa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  801e01:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0c:	c7 04 24 b9 19 80 00 	movl   $0x8019b9,(%esp)
  801e13:	e8 e6 fb ff ff       	call   8019fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801e18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e21:	eb 05                	jmp    801e28 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801e23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e30:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801e33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e37:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e45:	8b 45 08             	mov    0x8(%ebp),%eax
  801e48:	89 04 24             	mov    %eax,(%esp)
  801e4b:	e8 82 ff ff ff       	call   801dd2 <vsnprintf>
	va_end(ap);

	return rc;
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    
  801e52:	66 90                	xchg   %ax,%ax
  801e54:	66 90                	xchg   %ax,%ax
  801e56:	66 90                	xchg   %ax,%ax
  801e58:	66 90                	xchg   %ax,%ax
  801e5a:	66 90                	xchg   %ax,%ax
  801e5c:	66 90                	xchg   %ax,%ax
  801e5e:	66 90                	xchg   %ax,%ax

00801e60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801e66:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6b:	eb 03                	jmp    801e70 <strlen+0x10>
		n++;
  801e6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801e70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801e74:	75 f7                	jne    801e6d <strlen+0xd>
		n++;
	return n;
}
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    

00801e78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	eb 03                	jmp    801e8b <strnlen+0x13>
		n++;
  801e88:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801e8b:	39 d0                	cmp    %edx,%eax
  801e8d:	74 06                	je     801e95 <strnlen+0x1d>
  801e8f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801e93:	75 f3                	jne    801e88 <strnlen+0x10>
		n++;
	return n;
}
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	53                   	push   %ebx
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801ea1:	89 c2                	mov    %eax,%edx
  801ea3:	83 c2 01             	add    $0x1,%edx
  801ea6:	83 c1 01             	add    $0x1,%ecx
  801ea9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801ead:	88 5a ff             	mov    %bl,-0x1(%edx)
  801eb0:	84 db                	test   %bl,%bl
  801eb2:	75 ef                	jne    801ea3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801eb4:	5b                   	pop    %ebx
  801eb5:	5d                   	pop    %ebp
  801eb6:	c3                   	ret    

00801eb7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	53                   	push   %ebx
  801ebb:	83 ec 08             	sub    $0x8,%esp
  801ebe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ec1:	89 1c 24             	mov    %ebx,(%esp)
  801ec4:	e8 97 ff ff ff       	call   801e60 <strlen>
	strcpy(dst + len, src);
  801ec9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ed0:	01 d8                	add    %ebx,%eax
  801ed2:	89 04 24             	mov    %eax,(%esp)
  801ed5:	e8 bd ff ff ff       	call   801e97 <strcpy>
	return dst;
}
  801eda:	89 d8                	mov    %ebx,%eax
  801edc:	83 c4 08             	add    $0x8,%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5d                   	pop    %ebp
  801ee1:	c3                   	ret    

00801ee2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	56                   	push   %esi
  801ee6:	53                   	push   %ebx
  801ee7:	8b 75 08             	mov    0x8(%ebp),%esi
  801eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eed:	89 f3                	mov    %esi,%ebx
  801eef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801ef2:	89 f2                	mov    %esi,%edx
  801ef4:	eb 0f                	jmp    801f05 <strncpy+0x23>
		*dst++ = *src;
  801ef6:	83 c2 01             	add    $0x1,%edx
  801ef9:	0f b6 01             	movzbl (%ecx),%eax
  801efc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801eff:	80 39 01             	cmpb   $0x1,(%ecx)
  801f02:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f05:	39 da                	cmp    %ebx,%edx
  801f07:	75 ed                	jne    801ef6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801f09:	89 f0                	mov    %esi,%eax
  801f0b:	5b                   	pop    %ebx
  801f0c:	5e                   	pop    %esi
  801f0d:	5d                   	pop    %ebp
  801f0e:	c3                   	ret    

00801f0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	56                   	push   %esi
  801f13:	53                   	push   %ebx
  801f14:	8b 75 08             	mov    0x8(%ebp),%esi
  801f17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f1d:	89 f0                	mov    %esi,%eax
  801f1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801f23:	85 c9                	test   %ecx,%ecx
  801f25:	75 0b                	jne    801f32 <strlcpy+0x23>
  801f27:	eb 1d                	jmp    801f46 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801f29:	83 c0 01             	add    $0x1,%eax
  801f2c:	83 c2 01             	add    $0x1,%edx
  801f2f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801f32:	39 d8                	cmp    %ebx,%eax
  801f34:	74 0b                	je     801f41 <strlcpy+0x32>
  801f36:	0f b6 0a             	movzbl (%edx),%ecx
  801f39:	84 c9                	test   %cl,%cl
  801f3b:	75 ec                	jne    801f29 <strlcpy+0x1a>
  801f3d:	89 c2                	mov    %eax,%edx
  801f3f:	eb 02                	jmp    801f43 <strlcpy+0x34>
  801f41:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801f43:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801f46:	29 f0                	sub    %esi,%eax
}
  801f48:	5b                   	pop    %ebx
  801f49:	5e                   	pop    %esi
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    

00801f4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801f55:	eb 06                	jmp    801f5d <strcmp+0x11>
		p++, q++;
  801f57:	83 c1 01             	add    $0x1,%ecx
  801f5a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801f5d:	0f b6 01             	movzbl (%ecx),%eax
  801f60:	84 c0                	test   %al,%al
  801f62:	74 04                	je     801f68 <strcmp+0x1c>
  801f64:	3a 02                	cmp    (%edx),%al
  801f66:	74 ef                	je     801f57 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801f68:	0f b6 c0             	movzbl %al,%eax
  801f6b:	0f b6 12             	movzbl (%edx),%edx
  801f6e:	29 d0                	sub    %edx,%eax
}
  801f70:	5d                   	pop    %ebp
  801f71:	c3                   	ret    

00801f72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	53                   	push   %ebx
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7c:	89 c3                	mov    %eax,%ebx
  801f7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801f81:	eb 06                	jmp    801f89 <strncmp+0x17>
		n--, p++, q++;
  801f83:	83 c0 01             	add    $0x1,%eax
  801f86:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801f89:	39 d8                	cmp    %ebx,%eax
  801f8b:	74 15                	je     801fa2 <strncmp+0x30>
  801f8d:	0f b6 08             	movzbl (%eax),%ecx
  801f90:	84 c9                	test   %cl,%cl
  801f92:	74 04                	je     801f98 <strncmp+0x26>
  801f94:	3a 0a                	cmp    (%edx),%cl
  801f96:	74 eb                	je     801f83 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801f98:	0f b6 00             	movzbl (%eax),%eax
  801f9b:	0f b6 12             	movzbl (%edx),%edx
  801f9e:	29 d0                	sub    %edx,%eax
  801fa0:	eb 05                	jmp    801fa7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801fa2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801fa7:	5b                   	pop    %ebx
  801fa8:	5d                   	pop    %ebp
  801fa9:	c3                   	ret    

00801faa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801fb4:	eb 07                	jmp    801fbd <strchr+0x13>
		if (*s == c)
  801fb6:	38 ca                	cmp    %cl,%dl
  801fb8:	74 0f                	je     801fc9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801fba:	83 c0 01             	add    $0x1,%eax
  801fbd:	0f b6 10             	movzbl (%eax),%edx
  801fc0:	84 d2                	test   %dl,%dl
  801fc2:	75 f2                	jne    801fb6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801fc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    

00801fcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801fd5:	eb 07                	jmp    801fde <strfind+0x13>
		if (*s == c)
  801fd7:	38 ca                	cmp    %cl,%dl
  801fd9:	74 0a                	je     801fe5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801fdb:	83 c0 01             	add    $0x1,%eax
  801fde:	0f b6 10             	movzbl (%eax),%edx
  801fe1:	84 d2                	test   %dl,%dl
  801fe3:	75 f2                	jne    801fd7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  801fe5:	5d                   	pop    %ebp
  801fe6:	c3                   	ret    

00801fe7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
  801fea:	57                   	push   %edi
  801feb:	56                   	push   %esi
  801fec:	53                   	push   %ebx
  801fed:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ff0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ff3:	85 c9                	test   %ecx,%ecx
  801ff5:	74 36                	je     80202d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ff7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801ffd:	75 28                	jne    802027 <memset+0x40>
  801fff:	f6 c1 03             	test   $0x3,%cl
  802002:	75 23                	jne    802027 <memset+0x40>
		c &= 0xFF;
  802004:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802008:	89 d3                	mov    %edx,%ebx
  80200a:	c1 e3 08             	shl    $0x8,%ebx
  80200d:	89 d6                	mov    %edx,%esi
  80200f:	c1 e6 18             	shl    $0x18,%esi
  802012:	89 d0                	mov    %edx,%eax
  802014:	c1 e0 10             	shl    $0x10,%eax
  802017:	09 f0                	or     %esi,%eax
  802019:	09 c2                	or     %eax,%edx
  80201b:	89 d0                	mov    %edx,%eax
  80201d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80201f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802022:	fc                   	cld    
  802023:	f3 ab                	rep stos %eax,%es:(%edi)
  802025:	eb 06                	jmp    80202d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202a:	fc                   	cld    
  80202b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80202d:	89 f8                	mov    %edi,%eax
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    

00802034 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	57                   	push   %edi
  802038:	56                   	push   %esi
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80203f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802042:	39 c6                	cmp    %eax,%esi
  802044:	73 35                	jae    80207b <memmove+0x47>
  802046:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802049:	39 d0                	cmp    %edx,%eax
  80204b:	73 2e                	jae    80207b <memmove+0x47>
		s += n;
		d += n;
  80204d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802050:	89 d6                	mov    %edx,%esi
  802052:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802054:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80205a:	75 13                	jne    80206f <memmove+0x3b>
  80205c:	f6 c1 03             	test   $0x3,%cl
  80205f:	75 0e                	jne    80206f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802061:	83 ef 04             	sub    $0x4,%edi
  802064:	8d 72 fc             	lea    -0x4(%edx),%esi
  802067:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80206a:	fd                   	std    
  80206b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80206d:	eb 09                	jmp    802078 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80206f:	83 ef 01             	sub    $0x1,%edi
  802072:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802075:	fd                   	std    
  802076:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802078:	fc                   	cld    
  802079:	eb 1d                	jmp    802098 <memmove+0x64>
  80207b:	89 f2                	mov    %esi,%edx
  80207d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80207f:	f6 c2 03             	test   $0x3,%dl
  802082:	75 0f                	jne    802093 <memmove+0x5f>
  802084:	f6 c1 03             	test   $0x3,%cl
  802087:	75 0a                	jne    802093 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  802089:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80208c:	89 c7                	mov    %eax,%edi
  80208e:	fc                   	cld    
  80208f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802091:	eb 05                	jmp    802098 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802093:	89 c7                	mov    %eax,%edi
  802095:	fc                   	cld    
  802096:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802098:	5e                   	pop    %esi
  802099:	5f                   	pop    %edi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    

0080209c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80209c:	55                   	push   %ebp
  80209d:	89 e5                	mov    %esp,%ebp
  80209f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8020a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	89 04 24             	mov    %eax,(%esp)
  8020b6:	e8 79 ff ff ff       	call   802034 <memmove>
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	56                   	push   %esi
  8020c1:	53                   	push   %ebx
  8020c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020c8:	89 d6                	mov    %edx,%esi
  8020ca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8020cd:	eb 1a                	jmp    8020e9 <memcmp+0x2c>
		if (*s1 != *s2)
  8020cf:	0f b6 02             	movzbl (%edx),%eax
  8020d2:	0f b6 19             	movzbl (%ecx),%ebx
  8020d5:	38 d8                	cmp    %bl,%al
  8020d7:	74 0a                	je     8020e3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8020d9:	0f b6 c0             	movzbl %al,%eax
  8020dc:	0f b6 db             	movzbl %bl,%ebx
  8020df:	29 d8                	sub    %ebx,%eax
  8020e1:	eb 0f                	jmp    8020f2 <memcmp+0x35>
		s1++, s2++;
  8020e3:	83 c2 01             	add    $0x1,%edx
  8020e6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8020e9:	39 f2                	cmp    %esi,%edx
  8020eb:	75 e2                	jne    8020cf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8020ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f2:	5b                   	pop    %ebx
  8020f3:	5e                   	pop    %esi
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    

008020f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8020ff:	89 c2                	mov    %eax,%edx
  802101:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802104:	eb 07                	jmp    80210d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802106:	38 08                	cmp    %cl,(%eax)
  802108:	74 07                	je     802111 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80210a:	83 c0 01             	add    $0x1,%eax
  80210d:	39 d0                	cmp    %edx,%eax
  80210f:	72 f5                	jb     802106 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802111:	5d                   	pop    %ebp
  802112:	c3                   	ret    

00802113 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	57                   	push   %edi
  802117:	56                   	push   %esi
  802118:	53                   	push   %ebx
  802119:	8b 55 08             	mov    0x8(%ebp),%edx
  80211c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80211f:	eb 03                	jmp    802124 <strtol+0x11>
		s++;
  802121:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802124:	0f b6 0a             	movzbl (%edx),%ecx
  802127:	80 f9 09             	cmp    $0x9,%cl
  80212a:	74 f5                	je     802121 <strtol+0xe>
  80212c:	80 f9 20             	cmp    $0x20,%cl
  80212f:	74 f0                	je     802121 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802131:	80 f9 2b             	cmp    $0x2b,%cl
  802134:	75 0a                	jne    802140 <strtol+0x2d>
		s++;
  802136:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802139:	bf 00 00 00 00       	mov    $0x0,%edi
  80213e:	eb 11                	jmp    802151 <strtol+0x3e>
  802140:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802145:	80 f9 2d             	cmp    $0x2d,%cl
  802148:	75 07                	jne    802151 <strtol+0x3e>
		s++, neg = 1;
  80214a:	8d 52 01             	lea    0x1(%edx),%edx
  80214d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802151:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802156:	75 15                	jne    80216d <strtol+0x5a>
  802158:	80 3a 30             	cmpb   $0x30,(%edx)
  80215b:	75 10                	jne    80216d <strtol+0x5a>
  80215d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802161:	75 0a                	jne    80216d <strtol+0x5a>
		s += 2, base = 16;
  802163:	83 c2 02             	add    $0x2,%edx
  802166:	b8 10 00 00 00       	mov    $0x10,%eax
  80216b:	eb 10                	jmp    80217d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 0c                	jne    80217d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  802171:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802173:	80 3a 30             	cmpb   $0x30,(%edx)
  802176:	75 05                	jne    80217d <strtol+0x6a>
		s++, base = 8;
  802178:	83 c2 01             	add    $0x1,%edx
  80217b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  80217d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802182:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802185:	0f b6 0a             	movzbl (%edx),%ecx
  802188:	8d 71 d0             	lea    -0x30(%ecx),%esi
  80218b:	89 f0                	mov    %esi,%eax
  80218d:	3c 09                	cmp    $0x9,%al
  80218f:	77 08                	ja     802199 <strtol+0x86>
			dig = *s - '0';
  802191:	0f be c9             	movsbl %cl,%ecx
  802194:	83 e9 30             	sub    $0x30,%ecx
  802197:	eb 20                	jmp    8021b9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  802199:	8d 71 9f             	lea    -0x61(%ecx),%esi
  80219c:	89 f0                	mov    %esi,%eax
  80219e:	3c 19                	cmp    $0x19,%al
  8021a0:	77 08                	ja     8021aa <strtol+0x97>
			dig = *s - 'a' + 10;
  8021a2:	0f be c9             	movsbl %cl,%ecx
  8021a5:	83 e9 57             	sub    $0x57,%ecx
  8021a8:	eb 0f                	jmp    8021b9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8021aa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8021ad:	89 f0                	mov    %esi,%eax
  8021af:	3c 19                	cmp    $0x19,%al
  8021b1:	77 16                	ja     8021c9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8021b3:	0f be c9             	movsbl %cl,%ecx
  8021b6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8021b9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8021bc:	7d 0f                	jge    8021cd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8021be:	83 c2 01             	add    $0x1,%edx
  8021c1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8021c5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8021c7:	eb bc                	jmp    802185 <strtol+0x72>
  8021c9:	89 d8                	mov    %ebx,%eax
  8021cb:	eb 02                	jmp    8021cf <strtol+0xbc>
  8021cd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8021cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021d3:	74 05                	je     8021da <strtol+0xc7>
		*endptr = (char *) s;
  8021d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021d8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8021da:	f7 d8                	neg    %eax
  8021dc:	85 ff                	test   %edi,%edi
  8021de:	0f 44 c3             	cmove  %ebx,%eax
}
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5f                   	pop    %edi
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    

008021e6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	56                   	push   %esi
  8021ea:	53                   	push   %ebx
  8021eb:	83 ec 10             	sub    $0x10,%esp
  8021ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8021f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8021f7:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8021f9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8021fe:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802201:	89 04 24             	mov    %eax,(%esp)
  802204:	e8 95 e1 ff ff       	call   80039e <sys_ipc_recv>
  802209:	85 c0                	test   %eax,%eax
  80220b:	75 1e                	jne    80222b <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  80220d:	85 db                	test   %ebx,%ebx
  80220f:	74 0a                	je     80221b <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802211:	a1 08 40 80 00       	mov    0x804008,%eax
  802216:	8b 40 74             	mov    0x74(%eax),%eax
  802219:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80221b:	85 f6                	test   %esi,%esi
  80221d:	74 22                	je     802241 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  80221f:	a1 08 40 80 00       	mov    0x804008,%eax
  802224:	8b 40 78             	mov    0x78(%eax),%eax
  802227:	89 06                	mov    %eax,(%esi)
  802229:	eb 16                	jmp    802241 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80222b:	85 f6                	test   %esi,%esi
  80222d:	74 06                	je     802235 <ipc_recv+0x4f>
				*perm_store = 0;
  80222f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  802235:	85 db                	test   %ebx,%ebx
  802237:	74 10                	je     802249 <ipc_recv+0x63>
				*from_env_store=0;
  802239:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80223f:	eb 08                	jmp    802249 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802241:	a1 08 40 80 00       	mov    0x804008,%eax
  802246:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802249:	83 c4 10             	add    $0x10,%esp
  80224c:	5b                   	pop    %ebx
  80224d:	5e                   	pop    %esi
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    

00802250 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	57                   	push   %edi
  802254:	56                   	push   %esi
  802255:	53                   	push   %ebx
  802256:	83 ec 1c             	sub    $0x1c,%esp
  802259:	8b 75 0c             	mov    0xc(%ebp),%esi
  80225c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80225f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802262:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802264:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802269:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80226c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802270:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802274:	89 74 24 04          	mov    %esi,0x4(%esp)
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	89 04 24             	mov    %eax,(%esp)
  80227e:	e8 f8 e0 ff ff       	call   80037b <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802283:	eb 1c                	jmp    8022a1 <ipc_send+0x51>
	{
		sys_yield();
  802285:	e8 df de ff ff       	call   800169 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80228a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80228e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802292:	89 74 24 04          	mov    %esi,0x4(%esp)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	89 04 24             	mov    %eax,(%esp)
  80229c:	e8 da e0 ff ff       	call   80037b <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8022a1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022a4:	74 df                	je     802285 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8022a6:	83 c4 1c             	add    $0x1c,%esp
  8022a9:	5b                   	pop    %ebx
  8022aa:	5e                   	pop    %esi
  8022ab:	5f                   	pop    %edi
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    

008022ae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022b4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b9:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8022bc:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022c2:	8b 52 50             	mov    0x50(%edx),%edx
  8022c5:	39 ca                	cmp    %ecx,%edx
  8022c7:	75 0d                	jne    8022d6 <ipc_find_env+0x28>
			return envs[i].env_id;
  8022c9:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8022cc:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8022d1:	8b 40 40             	mov    0x40(%eax),%eax
  8022d4:	eb 0e                	jmp    8022e4 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8022d6:	83 c0 01             	add    $0x1,%eax
  8022d9:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022de:	75 d9                	jne    8022b9 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8022e0:	66 b8 00 00          	mov    $0x0,%ax
}
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    

008022e6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022ec:	89 d0                	mov    %edx,%eax
  8022ee:	c1 e8 16             	shr    $0x16,%eax
  8022f1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022f8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022fd:	f6 c1 01             	test   $0x1,%cl
  802300:	74 1d                	je     80231f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802302:	c1 ea 0c             	shr    $0xc,%edx
  802305:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80230c:	f6 c2 01             	test   $0x1,%dl
  80230f:	74 0e                	je     80231f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802311:	c1 ea 0c             	shr    $0xc,%edx
  802314:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80231b:	ef 
  80231c:	0f b7 c0             	movzwl %ax,%eax
}
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	66 90                	xchg   %ax,%ax
  802323:	66 90                	xchg   %ax,%ax
  802325:	66 90                	xchg   %ax,%ax
  802327:	66 90                	xchg   %ax,%ax
  802329:	66 90                	xchg   %ax,%ax
  80232b:	66 90                	xchg   %ax,%ax
  80232d:	66 90                	xchg   %ax,%ax
  80232f:	90                   	nop

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	83 ec 0c             	sub    $0xc,%esp
  802336:	8b 44 24 28          	mov    0x28(%esp),%eax
  80233a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80233e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802342:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802346:	85 c0                	test   %eax,%eax
  802348:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80234c:	89 ea                	mov    %ebp,%edx
  80234e:	89 0c 24             	mov    %ecx,(%esp)
  802351:	75 2d                	jne    802380 <__udivdi3+0x50>
  802353:	39 e9                	cmp    %ebp,%ecx
  802355:	77 61                	ja     8023b8 <__udivdi3+0x88>
  802357:	85 c9                	test   %ecx,%ecx
  802359:	89 ce                	mov    %ecx,%esi
  80235b:	75 0b                	jne    802368 <__udivdi3+0x38>
  80235d:	b8 01 00 00 00       	mov    $0x1,%eax
  802362:	31 d2                	xor    %edx,%edx
  802364:	f7 f1                	div    %ecx
  802366:	89 c6                	mov    %eax,%esi
  802368:	31 d2                	xor    %edx,%edx
  80236a:	89 e8                	mov    %ebp,%eax
  80236c:	f7 f6                	div    %esi
  80236e:	89 c5                	mov    %eax,%ebp
  802370:	89 f8                	mov    %edi,%eax
  802372:	f7 f6                	div    %esi
  802374:	89 ea                	mov    %ebp,%edx
  802376:	83 c4 0c             	add    $0xc,%esp
  802379:	5e                   	pop    %esi
  80237a:	5f                   	pop    %edi
  80237b:	5d                   	pop    %ebp
  80237c:	c3                   	ret    
  80237d:	8d 76 00             	lea    0x0(%esi),%esi
  802380:	39 e8                	cmp    %ebp,%eax
  802382:	77 24                	ja     8023a8 <__udivdi3+0x78>
  802384:	0f bd e8             	bsr    %eax,%ebp
  802387:	83 f5 1f             	xor    $0x1f,%ebp
  80238a:	75 3c                	jne    8023c8 <__udivdi3+0x98>
  80238c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802390:	39 34 24             	cmp    %esi,(%esp)
  802393:	0f 86 9f 00 00 00    	jbe    802438 <__udivdi3+0x108>
  802399:	39 d0                	cmp    %edx,%eax
  80239b:	0f 82 97 00 00 00    	jb     802438 <__udivdi3+0x108>
  8023a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023a8:	31 d2                	xor    %edx,%edx
  8023aa:	31 c0                	xor    %eax,%eax
  8023ac:	83 c4 0c             	add    $0xc,%esp
  8023af:	5e                   	pop    %esi
  8023b0:	5f                   	pop    %edi
  8023b1:	5d                   	pop    %ebp
  8023b2:	c3                   	ret    
  8023b3:	90                   	nop
  8023b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	89 f8                	mov    %edi,%eax
  8023ba:	f7 f1                	div    %ecx
  8023bc:	31 d2                	xor    %edx,%edx
  8023be:	83 c4 0c             	add    $0xc,%esp
  8023c1:	5e                   	pop    %esi
  8023c2:	5f                   	pop    %edi
  8023c3:	5d                   	pop    %ebp
  8023c4:	c3                   	ret    
  8023c5:	8d 76 00             	lea    0x0(%esi),%esi
  8023c8:	89 e9                	mov    %ebp,%ecx
  8023ca:	8b 3c 24             	mov    (%esp),%edi
  8023cd:	d3 e0                	shl    %cl,%eax
  8023cf:	89 c6                	mov    %eax,%esi
  8023d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d6:	29 e8                	sub    %ebp,%eax
  8023d8:	89 c1                	mov    %eax,%ecx
  8023da:	d3 ef                	shr    %cl,%edi
  8023dc:	89 e9                	mov    %ebp,%ecx
  8023de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8023e2:	8b 3c 24             	mov    (%esp),%edi
  8023e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8023e9:	89 d6                	mov    %edx,%esi
  8023eb:	d3 e7                	shl    %cl,%edi
  8023ed:	89 c1                	mov    %eax,%ecx
  8023ef:	89 3c 24             	mov    %edi,(%esp)
  8023f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8023f6:	d3 ee                	shr    %cl,%esi
  8023f8:	89 e9                	mov    %ebp,%ecx
  8023fa:	d3 e2                	shl    %cl,%edx
  8023fc:	89 c1                	mov    %eax,%ecx
  8023fe:	d3 ef                	shr    %cl,%edi
  802400:	09 d7                	or     %edx,%edi
  802402:	89 f2                	mov    %esi,%edx
  802404:	89 f8                	mov    %edi,%eax
  802406:	f7 74 24 08          	divl   0x8(%esp)
  80240a:	89 d6                	mov    %edx,%esi
  80240c:	89 c7                	mov    %eax,%edi
  80240e:	f7 24 24             	mull   (%esp)
  802411:	39 d6                	cmp    %edx,%esi
  802413:	89 14 24             	mov    %edx,(%esp)
  802416:	72 30                	jb     802448 <__udivdi3+0x118>
  802418:	8b 54 24 04          	mov    0x4(%esp),%edx
  80241c:	89 e9                	mov    %ebp,%ecx
  80241e:	d3 e2                	shl    %cl,%edx
  802420:	39 c2                	cmp    %eax,%edx
  802422:	73 05                	jae    802429 <__udivdi3+0xf9>
  802424:	3b 34 24             	cmp    (%esp),%esi
  802427:	74 1f                	je     802448 <__udivdi3+0x118>
  802429:	89 f8                	mov    %edi,%eax
  80242b:	31 d2                	xor    %edx,%edx
  80242d:	e9 7a ff ff ff       	jmp    8023ac <__udivdi3+0x7c>
  802432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802438:	31 d2                	xor    %edx,%edx
  80243a:	b8 01 00 00 00       	mov    $0x1,%eax
  80243f:	e9 68 ff ff ff       	jmp    8023ac <__udivdi3+0x7c>
  802444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802448:	8d 47 ff             	lea    -0x1(%edi),%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	83 c4 0c             	add    $0xc,%esp
  802450:	5e                   	pop    %esi
  802451:	5f                   	pop    %edi
  802452:	5d                   	pop    %ebp
  802453:	c3                   	ret    
  802454:	66 90                	xchg   %ax,%ax
  802456:	66 90                	xchg   %ax,%ax
  802458:	66 90                	xchg   %ax,%ax
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	83 ec 14             	sub    $0x14,%esp
  802466:	8b 44 24 28          	mov    0x28(%esp),%eax
  80246a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80246e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802472:	89 c7                	mov    %eax,%edi
  802474:	89 44 24 04          	mov    %eax,0x4(%esp)
  802478:	8b 44 24 30          	mov    0x30(%esp),%eax
  80247c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802480:	89 34 24             	mov    %esi,(%esp)
  802483:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802487:	85 c0                	test   %eax,%eax
  802489:	89 c2                	mov    %eax,%edx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	75 17                	jne    8024a8 <__umoddi3+0x48>
  802491:	39 fe                	cmp    %edi,%esi
  802493:	76 4b                	jbe    8024e0 <__umoddi3+0x80>
  802495:	89 c8                	mov    %ecx,%eax
  802497:	89 fa                	mov    %edi,%edx
  802499:	f7 f6                	div    %esi
  80249b:	89 d0                	mov    %edx,%eax
  80249d:	31 d2                	xor    %edx,%edx
  80249f:	83 c4 14             	add    $0x14,%esp
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    
  8024a6:	66 90                	xchg   %ax,%ax
  8024a8:	39 f8                	cmp    %edi,%eax
  8024aa:	77 54                	ja     802500 <__umoddi3+0xa0>
  8024ac:	0f bd e8             	bsr    %eax,%ebp
  8024af:	83 f5 1f             	xor    $0x1f,%ebp
  8024b2:	75 5c                	jne    802510 <__umoddi3+0xb0>
  8024b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8024b8:	39 3c 24             	cmp    %edi,(%esp)
  8024bb:	0f 87 e7 00 00 00    	ja     8025a8 <__umoddi3+0x148>
  8024c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024c5:	29 f1                	sub    %esi,%ecx
  8024c7:	19 c7                	sbb    %eax,%edi
  8024c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8024d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8024d9:	83 c4 14             	add    $0x14,%esp
  8024dc:	5e                   	pop    %esi
  8024dd:	5f                   	pop    %edi
  8024de:	5d                   	pop    %ebp
  8024df:	c3                   	ret    
  8024e0:	85 f6                	test   %esi,%esi
  8024e2:	89 f5                	mov    %esi,%ebp
  8024e4:	75 0b                	jne    8024f1 <__umoddi3+0x91>
  8024e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	f7 f6                	div    %esi
  8024ef:	89 c5                	mov    %eax,%ebp
  8024f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024f5:	31 d2                	xor    %edx,%edx
  8024f7:	f7 f5                	div    %ebp
  8024f9:	89 c8                	mov    %ecx,%eax
  8024fb:	f7 f5                	div    %ebp
  8024fd:	eb 9c                	jmp    80249b <__umoddi3+0x3b>
  8024ff:	90                   	nop
  802500:	89 c8                	mov    %ecx,%eax
  802502:	89 fa                	mov    %edi,%edx
  802504:	83 c4 14             	add    $0x14,%esp
  802507:	5e                   	pop    %esi
  802508:	5f                   	pop    %edi
  802509:	5d                   	pop    %ebp
  80250a:	c3                   	ret    
  80250b:	90                   	nop
  80250c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802510:	8b 04 24             	mov    (%esp),%eax
  802513:	be 20 00 00 00       	mov    $0x20,%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	29 ee                	sub    %ebp,%esi
  80251c:	d3 e2                	shl    %cl,%edx
  80251e:	89 f1                	mov    %esi,%ecx
  802520:	d3 e8                	shr    %cl,%eax
  802522:	89 e9                	mov    %ebp,%ecx
  802524:	89 44 24 04          	mov    %eax,0x4(%esp)
  802528:	8b 04 24             	mov    (%esp),%eax
  80252b:	09 54 24 04          	or     %edx,0x4(%esp)
  80252f:	89 fa                	mov    %edi,%edx
  802531:	d3 e0                	shl    %cl,%eax
  802533:	89 f1                	mov    %esi,%ecx
  802535:	89 44 24 08          	mov    %eax,0x8(%esp)
  802539:	8b 44 24 10          	mov    0x10(%esp),%eax
  80253d:	d3 ea                	shr    %cl,%edx
  80253f:	89 e9                	mov    %ebp,%ecx
  802541:	d3 e7                	shl    %cl,%edi
  802543:	89 f1                	mov    %esi,%ecx
  802545:	d3 e8                	shr    %cl,%eax
  802547:	89 e9                	mov    %ebp,%ecx
  802549:	09 f8                	or     %edi,%eax
  80254b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80254f:	f7 74 24 04          	divl   0x4(%esp)
  802553:	d3 e7                	shl    %cl,%edi
  802555:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802559:	89 d7                	mov    %edx,%edi
  80255b:	f7 64 24 08          	mull   0x8(%esp)
  80255f:	39 d7                	cmp    %edx,%edi
  802561:	89 c1                	mov    %eax,%ecx
  802563:	89 14 24             	mov    %edx,(%esp)
  802566:	72 2c                	jb     802594 <__umoddi3+0x134>
  802568:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80256c:	72 22                	jb     802590 <__umoddi3+0x130>
  80256e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802572:	29 c8                	sub    %ecx,%eax
  802574:	19 d7                	sbb    %edx,%edi
  802576:	89 e9                	mov    %ebp,%ecx
  802578:	89 fa                	mov    %edi,%edx
  80257a:	d3 e8                	shr    %cl,%eax
  80257c:	89 f1                	mov    %esi,%ecx
  80257e:	d3 e2                	shl    %cl,%edx
  802580:	89 e9                	mov    %ebp,%ecx
  802582:	d3 ef                	shr    %cl,%edi
  802584:	09 d0                	or     %edx,%eax
  802586:	89 fa                	mov    %edi,%edx
  802588:	83 c4 14             	add    $0x14,%esp
  80258b:	5e                   	pop    %esi
  80258c:	5f                   	pop    %edi
  80258d:	5d                   	pop    %ebp
  80258e:	c3                   	ret    
  80258f:	90                   	nop
  802590:	39 d7                	cmp    %edx,%edi
  802592:	75 da                	jne    80256e <__umoddi3+0x10e>
  802594:	8b 14 24             	mov    (%esp),%edx
  802597:	89 c1                	mov    %eax,%ecx
  802599:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80259d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8025a1:	eb cb                	jmp    80256e <__umoddi3+0x10e>
  8025a3:	90                   	nop
  8025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8025ac:	0f 82 0f ff ff ff    	jb     8024c1 <__umoddi3+0x61>
  8025b2:	e9 1a ff ff ff       	jmp    8024d1 <__umoddi3+0x71>
