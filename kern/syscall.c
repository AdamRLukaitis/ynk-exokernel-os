/* See COPYRIGHT for copyright information. */

#include <inc/x86.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/syscall.h>
#include <kern/console.h>
#include <kern/sched.h>
#include <kern/time.h>
#include <kern/e1000.h>


// Print a string to the system console.
// The string is exactly 'len' characters long.
// Destroys the environment on memory errors.
static void
sys_cputs(const char *s, size_t len)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.

	user_mem_assert(curenv,s,len,0);



	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
}

// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
}

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
}

// Destroy a given environment (possibly the currently running environment).
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
		return r;

	if (e == curenv)
		cprintf("[%08x] exiting gracefully\n", curenv->env_id);
	else
		cprintf("[%08x] destroying %08x\n", curenv->env_id, e->env_id);


	env_destroy(e);
	return 0;
}

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
}

// Allocate a new environment.
// Returns envid of new environment, or < 0 on error.  Errors are:
//	-E_NO_FREE_ENV if no free environment is available.
//	-E_NO_MEM on memory exhaustion.
static envid_t
sys_exofork(void)
{
	// Create the new environment with env_alloc(), from kern/env.c.
	// It should be left as env_alloc created it, except that
	// status is set to ENV_NOT_RUNNABLE, and the register set is copied
	// from the current environment -- but tweaked so sys_exofork
	// will appear to return 0.

	struct Env *forked_env ;
	int err_code = env_alloc(&forked_env,curenv->env_id);
	if(err_code < 0)
	{
		return err_code;
	}
	forked_env->env_status = ENV_NOT_RUNNABLE;
	forked_env->env_tf = curenv->env_tf;
	forked_env->env_tf.tf_regs.reg_eax=0;
	//cprintf("forked_env id %d\n",forked_env->env_id);
	return forked_env->env_id;
	// LAB 4: Your code here.
	//panic("sys_exofork not implemented");

}

// Set envid's env_status to status, which must be ENV_RUNNABLE
// or ENV_NOT_RUNNABLE.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if status is not a valid status for an environment.
static int
sys_env_set_status(envid_t envid, int status)
{
	// Hint: Use the 'envid2env' function from kern/env.c to translate an
	// envid to a struct Env.
	// You should set envid2env's third argument to 1, which will
	// check whether the current environment has permission to set
	// envid's status.

struct Env *env_ptr;
	int rcode;
	rcode = envid2env(envid,&env_ptr,1);
	if(rcode < 0)
		return -E_BAD_ENV;
	if(status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
		return -E_INVAL;
		env_ptr->env_status = status;
		return 0;
	// LAB 4: Your code here.
	//panic("sys_env_set_status not implemented");

}

// Set envid's trap frame to 'tf'.
// tf is modified to make sure that user environments always run at code
// protection level 3 (CPL 3) with interrupts enabled.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	//panic("sys_env_set_trapframe not implemented");
	struct Env *sys_env;
	if(envid2env(envid,&sys_env,1)<0)
		return -E_BAD_ENV;
	else
	{
		sys_env->env_tf = *tf;
		user_mem_assert(sys_env,tf,sizeof(tf),PTE_U);
		sys_env->env_tf.tf_eflags = sys_env->env_tf.tf_eflags | FL_IF;
		return 0;
	}


}

// Set the page fault upcall for 'envid' by modifying the corresponding struct
// Env's 'env_pgfault_upcall' field.  When 'envid' causes a page fault, the
// kernel will push a fault record onto the exception stack, then branch to
// 'func'.
//
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)

{   
	struct Env *env_ptr;
	if(envid2env(envid,&env_ptr,1)==0)
	{
		env_ptr->env_pgfault_upcall = func;
		return 0;
	}
	return -E_BAD_ENV;
	// LAB 4: Your code here.
	//panic("sys_env_set_pgfault_upcall not implemented");


}

// Allocate a page of memory and map it at 'va' with permission
// 'perm' in the address space of 'envid'.
// The page's contents are set to 0.
// If a page is already mapped at 'va', that page is unmapped as a
// side effect.
//
// perm -- PTE_U | PTE_P must be set, PTE_AVAIL | PTE_W may or may not be set,
//         but no other bits may be set.  See PTE_SYSCALL in inc/mmu.h.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
//	-E_INVAL if perm is inappropriate (see above).
//	-E_NO_MEM if there's no memory to allocate the new page,
//		or to allocate any necessary page tables.
static int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	// Hint: This function is a wrapper around page_alloc() and
	//   page_insert() from kern/pmap.c.
	//   Most of the new code you write should be to check the
	//   parameters for correctness.
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	if((((perm & PTE_U) !=PTE_U) && ((perm & PTE_P) !=PTE_P)) || (uint32_t)va>=UTOP || (perm & ~PTE_SYSCALL) || (uint32_t)va%PGSIZE!=0)
		return -E_INVAL;

	struct Env *env_ptr;
	if(envid2env(envid,&env_ptr,1)!=0)
		return -E_BAD_ENV;

	struct PageInfo *pg = page_alloc(ALLOC_ZERO);
	if(pg == NULL)
		return -E_NO_MEM;
	if(page_insert(env_ptr->env_pgdir,pg,va,perm)!=0)
	{
		page_free(pg);
		return -E_NO_MEM;
	}
	return 0;
	// LAB 4: Your code here.
	//panic("sys_page_alloc not implemented");

}

