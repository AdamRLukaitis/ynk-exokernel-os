
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 28 00 00 00       	call   800059 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	c7 44 24 04 be 04 80 	movl   $0x8004be,0x4(%esp)
  800040:	00 
  800041:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800048:	e8 e4 02 00 00       	call   800331 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80004d:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800054:	00 00 00 
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	56                   	push   %esi
  80005d:	53                   	push   %ebx
  80005e:	83 ec 10             	sub    $0x10,%esp
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800067:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80006e:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800071:	e8 dd 00 00 00       	call   800153 <sys_getenvid>
  800076:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80007b:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80007e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800083:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800088:	85 db                	test   %ebx,%ebx
  80008a:	7e 07                	jle    800093 <libmain+0x3a>
		binaryname = argv[0];
  80008c:	8b 06                	mov    (%esi),%eax
  80008e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800093:	89 74 24 04          	mov    %esi,0x4(%esp)
  800097:	89 1c 24             	mov    %ebx,(%esp)
  80009a:	e8 94 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009f:	e8 07 00 00 00       	call   8000ab <exit>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	5b                   	pop    %ebx
  8000a8:	5e                   	pop    %esi
  8000a9:	5d                   	pop    %ebp
  8000aa:	c3                   	ret    

008000ab <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ab:	55                   	push   %ebp
  8000ac:	89 e5                	mov    %esp,%ebp
  8000ae:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000b1:	e8 14 06 00 00       	call   8006ca <close_all>
	sys_env_destroy(0);
  8000b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000bd:	e8 3f 00 00 00       	call   800101 <sys_env_destroy>
}
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	57                   	push   %edi
  8000c8:	56                   	push   %esi
  8000c9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8000cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8000d5:	89 c3                	mov    %eax,%ebx
  8000d7:	89 c7                	mov    %eax,%edi
  8000d9:	89 c6                	mov    %eax,%esi
  8000db:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000dd:	5b                   	pop    %ebx
  8000de:	5e                   	pop    %esi
  8000df:	5f                   	pop    %edi
  8000e0:	5d                   	pop    %ebp
  8000e1:	c3                   	ret    

008000e2 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	57                   	push   %edi
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f2:	89 d1                	mov    %edx,%ecx
  8000f4:	89 d3                	mov    %edx,%ebx
  8000f6:	89 d7                	mov    %edx,%edi
  8000f8:	89 d6                	mov    %edx,%esi
  8000fa:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000fc:	5b                   	pop    %ebx
  8000fd:	5e                   	pop    %esi
  8000fe:	5f                   	pop    %edi
  8000ff:	5d                   	pop    %ebp
  800100:	c3                   	ret    

00800101 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	57                   	push   %edi
  800105:	56                   	push   %esi
  800106:	53                   	push   %ebx
  800107:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80010a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80010f:	b8 03 00 00 00       	mov    $0x3,%eax
  800114:	8b 55 08             	mov    0x8(%ebp),%edx
  800117:	89 cb                	mov    %ecx,%ebx
  800119:	89 cf                	mov    %ecx,%edi
  80011b:	89 ce                	mov    %ecx,%esi
  80011d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80011f:	85 c0                	test   %eax,%eax
  800121:	7e 28                	jle    80014b <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800123:	89 44 24 10          	mov    %eax,0x10(%esp)
  800127:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80012e:	00 
  80012f:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  800136:	00 
  800137:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80013e:	00 
  80013f:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  800146:	e8 5b 16 00 00       	call   8017a6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80014b:	83 c4 2c             	add    $0x2c,%esp
  80014e:	5b                   	pop    %ebx
  80014f:	5e                   	pop    %esi
  800150:	5f                   	pop    %edi
  800151:	5d                   	pop    %ebp
  800152:	c3                   	ret    

00800153 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800153:	55                   	push   %ebp
  800154:	89 e5                	mov    %esp,%ebp
  800156:	57                   	push   %edi
  800157:	56                   	push   %esi
  800158:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800159:	ba 00 00 00 00       	mov    $0x0,%edx
  80015e:	b8 02 00 00 00       	mov    $0x2,%eax
  800163:	89 d1                	mov    %edx,%ecx
  800165:	89 d3                	mov    %edx,%ebx
  800167:	89 d7                	mov    %edx,%edi
  800169:	89 d6                	mov    %edx,%esi
  80016b:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80016d:	5b                   	pop    %ebx
  80016e:	5e                   	pop    %esi
  80016f:	5f                   	pop    %edi
  800170:	5d                   	pop    %ebp
  800171:	c3                   	ret    

00800172 <sys_yield>:

void
sys_yield(void)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	57                   	push   %edi
  800176:	56                   	push   %esi
  800177:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800178:	ba 00 00 00 00       	mov    $0x0,%edx
  80017d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800182:	89 d1                	mov    %edx,%ecx
  800184:	89 d3                	mov    %edx,%ebx
  800186:	89 d7                	mov    %edx,%edi
  800188:	89 d6                	mov    %edx,%esi
  80018a:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80018c:	5b                   	pop    %ebx
  80018d:	5e                   	pop    %esi
  80018e:	5f                   	pop    %edi
  80018f:	5d                   	pop    %ebp
  800190:	c3                   	ret    

00800191 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	57                   	push   %edi
  800195:	56                   	push   %esi
  800196:	53                   	push   %ebx
  800197:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80019a:	be 00 00 00 00       	mov    $0x0,%esi
  80019f:	b8 04 00 00 00       	mov    $0x4,%eax
  8001a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ad:	89 f7                	mov    %esi,%edi
  8001af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001b1:	85 c0                	test   %eax,%eax
  8001b3:	7e 28                	jle    8001dd <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001b9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001c0:	00 
  8001c1:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  8001c8:	00 
  8001c9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8001d0:	00 
  8001d1:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  8001d8:	e8 c9 15 00 00       	call   8017a6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001dd:	83 c4 2c             	add    $0x2c,%esp
  8001e0:	5b                   	pop    %ebx
  8001e1:	5e                   	pop    %esi
  8001e2:	5f                   	pop    %edi
  8001e3:	5d                   	pop    %ebp
  8001e4:	c3                   	ret    

008001e5 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	57                   	push   %edi
  8001e9:	56                   	push   %esi
  8001ea:	53                   	push   %ebx
  8001eb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001ee:	b8 05 00 00 00       	mov    $0x5,%eax
  8001f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001ff:	8b 75 18             	mov    0x18(%ebp),%esi
  800202:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800204:	85 c0                	test   %eax,%eax
  800206:	7e 28                	jle    800230 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800208:	89 44 24 10          	mov    %eax,0x10(%esp)
  80020c:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800213:	00 
  800214:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  80021b:	00 
  80021c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800223:	00 
  800224:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  80022b:	e8 76 15 00 00       	call   8017a6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800230:	83 c4 2c             	add    $0x2c,%esp
  800233:	5b                   	pop    %ebx
  800234:	5e                   	pop    %esi
  800235:	5f                   	pop    %edi
  800236:	5d                   	pop    %ebp
  800237:	c3                   	ret    

00800238 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	57                   	push   %edi
  80023c:	56                   	push   %esi
  80023d:	53                   	push   %ebx
  80023e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800241:	bb 00 00 00 00       	mov    $0x0,%ebx
  800246:	b8 06 00 00 00       	mov    $0x6,%eax
  80024b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80024e:	8b 55 08             	mov    0x8(%ebp),%edx
  800251:	89 df                	mov    %ebx,%edi
  800253:	89 de                	mov    %ebx,%esi
  800255:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800257:	85 c0                	test   %eax,%eax
  800259:	7e 28                	jle    800283 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80025b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80025f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800266:	00 
  800267:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  80026e:	00 
  80026f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800276:	00 
  800277:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  80027e:	e8 23 15 00 00       	call   8017a6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800283:	83 c4 2c             	add    $0x2c,%esp
  800286:	5b                   	pop    %ebx
  800287:	5e                   	pop    %esi
  800288:	5f                   	pop    %edi
  800289:	5d                   	pop    %ebp
  80028a:	c3                   	ret    

0080028b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	57                   	push   %edi
  80028f:	56                   	push   %esi
  800290:	53                   	push   %ebx
  800291:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800294:	bb 00 00 00 00       	mov    $0x0,%ebx
  800299:	b8 08 00 00 00       	mov    $0x8,%eax
  80029e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a4:	89 df                	mov    %ebx,%edi
  8002a6:	89 de                	mov    %ebx,%esi
  8002a8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	7e 28                	jle    8002d6 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ae:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002b2:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002b9:	00 
  8002ba:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  8002c1:	00 
  8002c2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002c9:	00 
  8002ca:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  8002d1:	e8 d0 14 00 00       	call   8017a6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002d6:	83 c4 2c             	add    $0x2c,%esp
  8002d9:	5b                   	pop    %ebx
  8002da:	5e                   	pop    %esi
  8002db:	5f                   	pop    %edi
  8002dc:	5d                   	pop    %ebp
  8002dd:	c3                   	ret    

008002de <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8002f1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f7:	89 df                	mov    %ebx,%edi
  8002f9:	89 de                	mov    %ebx,%esi
  8002fb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	7e 28                	jle    800329 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800301:	89 44 24 10          	mov    %eax,0x10(%esp)
  800305:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80030c:	00 
  80030d:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  800314:	00 
  800315:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80031c:	00 
  80031d:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  800324:	e8 7d 14 00 00       	call   8017a6 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800329:	83 c4 2c             	add    $0x2c,%esp
  80032c:	5b                   	pop    %ebx
  80032d:	5e                   	pop    %esi
  80032e:	5f                   	pop    %edi
  80032f:	5d                   	pop    %ebp
  800330:	c3                   	ret    

00800331 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800331:	55                   	push   %ebp
  800332:	89 e5                	mov    %esp,%ebp
  800334:	57                   	push   %edi
  800335:	56                   	push   %esi
  800336:	53                   	push   %ebx
  800337:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80033a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80033f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800344:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800347:	8b 55 08             	mov    0x8(%ebp),%edx
  80034a:	89 df                	mov    %ebx,%edi
  80034c:	89 de                	mov    %ebx,%esi
  80034e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800350:	85 c0                	test   %eax,%eax
  800352:	7e 28                	jle    80037c <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800354:	89 44 24 10          	mov    %eax,0x10(%esp)
  800358:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80035f:	00 
  800360:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  800367:	00 
  800368:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80036f:	00 
  800370:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  800377:	e8 2a 14 00 00       	call   8017a6 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80037c:	83 c4 2c             	add    $0x2c,%esp
  80037f:	5b                   	pop    %ebx
  800380:	5e                   	pop    %esi
  800381:	5f                   	pop    %edi
  800382:	5d                   	pop    %ebp
  800383:	c3                   	ret    

00800384 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	57                   	push   %edi
  800388:	56                   	push   %esi
  800389:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80038a:	be 00 00 00 00       	mov    $0x0,%esi
  80038f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800394:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800397:	8b 55 08             	mov    0x8(%ebp),%edx
  80039a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80039d:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003a0:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003a2:	5b                   	pop    %ebx
  8003a3:	5e                   	pop    %esi
  8003a4:	5f                   	pop    %edi
  8003a5:	5d                   	pop    %ebp
  8003a6:	c3                   	ret    

008003a7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	57                   	push   %edi
  8003ab:	56                   	push   %esi
  8003ac:	53                   	push   %ebx
  8003ad:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003b5:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8003bd:	89 cb                	mov    %ecx,%ebx
  8003bf:	89 cf                	mov    %ecx,%edi
  8003c1:	89 ce                	mov    %ecx,%esi
  8003c3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003c5:	85 c0                	test   %eax,%eax
  8003c7:	7e 28                	jle    8003f1 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003cd:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003d4:	00 
  8003d5:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  8003dc:	00 
  8003dd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003e4:	00 
  8003e5:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  8003ec:	e8 b5 13 00 00       	call   8017a6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003f1:	83 c4 2c             	add    $0x2c,%esp
  8003f4:	5b                   	pop    %ebx
  8003f5:	5e                   	pop    %esi
  8003f6:	5f                   	pop    %edi
  8003f7:	5d                   	pop    %ebp
  8003f8:	c3                   	ret    

008003f9 <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	57                   	push   %edi
  8003fd:	56                   	push   %esi
  8003fe:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800404:	b8 0e 00 00 00       	mov    $0xe,%eax
  800409:	89 d1                	mov    %edx,%ecx
  80040b:	89 d3                	mov    %edx,%ebx
  80040d:	89 d7                	mov    %edx,%edi
  80040f:	89 d6                	mov    %edx,%esi
  800411:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800413:	5b                   	pop    %ebx
  800414:	5e                   	pop    %esi
  800415:	5f                   	pop    %edi
  800416:	5d                   	pop    %ebp
  800417:	c3                   	ret    

00800418 <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	57                   	push   %edi
  80041c:	56                   	push   %esi
  80041d:	53                   	push   %ebx
  80041e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800421:	bb 00 00 00 00       	mov    $0x0,%ebx
  800426:	b8 0f 00 00 00       	mov    $0xf,%eax
  80042b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80042e:	8b 55 08             	mov    0x8(%ebp),%edx
  800431:	89 df                	mov    %ebx,%edi
  800433:	89 de                	mov    %ebx,%esi
  800435:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800437:	85 c0                	test   %eax,%eax
  800439:	7e 28                	jle    800463 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80043b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80043f:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800446:	00 
  800447:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  80044e:	00 
  80044f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800456:	00 
  800457:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  80045e:	e8 43 13 00 00       	call   8017a6 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800463:	83 c4 2c             	add    $0x2c,%esp
  800466:	5b                   	pop    %ebx
  800467:	5e                   	pop    %esi
  800468:	5f                   	pop    %edi
  800469:	5d                   	pop    %ebp
  80046a:	c3                   	ret    

0080046b <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80046b:	55                   	push   %ebp
  80046c:	89 e5                	mov    %esp,%ebp
  80046e:	57                   	push   %edi
  80046f:	56                   	push   %esi
  800470:	53                   	push   %ebx
  800471:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800474:	bb 00 00 00 00       	mov    $0x0,%ebx
  800479:	b8 10 00 00 00       	mov    $0x10,%eax
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	8b 55 08             	mov    0x8(%ebp),%edx
  800484:	89 df                	mov    %ebx,%edi
  800486:	89 de                	mov    %ebx,%esi
  800488:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80048a:	85 c0                	test   %eax,%eax
  80048c:	7e 28                	jle    8004b6 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80048e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800492:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800499:	00 
  80049a:	c7 44 24 08 6a 26 80 	movl   $0x80266a,0x8(%esp)
  8004a1:	00 
  8004a2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004a9:	00 
  8004aa:	c7 04 24 87 26 80 00 	movl   $0x802687,(%esp)
  8004b1:	e8 f0 12 00 00       	call   8017a6 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8004b6:	83 c4 2c             	add    $0x2c,%esp
  8004b9:	5b                   	pop    %ebx
  8004ba:	5e                   	pop    %esi
  8004bb:	5f                   	pop    %edi
  8004bc:	5d                   	pop    %ebp
  8004bd:	c3                   	ret    

008004be <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8004be:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8004bf:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  8004c4:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8004c6:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  8004c9:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  8004cb:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  8004cf:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  8004d3:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  8004d4:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  8004d6:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  8004d8:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  8004dc:	58                   	pop    %eax
	popl %eax;
  8004dd:	58                   	pop    %eax
	popal;
  8004de:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  8004df:	83 c4 04             	add    $0x4,%esp
	popfl;
  8004e2:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8004e3:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  8004e4:	c3                   	ret    
  8004e5:	66 90                	xchg   %ax,%ax
  8004e7:	66 90                	xchg   %ax,%ax
  8004e9:	66 90                	xchg   %ax,%ax
  8004eb:	66 90                	xchg   %ax,%ax
  8004ed:	66 90                	xchg   %ax,%ax
  8004ef:	90                   	nop

