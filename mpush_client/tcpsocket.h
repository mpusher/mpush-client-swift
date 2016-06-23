//
//  tcpsocket.h
//  mpush-client
//
//  Created by OHUN on 16/5/31.
//  Copyright © 2016年 OHUN. All rights reserved.
//

#ifndef tcpsocket_h
#define tcpsocket_h

#include <stdio.h>

int tcpsocket_connect(const char *host,int port,int timeout);
int tcpsocket_close(int socketfd);
int tcpsocket_read(int socketfd,char *data,int len,int timeout_sec);
int tcpsocket_write(int socketfd,const char *data,int len);
int tcpsocket_listen(const char *addr,int port);
int tcpsocket_accept(int onsocketfd,char *remoteip,int* remoteport);

#endif /* tcpsocket_h */