// Map the page of memory at 'srcva' in srcenvid's address space
// at 'dstva' in dstenvid's address space with permission 'perm'.
// Perm has the same restrictions as in sys_page_alloc, except
// that it also must not grant write access to a read-only
// page.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if srcenvid and/or dstenvid doesn't currently exist,
//		or the caller doesn't have permission to change one of them.
//	-E_INVAL if srcva >= UTOP or srcva is not page-aligned,
//		or dstva >= UTOP or dstva is not page-aligned.
//	-E_INVAL is srcva is not mapped in srcenvid's address space.
//	-E_INVAL if perm is inappropriate (see sys_page_alloc).
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in srcenvid's
//		address space.
//	-E_NO_MEM if there's no memory to allocate any necessary page tables.
static int
sys_page_map(envid_t srcenvid, void *srcva,
	     envid_t dstenvid, void *dstva, int perm)
{
	// Hint: This function is a wrapper around page_lookup() and
	//   page_insert() from kern/pmap.c.
	//   Again, most of the new code you write should be to check the
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

    struct Env *src_env_ptr, *dst_env_ptr;
    if((envid2env(srcenvid,&src_env_ptr,1)) < 0 ||(envid2env(dstenvid,&dst_env_ptr,1))<0)
    	return -E_BAD_ENV;
    if((uint32_t)srcva>=UTOP || (uint32_t)dstva>=UTOP || (uint32_t)srcva%PGSIZE!=0 || (uint32_t)dstva%PGSIZE!=0)
    	return -E_INVAL;
    if((((perm & PTE_U) !=PTE_U) && ((perm & PTE_P) !=PTE_P)) || (perm & ~PTE_SYSCALL))
    	return -E_INVAL;
    uint32_t *env_pg_addr;
    struct PageInfo *env_page = page_lookup(src_env_ptr->env_pgdir,srcva,&env_pg_addr);
    if(env_pg_addr == NULL)
    	return -E_INVAL;
    if((perm&PTE_W) == PTE_W &&((*env_pg_addr&PTE_W) ==0))
    	return -E_INVAL;
    if(page_insert(dst_env_ptr->env_pgdir,env_page,dstva,perm)!=0)
    	return -E_NO_MEM;
    return 0;
	// LAB 4: Your code here.
	//panic("sys_page_map not implemented");


}

// Unmap the page of memory at 'va' in the address space of 'envid'.
// If no page is mapped, the function silently succeeds.
//
// Return 0 on success, < 0 on error.  Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist,
//		or the caller doesn't have permission to change envid.
//	-E_INVAL if va >= UTOP, or va is not page-aligned.
static int
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().

	struct Env *env_ptr;
	if(envid2env(envid,&env_ptr,1)<0)
		return -E_BAD_ENV;
	if((uint32_t)va>UTOP && (uint32_t)va%PGSIZE!=0)
		return -E_INVAL;
	page_remove(env_ptr->env_pgdir,va);
	return 0;


	// LAB 4: Your code here.
	panic("sys_page_unmap not implemented");
}

// Try to send 'value' to the target env 'envid'.
// If srcva < UTOP, then also send page currently mapped at 'srcva',
// so that receiver gets a duplicate mapping of the same page.
//
// The send fails with a return value of -E_IPC_NOT_RECV if the
// target is not blocked, waiting for an IPC.
//
// The send also can fail for the other reasons listed below.
//
// Otherwise, the send succeeds, and the target's ipc fields are
// updated as follows:
//    env_ipc_recving is set to 0 to block future sends;
//    env_ipc_from is set to the sending envid;
//    env_ipc_value is set to the 'value' parameter;
//    env_ipc_perm is set to 'perm' if a page was transferred, 0 otherwise.
// The target environment is marked runnable again, returning 0
// from the paused sys_ipc_recv system call.  (Hint: does the
// sys_ipc_recv function ever actually return?)
//
// If the sender wants to send a page but the receiver isn't asking for one,
// then no page mapping is transferred, but no error occurs.
// The ipc only happens when no errors occur.
//
// Returns 0 on success, < 0 on error.
// Errors are:
//	-E_BAD_ENV if environment envid doesn't currently exist.
//		(No need to check permissions.)
//	-E_IPC_NOT_RECV if envid is not currently blocked in sys_ipc_recv,
//		or another environment managed to send first.
//	-E_INVAL if srcva < UTOP but srcva is not page-aligned.
//	-E_INVAL if srcva < UTOP and perm is inappropriate
//		(see sys_page_alloc).
//	-E_INVAL if srcva < UTOP but srcva is not mapped in the caller's
//		address space.
//	-E_INVAL if (perm & PTE_W), but srcva is read-only in the
//		current environment's address space.
//	-E_NO_MEM if there's not enough memory to map srcva in envid's
//		address space.
static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.

	//cprintf("sys_ipc_try_send function called \n");
	struct Env *env;
	uint32_t *page_address;
	struct PageInfo *p_info;
	if(envid2env(envid,&env,0)<0)
	{
		return -E_BAD_ENV;
	}
	if((uint32_t)srcva<UTOP && (uint32_t)srcva%PGSIZE!=0)
	{
		return -E_INVAL;
	}
	if(env->env_ipc_recving == false)
	{
		return -E_IPC_NOT_RECV;
	}
	if((p_info = page_lookup(curenv->env_pgdir,srcva,&page_address))<0)
		return -E_INVAL;
	//cprintf("page info is %08x\n",p_info);
	if((perm&PTE_W)&&((*page_address & PTE_W)==0))
		return -E_INVAL;
	if(((uint32_t)srcva<UTOP)&&((uint32_t)env->env_ipc_dstva<UTOP))
	{
	if((page_insert(env->env_pgdir,p_info,env->env_ipc_dstva,perm))<0)
		return -E_NO_MEM;
	env->env_ipc_perm = perm;
}
else
{
env->env_ipc_perm = 0;	
}
	env->env_ipc_recving =false;
	env->env_ipc_from = curenv->env_id;
	env->env_ipc_value = value;
	env->env_status = ENV_RUNNABLE;
	return 0;
	//panic("sys_ipc_try_send not implemented");



}