008004f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8004fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8004fe:	5d                   	pop    %ebp
  8004ff:	c3                   	ret    

00800500 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800503:	8b 45 08             	mov    0x8(%ebp),%eax
  800506:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80050b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800510:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800515:	5d                   	pop    %ebp
  800516:	c3                   	ret    

00800517 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80051d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800522:	89 c2                	mov    %eax,%edx
  800524:	c1 ea 16             	shr    $0x16,%edx
  800527:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80052e:	f6 c2 01             	test   $0x1,%dl
  800531:	74 11                	je     800544 <fd_alloc+0x2d>
  800533:	89 c2                	mov    %eax,%edx
  800535:	c1 ea 0c             	shr    $0xc,%edx
  800538:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80053f:	f6 c2 01             	test   $0x1,%dl
  800542:	75 09                	jne    80054d <fd_alloc+0x36>
			*fd_store = fd;
  800544:	89 01                	mov    %eax,(%ecx)
			return 0;
  800546:	b8 00 00 00 00       	mov    $0x0,%eax
  80054b:	eb 17                	jmp    800564 <fd_alloc+0x4d>
  80054d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800552:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800557:	75 c9                	jne    800522 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800559:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80055f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800564:	5d                   	pop    %ebp
  800565:	c3                   	ret    

00800566 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80056c:	83 f8 1f             	cmp    $0x1f,%eax
  80056f:	77 36                	ja     8005a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800571:	c1 e0 0c             	shl    $0xc,%eax
  800574:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800579:	89 c2                	mov    %eax,%edx
  80057b:	c1 ea 16             	shr    $0x16,%edx
  80057e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800585:	f6 c2 01             	test   $0x1,%dl
  800588:	74 24                	je     8005ae <fd_lookup+0x48>
  80058a:	89 c2                	mov    %eax,%edx
  80058c:	c1 ea 0c             	shr    $0xc,%edx
  80058f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800596:	f6 c2 01             	test   $0x1,%dl
  800599:	74 1a                	je     8005b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80059b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059e:	89 02                	mov    %eax,(%edx)
	return 0;
  8005a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a5:	eb 13                	jmp    8005ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005ac:	eb 0c                	jmp    8005ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8005ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8005b3:	eb 05                	jmp    8005ba <fd_lookup+0x54>
  8005b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8005ba:	5d                   	pop    %ebp
  8005bb:	c3                   	ret    

008005bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 18             	sub    $0x18,%esp
  8005c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8005c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ca:	eb 13                	jmp    8005df <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8005cc:	39 08                	cmp    %ecx,(%eax)
  8005ce:	75 0c                	jne    8005dc <dev_lookup+0x20>
			*dev = devtab[i];
  8005d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8005d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8005da:	eb 38                	jmp    800614 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8005dc:	83 c2 01             	add    $0x1,%edx
  8005df:	8b 04 95 14 27 80 00 	mov    0x802714(,%edx,4),%eax
  8005e6:	85 c0                	test   %eax,%eax
  8005e8:	75 e2                	jne    8005cc <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8005ef:	8b 40 48             	mov    0x48(%eax),%eax
  8005f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005fa:	c7 04 24 98 26 80 00 	movl   $0x802698,(%esp)
  800601:	e8 99 12 00 00       	call   80189f <cprintf>
	*dev = 0;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80060f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	56                   	push   %esi
  80061a:	53                   	push   %ebx
  80061b:	83 ec 20             	sub    $0x20,%esp
  80061e:	8b 75 08             	mov    0x8(%ebp),%esi
  800621:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800624:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800627:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80062b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800631:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800634:	89 04 24             	mov    %eax,(%esp)
  800637:	e8 2a ff ff ff       	call   800566 <fd_lookup>
  80063c:	85 c0                	test   %eax,%eax
  80063e:	78 05                	js     800645 <fd_close+0x2f>
	    || fd != fd2)
  800640:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800643:	74 0c                	je     800651 <fd_close+0x3b>
		return (must_exist ? r : 0);
  800645:	84 db                	test   %bl,%bl
  800647:	ba 00 00 00 00       	mov    $0x0,%edx
  80064c:	0f 44 c2             	cmove  %edx,%eax
  80064f:	eb 3f                	jmp    800690 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800651:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800654:	89 44 24 04          	mov    %eax,0x4(%esp)
  800658:	8b 06                	mov    (%esi),%eax
  80065a:	89 04 24             	mov    %eax,(%esp)
  80065d:	e8 5a ff ff ff       	call   8005bc <dev_lookup>
  800662:	89 c3                	mov    %eax,%ebx
  800664:	85 c0                	test   %eax,%eax
  800666:	78 16                	js     80067e <fd_close+0x68>
		if (dev->dev_close)
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80066e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800673:	85 c0                	test   %eax,%eax
  800675:	74 07                	je     80067e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800677:	89 34 24             	mov    %esi,(%esp)
  80067a:	ff d0                	call   *%eax
  80067c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80067e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800682:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800689:	e8 aa fb ff ff       	call   800238 <sys_page_unmap>
	return r;
  80068e:	89 d8                	mov    %ebx,%eax
}
  800690:	83 c4 20             	add    $0x20,%esp
  800693:	5b                   	pop    %ebx
  800694:	5e                   	pop    %esi
  800695:	5d                   	pop    %ebp
  800696:	c3                   	ret    

00800697 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80069d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	89 04 24             	mov    %eax,(%esp)
  8006aa:	e8 b7 fe ff ff       	call   800566 <fd_lookup>
  8006af:	89 c2                	mov    %eax,%edx
  8006b1:	85 d2                	test   %edx,%edx
  8006b3:	78 13                	js     8006c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8006b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8006bc:	00 
  8006bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006c0:	89 04 24             	mov    %eax,(%esp)
  8006c3:	e8 4e ff ff ff       	call   800616 <fd_close>
}
  8006c8:	c9                   	leave  
  8006c9:	c3                   	ret    

008006ca <close_all>:

void
close_all(void)
{
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	53                   	push   %ebx
  8006ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8006d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8006d6:	89 1c 24             	mov    %ebx,(%esp)
  8006d9:	e8 b9 ff ff ff       	call   800697 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8006de:	83 c3 01             	add    $0x1,%ebx
  8006e1:	83 fb 20             	cmp    $0x20,%ebx
  8006e4:	75 f0                	jne    8006d6 <close_all+0xc>
		close(i);
}
  8006e6:	83 c4 14             	add    $0x14,%esp
  8006e9:	5b                   	pop    %ebx
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
  8006ef:	57                   	push   %edi
  8006f0:	56                   	push   %esi
  8006f1:	53                   	push   %ebx
  8006f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	e8 5f fe ff ff       	call   800566 <fd_lookup>
  800707:	89 c2                	mov    %eax,%edx
  800709:	85 d2                	test   %edx,%edx
  80070b:	0f 88 e1 00 00 00    	js     8007f2 <dup+0x106>
		return r;
	close(newfdnum);
  800711:	8b 45 0c             	mov    0xc(%ebp),%eax
  800714:	89 04 24             	mov    %eax,(%esp)
  800717:	e8 7b ff ff ff       	call   800697 <close>

	newfd = INDEX2FD(newfdnum);
  80071c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80071f:	c1 e3 0c             	shl    $0xc,%ebx
  800722:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80072b:	89 04 24             	mov    %eax,(%esp)
  80072e:	e8 cd fd ff ff       	call   800500 <fd2data>
  800733:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800735:	89 1c 24             	mov    %ebx,(%esp)
  800738:	e8 c3 fd ff ff       	call   800500 <fd2data>
  80073d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80073f:	89 f0                	mov    %esi,%eax
  800741:	c1 e8 16             	shr    $0x16,%eax
  800744:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80074b:	a8 01                	test   $0x1,%al
  80074d:	74 43                	je     800792 <dup+0xa6>
  80074f:	89 f0                	mov    %esi,%eax
  800751:	c1 e8 0c             	shr    $0xc,%eax
  800754:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80075b:	f6 c2 01             	test   $0x1,%dl
  80075e:	74 32                	je     800792 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800760:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800767:	25 07 0e 00 00       	and    $0xe07,%eax
  80076c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800770:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800774:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80077b:	00 
  80077c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800780:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800787:	e8 59 fa ff ff       	call   8001e5 <sys_page_map>
  80078c:	89 c6                	mov    %eax,%esi
  80078e:	85 c0                	test   %eax,%eax
  800790:	78 3e                	js     8007d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800792:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800795:	89 c2                	mov    %eax,%edx
  800797:	c1 ea 0c             	shr    $0xc,%edx
  80079a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8007a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8007a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8007b6:	00 
  8007b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007c2:	e8 1e fa ff ff       	call   8001e5 <sys_page_map>
  8007c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8007c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8007cc:	85 f6                	test   %esi,%esi
  8007ce:	79 22                	jns    8007f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8007d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007db:	e8 58 fa ff ff       	call   800238 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8007e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007eb:	e8 48 fa ff ff       	call   800238 <sys_page_unmap>
	return r;
  8007f0:	89 f0                	mov    %esi,%eax
}
  8007f2:	83 c4 3c             	add    $0x3c,%esp
  8007f5:	5b                   	pop    %ebx
  8007f6:	5e                   	pop    %esi
  8007f7:	5f                   	pop    %edi
  8007f8:	5d                   	pop    %ebp
  8007f9:	c3                   	ret    

008007fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	53                   	push   %ebx
  8007fe:	83 ec 24             	sub    $0x24,%esp
  800801:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800804:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080b:	89 1c 24             	mov    %ebx,(%esp)
  80080e:	e8 53 fd ff ff       	call   800566 <fd_lookup>
  800813:	89 c2                	mov    %eax,%edx
  800815:	85 d2                	test   %edx,%edx
  800817:	78 6d                	js     800886 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800819:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80081c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 04 24             	mov    %eax,(%esp)
  800828:	e8 8f fd ff ff       	call   8005bc <dev_lookup>
  80082d:	85 c0                	test   %eax,%eax
  80082f:	78 55                	js     800886 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800834:	8b 50 08             	mov    0x8(%eax),%edx
  800837:	83 e2 03             	and    $0x3,%edx
  80083a:	83 fa 01             	cmp    $0x1,%edx
  80083d:	75 23                	jne    800862 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80083f:	a1 08 40 80 00       	mov    0x804008,%eax
  800844:	8b 40 48             	mov    0x48(%eax),%eax
  800847:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80084b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084f:	c7 04 24 d9 26 80 00 	movl   $0x8026d9,(%esp)
  800856:	e8 44 10 00 00       	call   80189f <cprintf>
		return -E_INVAL;
  80085b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800860:	eb 24                	jmp    800886 <read+0x8c>
	}
	if (!dev->dev_read)
  800862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800865:	8b 52 08             	mov    0x8(%edx),%edx
  800868:	85 d2                	test   %edx,%edx
  80086a:	74 15                	je     800881 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80086c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80086f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800873:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800876:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80087a:	89 04 24             	mov    %eax,(%esp)
  80087d:	ff d2                	call   *%edx
  80087f:	eb 05                	jmp    800886 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800881:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800886:	83 c4 24             	add    $0x24,%esp
  800889:	5b                   	pop    %ebx
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	57                   	push   %edi
  800890:	56                   	push   %esi
  800891:	53                   	push   %ebx
  800892:	83 ec 1c             	sub    $0x1c,%esp
  800895:	8b 7d 08             	mov    0x8(%ebp),%edi
  800898:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80089b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008a0:	eb 23                	jmp    8008c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8008a2:	89 f0                	mov    %esi,%eax
  8008a4:	29 d8                	sub    %ebx,%eax
  8008a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008aa:	89 d8                	mov    %ebx,%eax
  8008ac:	03 45 0c             	add    0xc(%ebp),%eax
  8008af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b3:	89 3c 24             	mov    %edi,(%esp)
  8008b6:	e8 3f ff ff ff       	call   8007fa <read>
		if (m < 0)
  8008bb:	85 c0                	test   %eax,%eax
  8008bd:	78 10                	js     8008cf <readn+0x43>
			return m;
		if (m == 0)
  8008bf:	85 c0                	test   %eax,%eax
  8008c1:	74 0a                	je     8008cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8008c3:	01 c3                	add    %eax,%ebx
  8008c5:	39 f3                	cmp    %esi,%ebx
  8008c7:	72 d9                	jb     8008a2 <readn+0x16>
  8008c9:	89 d8                	mov    %ebx,%eax
  8008cb:	eb 02                	jmp    8008cf <readn+0x43>
  8008cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8008cf:	83 c4 1c             	add    $0x1c,%esp
  8008d2:	5b                   	pop    %ebx
  8008d3:	5e                   	pop    %esi
  8008d4:	5f                   	pop    %edi
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	83 ec 24             	sub    $0x24,%esp
  8008de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e8:	89 1c 24             	mov    %ebx,(%esp)
  8008eb:	e8 76 fc ff ff       	call   800566 <fd_lookup>
  8008f0:	89 c2                	mov    %eax,%edx
  8008f2:	85 d2                	test   %edx,%edx
  8008f4:	78 68                	js     80095e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	89 04 24             	mov    %eax,(%esp)
  800905:	e8 b2 fc ff ff       	call   8005bc <dev_lookup>
  80090a:	85 c0                	test   %eax,%eax
  80090c:	78 50                	js     80095e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80090e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800911:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800915:	75 23                	jne    80093a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800917:	a1 08 40 80 00       	mov    0x804008,%eax
  80091c:	8b 40 48             	mov    0x48(%eax),%eax
  80091f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800923:	89 44 24 04          	mov    %eax,0x4(%esp)
  800927:	c7 04 24 f5 26 80 00 	movl   $0x8026f5,(%esp)
  80092e:	e8 6c 0f 00 00       	call   80189f <cprintf>
		return -E_INVAL;
  800933:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800938:	eb 24                	jmp    80095e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80093a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093d:	8b 52 0c             	mov    0xc(%edx),%edx
  800940:	85 d2                	test   %edx,%edx
  800942:	74 15                	je     800959 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800944:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800947:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80094b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800952:	89 04 24             	mov    %eax,(%esp)
  800955:	ff d2                	call   *%edx
  800957:	eb 05                	jmp    80095e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800959:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80095e:	83 c4 24             	add    $0x24,%esp
  800961:	5b                   	pop    %ebx
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <seek>:

