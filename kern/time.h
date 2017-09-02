#ifndef JOS_KERN_TIME_H
#define JOS_KERN_TIME_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

void time_init(void);
void time_tick(unsigned int c_no);
unsigned int time_msec(unsigned int c_no);

#endif /* JOS_KERN_TIME_H */