// Block until a value is ready.  Record that you want to receive
// using the env_ipc_recving and env_ipc_dstva fields of struct Env,
// mark yourself not runnable, and then give up the CPU.
//
// If 'dstva' is < UTOP, then you are willing to receive a page of data.
// 'dstva' is the virtual address at which the sent page should be mapped.
//
// This function only returns on error, but the system call will eventually
// return 0 on success.
// Return < 0 on error.  Errors are:
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
		//cprintf("In sys_ipc_recv funcion\n");
	if(((uint32_t)dstva<UTOP)&&(((uint32_t)dstva%PGSIZE)!=0))
		return -E_INVAL;
	curenv->env_ipc_dstva = dstva;
	curenv->env_ipc_recving = true;
	curenv->env_status = ENV_NOT_RUNNABLE;
	curenv->env_tf.tf_regs.reg_eax = 0;
	sys_yield();
	return 0;
	//panic("sys_ipc_recv not implemented");
	//return 0;
}


// Return the current time.
static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	//panic("sys_time_msec not implemented");
	return time_msec(cpunum());
}

static int sys_e1000_transmit(char *data,int len)
{
	cprintf("Length recieved in syscall.c is %d \n",len);
	user_mem_assert(curenv,data,len,0);
	int r = transmit_packet(data,len);
	return r;
}
static int sys_e1000_recieve(char *data,int *len)
{
	int r ;
	user_mem_assert(curenv,data,strlen(data),0);
	user_mem_assert(curenv,len,sizeof(len),0);
		//sched_yield();
		r = recv_packet(data,len);

	return r;
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	// Call the function corresponding to the 'syscallno' parameter.
	// Return any appropriate return value.
	// LAB 3: Your code here.
	//panic("syscall not implemented");
	int return_code = 0;
	switch (syscallno) {
	case SYS_cputs: sys_cputs((char *)a1,a2);
					break;
	case SYS_cgetc: return_code =sys_cgetc();
				   break;
	case SYS_getenvid:return_code =sys_getenvid();
					   break;
	case SYS_env_destroy:return_code = sys_env_destroy(a1);
						  break;
	case SYS_yield:sys_yield();
				    break;
	case SYS_exofork: return_code =sys_exofork();
					  break;
	case SYS_env_set_status:return_code = sys_env_set_status(a1,a2);
							break;
	case SYS_page_alloc: return_code = sys_page_alloc(a1,(void*)a2,a3);
						 break;
	case SYS_page_map : return_code = sys_page_map(a1,(void*)a2,a3,(void*)a4,a5);
						break;
	case SYS_page_unmap: return_code =sys_page_unmap(a1,(void*)a2);
						  break;
	case SYS_env_set_pgfault_upcall: return_code=sys_env_set_pgfault_upcall(a1,(void*)a2);
									  break;
	case SYS_ipc_recv : return_code = sys_ipc_recv((void*)a1);
									  //cprintf("In sys_ipc_recv\n");
									  break;
	case SYS_ipc_try_send: return_code = sys_ipc_try_send(a1,a2,(void*)a3,a4);
							break;

	case SYS_env_set_trapframe: return_code = sys_env_set_trapframe(a1,(void*)a2);
								break;
	case SYS_time_msec : return_code = sys_time_msec();
						 break;
	case SYS_e1000_transmit : return_code = sys_e1000_transmit((char*)a1,(int)a2);
							 break;
	case SYS_e1000_recieve  : return_code = sys_e1000_recieve((char*)a1,(int*)a2);
							  break;
	default:
		return -E_INVAL;
	}
	return return_code;



}