int
seek(int fdnum, off_t offset)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80096a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	89 04 24             	mov    %eax,(%esp)
  800977:	e8 ea fb ff ff       	call   800566 <fd_lookup>
  80097c:	85 c0                	test   %eax,%eax
  80097e:	78 0e                	js     80098e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800983:	8b 55 0c             	mov    0xc(%ebp),%edx
  800986:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800989:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	53                   	push   %ebx
  800994:	83 ec 24             	sub    $0x24,%esp
  800997:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80099a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80099d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a1:	89 1c 24             	mov    %ebx,(%esp)
  8009a4:	e8 bd fb ff ff       	call   800566 <fd_lookup>
  8009a9:	89 c2                	mov    %eax,%edx
  8009ab:	85 d2                	test   %edx,%edx
  8009ad:	78 61                	js     800a10 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	89 04 24             	mov    %eax,(%esp)
  8009be:	e8 f9 fb ff ff       	call   8005bc <dev_lookup>
  8009c3:	85 c0                	test   %eax,%eax
  8009c5:	78 49                	js     800a10 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8009c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8009ce:	75 23                	jne    8009f3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8009d0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009d5:	8b 40 48             	mov    0x48(%eax),%eax
  8009d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e0:	c7 04 24 b8 26 80 00 	movl   $0x8026b8,(%esp)
  8009e7:	e8 b3 0e 00 00       	call   80189f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f1:	eb 1d                	jmp    800a10 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8009f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009f6:	8b 52 18             	mov    0x18(%edx),%edx
  8009f9:	85 d2                	test   %edx,%edx
  8009fb:	74 0e                	je     800a0b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a00:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a04:	89 04 24             	mov    %eax,(%esp)
  800a07:	ff d2                	call   *%edx
  800a09:	eb 05                	jmp    800a10 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800a0b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800a10:	83 c4 24             	add    $0x24,%esp
  800a13:	5b                   	pop    %ebx
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	53                   	push   %ebx
  800a1a:	83 ec 24             	sub    $0x24,%esp
  800a1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800a20:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	89 04 24             	mov    %eax,(%esp)
  800a2d:	e8 34 fb ff ff       	call   800566 <fd_lookup>
  800a32:	89 c2                	mov    %eax,%edx
  800a34:	85 d2                	test   %edx,%edx
  800a36:	78 52                	js     800a8a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a42:	8b 00                	mov    (%eax),%eax
  800a44:	89 04 24             	mov    %eax,(%esp)
  800a47:	e8 70 fb ff ff       	call   8005bc <dev_lookup>
  800a4c:	85 c0                	test   %eax,%eax
  800a4e:	78 3a                	js     800a8a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a53:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a57:	74 2c                	je     800a85 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a59:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a5c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a63:	00 00 00 
	stat->st_isdir = 0;
  800a66:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a6d:	00 00 00 
	stat->st_dev = dev;
  800a70:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a76:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a7d:	89 14 24             	mov    %edx,(%esp)
  800a80:	ff 50 14             	call   *0x14(%eax)
  800a83:	eb 05                	jmp    800a8a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a85:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a8a:	83 c4 24             	add    $0x24,%esp
  800a8d:	5b                   	pop    %ebx
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	56                   	push   %esi
  800a94:	53                   	push   %ebx
  800a95:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a9f:	00 
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	89 04 24             	mov    %eax,(%esp)
  800aa6:	e8 28 02 00 00       	call   800cd3 <open>
  800aab:	89 c3                	mov    %eax,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	78 1b                	js     800acc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab8:	89 1c 24             	mov    %ebx,(%esp)
  800abb:	e8 56 ff ff ff       	call   800a16 <fstat>
  800ac0:	89 c6                	mov    %eax,%esi
	close(fd);
  800ac2:	89 1c 24             	mov    %ebx,(%esp)
  800ac5:	e8 cd fb ff ff       	call   800697 <close>
	return r;
  800aca:	89 f0                	mov    %esi,%eax
}
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	56                   	push   %esi
  800ad7:	53                   	push   %ebx
  800ad8:	83 ec 10             	sub    $0x10,%esp
  800adb:	89 c6                	mov    %eax,%esi
  800add:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800adf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ae6:	75 11                	jne    800af9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ae8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800aef:	e8 5b 18 00 00       	call   80234f <ipc_find_env>
  800af4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800af9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800b00:	00 
  800b01:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800b08:	00 
  800b09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b0d:	a1 00 40 80 00       	mov    0x804000,%eax
  800b12:	89 04 24             	mov    %eax,(%esp)
  800b15:	e8 d7 17 00 00       	call   8022f1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800b1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b21:	00 
  800b22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b2d:	e8 55 17 00 00       	call   802287 <ipc_recv>
}
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5d                   	pop    %ebp
  800b38:	c3                   	ret    

00800b39 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	8b 40 0c             	mov    0xc(%eax),%eax
  800b45:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800b52:	ba 00 00 00 00       	mov    $0x0,%edx
  800b57:	b8 02 00 00 00       	mov    $0x2,%eax
  800b5c:	e8 72 ff ff ff       	call   800ad3 <fsipc>
}
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  800b6f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx
  800b79:	b8 06 00 00 00       	mov    $0x6,%eax
  800b7e:	e8 50 ff ff ff       	call   800ad3 <fsipc>
}
  800b83:	c9                   	leave  
  800b84:	c3                   	ret    

00800b85 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	53                   	push   %ebx
  800b89:	83 ec 14             	sub    $0x14,%esp
  800b8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	8b 40 0c             	mov    0xc(%eax),%eax
  800b95:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9f:	b8 05 00 00 00       	mov    $0x5,%eax
  800ba4:	e8 2a ff ff ff       	call   800ad3 <fsipc>
  800ba9:	89 c2                	mov    %eax,%edx
  800bab:	85 d2                	test   %edx,%edx
  800bad:	78 2b                	js     800bda <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800baf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bb6:	00 
  800bb7:	89 1c 24             	mov    %ebx,(%esp)
  800bba:	e8 08 13 00 00       	call   801ec7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800bbf:	a1 80 50 80 00       	mov    0x805080,%eax
  800bc4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800bca:	a1 84 50 80 00       	mov    0x805084,%eax
  800bcf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800bd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bda:	83 c4 14             	add    $0x14,%esp
  800bdd:	5b                   	pop    %ebx
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 18             	sub    $0x18,%esp
  800be6:	8b 45 10             	mov    0x10(%ebp),%eax
  800be9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800bee:	ba f8 0f 00 00       	mov    $0xff8,%edx
  800bf3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  800bf6:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  800bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfe:	8b 52 0c             	mov    0xc(%edx),%edx
  800c01:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  800c07:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c12:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  800c19:	e8 46 14 00 00       	call   802064 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  800c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c23:	b8 04 00 00 00       	mov    $0x4,%eax
  800c28:	e8 a6 fe ff ff       	call   800ad3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  800c2d:	c9                   	leave  
  800c2e:	c3                   	ret    

00800c2f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800c2f:	55                   	push   %ebp
  800c30:	89 e5                	mov    %esp,%ebp
  800c32:	56                   	push   %esi
  800c33:	53                   	push   %ebx
  800c34:	83 ec 10             	sub    $0x10,%esp
  800c37:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  800c40:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800c45:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c50:	b8 03 00 00 00       	mov    $0x3,%eax
  800c55:	e8 79 fe ff ff       	call   800ad3 <fsipc>
  800c5a:	89 c3                	mov    %eax,%ebx
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	78 6a                	js     800cca <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800c60:	39 c6                	cmp    %eax,%esi
  800c62:	73 24                	jae    800c88 <devfile_read+0x59>
  800c64:	c7 44 24 0c 28 27 80 	movl   $0x802728,0xc(%esp)
  800c6b:	00 
  800c6c:	c7 44 24 08 2f 27 80 	movl   $0x80272f,0x8(%esp)
  800c73:	00 
  800c74:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  800c7b:	00 
  800c7c:	c7 04 24 44 27 80 00 	movl   $0x802744,(%esp)
  800c83:	e8 1e 0b 00 00       	call   8017a6 <_panic>
	assert(r <= PGSIZE);
  800c88:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c8d:	7e 24                	jle    800cb3 <devfile_read+0x84>
  800c8f:	c7 44 24 0c 4f 27 80 	movl   $0x80274f,0xc(%esp)
  800c96:	00 
  800c97:	c7 44 24 08 2f 27 80 	movl   $0x80272f,0x8(%esp)
  800c9e:	00 
  800c9f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  800ca6:	00 
  800ca7:	c7 04 24 44 27 80 00 	movl   $0x802744,(%esp)
  800cae:	e8 f3 0a 00 00       	call   8017a6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800cb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cb7:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800cbe:	00 
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	89 04 24             	mov    %eax,(%esp)
  800cc5:	e8 9a 13 00 00       	call   802064 <memmove>
	return r;
}
  800cca:	89 d8                	mov    %ebx,%eax
  800ccc:	83 c4 10             	add    $0x10,%esp
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 24             	sub    $0x24,%esp
  800cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800cdd:	89 1c 24             	mov    %ebx,(%esp)
  800ce0:	e8 ab 11 00 00       	call   801e90 <strlen>
  800ce5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800cea:	7f 60                	jg     800d4c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800cec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cef:	89 04 24             	mov    %eax,(%esp)
  800cf2:	e8 20 f8 ff ff       	call   800517 <fd_alloc>
  800cf7:	89 c2                	mov    %eax,%edx
  800cf9:	85 d2                	test   %edx,%edx
  800cfb:	78 54                	js     800d51 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800cfd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d01:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800d08:	e8 ba 11 00 00       	call   801ec7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d18:	b8 01 00 00 00       	mov    $0x1,%eax
  800d1d:	e8 b1 fd ff ff       	call   800ad3 <fsipc>
  800d22:	89 c3                	mov    %eax,%ebx
  800d24:	85 c0                	test   %eax,%eax
  800d26:	79 17                	jns    800d3f <open+0x6c>
		fd_close(fd, 0);
  800d28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d2f:	00 
  800d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d33:	89 04 24             	mov    %eax,(%esp)
  800d36:	e8 db f8 ff ff       	call   800616 <fd_close>
		return r;
  800d3b:	89 d8                	mov    %ebx,%eax
  800d3d:	eb 12                	jmp    800d51 <open+0x7e>
	}

	return fd2num(fd);
  800d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d42:	89 04 24             	mov    %eax,(%esp)
  800d45:	e8 a6 f7 ff ff       	call   8004f0 <fd2num>
  800d4a:	eb 05                	jmp    800d51 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800d4c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800d51:	83 c4 24             	add    $0x24,%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 08 00 00 00       	mov    $0x8,%eax
  800d67:	e8 67 fd ff ff       	call   800ad3 <fsipc>
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    
  800d6e:	66 90                	xchg   %ax,%ax

00800d70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800d76:	c7 44 24 04 5b 27 80 	movl   $0x80275b,0x4(%esp)
  800d7d:	00 
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	89 04 24             	mov    %eax,(%esp)
  800d84:	e8 3e 11 00 00       	call   801ec7 <strcpy>
	return 0;
}
  800d89:	b8 00 00 00 00       	mov    $0x0,%eax
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	53                   	push   %ebx
  800d94:	83 ec 14             	sub    $0x14,%esp
  800d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  800d9a:	89 1c 24             	mov    %ebx,(%esp)
  800d9d:	e8 e5 15 00 00       	call   802387 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  800da2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  800da7:	83 f8 01             	cmp    $0x1,%eax
  800daa:	75 0d                	jne    800db9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  800dac:	8b 43 0c             	mov    0xc(%ebx),%eax
  800daf:	89 04 24             	mov    %eax,(%esp)
  800db2:	e8 29 03 00 00       	call   8010e0 <nsipc_close>
  800db7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  800db9:	89 d0                	mov    %edx,%eax
  800dbb:	83 c4 14             	add    $0x14,%esp
  800dbe:	5b                   	pop    %ebx
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800dc7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800dce:	00 
  800dcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8b 40 0c             	mov    0xc(%eax),%eax
  800de3:	89 04 24             	mov    %eax,(%esp)
  800de6:	e8 f0 03 00 00       	call   8011db <nsipc_send>
}
  800deb:	c9                   	leave  
  800dec:	c3                   	ret    

00800ded <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800df3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800dfa:	00 
  800dfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dfe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  800e0f:	89 04 24             	mov    %eax,(%esp)
  800e12:	e8 44 03 00 00       	call   80115b <nsipc_recv>
}
  800e17:	c9                   	leave  
  800e18:	c3                   	ret    

00800e19 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800e1f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e22:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e26:	89 04 24             	mov    %eax,(%esp)
  800e29:	e8 38 f7 ff ff       	call   800566 <fd_lookup>
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	78 17                	js     800e49 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e35:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  800e3b:	39 08                	cmp    %ecx,(%eax)
  800e3d:	75 05                	jne    800e44 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800e3f:	8b 40 0c             	mov    0xc(%eax),%eax
  800e42:	eb 05                	jmp    800e49 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  800e44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
  800e50:	83 ec 20             	sub    $0x20,%esp
  800e53:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800e55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e58:	89 04 24             	mov    %eax,(%esp)
  800e5b:	e8 b7 f6 ff ff       	call   800517 <fd_alloc>
  800e60:	89 c3                	mov    %eax,%ebx
  800e62:	85 c0                	test   %eax,%eax
  800e64:	78 21                	js     800e87 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  800e66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800e6d:	00 
  800e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e7c:	e8 10 f3 ff ff       	call   800191 <sys_page_alloc>
  800e81:	89 c3                	mov    %eax,%ebx
  800e83:	85 c0                	test   %eax,%eax
  800e85:	79 0c                	jns    800e93 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  800e87:	89 34 24             	mov    %esi,(%esp)
  800e8a:	e8 51 02 00 00       	call   8010e0 <nsipc_close>
		return r;
  800e8f:	89 d8                	mov    %ebx,%eax
  800e91:	eb 20                	jmp    800eb3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800e93:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e9c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  800ea8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  800eab:	89 14 24             	mov    %edx,(%esp)
  800eae:	e8 3d f6 ff ff       	call   8004f0 <fd2num>
}
  800eb3:	83 c4 20             	add    $0x20,%esp
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    

00800eba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	e8 51 ff ff ff       	call   800e19 <fd2sockid>
		return r;
  800ec8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	78 23                	js     800ef1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800ece:	8b 55 10             	mov    0x10(%ebp),%edx
  800ed1:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ed5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800edc:	89 04 24             	mov    %eax,(%esp)
  800edf:	e8 45 01 00 00       	call   801029 <nsipc_accept>
		return r;
  800ee4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  800ee6:	85 c0                	test   %eax,%eax
  800ee8:	78 07                	js     800ef1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  800eea:	e8 5c ff ff ff       	call   800e4b <alloc_sockfd>
  800eef:	89 c1                	mov    %eax,%ecx
}
  800ef1:	89 c8                	mov    %ecx,%eax
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	e8 16 ff ff ff       	call   800e19 <fd2sockid>
  800f03:	89 c2                	mov    %eax,%edx
  800f05:	85 d2                	test   %edx,%edx
  800f07:	78 16                	js     800f1f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f17:	89 14 24             	mov    %edx,(%esp)
  800f1a:	e8 60 01 00 00       	call   80107f <nsipc_bind>
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <shutdown>:

int
shutdown(int s, int how)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	e8 ea fe ff ff       	call   800e19 <fd2sockid>
  800f2f:	89 c2                	mov    %eax,%edx
  800f31:	85 d2                	test   %edx,%edx
  800f33:	78 0f                	js     800f44 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f3c:	89 14 24             	mov    %edx,(%esp)
  800f3f:	e8 7a 01 00 00       	call   8010be <nsipc_shutdown>
}
  800f44:	c9                   	leave  
  800f45:	c3                   	ret    

00800f46 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	e8 c5 fe ff ff       	call   800e19 <fd2sockid>
  800f54:	89 c2                	mov    %eax,%edx
  800f56:	85 d2                	test   %edx,%edx
  800f58:	78 16                	js     800f70 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f68:	89 14 24             	mov    %edx,(%esp)
  800f6b:	e8 8a 01 00 00       	call   8010fa <nsipc_connect>
}
  800f70:	c9                   	leave  
  800f71:	c3                   	ret    

00800f72 <listen>:

int
listen(int s, int backlog)
{
  800f72:	55                   	push   %ebp
  800f73:	89 e5                	mov    %esp,%ebp
  800f75:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800f78:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7b:	e8 99 fe ff ff       	call   800e19 <fd2sockid>
  800f80:	89 c2                	mov    %eax,%edx
  800f82:	85 d2                	test   %edx,%edx
  800f84:	78 0f                	js     800f95 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f8d:	89 14 24             	mov    %edx,(%esp)
  800f90:	e8 a4 01 00 00       	call   801139 <nsipc_listen>
}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	89 04 24             	mov    %eax,(%esp)
  800fb1:	e8 98 02 00 00       	call   80124e <nsipc_socket>
  800fb6:	89 c2                	mov    %eax,%edx
  800fb8:	85 d2                	test   %edx,%edx
  800fba:	78 05                	js     800fc1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  800fbc:	e8 8a fe ff ff       	call   800e4b <alloc_sockfd>
}
  800fc1:	c9                   	leave  
  800fc2:	c3                   	ret    

00800fc3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	53                   	push   %ebx
  800fc7:	83 ec 14             	sub    $0x14,%esp
  800fca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  800fcc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  800fd3:	75 11                	jne    800fe6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  800fd5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800fdc:	e8 6e 13 00 00       	call   80234f <ipc_find_env>
  800fe1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  800fe6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800fed:	00 
  800fee:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  800ff5:	00 
  800ff6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ffa:	a1 04 40 80 00       	mov    0x804004,%eax
  800fff:	89 04 24             	mov    %eax,(%esp)
  801002:	e8 ea 12 00 00       	call   8022f1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801007:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80100e:	00 
  80100f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801016:	00 
  801017:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80101e:	e8 64 12 00 00       	call   802287 <ipc_recv>
}
  801023:	83 c4 14             	add    $0x14,%esp
  801026:	5b                   	pop    %ebx
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	56                   	push   %esi
  80102d:	53                   	push   %ebx
  80102e:	83 ec 10             	sub    $0x10,%esp
  801031:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801034:	8b 45 08             	mov    0x8(%ebp),%eax
  801037:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80103c:	8b 06                	mov    (%esi),%eax
  80103e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801043:	b8 01 00 00 00       	mov    $0x1,%eax
  801048:	e8 76 ff ff ff       	call   800fc3 <nsipc>
  80104d:	89 c3                	mov    %eax,%ebx
  80104f:	85 c0                	test   %eax,%eax
  801051:	78 23                	js     801076 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801053:	a1 10 60 80 00       	mov    0x806010,%eax
  801058:	89 44 24 08          	mov    %eax,0x8(%esp)
  80105c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801063:	00 
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	89 04 24             	mov    %eax,(%esp)
  80106a:	e8 f5 0f 00 00       	call   802064 <memmove>
		*addrlen = ret->ret_addrlen;
  80106f:	a1 10 60 80 00       	mov    0x806010,%eax
  801074:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801076:	89 d8                	mov    %ebx,%eax
  801078:	83 c4 10             	add    $0x10,%esp
  80107b:	5b                   	pop    %ebx
  80107c:	5e                   	pop    %esi
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	53                   	push   %ebx
  801083:	83 ec 14             	sub    $0x14,%esp
  801086:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801091:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	89 44 24 04          	mov    %eax,0x4(%esp)
  80109c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8010a3:	e8 bc 0f 00 00       	call   802064 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8010a8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8010ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8010b3:	e8 0b ff ff ff       	call   800fc3 <nsipc>
}
  8010b8:	83 c4 14             	add    $0x14,%esp
  8010bb:	5b                   	pop    %ebx
  8010bc:	5d                   	pop    %ebp
  8010bd:	c3                   	ret    

008010be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8010d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8010d9:	e8 e5 fe ff ff       	call   800fc3 <nsipc>
}
  8010de:	c9                   	leave  
  8010df:	c3                   	ret    

008010e0 <nsipc_close>:

int
nsipc_close(int s)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8010ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8010f3:	e8 cb fe ff ff       	call   800fc3 <nsipc>
}
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	53                   	push   %ebx
  8010fe:	83 ec 14             	sub    $0x14,%esp
  801101:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80110c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	89 44 24 04          	mov    %eax,0x4(%esp)
  801117:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80111e:	e8 41 0f 00 00       	call   802064 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801123:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801129:	b8 05 00 00 00       	mov    $0x5,%eax
  80112e:	e8 90 fe ff ff       	call   800fc3 <nsipc>
}
  801133:	83 c4 14             	add    $0x14,%esp
  801136:	5b                   	pop    %ebx
  801137:	5d                   	pop    %ebp
  801138:	c3                   	ret    

00801139 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801139:	55                   	push   %ebp
  80113a:	89 e5                	mov    %esp,%ebp
  80113c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80113f:	8b 45 08             	mov    0x8(%ebp),%eax
  801142:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80114f:	b8 06 00 00 00       	mov    $0x6,%eax
  801154:	e8 6a fe ff ff       	call   800fc3 <nsipc>
}
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	56                   	push   %esi
  80115f:	53                   	push   %ebx
  801160:	83 ec 10             	sub    $0x10,%esp
  801163:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  80116e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801174:	8b 45 14             	mov    0x14(%ebp),%eax
  801177:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80117c:	b8 07 00 00 00       	mov    $0x7,%eax
  801181:	e8 3d fe ff ff       	call   800fc3 <nsipc>
  801186:	89 c3                	mov    %eax,%ebx
  801188:	85 c0                	test   %eax,%eax
  80118a:	78 46                	js     8011d2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80118c:	39 f0                	cmp    %esi,%eax
  80118e:	7f 07                	jg     801197 <nsipc_recv+0x3c>
  801190:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801195:	7e 24                	jle    8011bb <nsipc_recv+0x60>
  801197:	c7 44 24 0c 67 27 80 	movl   $0x802767,0xc(%esp)
  80119e:	00 
  80119f:	c7 44 24 08 2f 27 80 	movl   $0x80272f,0x8(%esp)
  8011a6:	00 
  8011a7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8011ae:	00 
  8011af:	c7 04 24 7c 27 80 00 	movl   $0x80277c,(%esp)
  8011b6:	e8 eb 05 00 00       	call   8017a6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8011bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011bf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8011c6:	00 
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 04 24             	mov    %eax,(%esp)
  8011cd:	e8 92 0e 00 00       	call   802064 <memmove>
	}

	return r;
}
  8011d2:	89 d8                	mov    %ebx,%eax
  8011d4:	83 c4 10             	add    $0x10,%esp
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	53                   	push   %ebx
  8011df:	83 ec 14             	sub    $0x14,%esp
  8011e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8011e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8011ed:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8011f3:	7e 24                	jle    801219 <nsipc_send+0x3e>
  8011f5:	c7 44 24 0c 88 27 80 	movl   $0x802788,0xc(%esp)
  8011fc:	00 
  8011fd:	c7 44 24 08 2f 27 80 	movl   $0x80272f,0x8(%esp)
  801204:	00 
  801205:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80120c:	00 
  80120d:	c7 04 24 7c 27 80 00 	movl   $0x80277c,(%esp)
  801214:	e8 8d 05 00 00       	call   8017a6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801219:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	89 44 24 04          	mov    %eax,0x4(%esp)
  801224:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80122b:	e8 34 0e 00 00       	call   802064 <memmove>
	nsipcbuf.send.req_size = size;
  801230:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80123e:	b8 08 00 00 00       	mov    $0x8,%eax
  801243:	e8 7b fd ff ff       	call   800fc3 <nsipc>
}
  801248:	83 c4 14             	add    $0x14,%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801264:	8b 45 10             	mov    0x10(%ebp),%eax
  801267:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80126c:	b8 09 00 00 00       	mov    $0x9,%eax
  801271:	e8 4d fd ff ff       	call   800fc3 <nsipc>
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	56                   	push   %esi
  80127c:	53                   	push   %ebx
  80127d:	83 ec 10             	sub    $0x10,%esp
  801280:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 04 24             	mov    %eax,(%esp)
  801289:	e8 72 f2 ff ff       	call   800500 <fd2data>
  80128e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801290:	c7 44 24 04 94 27 80 	movl   $0x802794,0x4(%esp)
  801297:	00 
  801298:	89 1c 24             	mov    %ebx,(%esp)
  80129b:	e8 27 0c 00 00       	call   801ec7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8012a0:	8b 46 04             	mov    0x4(%esi),%eax
  8012a3:	2b 06                	sub    (%esi),%eax
  8012a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8012ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012b2:	00 00 00 
	stat->st_dev = &devpipe;
  8012b5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  8012bc:	30 80 00 
	return 0;
}
  8012bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8012c4:	83 c4 10             	add    $0x10,%esp
  8012c7:	5b                   	pop    %ebx
  8012c8:	5e                   	pop    %esi
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    

008012cb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	53                   	push   %ebx
  8012cf:	83 ec 14             	sub    $0x14,%esp
  8012d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8012d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e0:	e8 53 ef ff ff       	call   800238 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8012e5:	89 1c 24             	mov    %ebx,(%esp)
  8012e8:	e8 13 f2 ff ff       	call   800500 <fd2data>
  8012ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012f8:	e8 3b ef ff ff       	call   800238 <sys_page_unmap>
}
  8012fd:	83 c4 14             	add    $0x14,%esp
  801300:	5b                   	pop    %ebx
  801301:	5d                   	pop    %ebp
  801302:	c3                   	ret    

00801303 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
  801306:	57                   	push   %edi
  801307:	56                   	push   %esi
  801308:	53                   	push   %ebx
  801309:	83 ec 2c             	sub    $0x2c,%esp
  80130c:	89 c6                	mov    %eax,%esi
  80130e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801311:	a1 08 40 80 00       	mov    0x804008,%eax
  801316:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801319:	89 34 24             	mov    %esi,(%esp)
  80131c:	e8 66 10 00 00       	call   802387 <pageref>
  801321:	89 c7                	mov    %eax,%edi
  801323:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801326:	89 04 24             	mov    %eax,(%esp)
  801329:	e8 59 10 00 00       	call   802387 <pageref>
  80132e:	39 c7                	cmp    %eax,%edi
  801330:	0f 94 c2             	sete   %dl
  801333:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801336:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  80133c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80133f:	39 fb                	cmp    %edi,%ebx
  801341:	74 21                	je     801364 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801343:	84 d2                	test   %dl,%dl
  801345:	74 ca                	je     801311 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801347:	8b 51 58             	mov    0x58(%ecx),%edx
  80134a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80134e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801352:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801356:	c7 04 24 9b 27 80 00 	movl   $0x80279b,(%esp)
  80135d:	e8 3d 05 00 00       	call   80189f <cprintf>
  801362:	eb ad                	jmp    801311 <_pipeisclosed+0xe>
	}
}
  801364:	83 c4 2c             	add    $0x2c,%esp
  801367:	5b                   	pop    %ebx
  801368:	5e                   	pop    %esi
  801369:	5f                   	pop    %edi
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	57                   	push   %edi
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
  801372:	83 ec 1c             	sub    $0x1c,%esp
  801375:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801378:	89 34 24             	mov    %esi,(%esp)
  80137b:	e8 80 f1 ff ff       	call   800500 <fd2data>
  801380:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801382:	bf 00 00 00 00       	mov    $0x0,%edi
  801387:	eb 45                	jmp    8013ce <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801389:	89 da                	mov    %ebx,%edx
  80138b:	89 f0                	mov    %esi,%eax
  80138d:	e8 71 ff ff ff       	call   801303 <_pipeisclosed>
  801392:	85 c0                	test   %eax,%eax
  801394:	75 41                	jne    8013d7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801396:	e8 d7 ed ff ff       	call   800172 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80139b:	8b 43 04             	mov    0x4(%ebx),%eax
  80139e:	8b 0b                	mov    (%ebx),%ecx
  8013a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8013a3:	39 d0                	cmp    %edx,%eax
  8013a5:	73 e2                	jae    801389 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8013a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8013ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8013b1:	99                   	cltd   
  8013b2:	c1 ea 1b             	shr    $0x1b,%edx
  8013b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8013b8:	83 e1 1f             	and    $0x1f,%ecx
  8013bb:	29 d1                	sub    %edx,%ecx
  8013bd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8013c1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8013c5:	83 c0 01             	add    $0x1,%eax
  8013c8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013cb:	83 c7 01             	add    $0x1,%edi
  8013ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8013d1:	75 c8                	jne    80139b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8013d3:	89 f8                	mov    %edi,%eax
  8013d5:	eb 05                	jmp    8013dc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8013dc:	83 c4 1c             	add    $0x1c,%esp
  8013df:	5b                   	pop    %ebx
  8013e0:	5e                   	pop    %esi
  8013e1:	5f                   	pop    %edi
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    

008013e4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	57                   	push   %edi
  8013e8:	56                   	push   %esi
  8013e9:	53                   	push   %ebx
  8013ea:	83 ec 1c             	sub    $0x1c,%esp
  8013ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8013f0:	89 3c 24             	mov    %edi,(%esp)
  8013f3:	e8 08 f1 ff ff       	call   800500 <fd2data>
  8013f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8013fa:	be 00 00 00 00       	mov    $0x0,%esi
  8013ff:	eb 3d                	jmp    80143e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801401:	85 f6                	test   %esi,%esi
  801403:	74 04                	je     801409 <devpipe_read+0x25>
				return i;
  801405:	89 f0                	mov    %esi,%eax
  801407:	eb 43                	jmp    80144c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801409:	89 da                	mov    %ebx,%edx
  80140b:	89 f8                	mov    %edi,%eax
  80140d:	e8 f1 fe ff ff       	call   801303 <_pipeisclosed>
  801412:	85 c0                	test   %eax,%eax
  801414:	75 31                	jne    801447 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801416:	e8 57 ed ff ff       	call   800172 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80141b:	8b 03                	mov    (%ebx),%eax
  80141d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801420:	74 df                	je     801401 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801422:	99                   	cltd   
  801423:	c1 ea 1b             	shr    $0x1b,%edx
  801426:	01 d0                	add    %edx,%eax
  801428:	83 e0 1f             	and    $0x1f,%eax
  80142b:	29 d0                	sub    %edx,%eax
  80142d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801432:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801435:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801438:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80143b:	83 c6 01             	add    $0x1,%esi
  80143e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801441:	75 d8                	jne    80141b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801443:	89 f0                	mov    %esi,%eax
  801445:	eb 05                	jmp    80144c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80144c:	83 c4 1c             	add    $0x1c,%esp
  80144f:	5b                   	pop    %ebx
  801450:	5e                   	pop    %esi
  801451:	5f                   	pop    %edi
  801452:	5d                   	pop    %ebp
  801453:	c3                   	ret    

00801454 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	56                   	push   %esi
  801458:	53                   	push   %ebx
  801459:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80145c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145f:	89 04 24             	mov    %eax,(%esp)
  801462:	e8 b0 f0 ff ff       	call   800517 <fd_alloc>
  801467:	89 c2                	mov    %eax,%edx
  801469:	85 d2                	test   %edx,%edx
  80146b:	0f 88 4d 01 00 00    	js     8015be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801471:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801478:	00 
  801479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801480:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801487:	e8 05 ed ff ff       	call   800191 <sys_page_alloc>
  80148c:	89 c2                	mov    %eax,%edx
  80148e:	85 d2                	test   %edx,%edx
  801490:	0f 88 28 01 00 00    	js     8015be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801496:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801499:	89 04 24             	mov    %eax,(%esp)
  80149c:	e8 76 f0 ff ff       	call   800517 <fd_alloc>
  8014a1:	89 c3                	mov    %eax,%ebx
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	0f 88 fe 00 00 00    	js     8015a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014b2:	00 
  8014b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014c1:	e8 cb ec ff ff       	call   800191 <sys_page_alloc>
  8014c6:	89 c3                	mov    %eax,%ebx
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	0f 88 d9 00 00 00    	js     8015a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8014d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d3:	89 04 24             	mov    %eax,(%esp)
  8014d6:	e8 25 f0 ff ff       	call   800500 <fd2data>
  8014db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014dd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8014e4:	00 
  8014e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f0:	e8 9c ec ff ff       	call   800191 <sys_page_alloc>
  8014f5:	89 c3                	mov    %eax,%ebx
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	0f 88 97 00 00 00    	js     801596 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8014ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801502:	89 04 24             	mov    %eax,(%esp)
  801505:	e8 f6 ef ff ff       	call   800500 <fd2data>
  80150a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801511:	00 
  801512:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801516:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80151d:	00 
  80151e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801522:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801529:	e8 b7 ec ff ff       	call   8001e5 <sys_page_map>
  80152e:	89 c3                	mov    %eax,%ebx
  801530:	85 c0                	test   %eax,%eax
  801532:	78 52                	js     801586 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801534:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80153a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801542:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801549:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80154f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801552:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801557:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80155e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801561:	89 04 24             	mov    %eax,(%esp)
  801564:	e8 87 ef ff ff       	call   8004f0 <fd2num>
  801569:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80156c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801571:	89 04 24             	mov    %eax,(%esp)
  801574:	e8 77 ef ff ff       	call   8004f0 <fd2num>
  801579:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
  801584:	eb 38                	jmp    8015be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801586:	89 74 24 04          	mov    %esi,0x4(%esp)
  80158a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801591:	e8 a2 ec ff ff       	call   800238 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015a4:	e8 8f ec ff ff       	call   800238 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b7:	e8 7c ec ff ff       	call   800238 <sys_page_unmap>
  8015bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8015be:	83 c4 30             	add    $0x30,%esp
  8015c1:	5b                   	pop    %ebx
  8015c2:	5e                   	pop    %esi
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    

008015c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	89 04 24             	mov    %eax,(%esp)
  8015d8:	e8 89 ef ff ff       	call   800566 <fd_lookup>
  8015dd:	89 c2                	mov    %eax,%edx
  8015df:	85 d2                	test   %edx,%edx
  8015e1:	78 15                	js     8015f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e6:	89 04 24             	mov    %eax,(%esp)
  8015e9:	e8 12 ef ff ff       	call   800500 <fd2data>
	return _pipeisclosed(fd, p);
  8015ee:	89 c2                	mov    %eax,%edx
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	e8 0b fd ff ff       	call   801303 <_pipeisclosed>
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    
  8015fa:	66 90                	xchg   %ax,%ax
  8015fc:	66 90                	xchg   %ax,%ax
  8015fe:	66 90                	xchg   %ax,%ax

00801600 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
  801608:	5d                   	pop    %ebp
  801609:	c3                   	ret    

0080160a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
  80160d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801610:	c7 44 24 04 b3 27 80 	movl   $0x8027b3,0x4(%esp)
  801617:	00 
  801618:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161b:	89 04 24             	mov    %eax,(%esp)
  80161e:	e8 a4 08 00 00       	call   801ec7 <strcpy>
	return 0;
}
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
  801628:	c9                   	leave  
  801629:	c3                   	ret    

0080162a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80162a:	55                   	push   %ebp
  80162b:	89 e5                	mov    %esp,%ebp
  80162d:	57                   	push   %edi
  80162e:	56                   	push   %esi
  80162f:	53                   	push   %ebx
  801630:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801636:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80163b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801641:	eb 31                	jmp    801674 <devcons_write+0x4a>
		m = n - tot;
  801643:	8b 75 10             	mov    0x10(%ebp),%esi
  801646:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  801648:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80164b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801650:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801653:	89 74 24 08          	mov    %esi,0x8(%esp)
  801657:	03 45 0c             	add    0xc(%ebp),%eax
  80165a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165e:	89 3c 24             	mov    %edi,(%esp)
  801661:	e8 fe 09 00 00       	call   802064 <memmove>
		sys_cputs(buf, m);
  801666:	89 74 24 04          	mov    %esi,0x4(%esp)
  80166a:	89 3c 24             	mov    %edi,(%esp)
  80166d:	e8 52 ea ff ff       	call   8000c4 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801672:	01 f3                	add    %esi,%ebx
  801674:	89 d8                	mov    %ebx,%eax
  801676:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801679:	72 c8                	jb     801643 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80167b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801681:	5b                   	pop    %ebx
  801682:	5e                   	pop    %esi
  801683:	5f                   	pop    %edi
  801684:	5d                   	pop    %ebp
  801685:	c3                   	ret    

00801686 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801691:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801695:	75 07                	jne    80169e <devcons_read+0x18>
  801697:	eb 2a                	jmp    8016c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801699:	e8 d4 ea ff ff       	call   800172 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80169e:	66 90                	xchg   %ax,%ax
  8016a0:	e8 3d ea ff ff       	call   8000e2 <sys_cgetc>
  8016a5:	85 c0                	test   %eax,%eax
  8016a7:	74 f0                	je     801699 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	78 16                	js     8016c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8016ad:	83 f8 04             	cmp    $0x4,%eax
  8016b0:	74 0c                	je     8016be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	88 02                	mov    %al,(%edx)
	return 1;
  8016b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8016bc:	eb 05                	jmp    8016c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8016d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016d8:	00 
  8016d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8016dc:	89 04 24             	mov    %eax,(%esp)
  8016df:	e8 e0 e9 ff ff       	call   8000c4 <sys_cputs>
}
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <getchar>:

int
getchar(void)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8016ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8016f3:	00 
  8016f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8016f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801702:	e8 f3 f0 ff ff       	call   8007fa <read>
	if (r < 0)
  801707:	85 c0                	test   %eax,%eax
  801709:	78 0f                	js     80171a <getchar+0x34>
		return r;
	if (r < 1)
  80170b:	85 c0                	test   %eax,%eax
  80170d:	7e 06                	jle    801715 <getchar+0x2f>
		return -E_EOF;
	return c;
  80170f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801713:	eb 05                	jmp    80171a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801715:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801722:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801725:	89 44 24 04          	mov    %eax,0x4(%esp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	89 04 24             	mov    %eax,(%esp)
  80172f:	e8 32 ee ff ff       	call   800566 <fd_lookup>
  801734:	85 c0                	test   %eax,%eax
  801736:	78 11                	js     801749 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801741:	39 10                	cmp    %edx,(%eax)
  801743:	0f 94 c0             	sete   %al
  801746:	0f b6 c0             	movzbl %al,%eax
}
  801749:	c9                   	leave  
  80174a:	c3                   	ret    

0080174b <opencons>:

int
opencons(void)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801751:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801754:	89 04 24             	mov    %eax,(%esp)
  801757:	e8 bb ed ff ff       	call   800517 <fd_alloc>
		return r;
  80175c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 40                	js     8017a2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801762:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801769:	00 
  80176a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801771:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801778:	e8 14 ea ff ff       	call   800191 <sys_page_alloc>
		return r;
  80177d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 1f                	js     8017a2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801783:	8b 15 58 30 80 00    	mov    0x803058,%edx
  801789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80178e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801791:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801798:	89 04 24             	mov    %eax,(%esp)
  80179b:	e8 50 ed ff ff       	call   8004f0 <fd2num>
  8017a0:	89 c2                	mov    %eax,%edx
}
  8017a2:	89 d0                	mov    %edx,%eax
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	56                   	push   %esi
  8017aa:	53                   	push   %ebx
  8017ab:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8017ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8017b1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8017b7:	e8 97 e9 ff ff       	call   800153 <sys_getenvid>
  8017bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8017ca:	89 74 24 08          	mov    %esi,0x8(%esp)
  8017ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d2:	c7 04 24 c0 27 80 00 	movl   $0x8027c0,(%esp)
  8017d9:	e8 c1 00 00 00       	call   80189f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8017de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e5:	89 04 24             	mov    %eax,(%esp)
  8017e8:	e8 51 00 00 00       	call   80183e <vcprintf>
	cprintf("\n");
  8017ed:	c7 04 24 ac 27 80 00 	movl   $0x8027ac,(%esp)
  8017f4:	e8 a6 00 00 00       	call   80189f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8017f9:	cc                   	int3   
  8017fa:	eb fd                	jmp    8017f9 <_panic+0x53>

008017fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	53                   	push   %ebx
  801800:	83 ec 14             	sub    $0x14,%esp
  801803:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801806:	8b 13                	mov    (%ebx),%edx
  801808:	8d 42 01             	lea    0x1(%edx),%eax
  80180b:	89 03                	mov    %eax,(%ebx)
  80180d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801810:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801814:	3d ff 00 00 00       	cmp    $0xff,%eax
  801819:	75 19                	jne    801834 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80181b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801822:	00 
  801823:	8d 43 08             	lea    0x8(%ebx),%eax
  801826:	89 04 24             	mov    %eax,(%esp)
  801829:	e8 96 e8 ff ff       	call   8000c4 <sys_cputs>
		b->idx = 0;
  80182e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801834:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801838:	83 c4 14             	add    $0x14,%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5d                   	pop    %ebp
  80183d:	c3                   	ret    

0080183e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801847:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80184e:	00 00 00 
	b.cnt = 0;
  801851:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801858:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80185b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	89 44 24 08          	mov    %eax,0x8(%esp)
  801869:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80186f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801873:	c7 04 24 fc 17 80 00 	movl   $0x8017fc,(%esp)
  80187a:	e8 af 01 00 00       	call   801a2e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80187f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801885:	89 44 24 04          	mov    %eax,0x4(%esp)
  801889:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80188f:	89 04 24             	mov    %eax,(%esp)
  801892:	e8 2d e8 ff ff       	call   8000c4 <sys_cputs>

	return b.cnt;
}
  801897:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8018a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8018a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	89 04 24             	mov    %eax,(%esp)
  8018b2:	e8 87 ff ff ff       	call   80183e <vcprintf>
	va_end(ap);

	return cnt;
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    
  8018b9:	66 90                	xchg   %ax,%ax
  8018bb:	66 90                	xchg   %ax,%ax
  8018bd:	66 90                	xchg   %ax,%ax
  8018bf:	90                   	nop

008018c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	57                   	push   %edi
  8018c4:	56                   	push   %esi
  8018c5:	53                   	push   %ebx
  8018c6:	83 ec 3c             	sub    $0x3c,%esp
  8018c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018cc:	89 d7                	mov    %edx,%edi
  8018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8018d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d7:	89 c3                	mov    %eax,%ebx
  8018d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8018dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8018df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8018ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8018ed:	39 d9                	cmp    %ebx,%ecx
  8018ef:	72 05                	jb     8018f6 <printnum+0x36>
  8018f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8018f4:	77 69                	ja     80195f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8018f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8018fd:	83 ee 01             	sub    $0x1,%esi
  801900:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801904:	89 44 24 08          	mov    %eax,0x8(%esp)
  801908:	8b 44 24 08          	mov    0x8(%esp),%eax
  80190c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801910:	89 c3                	mov    %eax,%ebx
  801912:	89 d6                	mov    %edx,%esi
  801914:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801917:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80191a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80191e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801922:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801925:	89 04 24             	mov    %eax,(%esp)
  801928:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80192b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192f:	e8 9c 0a 00 00       	call   8023d0 <__udivdi3>
  801934:	89 d9                	mov    %ebx,%ecx
  801936:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80193a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80193e:	89 04 24             	mov    %eax,(%esp)
  801941:	89 54 24 04          	mov    %edx,0x4(%esp)
  801945:	89 fa                	mov    %edi,%edx
  801947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80194a:	e8 71 ff ff ff       	call   8018c0 <printnum>
  80194f:	eb 1b                	jmp    80196c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801951:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801955:	8b 45 18             	mov    0x18(%ebp),%eax
  801958:	89 04 24             	mov    %eax,(%esp)
  80195b:	ff d3                	call   *%ebx
  80195d:	eb 03                	jmp    801962 <printnum+0xa2>
  80195f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801962:	83 ee 01             	sub    $0x1,%esi
  801965:	85 f6                	test   %esi,%esi
  801967:	7f e8                	jg     801951 <printnum+0x91>
  801969:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80196c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801970:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801974:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801977:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80197a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80197e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801982:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801985:	89 04 24             	mov    %eax,(%esp)
  801988:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80198b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198f:	e8 6c 0b 00 00       	call   802500 <__umoddi3>
  801994:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801998:	0f be 80 e3 27 80 00 	movsbl 0x8027e3(%eax),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019a5:	ff d0                	call   *%eax
}
  8019a7:	83 c4 3c             	add    $0x3c,%esp
  8019aa:	5b                   	pop    %ebx
  8019ab:	5e                   	pop    %esi
  8019ac:	5f                   	pop    %edi
  8019ad:	5d                   	pop    %ebp
  8019ae:	c3                   	ret    

008019af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019b2:	83 fa 01             	cmp    $0x1,%edx
  8019b5:	7e 0e                	jle    8019c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8019b7:	8b 10                	mov    (%eax),%edx
  8019b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8019bc:	89 08                	mov    %ecx,(%eax)
  8019be:	8b 02                	mov    (%edx),%eax
  8019c0:	8b 52 04             	mov    0x4(%edx),%edx
  8019c3:	eb 22                	jmp    8019e7 <getuint+0x38>
	else if (lflag)
  8019c5:	85 d2                	test   %edx,%edx
  8019c7:	74 10                	je     8019d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8019c9:	8b 10                	mov    (%eax),%edx
  8019cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8019ce:	89 08                	mov    %ecx,(%eax)
  8019d0:	8b 02                	mov    (%edx),%eax
  8019d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d7:	eb 0e                	jmp    8019e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8019d9:	8b 10                	mov    (%eax),%edx
  8019db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8019de:	89 08                	mov    %ecx,(%eax)
  8019e0:	8b 02                	mov    (%edx),%eax
  8019e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019e7:	5d                   	pop    %ebp
  8019e8:	c3                   	ret    

008019e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
  8019ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8019ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8019f3:	8b 10                	mov    (%eax),%edx
  8019f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8019f8:	73 0a                	jae    801a04 <sprintputch+0x1b>
		*b->buf++ = ch;
  8019fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8019fd:	89 08                	mov    %ecx,(%eax)
  8019ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801a02:	88 02                	mov    %al,(%edx)
}
  801a04:	5d                   	pop    %ebp
  801a05:	c3                   	ret    

00801a06 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801a0c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a13:	8b 45 10             	mov    0x10(%ebp),%eax
  801a16:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	e8 02 00 00 00       	call   801a2e <vprintfmt>
	va_end(ap);
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	57                   	push   %edi
  801a32:	56                   	push   %esi
  801a33:	53                   	push   %ebx
  801a34:	83 ec 3c             	sub    $0x3c,%esp
  801a37:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a3d:	eb 14                	jmp    801a53 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	0f 84 b3 03 00 00    	je     801dfa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  801a47:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a4b:	89 04 24             	mov    %eax,(%esp)
  801a4e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a51:	89 f3                	mov    %esi,%ebx
  801a53:	8d 73 01             	lea    0x1(%ebx),%esi
  801a56:	0f b6 03             	movzbl (%ebx),%eax
  801a59:	83 f8 25             	cmp    $0x25,%eax
  801a5c:	75 e1                	jne    801a3f <vprintfmt+0x11>
  801a5e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  801a62:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801a69:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  801a70:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  801a77:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7c:	eb 1d                	jmp    801a9b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a7e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  801a80:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  801a84:	eb 15                	jmp    801a9b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a86:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a88:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  801a8c:	eb 0d                	jmp    801a9b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801a8e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a91:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a94:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a9b:	8d 5e 01             	lea    0x1(%esi),%ebx
  801a9e:	0f b6 0e             	movzbl (%esi),%ecx
  801aa1:	0f b6 c1             	movzbl %cl,%eax
  801aa4:	83 e9 23             	sub    $0x23,%ecx
  801aa7:	80 f9 55             	cmp    $0x55,%cl
  801aaa:	0f 87 2a 03 00 00    	ja     801dda <vprintfmt+0x3ac>
  801ab0:	0f b6 c9             	movzbl %cl,%ecx
  801ab3:	ff 24 8d 20 29 80 00 	jmp    *0x802920(,%ecx,4)
  801aba:	89 de                	mov    %ebx,%esi
  801abc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801ac1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801ac4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801ac8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801acb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  801ace:	83 fb 09             	cmp    $0x9,%ebx
  801ad1:	77 36                	ja     801b09 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801ad3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ad6:	eb e9                	jmp    801ac1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ad8:	8b 45 14             	mov    0x14(%ebp),%eax
  801adb:	8d 48 04             	lea    0x4(%eax),%ecx
  801ade:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801ae1:	8b 00                	mov    (%eax),%eax
  801ae3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ae6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801ae8:	eb 22                	jmp    801b0c <vprintfmt+0xde>
  801aea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801aed:	85 c9                	test   %ecx,%ecx
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
  801af4:	0f 49 c1             	cmovns %ecx,%eax
  801af7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801afa:	89 de                	mov    %ebx,%esi
  801afc:	eb 9d                	jmp    801a9b <vprintfmt+0x6d>
  801afe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801b00:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  801b07:	eb 92                	jmp    801a9b <vprintfmt+0x6d>
  801b09:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  801b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801b10:	79 89                	jns    801a9b <vprintfmt+0x6d>
  801b12:	e9 77 ff ff ff       	jmp    801a8e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b17:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b1a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801b1c:	e9 7a ff ff ff       	jmp    801a9b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b21:	8b 45 14             	mov    0x14(%ebp),%eax
  801b24:	8d 50 04             	lea    0x4(%eax),%edx
  801b27:	89 55 14             	mov    %edx,0x14(%ebp)
  801b2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b2e:	8b 00                	mov    (%eax),%eax
  801b30:	89 04 24             	mov    %eax,(%esp)
  801b33:	ff 55 08             	call   *0x8(%ebp)
			break;
  801b36:	e9 18 ff ff ff       	jmp    801a53 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b3b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b3e:	8d 50 04             	lea    0x4(%eax),%edx
  801b41:	89 55 14             	mov    %edx,0x14(%ebp)
  801b44:	8b 00                	mov    (%eax),%eax
  801b46:	99                   	cltd   
  801b47:	31 d0                	xor    %edx,%eax
  801b49:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b4b:	83 f8 0f             	cmp    $0xf,%eax
  801b4e:	7f 0b                	jg     801b5b <vprintfmt+0x12d>
  801b50:	8b 14 85 80 2a 80 00 	mov    0x802a80(,%eax,4),%edx
  801b57:	85 d2                	test   %edx,%edx
  801b59:	75 20                	jne    801b7b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  801b5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b5f:	c7 44 24 08 fb 27 80 	movl   $0x8027fb,0x8(%esp)
  801b66:	00 
  801b67:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	89 04 24             	mov    %eax,(%esp)
  801b71:	e8 90 fe ff ff       	call   801a06 <printfmt>
  801b76:	e9 d8 fe ff ff       	jmp    801a53 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  801b7b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801b7f:	c7 44 24 08 41 27 80 	movl   $0x802741,0x8(%esp)
  801b86:	00 
  801b87:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 70 fe ff ff       	call   801a06 <printfmt>
  801b96:	e9 b8 fe ff ff       	jmp    801a53 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801b9b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801b9e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ba1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801ba4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba7:	8d 50 04             	lea    0x4(%eax),%edx
  801baa:	89 55 14             	mov    %edx,0x14(%ebp)
  801bad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  801baf:	85 f6                	test   %esi,%esi
  801bb1:	b8 f4 27 80 00       	mov    $0x8027f4,%eax
  801bb6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  801bb9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  801bbd:	0f 84 97 00 00 00    	je     801c5a <vprintfmt+0x22c>
  801bc3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801bc7:	0f 8e 9b 00 00 00    	jle    801c68 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bcd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bd1:	89 34 24             	mov    %esi,(%esp)
  801bd4:	e8 cf 02 00 00       	call   801ea8 <strnlen>
  801bd9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801bdc:	29 c2                	sub    %eax,%edx
  801bde:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  801be1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  801be5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801be8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801beb:	8b 75 08             	mov    0x8(%ebp),%esi
  801bee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801bf1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bf3:	eb 0f                	jmp    801c04 <vprintfmt+0x1d6>
					putch(padc, putdat);
  801bf5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bfc:	89 04 24             	mov    %eax,(%esp)
  801bff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801c01:	83 eb 01             	sub    $0x1,%ebx
  801c04:	85 db                	test   %ebx,%ebx
  801c06:	7f ed                	jg     801bf5 <vprintfmt+0x1c7>
  801c08:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801c0b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c0e:	85 d2                	test   %edx,%edx
  801c10:	b8 00 00 00 00       	mov    $0x0,%eax
  801c15:	0f 49 c2             	cmovns %edx,%eax
  801c18:	29 c2                	sub    %eax,%edx
  801c1a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c1d:	89 d7                	mov    %edx,%edi
  801c1f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c22:	eb 50                	jmp    801c74 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801c24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c28:	74 1e                	je     801c48 <vprintfmt+0x21a>
  801c2a:	0f be d2             	movsbl %dl,%edx
  801c2d:	83 ea 20             	sub    $0x20,%edx
  801c30:	83 fa 5e             	cmp    $0x5e,%edx
  801c33:	76 13                	jbe    801c48 <vprintfmt+0x21a>
					putch('?', putdat);
  801c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801c43:	ff 55 08             	call   *0x8(%ebp)
  801c46:	eb 0d                	jmp    801c55 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  801c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4b:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c4f:	89 04 24             	mov    %eax,(%esp)
  801c52:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c55:	83 ef 01             	sub    $0x1,%edi
  801c58:	eb 1a                	jmp    801c74 <vprintfmt+0x246>
  801c5a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c5d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c60:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c63:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c66:	eb 0c                	jmp    801c74 <vprintfmt+0x246>
  801c68:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801c6b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801c6e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801c71:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801c74:	83 c6 01             	add    $0x1,%esi
  801c77:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801c7b:	0f be c2             	movsbl %dl,%eax
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	74 27                	je     801ca9 <vprintfmt+0x27b>
  801c82:	85 db                	test   %ebx,%ebx
  801c84:	78 9e                	js     801c24 <vprintfmt+0x1f6>
  801c86:	83 eb 01             	sub    $0x1,%ebx
  801c89:	79 99                	jns    801c24 <vprintfmt+0x1f6>
  801c8b:	89 f8                	mov    %edi,%eax
  801c8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c90:	8b 75 08             	mov    0x8(%ebp),%esi
  801c93:	89 c3                	mov    %eax,%ebx
  801c95:	eb 1a                	jmp    801cb1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801c97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c9b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801ca2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ca4:	83 eb 01             	sub    $0x1,%ebx
  801ca7:	eb 08                	jmp    801cb1 <vprintfmt+0x283>
  801ca9:	89 fb                	mov    %edi,%ebx
  801cab:	8b 75 08             	mov    0x8(%ebp),%esi
  801cae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801cb1:	85 db                	test   %ebx,%ebx
  801cb3:	7f e2                	jg     801c97 <vprintfmt+0x269>
  801cb5:	89 75 08             	mov    %esi,0x8(%ebp)
  801cb8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cbb:	e9 93 fd ff ff       	jmp    801a53 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801cc0:	83 fa 01             	cmp    $0x1,%edx
  801cc3:	7e 16                	jle    801cdb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  801cc5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc8:	8d 50 08             	lea    0x8(%eax),%edx
  801ccb:	89 55 14             	mov    %edx,0x14(%ebp)
  801cce:	8b 50 04             	mov    0x4(%eax),%edx
  801cd1:	8b 00                	mov    (%eax),%eax
  801cd3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801cd6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801cd9:	eb 32                	jmp    801d0d <vprintfmt+0x2df>
	else if (lflag)
  801cdb:	85 d2                	test   %edx,%edx
  801cdd:	74 18                	je     801cf7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  801cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce2:	8d 50 04             	lea    0x4(%eax),%edx
  801ce5:	89 55 14             	mov    %edx,0x14(%ebp)
  801ce8:	8b 30                	mov    (%eax),%esi
  801cea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801ced:	89 f0                	mov    %esi,%eax
  801cef:	c1 f8 1f             	sar    $0x1f,%eax
  801cf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cf5:	eb 16                	jmp    801d0d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  801cf7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cfa:	8d 50 04             	lea    0x4(%eax),%edx
  801cfd:	89 55 14             	mov    %edx,0x14(%ebp)
  801d00:	8b 30                	mov    (%eax),%esi
  801d02:	89 75 e0             	mov    %esi,-0x20(%ebp)
  801d05:	89 f0                	mov    %esi,%eax
  801d07:	c1 f8 1f             	sar    $0x1f,%eax
  801d0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801d0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801d13:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801d18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d1c:	0f 89 80 00 00 00    	jns    801da2 <vprintfmt+0x374>
				putch('-', putdat);
  801d22:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d26:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801d2d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801d30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d36:	f7 d8                	neg    %eax
  801d38:	83 d2 00             	adc    $0x0,%edx
  801d3b:	f7 da                	neg    %edx
			}
			base = 10;
  801d3d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801d42:	eb 5e                	jmp    801da2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801d44:	8d 45 14             	lea    0x14(%ebp),%eax
  801d47:	e8 63 fc ff ff       	call   8019af <getuint>
			base = 10;
  801d4c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801d51:	eb 4f                	jmp    801da2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  801d53:	8d 45 14             	lea    0x14(%ebp),%eax
  801d56:	e8 54 fc ff ff       	call   8019af <getuint>
			base =8;
  801d5b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801d60:	eb 40                	jmp    801da2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  801d62:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d66:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801d6d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801d70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d74:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801d7b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801d7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d81:	8d 50 04             	lea    0x4(%eax),%edx
  801d84:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d87:	8b 00                	mov    (%eax),%eax
  801d89:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801d8e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801d93:	eb 0d                	jmp    801da2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d95:	8d 45 14             	lea    0x14(%ebp),%eax
  801d98:	e8 12 fc ff ff       	call   8019af <getuint>
			base = 16;
  801d9d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801da2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  801da6:	89 74 24 10          	mov    %esi,0x10(%esp)
  801daa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  801dad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801db1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801db5:	89 04 24             	mov    %eax,(%esp)
  801db8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dbc:	89 fa                	mov    %edi,%edx
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	e8 fa fa ff ff       	call   8018c0 <printnum>
			break;
  801dc6:	e9 88 fc ff ff       	jmp    801a53 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801dcb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dcf:	89 04 24             	mov    %eax,(%esp)
  801dd2:	ff 55 08             	call   *0x8(%ebp)
			break;
  801dd5:	e9 79 fc ff ff       	jmp    801a53 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801dda:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dde:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801de5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801de8:	89 f3                	mov    %esi,%ebx
  801dea:	eb 03                	jmp    801def <vprintfmt+0x3c1>
  801dec:	83 eb 01             	sub    $0x1,%ebx
  801def:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801df3:	75 f7                	jne    801dec <vprintfmt+0x3be>
  801df5:	e9 59 fc ff ff       	jmp    801a53 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  801dfa:	83 c4 3c             	add    $0x3c,%esp
  801dfd:	5b                   	pop    %ebx
  801dfe:	5e                   	pop    %esi
  801dff:	5f                   	pop    %edi
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 28             	sub    $0x28,%esp
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e11:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801e15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e1f:	85 c0                	test   %eax,%eax
  801e21:	74 30                	je     801e53 <vsnprintf+0x51>
  801e23:	85 d2                	test   %edx,%edx
  801e25:	7e 2c                	jle    801e53 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e27:	8b 45 14             	mov    0x14(%ebp),%eax
  801e2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e31:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3c:	c7 04 24 e9 19 80 00 	movl   $0x8019e9,(%esp)
  801e43:	e8 e6 fb ff ff       	call   801a2e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e4b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	eb 05                	jmp    801e58 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801e53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e60:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801e63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e67:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	89 04 24             	mov    %eax,(%esp)
  801e7b:	e8 82 ff ff ff       	call   801e02 <vsnprintf>
	va_end(ap);

	return rc;
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    
  801e82:	66 90                	xchg   %ax,%ax
  801e84:	66 90                	xchg   %ax,%ax
  801e86:	66 90                	xchg   %ax,%ax
  801e88:	66 90                	xchg   %ax,%ax
  801e8a:	66 90                	xchg   %ax,%ax
  801e8c:	66 90                	xchg   %ax,%ax
  801e8e:	66 90                	xchg   %ax,%ax

00801e90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	eb 03                	jmp    801ea0 <strlen+0x10>
		n++;
  801e9d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ea0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801ea4:	75 f7                	jne    801e9d <strlen+0xd>
		n++;
	return n;
}
  801ea6:	5d                   	pop    %ebp
  801ea7:	c3                   	ret    

00801ea8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb6:	eb 03                	jmp    801ebb <strnlen+0x13>
		n++;
  801eb8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801ebb:	39 d0                	cmp    %edx,%eax
  801ebd:	74 06                	je     801ec5 <strnlen+0x1d>
  801ebf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801ec3:	75 f3                	jne    801eb8 <strnlen+0x10>
		n++;
	return n;
}
  801ec5:	5d                   	pop    %ebp
  801ec6:	c3                   	ret    

00801ec7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	53                   	push   %ebx
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801ed1:	89 c2                	mov    %eax,%edx
  801ed3:	83 c2 01             	add    $0x1,%edx
  801ed6:	83 c1 01             	add    $0x1,%ecx
  801ed9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801edd:	88 5a ff             	mov    %bl,-0x1(%edx)
  801ee0:	84 db                	test   %bl,%bl
  801ee2:	75 ef                	jne    801ed3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801ee4:	5b                   	pop    %ebx
  801ee5:	5d                   	pop    %ebp
  801ee6:	c3                   	ret    

00801ee7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	53                   	push   %ebx
  801eeb:	83 ec 08             	sub    $0x8,%esp
  801eee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801ef1:	89 1c 24             	mov    %ebx,(%esp)
  801ef4:	e8 97 ff ff ff       	call   801e90 <strlen>
	strcpy(dst + len, src);
  801ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efc:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f00:	01 d8                	add    %ebx,%eax
  801f02:	89 04 24             	mov    %eax,(%esp)
  801f05:	e8 bd ff ff ff       	call   801ec7 <strcpy>
	return dst;
}
  801f0a:	89 d8                	mov    %ebx,%eax
  801f0c:	83 c4 08             	add    $0x8,%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5d                   	pop    %ebp
  801f11:	c3                   	ret    

00801f12 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	56                   	push   %esi
  801f16:	53                   	push   %ebx
  801f17:	8b 75 08             	mov    0x8(%ebp),%esi
  801f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f1d:	89 f3                	mov    %esi,%ebx
  801f1f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f22:	89 f2                	mov    %esi,%edx
  801f24:	eb 0f                	jmp    801f35 <strncpy+0x23>
		*dst++ = *src;
  801f26:	83 c2 01             	add    $0x1,%edx
  801f29:	0f b6 01             	movzbl (%ecx),%eax
  801f2c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801f2f:	80 39 01             	cmpb   $0x1,(%ecx)
  801f32:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f35:	39 da                	cmp    %ebx,%edx
  801f37:	75 ed                	jne    801f26 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801f39:	89 f0                	mov    %esi,%eax
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5d                   	pop    %ebp
  801f3e:	c3                   	ret    

00801f3f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	56                   	push   %esi
  801f43:	53                   	push   %ebx
  801f44:	8b 75 08             	mov    0x8(%ebp),%esi
  801f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f4d:	89 f0                	mov    %esi,%eax
  801f4f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801f53:	85 c9                	test   %ecx,%ecx
  801f55:	75 0b                	jne    801f62 <strlcpy+0x23>
  801f57:	eb 1d                	jmp    801f76 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801f59:	83 c0 01             	add    $0x1,%eax
  801f5c:	83 c2 01             	add    $0x1,%edx
  801f5f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801f62:	39 d8                	cmp    %ebx,%eax
  801f64:	74 0b                	je     801f71 <strlcpy+0x32>
  801f66:	0f b6 0a             	movzbl (%edx),%ecx
  801f69:	84 c9                	test   %cl,%cl
  801f6b:	75 ec                	jne    801f59 <strlcpy+0x1a>
  801f6d:	89 c2                	mov    %eax,%edx
  801f6f:	eb 02                	jmp    801f73 <strlcpy+0x34>
  801f71:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  801f73:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  801f76:	29 f0                	sub    %esi,%eax
}
  801f78:	5b                   	pop    %ebx
  801f79:	5e                   	pop    %esi
  801f7a:	5d                   	pop    %ebp
  801f7b:	c3                   	ret    

00801f7c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f82:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801f85:	eb 06                	jmp    801f8d <strcmp+0x11>
		p++, q++;
  801f87:	83 c1 01             	add    $0x1,%ecx
  801f8a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801f8d:	0f b6 01             	movzbl (%ecx),%eax
  801f90:	84 c0                	test   %al,%al
  801f92:	74 04                	je     801f98 <strcmp+0x1c>
  801f94:	3a 02                	cmp    (%edx),%al
  801f96:	74 ef                	je     801f87 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801f98:	0f b6 c0             	movzbl %al,%eax
  801f9b:	0f b6 12             	movzbl (%edx),%edx
  801f9e:	29 d0                	sub    %edx,%eax
}
  801fa0:	5d                   	pop    %ebp
  801fa1:	c3                   	ret    

00801fa2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	53                   	push   %ebx
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	89 c3                	mov    %eax,%ebx
  801fae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801fb1:	eb 06                	jmp    801fb9 <strncmp+0x17>
		n--, p++, q++;
  801fb3:	83 c0 01             	add    $0x1,%eax
  801fb6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801fb9:	39 d8                	cmp    %ebx,%eax
  801fbb:	74 15                	je     801fd2 <strncmp+0x30>
  801fbd:	0f b6 08             	movzbl (%eax),%ecx
  801fc0:	84 c9                	test   %cl,%cl
  801fc2:	74 04                	je     801fc8 <strncmp+0x26>
  801fc4:	3a 0a                	cmp    (%edx),%cl
  801fc6:	74 eb                	je     801fb3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801fc8:	0f b6 00             	movzbl (%eax),%eax
  801fcb:	0f b6 12             	movzbl (%edx),%edx
  801fce:	29 d0                	sub    %edx,%eax
  801fd0:	eb 05                	jmp    801fd7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801fd7:	5b                   	pop    %ebx
  801fd8:	5d                   	pop    %ebp
  801fd9:	c3                   	ret    

00801fda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801fe4:	eb 07                	jmp    801fed <strchr+0x13>
		if (*s == c)
  801fe6:	38 ca                	cmp    %cl,%dl
  801fe8:	74 0f                	je     801ff9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801fea:	83 c0 01             	add    $0x1,%eax
  801fed:	0f b6 10             	movzbl (%eax),%edx
  801ff0:	84 d2                	test   %dl,%dl
  801ff2:	75 f2                	jne    801fe6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  801ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff9:	5d                   	pop    %ebp
  801ffa:	c3                   	ret    

00801ffb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802005:	eb 07                	jmp    80200e <strfind+0x13>
		if (*s == c)
  802007:	38 ca                	cmp    %cl,%dl
  802009:	74 0a                	je     802015 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80200b:	83 c0 01             	add    $0x1,%eax
  80200e:	0f b6 10             	movzbl (%eax),%edx
  802011:	84 d2                	test   %dl,%dl
  802013:	75 f2                	jne    802007 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802015:	5d                   	pop    %ebp
  802016:	c3                   	ret    

00802017 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	57                   	push   %edi
  80201b:	56                   	push   %esi
  80201c:	53                   	push   %ebx
  80201d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802020:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802023:	85 c9                	test   %ecx,%ecx
  802025:	74 36                	je     80205d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802027:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80202d:	75 28                	jne    802057 <memset+0x40>
  80202f:	f6 c1 03             	test   $0x3,%cl
  802032:	75 23                	jne    802057 <memset+0x40>
		c &= 0xFF;
  802034:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802038:	89 d3                	mov    %edx,%ebx
  80203a:	c1 e3 08             	shl    $0x8,%ebx
  80203d:	89 d6                	mov    %edx,%esi
  80203f:	c1 e6 18             	shl    $0x18,%esi
  802042:	89 d0                	mov    %edx,%eax
  802044:	c1 e0 10             	shl    $0x10,%eax
  802047:	09 f0                	or     %esi,%eax
  802049:	09 c2                	or     %eax,%edx
  80204b:	89 d0                	mov    %edx,%eax
  80204d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80204f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802052:	fc                   	cld    
  802053:	f3 ab                	rep stos %eax,%es:(%edi)
  802055:	eb 06                	jmp    80205d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205a:	fc                   	cld    
  80205b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80205d:	89 f8                	mov    %edi,%eax
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5f                   	pop    %edi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    

00802064 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	57                   	push   %edi
  802068:	56                   	push   %esi
  802069:	8b 45 08             	mov    0x8(%ebp),%eax
  80206c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80206f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802072:	39 c6                	cmp    %eax,%esi
  802074:	73 35                	jae    8020ab <memmove+0x47>
  802076:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802079:	39 d0                	cmp    %edx,%eax
  80207b:	73 2e                	jae    8020ab <memmove+0x47>
		s += n;
		d += n;
  80207d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  802080:	89 d6                	mov    %edx,%esi
  802082:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802084:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80208a:	75 13                	jne    80209f <memmove+0x3b>
  80208c:	f6 c1 03             	test   $0x3,%cl
  80208f:	75 0e                	jne    80209f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  802091:	83 ef 04             	sub    $0x4,%edi
  802094:	8d 72 fc             	lea    -0x4(%edx),%esi
  802097:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80209a:	fd                   	std    
  80209b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80209d:	eb 09                	jmp    8020a8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80209f:	83 ef 01             	sub    $0x1,%edi
  8020a2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8020a5:	fd                   	std    
  8020a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8020a8:	fc                   	cld    
  8020a9:	eb 1d                	jmp    8020c8 <memmove+0x64>
  8020ab:	89 f2                	mov    %esi,%edx
  8020ad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8020af:	f6 c2 03             	test   $0x3,%dl
  8020b2:	75 0f                	jne    8020c3 <memmove+0x5f>
  8020b4:	f6 c1 03             	test   $0x3,%cl
  8020b7:	75 0a                	jne    8020c3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8020b9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8020bc:	89 c7                	mov    %eax,%edi
  8020be:	fc                   	cld    
  8020bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8020c1:	eb 05                	jmp    8020c8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8020c3:	89 c7                	mov    %eax,%edi
  8020c5:	fc                   	cld    
  8020c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    

008020cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8020d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	89 04 24             	mov    %eax,(%esp)
  8020e6:	e8 79 ff ff ff       	call   802064 <memmove>
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	56                   	push   %esi
  8020f1:	53                   	push   %ebx
  8020f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020f8:	89 d6                	mov    %edx,%esi
  8020fa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8020fd:	eb 1a                	jmp    802119 <memcmp+0x2c>
		if (*s1 != *s2)
  8020ff:	0f b6 02             	movzbl (%edx),%eax
  802102:	0f b6 19             	movzbl (%ecx),%ebx
  802105:	38 d8                	cmp    %bl,%al
  802107:	74 0a                	je     802113 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802109:	0f b6 c0             	movzbl %al,%eax
  80210c:	0f b6 db             	movzbl %bl,%ebx
  80210f:	29 d8                	sub    %ebx,%eax
  802111:	eb 0f                	jmp    802122 <memcmp+0x35>
		s1++, s2++;
  802113:	83 c2 01             	add    $0x1,%edx
  802116:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802119:	39 f2                	cmp    %esi,%edx
  80211b:	75 e2                	jne    8020ff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80211d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802122:	5b                   	pop    %ebx
  802123:	5e                   	pop    %esi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    

00802126 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80212f:	89 c2                	mov    %eax,%edx
  802131:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802134:	eb 07                	jmp    80213d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802136:	38 08                	cmp    %cl,(%eax)
  802138:	74 07                	je     802141 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80213a:	83 c0 01             	add    $0x1,%eax
  80213d:	39 d0                	cmp    %edx,%eax
  80213f:	72 f5                	jb     802136 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802141:	5d                   	pop    %ebp
  802142:	c3                   	ret    

00802143 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	57                   	push   %edi
  802147:	56                   	push   %esi
  802148:	53                   	push   %ebx
  802149:	8b 55 08             	mov    0x8(%ebp),%edx
  80214c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80214f:	eb 03                	jmp    802154 <strtol+0x11>
		s++;
  802151:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802154:	0f b6 0a             	movzbl (%edx),%ecx
  802157:	80 f9 09             	cmp    $0x9,%cl
  80215a:	74 f5                	je     802151 <strtol+0xe>
  80215c:	80 f9 20             	cmp    $0x20,%cl
  80215f:	74 f0                	je     802151 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802161:	80 f9 2b             	cmp    $0x2b,%cl
  802164:	75 0a                	jne    802170 <strtol+0x2d>
		s++;
  802166:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802169:	bf 00 00 00 00       	mov    $0x0,%edi
  80216e:	eb 11                	jmp    802181 <strtol+0x3e>
  802170:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  802175:	80 f9 2d             	cmp    $0x2d,%cl
  802178:	75 07                	jne    802181 <strtol+0x3e>
		s++, neg = 1;
  80217a:	8d 52 01             	lea    0x1(%edx),%edx
  80217d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802181:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  802186:	75 15                	jne    80219d <strtol+0x5a>
  802188:	80 3a 30             	cmpb   $0x30,(%edx)
  80218b:	75 10                	jne    80219d <strtol+0x5a>
  80218d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802191:	75 0a                	jne    80219d <strtol+0x5a>
		s += 2, base = 16;
  802193:	83 c2 02             	add    $0x2,%edx
  802196:	b8 10 00 00 00       	mov    $0x10,%eax
  80219b:	eb 10                	jmp    8021ad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  80219d:	85 c0                	test   %eax,%eax
  80219f:	75 0c                	jne    8021ad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8021a1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8021a3:	80 3a 30             	cmpb   $0x30,(%edx)
  8021a6:	75 05                	jne    8021ad <strtol+0x6a>
		s++, base = 8;
  8021a8:	83 c2 01             	add    $0x1,%edx
  8021ab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8021ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021b2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8021b5:	0f b6 0a             	movzbl (%edx),%ecx
  8021b8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8021bb:	89 f0                	mov    %esi,%eax
  8021bd:	3c 09                	cmp    $0x9,%al
  8021bf:	77 08                	ja     8021c9 <strtol+0x86>
			dig = *s - '0';
  8021c1:	0f be c9             	movsbl %cl,%ecx
  8021c4:	83 e9 30             	sub    $0x30,%ecx
  8021c7:	eb 20                	jmp    8021e9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8021c9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8021cc:	89 f0                	mov    %esi,%eax
  8021ce:	3c 19                	cmp    $0x19,%al
  8021d0:	77 08                	ja     8021da <strtol+0x97>
			dig = *s - 'a' + 10;
  8021d2:	0f be c9             	movsbl %cl,%ecx
  8021d5:	83 e9 57             	sub    $0x57,%ecx
  8021d8:	eb 0f                	jmp    8021e9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  8021da:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8021dd:	89 f0                	mov    %esi,%eax
  8021df:	3c 19                	cmp    $0x19,%al
  8021e1:	77 16                	ja     8021f9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  8021e3:	0f be c9             	movsbl %cl,%ecx
  8021e6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8021e9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8021ec:	7d 0f                	jge    8021fd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  8021ee:	83 c2 01             	add    $0x1,%edx
  8021f1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8021f5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8021f7:	eb bc                	jmp    8021b5 <strtol+0x72>
  8021f9:	89 d8                	mov    %ebx,%eax
  8021fb:	eb 02                	jmp    8021ff <strtol+0xbc>
  8021fd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8021ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802203:	74 05                	je     80220a <strtol+0xc7>
		*endptr = (char *) s;
  802205:	8b 75 0c             	mov    0xc(%ebp),%esi
  802208:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80220a:	f7 d8                	neg    %eax
  80220c:	85 ff                	test   %edi,%edi
  80220e:	0f 44 c3             	cmove  %ebx,%eax
}
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5f                   	pop    %edi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    

00802216 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80221c:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802223:	75 58                	jne    80227d <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802225:	a1 08 40 80 00       	mov    0x804008,%eax
  80222a:	8b 40 48             	mov    0x48(%eax),%eax
  80222d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802234:	00 
  802235:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80223c:	ee 
  80223d:	89 04 24             	mov    %eax,(%esp)
  802240:	e8 4c df ff ff       	call   800191 <sys_page_alloc>
		if(return_code!=0)
  802245:	85 c0                	test   %eax,%eax
  802247:	74 1c                	je     802265 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802249:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  802250:	00 
  802251:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802258:	00 
  802259:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  802260:	e8 41 f5 ff ff       	call   8017a6 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802265:	a1 08 40 80 00       	mov    0x804008,%eax
  80226a:	8b 40 48             	mov    0x48(%eax),%eax
  80226d:	c7 44 24 04 be 04 80 	movl   $0x8004be,0x4(%esp)
  802274:	00 
  802275:	89 04 24             	mov    %eax,(%esp)
  802278:	e8 b4 e0 ff ff       	call   800331 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	56                   	push   %esi
  80228b:	53                   	push   %ebx
  80228c:	83 ec 10             	sub    $0x10,%esp
  80228f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802292:	8b 45 0c             	mov    0xc(%ebp),%eax
  802295:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  802298:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  80229a:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  80229f:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8022a2:	89 04 24             	mov    %eax,(%esp)
  8022a5:	e8 fd e0 ff ff       	call   8003a7 <sys_ipc_recv>
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	75 1e                	jne    8022cc <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8022ae:	85 db                	test   %ebx,%ebx
  8022b0:	74 0a                	je     8022bc <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8022b2:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b7:	8b 40 74             	mov    0x74(%eax),%eax
  8022ba:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8022bc:	85 f6                	test   %esi,%esi
  8022be:	74 22                	je     8022e2 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8022c0:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c5:	8b 40 78             	mov    0x78(%eax),%eax
  8022c8:	89 06                	mov    %eax,(%esi)
  8022ca:	eb 16                	jmp    8022e2 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8022cc:	85 f6                	test   %esi,%esi
  8022ce:	74 06                	je     8022d6 <ipc_recv+0x4f>
				*perm_store = 0;
  8022d0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8022d6:	85 db                	test   %ebx,%ebx
  8022d8:	74 10                	je     8022ea <ipc_recv+0x63>
				*from_env_store=0;
  8022da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022e0:	eb 08                	jmp    8022ea <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8022e2:	a1 08 40 80 00       	mov    0x804008,%eax
  8022e7:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8022ea:	83 c4 10             	add    $0x10,%esp
  8022ed:	5b                   	pop    %ebx
  8022ee:	5e                   	pop    %esi
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    

008022f1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	57                   	push   %edi
  8022f5:	56                   	push   %esi
  8022f6:	53                   	push   %ebx
  8022f7:	83 ec 1c             	sub    $0x1c,%esp
  8022fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802300:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802303:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802305:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  80230a:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80230d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802311:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802315:	89 74 24 04          	mov    %esi,0x4(%esp)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	89 04 24             	mov    %eax,(%esp)
  80231f:	e8 60 e0 ff ff       	call   800384 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802324:	eb 1c                	jmp    802342 <ipc_send+0x51>
	{
		sys_yield();
  802326:	e8 47 de ff ff       	call   800172 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80232b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80232f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802333:	89 74 24 04          	mov    %esi,0x4(%esp)
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	89 04 24             	mov    %eax,(%esp)
  80233d:	e8 42 e0 ff ff       	call   800384 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802342:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802345:	74 df                	je     802326 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802347:	83 c4 1c             	add    $0x1c,%esp
  80234a:	5b                   	pop    %ebx
  80234b:	5e                   	pop    %esi
  80234c:	5f                   	pop    %edi
  80234d:	5d                   	pop    %ebp
  80234e:	c3                   	ret    

0080234f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
  802352:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802355:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80235a:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80235d:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802363:	8b 52 50             	mov    0x50(%edx),%edx
  802366:	39 ca                	cmp    %ecx,%edx
  802368:	75 0d                	jne    802377 <ipc_find_env+0x28>
			return envs[i].env_id;
  80236a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80236d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802372:	8b 40 40             	mov    0x40(%eax),%eax
  802375:	eb 0e                	jmp    802385 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802377:	83 c0 01             	add    $0x1,%eax
  80237a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80237f:	75 d9                	jne    80235a <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802381:	66 b8 00 00          	mov    $0x0,%ax
}
  802385:	5d                   	pop    %ebp
  802386:	c3                   	ret    

00802387 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
  80238a:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80238d:	89 d0                	mov    %edx,%eax
  80238f:	c1 e8 16             	shr    $0x16,%eax
  802392:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802399:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80239e:	f6 c1 01             	test   $0x1,%cl
  8023a1:	74 1d                	je     8023c0 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023a3:	c1 ea 0c             	shr    $0xc,%edx
  8023a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023ad:	f6 c2 01             	test   $0x1,%dl
  8023b0:	74 0e                	je     8023c0 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023b2:	c1 ea 0c             	shr    $0xc,%edx
  8023b5:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023bc:	ef 
  8023bd:	0f b7 c0             	movzwl %ax,%eax
}
  8023c0:	5d                   	pop    %ebp
  8023c1:	c3                   	ret    
  8023c2:	66 90                	xchg   %ax,%ax
  8023c4:	66 90                	xchg   %ax,%ax
  8023c6:	66 90                	xchg   %ax,%ax
  8023c8:	66 90                	xchg   %ax,%ax
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__udivdi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8023e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023ec:	89 ea                	mov    %ebp,%edx
  8023ee:	89 0c 24             	mov    %ecx,(%esp)
  8023f1:	75 2d                	jne    802420 <__udivdi3+0x50>
  8023f3:	39 e9                	cmp    %ebp,%ecx
  8023f5:	77 61                	ja     802458 <__udivdi3+0x88>
  8023f7:	85 c9                	test   %ecx,%ecx
  8023f9:	89 ce                	mov    %ecx,%esi
  8023fb:	75 0b                	jne    802408 <__udivdi3+0x38>
  8023fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802402:	31 d2                	xor    %edx,%edx
  802404:	f7 f1                	div    %ecx
  802406:	89 c6                	mov    %eax,%esi
  802408:	31 d2                	xor    %edx,%edx
  80240a:	89 e8                	mov    %ebp,%eax
  80240c:	f7 f6                	div    %esi
  80240e:	89 c5                	mov    %eax,%ebp
  802410:	89 f8                	mov    %edi,%eax
  802412:	f7 f6                	div    %esi
  802414:	89 ea                	mov    %ebp,%edx
  802416:	83 c4 0c             	add    $0xc,%esp
  802419:	5e                   	pop    %esi
  80241a:	5f                   	pop    %edi
  80241b:	5d                   	pop    %ebp
  80241c:	c3                   	ret    
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	39 e8                	cmp    %ebp,%eax
  802422:	77 24                	ja     802448 <__udivdi3+0x78>
  802424:	0f bd e8             	bsr    %eax,%ebp
  802427:	83 f5 1f             	xor    $0x1f,%ebp
  80242a:	75 3c                	jne    802468 <__udivdi3+0x98>
  80242c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802430:	39 34 24             	cmp    %esi,(%esp)
  802433:	0f 86 9f 00 00 00    	jbe    8024d8 <__udivdi3+0x108>
  802439:	39 d0                	cmp    %edx,%eax
  80243b:	0f 82 97 00 00 00    	jb     8024d8 <__udivdi3+0x108>
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	31 d2                	xor    %edx,%edx
  80244a:	31 c0                	xor    %eax,%eax
  80244c:	83 c4 0c             	add    $0xc,%esp
  80244f:	5e                   	pop    %esi
  802450:	5f                   	pop    %edi
  802451:	5d                   	pop    %ebp
  802452:	c3                   	ret    
  802453:	90                   	nop
  802454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 f8                	mov    %edi,%eax
  80245a:	f7 f1                	div    %ecx
  80245c:	31 d2                	xor    %edx,%edx
  80245e:	83 c4 0c             	add    $0xc,%esp
  802461:	5e                   	pop    %esi
  802462:	5f                   	pop    %edi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    
  802465:	8d 76 00             	lea    0x0(%esi),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	8b 3c 24             	mov    (%esp),%edi
  80246d:	d3 e0                	shl    %cl,%eax
  80246f:	89 c6                	mov    %eax,%esi
  802471:	b8 20 00 00 00       	mov    $0x20,%eax
  802476:	29 e8                	sub    %ebp,%eax
  802478:	89 c1                	mov    %eax,%ecx
  80247a:	d3 ef                	shr    %cl,%edi
  80247c:	89 e9                	mov    %ebp,%ecx
  80247e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802482:	8b 3c 24             	mov    (%esp),%edi
  802485:	09 74 24 08          	or     %esi,0x8(%esp)
  802489:	89 d6                	mov    %edx,%esi
  80248b:	d3 e7                	shl    %cl,%edi
  80248d:	89 c1                	mov    %eax,%ecx
  80248f:	89 3c 24             	mov    %edi,(%esp)
  802492:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802496:	d3 ee                	shr    %cl,%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	d3 e2                	shl    %cl,%edx
  80249c:	89 c1                	mov    %eax,%ecx
  80249e:	d3 ef                	shr    %cl,%edi
  8024a0:	09 d7                	or     %edx,%edi
  8024a2:	89 f2                	mov    %esi,%edx
  8024a4:	89 f8                	mov    %edi,%eax
  8024a6:	f7 74 24 08          	divl   0x8(%esp)
  8024aa:	89 d6                	mov    %edx,%esi
  8024ac:	89 c7                	mov    %eax,%edi
  8024ae:	f7 24 24             	mull   (%esp)
  8024b1:	39 d6                	cmp    %edx,%esi
  8024b3:	89 14 24             	mov    %edx,(%esp)
  8024b6:	72 30                	jb     8024e8 <__udivdi3+0x118>
  8024b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024bc:	89 e9                	mov    %ebp,%ecx
  8024be:	d3 e2                	shl    %cl,%edx
  8024c0:	39 c2                	cmp    %eax,%edx
  8024c2:	73 05                	jae    8024c9 <__udivdi3+0xf9>
  8024c4:	3b 34 24             	cmp    (%esp),%esi
  8024c7:	74 1f                	je     8024e8 <__udivdi3+0x118>
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	e9 7a ff ff ff       	jmp    80244c <__udivdi3+0x7c>
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	31 d2                	xor    %edx,%edx
  8024da:	b8 01 00 00 00       	mov    $0x1,%eax
  8024df:	e9 68 ff ff ff       	jmp    80244c <__udivdi3+0x7c>
  8024e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	83 c4 0c             	add    $0xc,%esp
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    
  8024f4:	66 90                	xchg   %ax,%ax
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__umoddi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	83 ec 14             	sub    $0x14,%esp
  802506:	8b 44 24 28          	mov    0x28(%esp),%eax
  80250a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80250e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802512:	89 c7                	mov    %eax,%edi
  802514:	89 44 24 04          	mov    %eax,0x4(%esp)
  802518:	8b 44 24 30          	mov    0x30(%esp),%eax
  80251c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802520:	89 34 24             	mov    %esi,(%esp)
  802523:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802527:	85 c0                	test   %eax,%eax
  802529:	89 c2                	mov    %eax,%edx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	75 17                	jne    802548 <__umoddi3+0x48>
  802531:	39 fe                	cmp    %edi,%esi
  802533:	76 4b                	jbe    802580 <__umoddi3+0x80>
  802535:	89 c8                	mov    %ecx,%eax
  802537:	89 fa                	mov    %edi,%edx
  802539:	f7 f6                	div    %esi
  80253b:	89 d0                	mov    %edx,%eax
  80253d:	31 d2                	xor    %edx,%edx
  80253f:	83 c4 14             	add    $0x14,%esp
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	66 90                	xchg   %ax,%ax
  802548:	39 f8                	cmp    %edi,%eax
  80254a:	77 54                	ja     8025a0 <__umoddi3+0xa0>
  80254c:	0f bd e8             	bsr    %eax,%ebp
  80254f:	83 f5 1f             	xor    $0x1f,%ebp
  802552:	75 5c                	jne    8025b0 <__umoddi3+0xb0>
  802554:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802558:	39 3c 24             	cmp    %edi,(%esp)
  80255b:	0f 87 e7 00 00 00    	ja     802648 <__umoddi3+0x148>
  802561:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802565:	29 f1                	sub    %esi,%ecx
  802567:	19 c7                	sbb    %eax,%edi
  802569:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80256d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802571:	8b 44 24 08          	mov    0x8(%esp),%eax
  802575:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802579:	83 c4 14             	add    $0x14,%esp
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    
  802580:	85 f6                	test   %esi,%esi
  802582:	89 f5                	mov    %esi,%ebp
  802584:	75 0b                	jne    802591 <__umoddi3+0x91>
  802586:	b8 01 00 00 00       	mov    $0x1,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	f7 f6                	div    %esi
  80258f:	89 c5                	mov    %eax,%ebp
  802591:	8b 44 24 04          	mov    0x4(%esp),%eax
  802595:	31 d2                	xor    %edx,%edx
  802597:	f7 f5                	div    %ebp
  802599:	89 c8                	mov    %ecx,%eax
  80259b:	f7 f5                	div    %ebp
  80259d:	eb 9c                	jmp    80253b <__umoddi3+0x3b>
  80259f:	90                   	nop
  8025a0:	89 c8                	mov    %ecx,%eax
  8025a2:	89 fa                	mov    %edi,%edx
  8025a4:	83 c4 14             	add    $0x14,%esp
  8025a7:	5e                   	pop    %esi
  8025a8:	5f                   	pop    %edi
  8025a9:	5d                   	pop    %ebp
  8025aa:	c3                   	ret    
  8025ab:	90                   	nop
  8025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	8b 04 24             	mov    (%esp),%eax
  8025b3:	be 20 00 00 00       	mov    $0x20,%esi
  8025b8:	89 e9                	mov    %ebp,%ecx
  8025ba:	29 ee                	sub    %ebp,%esi
  8025bc:	d3 e2                	shl    %cl,%edx
  8025be:	89 f1                	mov    %esi,%ecx
  8025c0:	d3 e8                	shr    %cl,%eax
  8025c2:	89 e9                	mov    %ebp,%ecx
  8025c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c8:	8b 04 24             	mov    (%esp),%eax
  8025cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025cf:	89 fa                	mov    %edi,%edx
  8025d1:	d3 e0                	shl    %cl,%eax
  8025d3:	89 f1                	mov    %esi,%ecx
  8025d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025dd:	d3 ea                	shr    %cl,%edx
  8025df:	89 e9                	mov    %ebp,%ecx
  8025e1:	d3 e7                	shl    %cl,%edi
  8025e3:	89 f1                	mov    %esi,%ecx
  8025e5:	d3 e8                	shr    %cl,%eax
  8025e7:	89 e9                	mov    %ebp,%ecx
  8025e9:	09 f8                	or     %edi,%eax
  8025eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8025ef:	f7 74 24 04          	divl   0x4(%esp)
  8025f3:	d3 e7                	shl    %cl,%edi
  8025f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025f9:	89 d7                	mov    %edx,%edi
  8025fb:	f7 64 24 08          	mull   0x8(%esp)
  8025ff:	39 d7                	cmp    %edx,%edi
  802601:	89 c1                	mov    %eax,%ecx
  802603:	89 14 24             	mov    %edx,(%esp)
  802606:	72 2c                	jb     802634 <__umoddi3+0x134>
  802608:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80260c:	72 22                	jb     802630 <__umoddi3+0x130>
  80260e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802612:	29 c8                	sub    %ecx,%eax
  802614:	19 d7                	sbb    %edx,%edi
  802616:	89 e9                	mov    %ebp,%ecx
  802618:	89 fa                	mov    %edi,%edx
  80261a:	d3 e8                	shr    %cl,%eax
  80261c:	89 f1                	mov    %esi,%ecx
  80261e:	d3 e2                	shl    %cl,%edx
  802620:	89 e9                	mov    %ebp,%ecx
  802622:	d3 ef                	shr    %cl,%edi
  802624:	09 d0                	or     %edx,%eax
  802626:	89 fa                	mov    %edi,%edx
  802628:	83 c4 14             	add    $0x14,%esp
  80262b:	5e                   	pop    %esi
  80262c:	5f                   	pop    %edi
  80262d:	5d                   	pop    %ebp
  80262e:	c3                   	ret    
  80262f:	90                   	nop
  802630:	39 d7                	cmp    %edx,%edi
  802632:	75 da                	jne    80260e <__umoddi3+0x10e>
  802634:	8b 14 24             	mov    (%esp),%edx
  802637:	89 c1                	mov    %eax,%ecx
  802639:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80263d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802641:	eb cb                	jmp    80260e <__umoddi3+0x10e>
  802643:	90                   	nop
  802644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802648:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80264c:	0f 82 0f ff ff ff    	jb     802561 <__umoddi3+0x61>
  802652:	e9 1a ff ff ff       	jmp    802571 <__umoddi3+0x71>
